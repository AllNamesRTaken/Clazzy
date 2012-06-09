define [
    "clazzy/abstraction/Lang"
    "clazzy/Exception"
], (lang, Exception) ->
    
    #The class all other classes inherit from.
    class BaseClass
        declaredClass: "BaseClass"
        _implements: () -> []
        _fullname: () -> ["BaseClass"]
        constructor: () -> 
            'use strict'
            if arguments.length and "object" is typeof arguments[0]
                @[key] = prop for key, prop of arguments[0]
            @_locked = {}
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
            @_model = {}
            this
        is: (name) ->
            'use strict'
            name = name.declaredClass if "object" is typeof name and name?.declaredClass
            name = name.classname if lang.isFunction name
            return true if name in @_fullname()
            return true if name in @_implements()
            false
        isnt: (name) ->
            'use strict'
            not @is name
        haz: (prop) -> 
            'use strict'
            return true if this._model?.hasOwnProperty(prop) or this[prop] isnt undefined
            false
        haznt: (prop) -> 
            'use strict'
            not @haz prop
        addModel: (model) ->
           lang.mixin @_model, model 
        set: (prop, value, index, self) -> 
            'use strict'
            model = if this._model?[prop] isnt undefined then this._model else this
            throw new Exception("IllegalPropertyNameException", "No property " + prop + " on class " + @declaredClass) if @haznt prop
            oldValue = model[prop]
            newValue = value
            if 1 is (cancel = @_validators(prop, oldValue, newValue, index, self))
                return oldValue

            if index? then model[prop][index] = newValue else model[prop] = newValue
            @_watchers(prop, oldValue, newValue, index, self)
            newValue
        get: (prop) -> 
            'use strict'
            model = if this._model?[prop] isnt undefined then this._model else this
            throw new Exception("IllegalPropertyNameException", "No property " + prop + " on class " + @declaredClass) if @haznt prop
            model[prop]
        watch: (prop, callback) ->
            'use strict'
            key = if prop isnt '*' then '_' + prop else prop
            callbacks = @_watchers[key]
            callbacks = @_watchers[key] = [] if typeof callbacks isnt "object"
            callbacks.push(callback)
            return {
                remove: () ->
                    callbacks.splice(lang.indexOf(callbacks, callback), 1)
            }
        validate: (prop, callback, _first) ->
            'use strict'
            key = '_' + prop
            callbacks = @_validators[key]
            callbacks = @_validators[key] = [] if typeof callbacks isnt "object"
            if _first
                callbacks.splice(0, 0, callback)
            else
                callbacks.push(callback)
            return {
                remove: () ->
                    callbacks.splice(lang.indexOf(callbacks, callback), 1)
            }
        inherited: () ->
            fname = @inherited.caller.nom
            args = @inherited.caller.arguments
            classname = @inherited.caller.cls
            passed = @declaredClass is classname
            ctx = @__super__
            max = 20
            ctx = ctx.__super__ until not ctx? or 
                (ctx[fname]? and (passed=passed or classname is ctx.declaredClass) and classname isnt ctx.declaredClass)
            throw new Exception("NullPointerException", classname + " has no __super__ with function " + fname) if not ctx?
            return ctx[fname].apply(this, args) if ctx?
        lock: (props, deferred) ->
            'use strict'
            props = [props] if not lang.isArray props
            for prop in props
                if not @islocked prop
                    if deferred? then deferred.addBoth lang.hitch this, ()->
                        @unlock prop
                    @_locked[prop] = @validate prop, (prop, oldValue, newValue) ->
                        console.warn "Trying to set locked property '" + prop + "'' on " + @declaredClass
                        1
                    , _first = true
                    @["_" + prop + "_locked"] = false if not @["_" + prop + "_locked"]?
                    @set("_" + prop + "_locked", true)
        unlock: (props) ->
            'use strict'
            props = [props] if not lang.isArray props
            for prop in props
                if @islocked prop
                    @_locked[prop].remove()
                    delete @_locked[prop]
                    @set("_" + prop + "_locked", false) if @["_" + prop + "_locked"]?
        islocked: (prop) ->
            'use strict'
            not not (@_locked[prop]? is true)
        toString: () ->
            'use strict'
            @declaredClass
    BaseClass.classname = "BaseClass"
    BaseClass
