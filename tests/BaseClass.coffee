define [
    "dojo/main"
    "util/doh/main"
], (dojo, doh, declare, Exception) ->

    doh.register "clazzy.tests.BaseClass", [
        name: "All_TESTS_FOR_BASECLASS_ARE_FOUND_IN_CLAZZY"
        runTest: (t) ->
            doh.assertTrue true
    ]
