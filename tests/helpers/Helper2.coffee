define [
    "clazzy/Clazzy"
], (Class) ->
    Class "clazzy.tests.helpers.Helper2", null, null, 
        __dependencies: ["IHelper1"]
        constructor: (args) -> 
            this
        getHelper1: () ->
            @IHelper1
