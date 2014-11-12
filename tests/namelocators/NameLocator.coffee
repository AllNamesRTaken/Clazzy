define [
    "dojo/main"
    "util/doh/main"
    "clazzy/namelocators/NameLocator"
    "clazzy/Exception"
], (dojo, doh, NameLocator, Exception) ->


    nameLocator = new NameLocator();
    doh.register "clazzy.tests.namelocators.NameLocator", [

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
        name: "setConfigTo_configName_configNameIsChanged"
        setUp: () ->
            #Arrange
            @configName = "newName"
        runTest: (t) -> 
            #Act
            nameLocator.setConfigTo @configName
            config = nameLocator.config
            #Assert
            doh.assertEqual(@configName, config)
        tearDown: (t) -> 
            nameLocator.setConfigTo "default"
    ,
        name: "register_newSourceNameAndTargetName_noError"
        setUp: () ->
            #Arrange
            @sourceName = "mySource"
            @targetName = "myTarget"
        runTest: (t) -> 
            #Act
            nameLocator.register(@sourceName, @targetName)
            #Assert
            doh.assertTrue true
        tearDown: (t) ->
            nameLocator.clear()
    ,
        name: "configExists_existingConfig_true"
        setUp: () ->
            #Arrange
            @configName = "default"
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertTrue nameLocator.configExists @configName
        tearDown: (t) -> 
    ,
        name: "configExists_notExistingConfig_false"
        setUp: () ->
            #Arrange
            @configName = "nonExistingConfigName"
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertFalse nameLocator.configExists @configName
        tearDown: (t) -> 
    ,
        name: "configIsEmpty_emptyConfig_true"
        setUp: () ->
            #Arrange
        runTest: (t) -> 
            #Act
            empty = nameLocator.configIsEmpty("default")
            #Assert
            doh.assertTrue empty
        tearDown: (t) ->
    ,
        name: "configIsEmpty_nonEmptyConfig_false"
        setUp: () ->
            #Arrange
            nameLocator.register("mySource", "myTarget")
        runTest: (t) -> 
            #Act
            empty = nameLocator.configIsEmpty("default")
            #Assert
            doh.assertFalse empty
        tearDown: (t) ->
            nameLocator.clear()
    ,        
        name: "findSource_targetName_found"
        setUp: () ->
            #Arrange
            @sourceName = "mySource"
            @targetName = "myTarget"
            nameLocator.register(@sourceName, @targetName)
        runTest: (t) -> 
            #Act
            source = nameLocator.findSource @targetName
            #Assert
            doh.assertEqual(@sourceName, source)
        tearDown: (t) ->
            nameLocator.clear()
    ,
        name: "findSource_notExisting_throws"
        setUp: () ->
            #Arrange
            @sourceName = "mySource"
            @targetName = "myTarget"
        runTest: (t) -> 
            #Act
            nameLocator.findSource(@targetName)
            #Assert
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            nameLocator.clear()
            t.Thrown = false
    ,
        name: "findSource_null_arrayWithAll"
        setUp: () ->
            #Arrange
            @sourceName = "mySource"
            @targetName = "myTarget"
            nameLocator.register(@sourceName, @targetName)
        runTest: (t) -> 
            #Act
            array = nameLocator.findSource()
            #Assert
            doh.assertEqual(@sourceName, array[0])
        tearDown: (t) ->
            nameLocator.clear()
    ,
        name: "findTarget_sourceName_found"
        setUp: () ->
            #Arrange
            @sourceName = "mySource"
            @targetName = "myTarget"
            nameLocator.register(@sourceName, @targetName)
        runTest: (t) -> 
            #Act
            name = nameLocator.findTarget @sourceName
            #Assert
            doh.assertEqual(@targetName, name)
        tearDown: (t) ->
            nameLocator.clear()
    ,
        name: "findTarget_notExisting_found"
        setUp: () ->
            #Arrange
            @sourceName = "mySource"
            @targetName = "myTarget"
        runTest: (t) -> 
            #Act
            nameLocator.findTarget(@sourceName)
            #Assert
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            nameLocator.clear()
            t.Thrown = false
    ,
        name: "findTarget_null_arrayWithAll"
        setUp: () ->
            #Arrange
            @sourceName = "mySource"
            @targetName = "myTarget"
            nameLocator.register(@sourceName, @targetName)
        runTest: (t) -> 
            #Act
            array = nameLocator.findTarget()
            #Assert
            doh.assertEqual(@targetName, array[0])
        tearDown: (t) ->
            nameLocator.clear()
    ,
        name: "clear_null_configIsCleared"
        setUp: () ->
            #Arrange
            @sourceName = "mySource"
            @targetName = "myTarget"
            nameLocator.register(@sourceName, @targetName)
        runTest: (t) -> 
            #Act
            nameLocator.clear()
            nameLocator.findSource(@targetName)
            #Assert
            doh.assertTrue(t.Thrown) 
        tearDown: (t) ->
            t.Thrown = false
    ,
        name: "clear_all_allConfigsAreCleared"
        setUp: () ->
            #Arrange
            @sourceName = "mySource"
            @targetName = "myTarget"
            @config1 = "config1"
            @config2 = "config2"
            nameLocator.register(@sourceName, @targetName, @config1)
            nameLocator.register(@sourceName, @targetName, @config2)
        runTest: (t) -> 
            #Act
            nameLocator.clear(all=true)
            #Assert
            nameLocator.setConfigTo(@config1)
            nameLocator.findSource(@targetName)
            doh.assertTrue(t.Thrown)
            t.Thrown = false
            nameLocator.setConfigTo(@config2)
            nameLocator.findSource(@targetName)
            doh.assertTrue(t.Thrown)
        tearDown: (t) ->
            t.Thrown = false
    ,
        name: "hasSource_notRegisteredSourceName_false"
        setUp: () ->
            #Arrange
            @targetName = "myTarget"
        runTest: (t) -> 
            #Act
            exits = nameLocator.hasSource(@targetName)
            #Assert
            doh.assertFalse exits
        tearDown: (t) ->
            nameLocator.clear()
    ,
        name: "hasSource_registeredSourceName_true"
        setUp: () ->
            #Arrange
            @sourceName = "mySource"
            @targetName = "myTarget"
            nameLocator.register(@sourceName, @targetName)
        runTest: (t) -> 
            #Act
            exits = nameLocator.hasSource(@targetName)
            #Assert
            doh.assertTrue exits
        tearDown: (t) ->
            nameLocator.clear()
    ,
        name: "hasTarget_notRegisteredTargetName_false"
        setUp: () ->
            #Arrange
            @sourceName = "myTarget"
        runTest: (t) -> 
            #Act
            exits = nameLocator.hasTarget(@sourceName)
            #Assert
            doh.assertFalse exits
        tearDown: (t) ->
            nameLocator.clear()
    ,
        name: "hasTarget_RegisteredTargetName_false"
        setUp: () ->
            #Arrange
            @sourceName = "mySource"
            @targetName = "myTarget"
            nameLocator.register(@sourceName, @targetName)
        runTest: (t) -> 
            #Act
            exits = nameLocator.hasTarget(@sourceName)
            #Assert
            doh.assertTrue exits
        tearDown: (t) ->
            nameLocator.clear()
    ,
        name: "TEARDOWN"
        setUp: () ->
            #Arrange
        runTest: () -> 
            #Act
            #Assert
            doh.assertTrue(true)
        tearDown: (t) ->
            Exception.prototype.Throw = t.originalThrow
    ]
