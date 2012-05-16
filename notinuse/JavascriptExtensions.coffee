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

    filter = (fun) ->
        "use strict"
        throw new TypeError()  unless this?
        t = Object(this)
        len = t.length >>> 0
        throw new TypeError()  unless typeof fun is "function"
        res = []
        thisp = arguments[1]
        i = 0

        while i < len
            if i of t
                val = t[i]
                res.push val  if fun.call(thisp, val, i, t)
            i++
        res

    unless Array::filter
        Array::filter = filter

    map = (callback, thisArg) ->
        T = undefined
        A = undefined
        k = undefined
        throw new TypeError(" this is null or not defined")  unless this?
        O = Object(this)
        len = O.length >>> 0
        throw new TypeError(callback + " is not a function")  unless {}.toString.call(callback) is "[object Function]"
        T = thisArg  if thisArg
        A = new Array(len)
        k = 0
        while k < len
            kValue = undefined
            mappedValue = undefined
            if k of O
                kValue = O[k]
                mappedValue = callback.call(T, kValue, k, O)
                A[k] = mappedValue
            k++
        A

    unless Array::map
        Array::map = map

    getOwnPropertyNames = (obj) ->
        keys = []
        if typeof obj is "object" and obj isnt null
            for x of obj
                keys.push x  if obj.hasOwnProperty(x)
        keys

    if typeof Object.getOwnPropertyNames isnt "function"
        Object.getOwnPropertyNames = getOwnPropertyNames

    trim = ->
        @replace /^\s+|\s+$/g, ""
        
    unless String::trim
        String::trim = trim 

    {
    Array: 
        indexOf: indexOf
        has: has
        hasnt: hasnt
        filter: filter
    Object:
        getOwnPropertyNames: getOwnPropertyNames
    }
