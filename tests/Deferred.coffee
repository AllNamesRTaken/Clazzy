define [
    "dojo/main" 
    "util/doh/main" 
    "clazzy/Deferred" 
    "clazzy/Exception"
], (dojo, doh, Deferred, Exception) ->

    doh.register "clazzy.tests.Deferred", [

        name: "resolve_data_callbackIsCalledWithData"
        setUp: () ->
            #Arrange
            @deferred = new Deferred()
            @data = 1
        runTest: (t) -> 
            #Act
            d = new doh.Deferred()
            @deferred.then d.getTestCallback (data) -> 
                #Assert
                doh.assertEqual 1, data
            @deferred.resolve(@data)
            d
    ,
        name: "resolve_data_thenOfPromiseIsCalledWithData"
        setUp: () ->
            #Arrange
            @deferred = new Deferred()
            @data = 1
        runTest: (t) -> 
            #Act
            d = new doh.Deferred()
            promise = @deferred.then d.getTestCallback (data) -> 
            promise.then d.getTestCallback (data) -> 
                #Assert
                doh.assertEqual 1, data
            @deferred.resolve(@data)
            d
    ,
        name: "reject_exception_errbackIsCalledWithErrorValue"
        runTest: (t) -> 
            #Arrange
            @deferred = new Deferred()
            someError = "SomeError"
            #Act
            d = new doh.Deferred()
            @deferred.then (data) -> 
                1
            , d.getTestCallback (error) ->
                #Assert
                doh.assertEqual someError, error
            @deferred.reject(someError)
            d
    ,
        name: "cancel_null_errbackIsCalledWithException"
        runTest: (t) -> 
            #Arrange
            @deferred = new Deferred()
            #Act
            error = @error
            d = new doh.Deferred()
            @deferred.then (data) -> 
                1
            , d.getTestCallback (error) ->
                #Assert
                doh.assertTrue error instanceof Exception
            @deferred.cancel()
            d
    ,
        name: "progress_data_progressIsCalled"
        setUp: () ->
            #Arrange
            @deferred = new Deferred()
            @data = 1
        runTest: (t) -> 
            #Act
            d = new doh.Deferred()
            @deferred.then () -> 
                false
            , () -> 
                false
            , d.getTestCallback (data) -> 
                #Assert
                doh.assertEqual 1, data
            @deferred.progress(@data)
            d
    ,
        name: "addCallback_callback_CalladdCallbacksWithCallbackAndFalsy"
        setUp: () ->
            #Arrange
            @deferred = new Deferred()
            @originalAddCallbacks = @deferred.addCallbacks
            @deferred.addCallbacks = (callback, errback) -> 
                [callback, errback]
            @callback = (data) -> 1
        runTest: (t) -> 
            #Act
            result = @deferred.addCallback @callback
            #Assert
            doh.assertEqual 1, result[0]()
            doh.assertTrue not result[1]
        tearDown: () -> 
            @deferred.addCallbacks = @originalAddCallbacks
    ,
        name: "addErrback_errback_CalladdCallbacksWithfalsyAndErrback"
        setUp: () ->
            #Arrange
            @deferred = new Deferred()
            @originalAddCallbacks = @deferred.addCallbacks
            @deferred.addCallbacks = (callback, errback) ->  
                [callback, errback]
            @errback = (data) -> 2
        runTest: (t) -> 
            #Act
            result = @deferred.addErrback @errback
            #Assert
            doh.assertEqual 2, result[1]()
            doh.assertTrue not result[0]
        tearDown: () -> 
            @deferred.addCallbacks = @originalAddCallbacks
    ,
        name: "addBoth_callbackAndErrback_CalladdCallbacksWithCallbackEqualsErrback"
        setUp: () ->
            #Arrange
            @deferred = new Deferred()
            @originalAddCallbacks = @deferred.addCallbacks
            @deferred.addCallbacks = (callback, errback) -> 
                [callback, errback]
            @callback = (data) -> 1
        runTest: (t) -> 
            #Act
            result = @deferred.addBoth @callback, @errback
            #Assert
            doh.assertEqual 1, result[0]()
            doh.assertEqual result[0], result[1]
        tearDown: () -> 
            @deferred.addCallbacks = @originalAddCallbacks
    ,
        name: "addCallbacks_callbackAndErrback_callingThen"
        setUp: () ->
            #Arrange
            @deferred = new Deferred()
            @originalThen = @deferred.then
            @deferred.then = (callback, errback, progress) -> 
                @result = [callback, errback, progress]
            @callback = (data) -> 1
            @errback = (error) -> 2            
        runTest: (t) -> 
            #Act
            @deferred.addCallbacks @callback, @errback
            doh.assertEqual 1, @deferred.result[0]()
            doh.assertEqual 2, @deferred.result[1]()
        tearDown: () -> 
            @deferred.then = @originalThen
    ,
        name: "resolveTwice_data_throws"
        setUp: () ->
            #Arrange
            @deferred = new Deferred()
        runTest: (t) -> 
            #Act
            @deferred.then (data) -> 
                false
            @deferred.resolve(1)
            try
                @deferred.resolve(1)
            catch e
                doh.assertTrue e instanceof Exception
    ]
