define [
    "dojo/main"
    "util/doh/main"
    "clazzy/TemplateRegistry"
    "clazzy/Exception"
], (dojo, doh, templateRegistry, Exception) ->

    doh.register "clazzy.TemplateRegistry", [

        name: "SETUP"
        setUp: (t) ->
            #Arrange
            t.originalThrow = Exception.prototype.Throw
            test = t
            test.Thrown = false
            Exception.prototype.Throw = () ->
                test.Thrown = true
        runTest: () -> 
            #Act
            #Assert
            doh.assertTrue true
    ,
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
            templateRegistry.get(null)
            #Assert
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            t.Thrown = false
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
        name: "setConfigTo_nonStringConfigname_throws"
        setUp: () ->
            #Arrange
        runTest: (t) -> 
            #Act
            templateRegistry.setConfigTo 0
            #Assert
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            t.Thrown = false
    ,
        name: "register_nullTemplateId_throws"
        setUp: () ->
            #Arrange
        runTest: (t) -> 
            #Act
            templateRegistry.register(null)
            #Assert
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            t.Thrown = false
    ,
        name: "Register_nullTemplateString_throws"
        setUp: () ->
            #Arrange
        runTest: (t) -> 
            #Act
            templateRegistry.register("valid", null)
            #Assert
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            t.Thrown = false
    ,
        name: "TEARDOWN"
        setUp: () ->
            #Arrange
        runTest: () -> 
            #Act
            #Assert
            doh.assertTrue true
        tearDown: (t) ->
            Exception.prototype.Throw = t.originalThrow
    ]
