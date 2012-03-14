define [
    "dojo/main"
    "util/doh/main"
    "clazzy/namelocators/InterfaceNameLocator"
    "clazzy/Exception"
], (dojo, doh, interfaceNameLocator, Exception) ->

    doh.register "clazzy.tests.namelocators.InterfaceNameLocators", [

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
        tearDown: () -> 
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
        tearDown: () ->
            interfaceNameLocator.clear()
    ,
        name: "register_existingInterfaceNameAndClassName_throws"
        setUp: () ->
            #Arrange
            @interfaceName = "myInterface"
            @className = "myClass"
            interfaceNameLocator.register(@interfaceName, @className)
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertError(Exception, interfaceNameLocator, "register", [@interfaceName, @className])
        tearDown: () ->
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
            interface = interfaceNameLocator.findInterface @className
            #Assert
            doh.assertEqual(@interfaceName, interface)
        tearDown: () ->
            interfaceNameLocator.clear()
    ,
        name: "findInterface_notExisting_throws"
        setUp: () ->
            #Arrange
            @interfaceName = "myInterface"
            @className = "myClass"
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertError(Exception, interfaceNameLocator, "findInterface", [@className])
        tearDown: () ->
            interfaceNameLocator.clear()
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
        tearDown: () ->
            interfaceNameLocator.clear()
    ,
        name: "findClass_notExisting_found"
        setUp: () ->
            #Arrange
            @interfaceName = "myInterface"
            @className = "myClass"
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertError(Exception, interfaceNameLocator, "findClass", [@interfaceName])
        tearDown: () ->
            interfaceNameLocator.clear()
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
            #Assert
            doh.assertError(Exception, interfaceNameLocator, "findInterface", [@className])
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
            interfaceNameLocator.setConfigTo @config1
            doh.assertError(Exception, interfaceNameLocator, "findInterface", [@className])
            interfaceNameLocator.setConfigTo @config2
            doh.assertError(Exception, interfaceNameLocator, "findInterface", [@className])
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
        tearDown: () ->
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
        tearDown: () ->
            interfaceNameLocator.clear()
    ]
