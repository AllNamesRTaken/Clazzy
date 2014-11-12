define [
    "dojo/main"
    "util/doh/main"
    "clazzy/namelocators/TemplateNameLocator"
    "clazzy/Exception"
], (dojo, doh, templateNameLocator, Exception) ->

    doh.register "clazzy.tests.namelocators.TemplateNameLocator", [

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
        name: "getConfig_null_configName"
        setUp: () ->
            #Arrange
            @configName = "default"
        runTest: (t) -> 
            #Act
            config = templateNameLocator.getConfig()
            #Assert
            doh.assertEqual(@configName, config)
    ,
        name: "setConfigTo_configName_configNameIsChanged"
        setUp: () ->
            #Arrange
            @configName = "newName"
        runTest: (t) -> 
            #Act
            templateNameLocator.setConfigTo @configName
            config = templateNameLocator.getConfig()
            #Assert
            doh.assertEqual(@configName, config)
        tearDown: (t) -> 
            templateNameLocator.setConfigTo "default"
    ,
        name: "configExists_existingConfig_true"
        setUp: () ->
            #Arrange
            @configName = "default"
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertTrue templateNameLocator.configExists @configName
        tearDown: (t) -> 
    ,
        name: "configExists_notExistingConfig_true"
        setUp: () ->
            #Arrange
            @configName = "nonExistingConfigName"
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertFalse templateNameLocator.configExists @configName
        tearDown: (t) -> 
    ,
        name: "configIsEmpty_emptyConfig_true"
        setUp: () ->
            #Arrange
        runTest: (t) -> 
            #Act
            empty = templateNameLocator.configIsEmpty("default")
            #Assert
            doh.assertTrue empty
        tearDown: (t) ->
    ,
        name: "configIsEmpty_nonEmptyConfig_false"
        setUp: () ->
            #Arrange
            templateNameLocator.register("mySource", "myTarget")
        runTest: (t) -> 
            #Act
            empty = templateNameLocator.configIsEmpty("default")
            #Assert
            doh.assertFalse empty
        tearDown: (t) ->
            templateNameLocator.clear()
    ,     
        name: "register_newTemplateNameAndClassName_noError"
        setUp: () ->
            #Arrange
            @templateName = "myTemplate"
            @className = "myClass"
        runTest: (t) -> 
            #Act
            templateNameLocator.register(@templateName, @className)
            #Assert
            doh.assertTrue true
        tearDown: (t) ->
            templateNameLocator.clear()
    ,
        name: "findTemplate_className_found"
        setUp: () ->
            #Arrange
            @templateName = "myTemplate"
            @className = "myClass"
            templateNameLocator.register(@templateName, @className)
        runTest: (t) -> 
            #Act
            template = templateNameLocator.findTemplate @className
            #Assert
            doh.assertEqual(@templateName, template)
        tearDown: (t) ->
            templateNameLocator.clear()
    ,
        name: "findTemplate_notExisting_throws"
        setUp: () ->
            #Arrange
            @templateName = "myTemplate"
            @className = "myClass"
        runTest: (t) -> 
            #Act
            templateNameLocator.findTemplate(@className)
            #Assert
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            templateNameLocator.clear()
            t.Thrown = false
    ,
        name: "findClass_templateName_found"
        setUp: () ->
            #Arrange
            @templateName = "myTemplate"
            @className = "myClass"
            templateNameLocator.register(@templateName, @className)
        runTest: (t) -> 
            #Act
            name = templateNameLocator.findClass @templateName
            #Assert
            doh.assertEqual(@className, name)
        tearDown: (t) ->
            templateNameLocator.clear()
    ,
        name: "findClass_notExisting_found"
        setUp: () ->
            #Arrange
            @templateName = "myTemplate"
            @className = "myClass"
        runTest: (t) -> 
            #Act
            templateNameLocator.findClass(@templateName)
            #Assert
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            templateNameLocator.clear()
            t.Thrown = false
    ,
        name: "clear_null_configIsCleared"
        setUp: () ->
            #Arrange
            @templateName = "myTemplate"
            @className = "myClass"
            templateNameLocator.register(@templateName, @className)
        runTest: (t) -> 
            #Act
            templateNameLocator.clear()
            templateNameLocator.findTemplate(@className)
            #Assert
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            t.Thrown = false
    ,
        name: "clear_all_allConfigsAreCleared"
        setUp: () ->
            #Arrange
            @templateName = "myTemplate"
            @className = "myClass"
            @config1 = "config1"
            @config2 = "config2"
            templateNameLocator.register(@templateName, @className, @config1)
            templateNameLocator.register(@templateName, @className, @config2)
        runTest: (t) -> 
            #Act
            templateNameLocator.clear(all=true)
            #Assert
            templateNameLocator.setConfigTo @config1
            templateNameLocator.findTemplate(@className)
            doh.assertTrue(t.Thrown)
            t.Thrown = false
            templateNameLocator.setConfigTo @config2
            templateNameLocator.findTemplate(@className)
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            t.Thrown = false
    ,
        name: "hasTemplate_notRegisteredTemplateName_false"
        setUp: () ->
            #Arrange
            @className = "myClass"
        runTest: (t) -> 
            #Act
            exits = templateNameLocator.hasTemplate(@className)
            #Assert
            doh.assertFalse exits
        tearDown: (t) ->
            templateNameLocator.clear()
    ,
        name: "hasTemplate_registeredTemplateName_true"
        setUp: () ->
            #Arrange
            @templateName = "myTemplate"
            @className = "myClass"
            templateNameLocator.register(@templateName, @className)
        runTest: (t) -> 
            #Act
            exits = templateNameLocator.hasTemplate(@className)
            #Assert
            doh.assertTrue exits
        tearDown: (t) ->
            templateNameLocator.clear()
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
