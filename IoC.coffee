#IoC
#ioc.register "__myInterface", "my/namespace/class" "default", {prop: value, prop: value}
#ioc.get "__myInterface" -> deferred
#ioc.setConfig "myTestConfig"
define [
    "clazzy/namelocators/InterfaceNameLocator"
    "clazzy/abstraction/Lang" #used for mixin,hitch,isFunction,filter
    "clazzy/Lib" #deferList,findClass
    "clazzy/Deferred"
    "clazzy/TemplateRegistry"
    "clazzy/namelocators/TemplateNameLocator"
], (locator, lang, lib, Deferred, tRegistry, tLocator) -> 
    'use strict'

    _alldependencies = []
    _allstores = []
    _allvalues = []
    _allsingeltons = []
    _allrequired = []

    _alldependencies[[locator.getConfig()]] = {}
    _allstores[[locator.getConfig()]] = {}
    _allvalues[[locator.getConfig()]] = {}
    _allsingeltons[[locator.getConfig()]] = {}
    _allrequired[[locator.getConfig()]] = {}

    _dependencies = _alldependencies[[locator.getConfig()]]
    _store = _allstores[[locator.getConfig()]]
    _values = _allvalues[[locator.getConfig()]]
    _singeltons = _allsingeltons[[locator.getConfig()]]
    _required = _allrequired[[locator.getConfig()]]

    
    _ = 
        # Instanciate, new and storeInstance... is used to create an instance of a class
        # they run synchron and expect all classes to be required.
        instanciate: (classname, values) ->
            instances = {}
            if _dependencies[classname]?.length > 0
            	for dependency in _dependencies[classname]
                    instances[dependency.interfacename] = @instanciate dependency.classname
            return lang.mixin @storeInstanceIfSingelton(classname, @nu classname, instances), values or {}
        
        "nu": (classname, dependencies) -> 
            dependencies.templateString = tRegistry.get tLocator.findTemplate classname if tLocator.hasTemplate classname
            dependencies = lang.mixin dependencies, _values[classname] or {}
            if lang.isFunction _store[classname]
                return new _store[classname](dependencies)
            return _store[classname]
		
        storeInstanceIfSingelton: (classname, instance) -> 
            _store[classname] = instance if _singeltons[classname]
            instance
		
        #function to look up all depencencies for a class
        #as well as register it as required
        registerRequired: (classnames, classes) -> 
            dependencies = []
            for i in [0..classes.length-1]
                _store[classnames[i]] = classes[i]
                dependencies = @getDependencies classnames[i]
                dependencies = dependencies.concat @getTemplateDependencies tRegistry.get tLocator.findTemplate classnames[i] if tLocator.hasTemplate classnames[i]
                if dependencies.length is 0 
                    _required[classnames[i]].resolve()
                else
                    count = i
                    @require(dependencies)
                    .then () -> 
                        _required[classnames[count]].resolve()
                        undefined
            return

        # Require, registerDep, getDep, filterDep, and convertToAmdModuleNames
        # is used for the require phase and asynch, using deferred to communicate when done.
        # finding all dependecies is done using width first
        # require returns Deferred or DeferredList
        require: (classnames) ->
            notRequired = lang.filter classnames, (classname) ->
                return not _required[classname]
            toBeRequired = []
            namesToBeRegistered = []
            classesToBeRegistered = []
            inProcess = lang.filter classnames, (classname) ->
                return not not _required[classname]
            #split up notRequired between existing defined classes and those that we need to require
            for classname, i in notRequired
                if cls = lib.findClass(classname)
                    namesToBeRegistered.push classname
                    classesToBeRegistered.push cls
                else
                    toBeRequired.push classname

            deferreds = (_required[classname] for classname in inProcess)
            if deferreds.length>0
                deferreds.push @require toBeRequired if toBeRequired.length>0 
                return lib.deferList(deferreds)
            
            deferredList = lib.deferList((_required[classname] = new Deferred()) for classname in notRequired)

            #register and look up their dependencies for all classes that
            #are not required but still seem to be defines allready
            @registerRequired.call(this, namesToBeRegistered, classesToBeRegistered) if namesToBeRegistered.length

            #require all dependencies that are neither defined nor required
            if toBeRequired.length
                modules = @convertToAmdModuleNames toBeRequired
                require modules, lang.hitch this, (classes...) ->
                    names = toBeRequired
                    @registerRequired.call(this, names, classes)
            
            deferredList
        
        registerDependencies: (classname, classes, interfaces) ->
            if not _dependencies[classname] and classes.length>0
                _dependencies[classname] = ({interfacename: interfaces[i], classname: classes[i]} for i in [0..classes.length-1])
            return classes
        
        getDependencies: (classname) ->
            return _dependencies[classname] if _dependencies[classname]?
            return @registerDependencies classname, [], [] if not _store[classname].prototype
            interfaces = []
            if _store[classname].prototype?.__dependencies?
                interfaces = _store[classname].prototype.__dependencies
            classes = (locator.findClass dep for dep in interfaces)
            return @registerDependencies classname, classes, interfaces

        getTemplateDependencies: (template) ->
            deps = []
            re = /data-dojo-type="(.*?)"/gi
            while match = re.exec(template)
                deps.push match[1]
            deps

        convertToAmdModuleNames: (classnames) ->
            modules = (classname.replace(/\./g, "/") for classname in classnames)
            modules
            
    ioc =
        register: (interfacename, classname, singelton, config, values) ->
            locator.register interfacename, classname, config
            if ((found = lib.findClass classname) and not _store[classname])
                _store[classname] = found 
            _singeltons[classname] = singelton is true
            _allvalues[config or [locator.getConfig()]][classname] = values if values?
        
        get: (interfacename, values) ->
            classname = locator.findClass interfacename
            @getByClass classname, values
        
        getByClass: (classname, values) -> 
            gotten = new Deferred()
            required = _.require [classname]
            required.then () -> 
                gotten.resolve(_.instanciate classname, values)
                undefined
            return gotten
            
        getConfig: () ->
            locator.getConfig()

        setConfig: (config) ->
            locator.setConfigTo config

            _alldependencies[config] = {} if not _alldependencies[config]?
            _allstores[config] = {} if not _allstores[config]?
            _allvalues[config] = {} if not _allvalues[config]?
            _allsingeltons[config] = {} if not _allsingeltons[config]?
            _allrequired[config] = {} if not _allrequired[config]?

            _dependencies = _alldependencies[config]
            _store = _allstores[config]
            _values = _allvalues[config]
            _singletons = _allsingeltons[config]
            _required = _allrequired[config]
            null

    ioc
