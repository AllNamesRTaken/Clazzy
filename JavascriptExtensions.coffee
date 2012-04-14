define [
], () ->
    'use strict'
    #Taken shamelessly from MDN
    indexOf = (searchElement) ->
        "use strict"
        throw new TypeError()    unless this?
        t = Object(this)
        len = t.length >>> 0
        return -1    if len is 0
        n = 0
        if arguments.length > 0
            n = Number(arguments[1])
            unless n is n
                n = 0
            else n = (n > 0 or -1) * Math.floor(Math.abs(n))    if n isnt 0 and n isnt Infinity and n isnt -Infinity
        return -1    if n >= len
        k = (if n >= 0 then n else Math.max(len - Math.abs(n), 0))
        while k < len
            return k    if k of t and t[k] is searchElement
            k++
        -1
    unless Array::indexOf
        Array::indexOf = indexOf
    {
    Array: 
        indexOf: indexOf
    }
