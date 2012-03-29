define [
    "dojo/main"
    "util/doh/main"
    "clazzy/IoC"
    "clazzy/Clazzy"
    "clazzy/abstraction/Lang" #used for hitch
    "clazzy/Lib" #deferList
    "dojo/cache"
    "dojo/_base/url"
    "clazzy/namelocators/TemplateNameLocator"
    "clazzy/TemplateRegistry"
], (dojo, doh, ioc, Class, lang, lib, cache, _url, templateNameLocator, templateRegistry) ->

    registerTemplate = (templateid, classname, templatestring, config) ->
        templateNameLocator.register templateid, classname, config
        templateRegistry.register templateid, templatestring, config 

    doh.register "clazzy.tests.IoC", [ 
        name: "SETUP"
        setUp: () ->
            #Arrange
            Class "tests.SingelDummy"
            Class "tests.NormalDummy"
            Class "tests.NormalDummyWithDeps", null, null, 
                __dependencies: ["IHelper1"]
                constructor: () ->
            Class "tests.NormalDummyWithDepsInTemplate", null, null, 
                __dependencies: []
                constructor: () ->
            ioc.setConfig "default"
            ioc.register "ISingelton", "tests.SingelDummy", true
            ioc.register "INormal", "tests.NormalDummy", false
            ioc.register "IHelper1", "clazzy.tests.helpers.Helper1", false
            ioc.register "IHelper2", "clazzy.tests.helpers.Helper2", false
            registerTemplate "THelper2", "clazzy.tests.helpers.Helper2", cache new _url("../../../lib/clazzy/tests/helpers/HelperTemplate.html")
            registerTemplate "DepsTemplate", "tests.NormalDummyWithDepsInTemplate", cache new _url("../../../lib/clazzy/tests/helpers/DepsTemplate.html")
        runTest: (t) -> 
            #Act
            doh.assertTrue true
    ,
        name: "get_interfaceWithValues_callsGetByClass"
        setUp: () ->
            #Arrange
            ioc.setConfig "default"
            @originalGetByClass = ioc.getByClass
            ioc.getByClass = (classname, values) ->
                {classname:classname, values:values}
            @values = {a:1, b:2}
        runTest: (t) -> 
            #Act
            result = ioc.get "INormal", @values
            #Assert
            doh.assertEqual "tests.NormalDummy", result.classname
            doh.assertEqual @values, result.values
        tearDown: () ->
            ioc.getByClass = @originalGetByClass
    ,
        name: "getByClass_singeltonClassWithValues_singeltonInstance"
        setUp: () ->
            #Arrange
            @values = {a:1, b:2}
        runTest: (t) -> 
            d = new doh.Deferred()
            #Act
            deferred = lib.deferList [
                ioc.getByClass "tests.SingelDummy", @values
                ioc.getByClass "tests.SingelDummy", @values
            ]
            deferred.then d.getTestCallback lang.hitch this, (data) -> 
                #Assert
                doh.assertEqual @values.a, data[0][1].a
                doh.assertEqual "tests.SingelDummy", data[0][1].declaredClass
                doh.assertTrue data[0][1] is data[1][1]
            d
    ,
        name: "getByClass_normalClassWithValues_normalInstance"
        setUp: () ->
            #Arrange
            @values = {a:1, b:2}
        runTest: (t) -> 
            d = new doh.Deferred()
            #Act
            deferred = lib.deferList [
                ioc.getByClass "tests.NormalDummy", @values
                ioc.getByClass "tests.NormalDummy", @values
            ]
            deferred.then d.getTestCallback lang.hitch this, (data) -> 
                #Assert
                doh.assertEqual @values.a, data[0][1].a
                doh.assertEqual "tests.NormalDummy", data[0][1].declaredClass
                doh.assertTrue data[0][1] isnt data[1][1]
            d
    ,
        name: "setConfig_configName_configIsChanged"
        setUp: () ->
            #Arrange
            @originalConfigName = ioc.getConfig()
            @configName = "newConfig"
        runTest: (t) -> 
            #Act
            ioc.setConfig @configName
            #Assert
            doh.assertEqual @configName, ioc.getConfig()
        tearDown: () ->
            ioc.setConfig @originalConfigName
    ,
        name: "getByClass_ExistingNotRequiredClassWithNotRequiredDependencies_instanceWithDependencies"
        setUp: () ->
            #Arrange
        runTest: (t) -> 
            d = new doh.Deferred()
            #Act
            ioc.getByClass("tests.NormalDummyWithDeps").then d.getTestCallback lang.hitch this, (instance) -> 
                #Assert
                doh.assertEqual "tests.NormalDummyWithDeps", instance.declaredClass
                doh.assertEqual "clazzy.tests.helpers.Helper1", instance.IHelper1.declaredClass
            d
    ,
        name: "get_notRequiredClassWithDependencies_instanceWithDependencies"
        setUp: () ->
            #Arrange
        runTest: (t) -> 
            d = new doh.Deferred()
            #Act
            ioc.get("IHelper2").then d.getTestCallback lang.hitch this, (instance) -> 
                #Assert
                doh.assertEqual "clazzy.tests.helpers.Helper2", instance.declaredClass
                doh.assertEqual "clazzy.tests.helpers.Helper1", instance.getHelper1().declaredClass
            d
    ,
        name: "get_ExistingNotRequiredClassWithDependeciesInTemplate_dependenciesAreRequired"
        setUp: () ->
            #Arrange
        runTest: (t) -> 
            d = new doh.Deferred()
            #Act
            doh.assertFalse not not clazzy.tests.helpers.Helper3
            ioc.getByClass("tests.NormalDummyWithDepsInTemplate").then d.getTestCallback lang.hitch this, (instance) -> 
                #Assert
                doh.assertTrue not not clazzy.tests.helpers.Helper3
            d

    ]
