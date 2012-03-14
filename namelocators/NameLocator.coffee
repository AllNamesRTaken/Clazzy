define [
    "clazzy/Clazzy"
    "clazzy/abstraction/Lang"
    "clazzy/Exception"
], ( Class, lang, Exception) ->

    _DEFAULT = "default"
    
    Class "clazzy.namelocators.NameLocator", null, null, 
        config: _DEFAULT

        constructor: () ->
            @_allsources = 
                default: {}
            @_alltargets = 
                default: {}
            @_sources = {}
            @_targets = {}
            
            @setConfigTo _DEFAULT
            this

        initConfig: (configname) -> 
            return if @_allsources[configname]
            @_allsources[configname] = {}
            @_alltargets[configname] = {}

        setConfigTo: (configname) ->
            @config = configname
            @_sources = @_allsources[@config]
            @_targets = @_alltargets[@config]

        register: (sourceName, targetName, config = @config) ->
            @initConfig(config)
            throw new Exception("RegisterException", sourceName + ", " + targetName + " combination already registered in config '" + (config || _DEFAULT) + "'") if @_sources[targetName] or @_targets[sourceName]
            @_allsources[config][targetName] = sourceName
            @_alltargets[config][sourceName] = targetName

        findSource: (targetName) ->
            return (value for name, value of @_sources) if not targetName
            throw new Exception("RegisterException", targetName + " not registered") if not @_sources[targetName]?
            @_sources[targetName]

        findTarget: (sourceName) ->
            return (value for name, value of @_targets) if not sourceName
            throw new Exception("RegisterException", sourceName + " not registered") if not @_targets[sourceName]?
            @_targets[sourceName]
        
        hasSource: (targetName) -> 
            @_sources[targetName]?
        
        hasTarget: (sourceName) -> 
            @_targets[sourceName]?

        clear: (all) -> 
            currentConfig = @config
            _clear = lang.hitch @, (configName) ->
                @_allsources[configName] = {}
                @_alltargets[configName] = {}
                @setConfigTo configName
            if not all 
                _clear @config 
            else 
                _clear configName for configName of @_allsources
                @setConfigTo currentConfig
            
