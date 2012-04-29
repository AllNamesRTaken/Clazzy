define [
], () ->
    'use strict'
    #Taken shamelessly from MDN
    #!... and turned into CoffeeScript
    #!... and lowered the cyclomatic complexity
    indexOf = (searchElement) ->
        "use strict"
        throw new TypeError() unless this?
        args = arguments
        t = Object(this)
        len = t.length >>> 0
        len is 0 and ret = -1
        #return -1 if len is 0
        n = 0
        not ret? and args.length > 0 and n = do () ->
        #if arguments.length > 0
            n = Number(args[1])
            unless n is n
                n = 0
            else n = (n > 0 or -1) * Math.floor(Math.abs(n)) if n isnt 0 and n isnt Infinity and n isnt -Infinity
        n >= len and ret = -1
        #return -1 if n >= len
        k = (if n >= 0 then n else Math.max(len - Math.abs(n), 0))
        while k < len
            return k if k of t and t[k] is searchElement
            k++
        ret or -1
        #-1

    unless Array::indexOf
        Array::indexOf = indexOf

    has = (searchElement) ->
        "use strict"
        throw new TypeError() unless this?
        this.indexOf(searchElement) isnt -1
    hasnt = (searchElement) ->
        "use strict"
        throw new TypeError() unless this?
        this.indexOf(searchElement) is -1

    unless Array::has
        Array::has = has
    unless Array::hasnt
        Array::hasnt = hasnt

    {
    Array: 
        indexOf: indexOf
        has: has
        hasnt: hasnt
    }
