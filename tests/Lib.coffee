define [
    "dojo/main" 
    "util/doh/main" 
    "clazzy/Lib" 
    "clazzy/Exception"
    "clazzy/Deferred"
    "clazzy/Clazzy"
], (dojo, doh, lib, Exception, Deferred, Class) ->

    doh.register "clazzy.tests.Lib", [
        name: "deferList_2deferreds_resolving"
        setUp: () ->
            #Arrange
            @deferred1 = new Deferred()
            @deferred1.resolve 1
            @deferred2 = new Deferred()
            @deferred2.resolve 2
        runTest: (t) -> 
            #Act
            d = new doh.Deferred()
            lib.deferList([
                @deferred1
                @deferred2
            ]).then d.getTestCallback (data) -> 
                one=data[0][1]
                two=data[1][1]
                #Assert
                doh.assertEqual 3, one + two
            d
    ,
        name: "deferList_2deferreds_rejecting"
        setUp: () ->
            #Arrange
            @deferred1 = new Deferred()
            @deferred1.resolve 1
            @deferred2 = new Deferred()
            @deferred2.reject new Exception()
        runTest: (t) -> 
            #Act
            d = new doh.Deferred()
            lib.deferList([
                @deferred1
                @deferred2
            ]).then d.getTestCallback (data) -> 
                one=data[0][1]
                error=data[1][1]
                #Assert
                doh.assertEqual 1, one
                doh.assertTrue error instanceof Exception
            d
    ,
        name: "find_existingClass_found"
        setUp: () ->
            #Arrange
            @cls = Class "tests.DummyClass"
        runTest: (t) -> 
            #Act
            cls = lib.findClass "tests.DummyClass"
            #Assert
            doh.assertEqual @cls, cls
    ,
        name: "find_undefinedClass_null"
        runTest: (t) -> 
            #Act
            cls = lib.findClass "tests.UnexisingDummyClass"
            #Assert
            doh.assertEqual null, cls
    ]
