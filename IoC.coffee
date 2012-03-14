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
		
        # Require, registerDep, getDep, filterDep, and convertToAmdModuleNames
        # is used for the require phase and asynch, using deferred to communicate when done.
        # finding all dependecies is done using width first

        # require returns Deferred or DeferredList
        require: (classnames) ->
            toBeRequired = lang.filter classnames, (classname) ->
                return not _required[classname]
            beingRequired = lang.filter classnames, (classname) ->
                return _required[classname]?

            deferreds = (_required[classname] for classname in beingRequired)
            if deferreds.length>0
                deferreds.push @require toBeRequired if toBeRequired.length>0 
                return lib.deferList(deferreds)
            
            deferredList = lib.deferList((_required[classname] = new Deferred()) for classname in toBeRequired)
            
            modules = @convertToAmdModuleNames toBeRequired
            require modules, lang.hitch this, (classes...) ->
                dependencies = []
                for i in [0..classes.length-1]
                    _store[classnames[i]] = classes[i]
                    dependencies = @getDependencies classnames[i]
                    if dependencies.length is 0 
                        _required[classnames[i]].resolve()
                    else
                        count = i
                        @require(dependencies)
                        .then () -> 
                            _required[classnames[count]].resolve()
                            undefined
                return
            
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

        convertToAmdModuleNames: (classnames) ->
            modules = (classname.replace(/\./g, "/") for classname in classnames)
            modules
            
    ioc =
        register: (interfacename, classname, singelton, config, values) ->
            locator.register interfacename, classname, config
            if ((found = lib.findClass classname) and not _store[classname])
                _store[classname] = found 
                _required[classname] = new Deferred()
                _required[classname].resolve()
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
            _dependencies = _alldependencies[config]
            _store = _allstores[config]
            _values = _allvalues[config]
            _singletons = _allsingeltons[config]
            _required = _allrequired[config]
            null

    ioc
