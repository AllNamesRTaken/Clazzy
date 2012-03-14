define [
    "dojo/main" 
    "util/doh/main" 
    "clazzy/DeferredList" 
    "clazzy/Exception" 
    "clazzy/Deferred"
], (dojo, doh, DeferredList, Exception, Deferred) ->

    doh.register "clazzy.tests.DeferredList", [

        name: "run_2deferreds_resolving"
        setUp: () ->
            #Arrange
            @deferred1 = new Deferred()
            @deferred1.resolve 1
            @deferred2 = new Deferred()
            @deferred2.resolve 2
            @deferredList = new DeferredList()
        runTest: (t) -> 
            d = new doh.Deferred()
            @deferredList.then d.getTestCallback (data) -> 
                one=data[0][1]
                two=data[1][1]
                #Assert
                doh.assertEqual 3, one + two

            #Act
            @deferredList.run([@deferred1, @deferred2])
            d
    ,
        name: "run_2deferreds_rejecting"
        setUp: () ->
            #Arrange
            @deferred1 = new Deferred()
            @deferred2 = new Deferred()
            @deferredList = new DeferredList()
        runTest: (t) -> 
            d = new doh.Deferred()
            @deferredList.then d.getTestCallback (data) -> 
                one=data[0][1]
                error=data[1][1]
                #Assert
                doh.assertEqual 1, one
                doh.assertTrue error instanceof Exception

            #Act
            @deferredList.run([@deferred1, @deferred2])
            @deferred1.resolve 1
            @deferred2.resolve new Exception()
            d
    ,
        name: "run_2deferredsFireOnCallback_resolving"
        setUp: () ->
            #Arrange
            @deferred1 = new Deferred()
            @deferred2 = new Deferred()
            @deferredList = new DeferredList()
        runTest: (t) -> 
            d = new doh.Deferred()
            @deferredList.then d.getTestCallback (data) -> 
                whichDeferred = data[0]
                value = data[1]
                #Assert
                doh.assertEqual 0. whichDeferred
                doh.assertEqual 42, value

            #Act
            @deferredList.run [@deferred1, @deferred2], true
            @deferred1.resolve(42)
            d
    ,
        name: "run_2deferredsFireOnErrbackDontConsumeErrors_rejectingThrows"
        setUp: () ->
            #Arrange
            @deferred1 = new Deferred()
            @deferred2 = new Deferred()
            @deferredList = new DeferredList()
        runTest: (t) -> 
            @deferredList.then (data) -> 
                false
            , (error) -> 
                false
            #Act
            @deferredList.run [@deferred1, @deferred2], false, true, false
            #Assert
            try
                @deferred1.reject new Exception()
            catch e
                doh.assertTrue e instanceof Exception
    ,
        name: "run_2deferredsFireOnErrbackConsumeErrors_resolvingWithError"
        setUp: () ->
            #Arrange
            @deferred1 = new Deferred()
            @deferred2 = new Deferred()
            @deferredList = new DeferredList()
        runTest: (t) -> 
            d = new doh.Deferred()
            @deferredList.then (data) ->
                false
            , d.getTestCallback (data) -> 
                doh.assertTrue data instanceof Exception

            #Act
            @deferredList.run [@deferred1, @deferred2], false, true, true
            @deferred1.resolve 1
            @deferred2.reject new Exception()
            d
    ]
