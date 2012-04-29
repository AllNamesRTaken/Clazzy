define [
    "clazzy/abstraction/Lang"
    "clazzy/Exception"
    "clazzy/JavascriptExtensions"
], (_lang, Exception) ->
    'use strict'
    #The class all other classes inherit from.
    class BaseClass
        declaredClass: "BaseClass"
        _implements: () -> []
        _fullname: () -> ["BaseClass"]
        constructor: () -> 
            if arguments.length and "object" is typeof arguments[0]
                @[key] = prop for key, prop of arguments[0]
            @_watchers = (prop, oldValue, newValue, index, self) ->
                if callbacks = @_watchers[key = '_' + prop]?.slice()
                    for callback in callbacks
                        throw new Exception("NotAFunctionException", "watcher is not a function for property: " + prop) if not callback.call?
                        callback.call(this, prop, oldValue, newValue, index, self)
                if callbacks = @_watchers['*']
                    for callback in callbacks
                        throw new Exception("NotAFunctionException", "watcher is not a function for property: " + prop) if not callback.call?
                        callback.call(this, prop, oldValue, newValue, index, self)
                this
            @_validators = (prop, oldValue, newValue, index, self) ->
                if callbacks = @_validators[key = '_' + prop]?.slice()
                    for callback in callbacks
                        throw new Exception("NotAFunctionException", "watcher is not a function for property: " + prop) if not callback.call?
                        return callback.call(this, prop, oldValue, newValue, index, self)
                0
            this
        is: (name) ->
            name = name.declaredClass if "object" is typeof name and name?.declaredClass
            name = name.classname if "function" is typeof name
            return true if name in @_fullname()
            return true if name in @_implements()
            false
        isnt: (name) ->
            not @is name
        set: (prop, value, index, self) -> 
            throw new Exception("IllegalPropertyNameException", "No property " + prop + " on class " + this.declaredClass) if this[prop] is undefined
            oldValue = this[prop]
            newValue = _lang.clone value
            if 1 is (cancel = this._validators(prop, oldValue, newValue, index, self))
                return oldValue

            if index? then this[prop][index] = newValue else this[prop] = newValue
            this._watchers(prop, oldValue, newValue, index, self)
            newValue
        get: (prop) -> 
            throw new Exception("IllegalPropertyNameException", "No property " + prop + " on class " + this.declaredClass) if this[prop] is undefined
            this[prop]
        watch: (prop, callback) ->
            key = if prop isnt '*' then '_' + prop else prop
            callbacks = @_watchers[key]
            callbacks = @_watchers[key] = [] if typeof callbacks isnt "object"
            callbacks.push(callback)
            return {
                remove: () ->
                    callbacks.splice(callbacks.indexOf(callback), 1)
            }
        validate: (prop, callback) ->
            key = '_' + prop
            callbacks = @_validators[key]
            callbacks = @_validators[key] = [] if typeof callbacks isnt "object"
            callbacks.push(callback)
            return {
                remove: () ->
                    callbacks.splice(callbacks.indexOf(callback), 1)
            }
        inherited: (fname, classname, args) ->
            passed = classname is this.declaredClass
            ctx = this.__super__
            ctx = ctx.__super__ until not ctx? or (ctx.hasOwnProperty(fname) and (passed=passed or classname is ctx.declaredClass) and classname isnt ctx.declaredClass)
            throw new Exception("NullPointerException", @declaredClass + " has no __super__ with function " + fname) if not ctx?
            return ctx[fname].apply(this, args) if ctx?
        toString: () ->
            @declaredClass
    BaseClass.classname = "BaseClass"
    BaseClass
