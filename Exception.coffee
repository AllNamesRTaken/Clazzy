define [
], () ->

    class Exception
        constructor: (@name="Exception", @message = "Something went wrong.") -> 
            
        toString: () ->
            "[" + @name + "] " + @message
    
