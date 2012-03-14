define [
    "clazzy/namelocators/NameLocator"
], (NameLocator) ->
    namelocator = new NameLocator()
    TemplateNameLocator = 
        getConfig: () -> 
            namelocator.config
        
        setConfigTo: (configname) ->
            namelocator.setConfigTo configname

        register: (templateId, className, config) ->
            namelocator.register templateId, className, config

        findTemplate: (className) ->
            namelocator.findSource className

        findClass: (templateId) ->
            namelocator.findTarget templateId

        hasTemplate: (className) -> 
            namelocator.hasSource className

        clear: (all) -> 
            namelocator.clear all
