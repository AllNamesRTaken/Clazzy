define [
    "dojo/main"
    "util/doh/main"
    "clazzy/Deferred"
    "clazzy/When"
], (dojo, doh, Deferred, When) ->

    doh.register "clazzy.tests.When", [
        name: "when_resolvedPromise_doWithReturnValue"
        runTest: (t) ->
            response = new Deferred()
            response.resolve("ok")
            d = new doh.Deferred()
            When response, d.getTestCallback (data) -> 
                doh.assertEqual "ok", data
    ,
        name: "when_nonPromiseValue_doWithValue"
        runTest: (t) ->
            response = "ok"
            When response, (data) -> 
                doh.assertEqual "ok", data
    ]
