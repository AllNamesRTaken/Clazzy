define [
    "dojo/main"
    "util/doh/main"
    "clazzy/TemplateRegistry"
], (dojo, doh, templateRegistry) ->

    doh.register "clazzy.TemplateRegistry", [

        name: "get_registeredTemplateId_templateString"
        setUp: () ->
            #Arrange
            @testString = 'abc123'
            templateRegistry.register 'myTemplateId', @testString
        runTest: (t) -> 
            #Act
            template = templateRegistry.get 'myTemplateId'
            #Assert
            doh.assertEqual @testString, template
    ,
        name: "get_notRegisteredTemplateId_defaultTemplateString"
        setUp: () ->
            #Arrange
            @testString = '<div>Template not available</div>'
        runTest: (t) -> 
            #Act
            template = templateRegistry.get 'undefinedKey'
            #Assert
            doh.assertEqual @testString, template
    ]
