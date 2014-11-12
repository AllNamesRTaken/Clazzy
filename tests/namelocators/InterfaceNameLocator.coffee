define [
    "dojo/main"
    "util/doh/main"
    "clazzy/namelocators/InterfaceNameLocator"
    "clazzy/Exception"
], (dojo, doh, interfaceNameLocator, Exception) ->

    doh.register "clazzy.tests.namelocators.InterfaceNameLocators", [

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
            config = interfaceNameLocator.getConfig()
            #Assert
            doh.assertEqual(@configName, config)
    ,
        name: "setConfigTo_configName_configNameIsChanged"
        setUp: () ->
            #Arrange
            @configName = "newName"
        runTest: (t) -> 
            #Act
            interfaceNameLocator.setConfigTo @configName
            config = interfaceNameLocator.getConfig()
            #Assert
            doh.assertEqual(@configName, config)
        tearDown: (t) -> 
            interfaceNameLocator.setConfigTo "default"
    ,
        name: "register_newInterfaceNameAndClassName_noError"
        setUp: () ->
            #Arrange
            @interfaceName = "myInterface"
            @className = "myClass"
        runTest: (t) -> 
            #Act
            interfaceNameLocator.register(@interfaceName, @className)
            #Assert
            doh.assertTrue true
        tearDown: (t) ->
            interfaceNameLocator.clear()
    ,
        name: "findInterface_className_found"
        setUp: () ->
            #Arrange
            @interfaceName = "myInterface"
            @className = "myClass"
            interfaceNameLocator.register(@interfaceName, @className)
        runTest: (t) -> 
            #Act
            interfejs = interfaceNameLocator.findInterface @className
            #Assert
            doh.assertEqual(@interfaceName, interfejs)
        tearDown: (t) ->
            interfaceNameLocator.clear()
    ,
        name: "findInterface_notExisting_throws"
        setUp: (t) ->
            #Arrange
            @interfaceName = "myInterface"
            @className = "myClass"
        runTest: (t) -> 
            #Act
            interfaceNameLocator.findInterface(@className)
            #Assert
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            interfaceNameLocator.clear()
            t.Thrown = false
    ,
        name: "findClass_interfaceName_found"
        setUp: () ->
            #Arrange
            @interfaceName = "myInterface"
            @className = "myClass"
            interfaceNameLocator.register(@interfaceName, @className)
        runTest: (t) -> 
            #Act
            name = interfaceNameLocator.findClass @interfaceName
            #Assert
            doh.assertEqual(@className, name)
        tearDown: (t) ->
            interfaceNameLocator.clear()
    ,
        name: "findClass_notExisting_found"
        setUp: () ->
            #Arrange
            @interfaceName = "myInterface"
            @className = "myClass"
        runTest: (t) -> 
            #Act
            interfaceNameLocator.findClass(@interfaceName)
            #Assert
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            interfaceNameLocator.clear()
            t.Thrown = false
    ,
        name: "clear_null_configIsCleared"
        setUp: () ->
            #Arrange
            @interfaceName = "myInterface"
            @className = "myClass"
            interfaceNameLocator.register(@interfaceName, @className)
        runTest: (t) -> 
            #Act
            interfaceNameLocator.clear()
            interfaceNameLocator.findInterface(@className)
            #Assert
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            t.Thrown = false
    ,
        name: "clear_all_allConfigsAreCleared"
        setUp: () ->
            #Arrange
            @interfaceName = "myInterface"
            @className = "myClass"
            @config1 = "config1"
            @config2 = "config2"
            interfaceNameLocator.register(@interfaceName, @className, @config1)
            interfaceNameLocator.register(@interfaceName, @className, @config2)
        runTest: (t) -> 
            #Act
            interfaceNameLocator.clear(all=true)
            #Assert
            interfaceNameLocator.setConfigTo(@config1)
            interfaceNameLocator.findInterface(@className)
            doh.assertTrue(t.Thrown)
            t.Thrown = false
            interfaceNameLocator.setConfigTo(@config2)
            interfaceNameLocator.findInterface(@className)
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            t.Thrown = false
    ,
        name: "hasClass_notRegisteredInterfaceName_false"
        setUp: () ->
            #Arrange
            @interfaceName = "myInterface"
        runTest: (t) -> 
            #Act
            exits = interfaceNameLocator.hasClass(@interfaceName)
            #Assert
            doh.assertFalse exits
        tearDown: (t) ->
            interfaceNameLocator.clear()
    ,
        name: "hasClass_registeredInterfaceName_true"
        setUp: () ->
            #Arrange
            @interfaceName = "myInterface"
            @className = "myClass"
            interfaceNameLocator.register(@interfaceName, @className)
        runTest: (t) -> 
            #Act
            exits = interfaceNameLocator.hasClass(@interfaceName)
            #Assert
            doh.assertTrue exits
        tearDown: (t) ->
            interfaceNameLocator.clear()
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
