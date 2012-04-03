define [
    "clazzy/Exception"
], (Exception) ->
    'use strict'

    _DEFAULT = "default"
    _registry = 
        default: {}
    TemplateRegistry = 
        config: _DEFAULT
        setConfigTo: (config) ->
            throw new Exception("InvalidInputException", "config must be a non null string. Currently: "+config) if not config or "string" isnt typeof config
            @config = config
            _registry[@config] = {} if not _registry[@config]
        register: (templateId, templateString) -> 
            throw new Exception("InvalidInputException", "templateId must be a non null string. Currently: "+templateId) if not templateId or  "string" isnt typeof templateId
            throw new Exception("InvalidInputException", "templateString must be a non null string. Currently: "+templateString) if not templateString or "string" isnt typeof templateString
            _registry[@config][templateId] = templateString
        get: (templateId) -> 
            throw new Exception("InvalidInputException", "templateId must be a non null string. Currently: "+templateId) if not templateId or "string" isnt typeof templateId
            _registry[@config][templateId] or "<div>Template not available</div>"
    TemplateRegistry
