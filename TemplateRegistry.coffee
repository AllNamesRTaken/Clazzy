define [
], () ->
    _registry = {}
    TemplateRegistry = 
        register: (templateId, templateString) -> 
            _registry[templateId] = templateString
        get: (templateId) -> 
            _registry[templateId] or "<div>Template not available</div>"
    TemplateRegistry
