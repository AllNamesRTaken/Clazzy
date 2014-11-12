define [
], () ->
    'use strict'

    class Exception
        constructor: (@name="Exception", @message = "Something went wrong.") -> 
            this

        toString: () ->
            "[" + @name + "] " + @message
    
        Throw: () ->
            console.log this.toString()
            this
