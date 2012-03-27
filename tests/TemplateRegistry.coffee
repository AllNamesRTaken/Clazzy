define [
    "dojo/main"
    "util/doh/main"
    "clazzy/TemplateRegistry"
    "clazzy/Exception"
], (dojo, doh, templateRegistry, Exception) ->

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
        name: "get_null_throws"
        setUp: () ->
            #Arrange
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertError Exception, templateRegistry, "get", [null]
        tearDown: () -> 
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
    ,
        name: "setConfigTo_configname_configIsChanged"
        setUp: () ->
            #Arrange
        runTest: () ->
            #Act
            templateRegistry.setConfigTo "someNewName"
            #Assert
            doh.assertEqual "someNewName", templateRegistry.config
    ,
        name: "register_nullTemplateId_throws"
        setUp: () ->
            #Arrange
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertError Exception, templateRegistry, "register", [null]
        tearDown: () -> 
    ,
        name: "Register_nullTemplateString_throws"
        setUp: () ->
            #Arrange
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertError Exception, templateRegistry, "register", ["valid", null]
        tearDown: () -> 
    ]
