#IoC
#ioc.register "__myInterface", "my/namespace/class" "default", {prop: value, prop: value}
#ioc.get "__myInterface" -> deferred
#ioc.setConfig "myTestConfig"
define [
    "clazzy/Clazzy"
    "clazzy/namelocators/InterfaceNameLocator"
    "clazzy/abstraction/Lang" #used for mixin,hitch,isFunction,filter
    "clazzy/Lib" #deferList,findClass
    "clazzy/Deferred"
    "clazzy/TemplateRegistry"
    "clazzy/namelocators/TemplateNameLocator"
    "clazzy/Exception"
], (Class, locator, lang, lib, Deferred, tRegistry, tLocator, Exception) -> 

    _alldependencies = []
    _allstores = []
    _allvalues = []
    _allsingeltons = []
    _allrequired = []
    _alldepreplaces = []

    _alldependencies[[locator.getConfig()]] = {}
    _allstores[[locator.getConfig()]] = {}
    _allvalues[[locator.getConfig()]] = {}
    _allsingeltons[[locator.getConfig()]] = {}
    _allrequired[[locator.getConfig()]] = {}
    _alldepreplaces[[locator.getConfig()]] = {}

    _dependencies = _alldependencies[[locator.getConfig()]]
    _store = _allstores[[locator.getConfig()]]
    _values = _allvalues[[locator.getConfig()]]
    _singeltons = _allsingeltons[[locator.getConfig()]]
    _required = _allrequired[[locator.getConfig()]]
    _depreplaces = _alldepreplaces[[locator.getConfig()]]

    
    _ioc = new (Class "clazzy._IoC", null, null, 
        # Instanciate, new and storeInstance... is used to create an instance of a class
        # they run synchron and expect all classes to be required.
        instanciate: (classname, values) ->
            'use strict'
            instances = {}
            if _dependencies[classname]?.length > 0
            	for dependency in _dependencies[classname]
                    instances[dependency.interfacename] = @instanciate dependency.classname
            instance = @storeInstanceIfSingelton(classname, @nu classname, instances)
            for prop, value of values
                if instance.set? 
                    instance.set prop, value
                else
                    instance[prop] = value
            return instance
        
        "nu": (classname, dependencies) -> 
            'use strict'
            dependencies.templateString = tRegistry.get tLocator.findTemplate classname if tLocator.hasTemplate classname
            dependencies = lang.mixin dependencies, _values[classname] or {}
            if lang.isFunction _store[classname]
                try
                    return new _store[classname](dependencies)
                catch e
                    (new Exception("UnableToNewException", "IoC crashed when trying to new "+classname+ ". ["+e.toString()+"]")).Throw()
            return _store[classname]
		
        storeInstanceIfSingelton: (classname, instance) -> 
            'use strict'
            _store[classname] = instance if _singeltons[classname]
            instance

        require: (classnames) ->
            toBeRequired = []
            inProgress = []
            notInProcess = []
            # create return value, an array where we will place deferreds
            answer = [];
            #get requires notInProcess
            notInProcess = lang.filter classnames, (classname) ->
                not _required[classname]?
            # check if required allready or if we need to require. add all deferreds to answer
            for classname in classnames
                if _required[classname]
                    # modules all ready in progress have a required, return that and dont do anything else
                    answer.push _required[classname]

            # register existing and require their dependencies before anything else
            for classname in notInProcess
                if existing = lib.findClass classname
                    # also add their deferreds to the answer
                    answer.push _required[classname] = new Deferred()
                    # register it and require its dependencies
                    @registerExisting classname, existing, _required[classname]
                    # store the class when the required resolves
                    @storeResult classname

            #refresh the notInProcess since it might have changes
            notInProcess = lang.filter classnames, (classname) ->
                not _required[classname]?

            # if all are either done or in progress, just return them
            return lib.deferList(answer) if notInProcess.length is 0

            # create deferreds for the ones we need to require
            for classname in notInProcess
                answer.push _required[classname] = new Deferred()
                # and store the class when the required resolves
                @storeResult classname

            # we have things to require
            # plugIns will not result in a class so they must be placed last so they can be ignored
            notInProcess = @placePluginsLast notInProcess
            modules = @convertToAmdModuleNames notInProcess
            # do actual require on the modules and register them when ready
            require modules, @ido (classes...) ->
                @registerExisting(notInProcess[i], cls, _required[notInProcess[i]]) for cls, i in classes
            # return a deferred list with all the requireds
            return lib.deferList(answer)

        storeResult: (classname) ->
            'use strict'
            _required[classname].then lang.partial((classname, retcls) ->
                _store[classname] = retcls
            , classname)
            , lang.partial((classname) ->
                (new Exception("IoCException", "unable to require " + classname + " or one of its dependencies")).Throw()
            , classname)

        registerExisting: (classname, existing, deferred) ->
            'use strict'
            cls = existing
            # get dependencies in class
            dependencies = @getDependencies classname, cls
            # get dependencies in template
            if tLocator.hasTemplate classname
                dependencies = dependencies.concat @getTemplateDependencies(tRegistry.get(tLocator.findTemplate(classname)))
            # if no dependencies just resolve
            return deferred.resolve(cls) if dependencies.length is 0
            # otherwise require dependencies and then resolve
            @require(dependencies).then () ->
                deferred.resolve(cls)
            , () ->
                deferred.reject()

        getDependencies: (classname, cls) -> 
            'use strict'
            return _dependencies[classname] if _dependencies[classname]?
            interfaces = []
            cls?.prototype?.__dependencies? && interfaces = cls.prototype.__dependencies
            replacedInterfaces = @replaceDependencies classname, interfaces
            classes = (locator.findClass dep for dep in replacedInterfaces)
            @registerDependencies classname, classes, interfaces
            classes

        registerDependencies: (classname, classes, interfaces) ->
            'use strict'
            if not _dependencies[classname] and classes.length>0
                _dependencies[classname] = ({interfacename: interfaces[i], classname: classes[i]} for i in [0..classes.length-1])
            return classes

        getTemplateDependencies: (template) ->
            'use strict'
            depsL = []
            depsD = {}
            re = /data-dojo-type=\s*['"](.*?)['"]/gi
            while match = re.exec(template)
                depsL.push match[1] if not depsD[match[1]]?
                depsD[match[1]] = 1
            depsL

        placePluginsLast: (classnames) ->
            'use strict'
            isplugin = /!/
            plugins = (name for name in classnames when isplugin.test name)
            nonplugins = (name for name in classnames when not isplugin.test name)
            nonplugins.concat plugins

        replaceDependencies: (classname, interfaces) ->
            _depreplaces[classname]?[dep] or dep for dep in interfaces

        convertToAmdModuleNames: (classnames) ->
            'use strict'
            modules = ((if classname.indexOf("/") is -1 then classname.replace(/\./g, "/") else classname) for classname in classnames)
            modules
    )()
    ioc = new (Class "clazzy.IoC", null, null, 
        register: (interfacename, classname, singelton, config, values, depreplace) ->
            'use strict'
            locator.register interfacename, classname, config
            #if ((found = lib.findClass classname) and not _store[classname])
            #    _store[classname] = found 
            _singeltons[classname] = singelton is true
            _allvalues[if config? then config else locator.getConfig()][classname] = values if values?
            _depreplaces[classname] = depreplace if depreplace?
        
        get: (interfacename, values) ->
            'use strict'
            classname = locator.findClass interfacename
            @getByClass classname, values
        
        getByClass: (classname, values) -> 
            gotten = new Deferred()
            if _store[classname]
                gotten.resolve(_ioc.instanciate classname, values)
            else
                required = _ioc.require [classname]
                required.then () -> 
                    gotten.resolve(_ioc.instanciate classname, values)
                    undefined
            return gotten
            
        getConfig: () ->
            'use strict'
            locator.getConfig()

        setConfig: (config) ->
            'use strict'
            locator.setConfigTo config

            _alldependencies[config] = {} if not _alldependencies[config]?
            _allstores[config] = {} if not _allstores[config]?
            _allvalues[config] = {} if not _allvalues[config]?
            _allsingeltons[config] = {} if not _allsingeltons[config]?
            _allrequired[config] = {} if not _allrequired[config]?
            _alldepreplaces[config] = {} if not _alldepreplaces[config]?

            _dependencies = _alldependencies[config]
            _store = _allstores[config]
            _values = _allvalues[config]
            _singletons = _allsingeltons[config]
            _depreplaces = _alldepreplaces[config]
            _required = _allrequired[config]
            null

        registerTemplate: (templateid, classname, templatestring, config) ->
            tLocator.register templateid, classname, config
            tRegistry.register templateid, templatestring, config 

    )()
    ioc
