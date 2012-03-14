define [
    "dojo/main"
    "util/doh/main"
    "clazzy/Exception"
], (dojo, doh, exception) ->

    doh.register "clazzy.tests.Exception", [

        name: "toString_null_nameUndMessageInString"
        setUp: () ->
            #Arrange
            @message = "--MESSAGE--"
            @name = "--NAME--"
            @ex = new exception @name, @message
        runTest: (t) -> 
            #Act
            exString = @ex.toString()
            #Assert
            doh.assertTrue exString.indexOf(@name)>-1 and exString.indexOf(@message)>-1
    ]
