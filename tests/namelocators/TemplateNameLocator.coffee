define [
    "dojo/main"
    "util/doh/main"
    "clazzy/namelocators/TemplateNameLocator"
    "clazzy/Exception"
], (dojo, doh, templateNameLocator, Exception) ->

    doh.register "clazzy.tests.namelocators.TemplateNameLocator", [

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
        tearDown: () -> 
            templateNameLocator.setConfigTo "default"
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
        tearDown: () ->
            templateNameLocator.clear()
    ,
        name: "register_existingTemplateNameAndClassName_throws"
        setUp: () ->
            #Arrange
            @templateName = "myTemplate"
            @className = "myClass"
            templateNameLocator.register(@templateName, @className)
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertError(Exception, templateNameLocator, "register", [@templateName, @className])
        tearDown: () ->
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
        tearDown: () ->
            templateNameLocator.clear()
    ,
        name: "findTemplate_notExisting_throws"
        setUp: () ->
            #Arrange
            @templateName = "myTemplate"
            @className = "myClass"
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertError(Exception, templateNameLocator, "findTemplate", [@className])
        tearDown: () ->
            templateNameLocator.clear()
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
        tearDown: () ->
            templateNameLocator.clear()
    ,
        name: "findClass_notExisting_found"
        setUp: () ->
            #Arrange
            @templateName = "myTemplate"
            @className = "myClass"
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertError(Exception, templateNameLocator, "findClass", [@templateName])
        tearDown: () ->
            templateNameLocator.clear()
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
            #Assert
            doh.assertError(Exception, templateNameLocator, "findTemplate", [@className])
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
            doh.assertError(Exception, templateNameLocator, "findTemplate", [@className])
            templateNameLocator.setConfigTo @config2
            doh.assertError(Exception, templateNameLocator, "findTemplate", [@className])
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
        tearDown: () ->
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
        tearDown: () ->
            templateNameLocator.clear()
    ]
