define [
    "underscore/main"
], (_) ->
    'use strict'

    _toArray = (obj, offset, startWith) ->
        return (startWith||[]).concat(Array.prototype.slice.call(obj, offset||0))

    Lang = 
        hitch: (that, func) ->
            if arguments.length > 2
                pre = _toArray(arguments, 2)
                return () ->
                    args = _toArray(arguments)
                    func.apply(this, pre.concat(args))
            return func if not that
            func = that[func] if typeof func is "string"
            return () -> 
                func.apply(that, arguments || [])
        partial: (method) -> #method, arguments
            arr = [ null ];
            return @hitch.apply(this, arr.concat(_toArray(arguments)))
        clone: (src) ->
            if not src or typeof src isnt "object" or "function" is typeof src
                return src
            if src.nodeType and "cloneNode" in src
                return src.cloneNode true
            if src instanceof Date
                return new Date(src.getTime())
            if src instanceof RegExp
                return new RegExp(src)
            if Lang.isArray(src)
                # array
                r = (Lang.clone(item) for item in src)
                # we don 't clone functions for performance reasons
                #      }else if(d.isFunction(src)){
                #          # function
                #          r = function(){ return src.apply(this, arguments); };
            else
                # generic objects
                r = if src.constructor then new src.constructor() else {}
            return Lang.mixin(r, src, Lang.clone)
        isArray: (it) ->
            return it and (it instanceof Array or typeof it is "array")
        isElement: (target) -> 
            return if target?.nodeType is 1 then true else false
        isFunction: (it) ->
            return Object.prototype.toString.call(it) is "[object Function]"
        mixin: (dest = {}, source, copyFunc) ->
            for name of source
                empty = {}
                # the (!(name in empty) || empty[name] !== s) condition avoids copying properties in "source"
                # inherited from Object.prototype.  For example, if dest has a custom toString() method,
                # don't overwrite it with the toString() method that source inherited from Object.prototype
                s = source[name]
                if not(name of dest) or (dest[name] isnt s and (not(name of empty) or empty[name] isnt s))
                    dest[name] = if copyFunc then copyFunc(s) else s
            ### dont know what this is, removed for now
            if has("bug-for-in-skips-shadowed")
                if source
                    for (i = 0; i < _extraLen; ++i) 
                        name = _extraNames[i]
                        s = source[name]
                        if (not(name of dest) or (dest[name] isnt s and (not(name of empty) or empty[name] isnt s)))
                            dest[name] = if copyFunc then copyFunc(s) else s
            ###
            dest

        # Underscore abstractions

        indexOf: _.indexOf
        filter: _.filter
        map: _.map

