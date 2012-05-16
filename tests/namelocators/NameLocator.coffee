define [
    "dojo/main"
    "util/doh/main"
    "clazzy/namelocators/NameLocator"
    "clazzy/Exception"
], (dojo, doh, NameLocator, Exception) ->


    nameLocator = new NameLocator();
    doh.register "clazzy.tests.namelocators.NameLocator", [

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
        tearDown: () -> 
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
        tearDown: () ->
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
        tearDown: () -> 
    ,
        name: "configExists_notExistingConfig_false"
        setUp: () ->
            #Arrange
            @configName = "nonExistingConfigName"
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertFalse nameLocator.configExists @configName
        tearDown: () -> 
    ,
        name: "configIsEmpty_emptyConfig_true"
        setUp: () ->
            #Arrange
        runTest: (t) -> 
            #Act
            empty = nameLocator.configIsEmpty("default")
            #Assert
            doh.assertTrue empty
        tearDown: () ->
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
        tearDown: () ->
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
        tearDown: () ->
            nameLocator.clear()
    ,
        name: "findSource_notExisting_throws"
        setUp: () ->
            #Arrange
            @sourceName = "mySource"
            @targetName = "myTarget"
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertError(Exception, nameLocator, "findSource", [@targetName])
        tearDown: () ->
            nameLocator.clear()
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
        tearDown: () ->
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
        tearDown: () ->
            nameLocator.clear()
    ,
        name: "findTarget_notExisting_found"
        setUp: () ->
            #Arrange
            @sourceName = "mySource"
            @targetName = "myTarget"
        runTest: (t) -> 
            #Act
            #Assert
            doh.assertError(Exception, nameLocator, "findTarget", [@sourceName])
        tearDown: () ->
            nameLocator.clear()
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
        tearDown: () ->
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
            #Assert
            doh.assertError(Exception, nameLocator, "findSource", [@targetName])
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
            nameLocator.setConfigTo @config1
            doh.assertError(Exception, nameLocator, "findSource", [@targetName])
            nameLocator.setConfigTo @config2
            doh.assertError(Exception, nameLocator, "findSource", [@targetName])
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
        tearDown: () ->
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
        tearDown: () ->
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
        tearDown: () ->
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
        tearDown: () ->
            nameLocator.clear()
    ]
