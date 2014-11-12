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
            (new Exception("InvalidInputException", "config must be a non null string. Currently: "+config)).Throw() if not config or "string" isnt typeof config
            @config = config
            _registry[@config] = {} if not _registry[@config]
        register: (templateId, templateString) -> 
            (new Exception("InvalidInputException", "templateId must be a non null string. Currently: "+templateId)).Throw() if not templateId or  "string" isnt typeof templateId
            (new Exception("InvalidInputException", "templateString must be a non null string. Currently: "+templateString)).Throw() if not templateString or "string" isnt typeof templateString
            _registry[@config][templateId] = templateString
        get: (templateId) -> 
            (new Exception("InvalidInputException", "templateId must be a non null string. Currently: "+templateId)).Throw() if not templateId or "string" isnt typeof templateId
            _registry[@config][templateId] or "<div>Template not available</div>"
    TemplateRegistry
