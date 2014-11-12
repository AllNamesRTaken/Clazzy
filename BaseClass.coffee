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
            @initConverters()
            @initWatchers()
            @initValidators()
            @initConnections()
            @_model = {}
            return this
            
        initConverters: () ->
            @_converters = (prop, value, oldValue) ->
                if callbacks = @_converters[key = '_' + prop]?.slice()
                    for callback in callbacks
                        if not callback.call?
                            (new Exception("NotAFunctionException", "converter is not a function for property: " + prop)).Throw()
                            return value
                        try
                            cval = callback.call(this, value, oldValue)
                        catch e
                            console.log(e)
                            (new Exception("ConverterException", "Converter function threw exception for " + @declaredClass + " and value=" + value)).Throw()
                        return cval
                value
        initWatchers: () ->
            @_watchers = (prop, oldValue, newValue, index, self) ->
                if callbacks = @_watchers[key = '_' + prop]?.slice()
                    for callback in callbacks
                        if not callback.call?
                            (new Exception("NotAFunctionException", "watcher is not a function for property: " + prop)).Throw()
                            return this
                        try
                            callback.call(this, prop, oldValue, newValue, index, self)
                        catch e
                            console.log(e)
                            (new Exception("WatcherException", "Watcher function threw exception for " + @declaredClass + " and newValue=" + newValue)).Throw()
                if callbacks = @_watchers['*']
                    for callback in callbacks
                        if not callback.call?
                            (new Exception("NotAFunctionException", "watcher is not a function for property: " + prop)).Throw()
                            return this
                        try
                            callback.call(this, prop, oldValue, newValue, index, self)
                        catch e
                            console.log(e)
                            (new Exception("WatcherException", "Watcher function threw exception for " + @declaredClass + " and newValue=" + newValue)).Throw()
                this
        initValidators: () ->
            @_validators = (prop, oldValue, newValue, index, self, hint) ->
                if callbacks = @_validators[key = '_' + prop]?.slice()
                    for callback in callbacks
                        if not callback.call?
                            (new Exception("NotAFunctionException", "validator is not a function for property: " + prop)).Throw()
                            return 1
                        try
                            invalid = @set "_invalidated", callback.call(this, prop, oldValue, newValue, index, self, hint), prop, self
                        catch e
                            console.log(e)
                            (new Exception("ValidatorException", "Validator function threw exception for " + @declaredClass + " and newValue=" + newValue)).Throw()
                        if invalid 
                            console.warn "Failed validation for property '" + prop + "' on " + @declaredClass + " with value ", newValue
                            return invalid
                0
        initConnections: () ->
            @_invalidated = {}
            @_connections = (prop, value, index, self) ->
                if connections = @_connections[key = '_' + prop]?.slice()
                    for connection in connections
                        if not connection 
                            (new Exception("NotAFunctionException", "connection is not a defined for property: " + prop)).Throw()
                            return 1
                        try
                            if self isnt connection.target then connection.target.set(connection.prop, value, index, this)
                        catch e
                            console.log(e)
                            (new Exception("ConnectException", "Connected setter threw exception for " + @declaredClass + " connected to " + @connection.target.declaredClass)).Throw()
                        invalid = connection.target["_invalidated"][connection.prop] or 0
                        if invalid then return invalid
                0
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
        addModel: (model = {}) ->
           lang.mixin @_model, model
           if @__init? then lang.mixin @_model, @__init
        # self is a horrible choice of a name, caller would be better name. It is used to avoid loops, especially through connections
        set: (prop, value, index, self, dontTrigger = false) -> 
            'use strict'
            model = if this._model?[prop] isnt undefined then this._model else this
            if @haznt prop 
                (new Exception("IllegalPropertyNameException", "No property " + prop + " on class " + @declaredClass)).Throw()
                return undefined
            oldValue = model[prop]
            newValue = @_converters(prop, value, oldValue)
            return newValue if newValue is oldValue
            if 1 is (cancel = @_validators(prop, oldValue, newValue, index, self))
                return oldValue
            hint = @_connections(prop, newValue, index, self, dontTrigger) 
            if hint
                if not (hasValidator = @_validators[key = '_' + prop]?.length>0) 
                    newValue = oldValue
                else
                    if 1 is (cancel = @_validators(prop, oldValue, newValue, index, self, hint))
                        return oldValue

            if index? then model[prop][index] = newValue else model[prop] = newValue
            @_watchers(prop, oldValue, newValue, index, self) if not dontTrigger
            newValue
        get: (prop) -> 
            'use strict'
            model = if this._model?[prop] isnt undefined then this._model else this
            if @haznt prop 
                (new Exception("IllegalPropertyNameException", "No property " + prop + " on class " + @declaredClass)).Throw()
                return undefined
            model[prop]
        trigger: (prop) ->
            model = if this._model?[prop] isnt undefined then this._model else this
            if @haznt prop 
                (new Exception("IllegalPropertyNameException", "No property " + prop + " on class " + @declaredClass)).Throw()
                return undefined
            val = model[prop]
            @_connections(prop, val)
            @_watchers(prop, val, val)
            undefined
        convert: (prop, callback) ->
            'use strict'
            key = if prop isnt '*' then '_' + prop else prop
            callbacks = @_converters[key]
            callbacks = @_converters[key] = [] if typeof callbacks isnt "object"
            callbacks.push(callback)
            return {
                remove: () ->
                    callbacks.splice(lang.indexOf(callbacks, callback), 1)
            }
        watch: (prop, callback, debounce) ->
            'use strict'
            key = if prop isnt '*' then '_' + prop else prop
            callbacks = @_watchers[key]
            callbacks = @_watchers[key] = [] if typeof callbacks isnt "object"
            cb = if debounce then lang.debounce callback, debounce else callback
            callbacks.push(cb)
            return {
                remove: () ->
                    callbacks.splice(lang.indexOf(callbacks, cb), 1)
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
        connect: (prop, target, targetProp) ->
            'use strict'
            key = '_' + prop
            connections = @_connections[key]
            connections = @_connections[key] = [] if typeof connections isnt "object"
            connections.push (connection={target: target, prop: targetProp})
            return {
                remove: () ->
                    connections.splice(lang.indexOf(connections, connection), 1)
            }

        addValidator: (prop, validator) ->
            if lang.isFunction validator
                @validate prop, validator
            else if lang.isRegExp validator
                @validate prop, lang.partial (v, prop, o, n, i, self) ->
                    return if v.exec(n) then 0 else 1
                , validator
            undefined

        inherited: (caller, args) ->
            caller = caller or @inherited.caller
            fname = caller.nom
            args = args or caller.arguments
            classname = caller.cls
            passed = @declaredClass is classname
            ctx = @__super__
            max = 20
            ctx = ctx.__super__ until not ctx? or 
                (ctx[fname]? and (passed=passed or classname is ctx.declaredClass) and classname isnt ctx.declaredClass)
            if not ctx? 
                (new Exception("NullPointerException", classname + " has no __super__ with function " + fname)).Throw()
                return undefined
            return ctx[fname].apply(this, args) if ctx?
        lock: (props, deferred) ->
            'use strict'
            props = [props] if not lang.isArray props
            invalidateFn = (prop, oldValue, newValue) ->
                console.warn "Trying to set locked property '" + prop + "' on " + @declaredClass
                1
            for prop in props
                if not @islocked(prop) and ((deferred? and not deferred.finished) or not deferred?)
                    if deferred? then deferred.addBoth @ido(@unlock,prop)
                    @_locked[prop] = @validate prop, invalidateFn, _first = true
                    @["_" + prop + "_locked"] = false if not @["_" + prop + "_locked"]?
                    @set("_" + prop + "_locked", true)
            undefined
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
            @declaredClass.substr(@declaredClass.indexOf(".") + 1)
        ido: (fn, args...) ->
            if not fn? 
                (new Exception("IllegalArgumentsException", "function fn passed to ido() was null or undefined, caller was: "+ @ido.caller.cls + "." + @ido.caller.nom + "()")).Throw()
                return undefined
            f = fn
            if args.length > 0
                f = lang.partial.apply lang, [fn].concat args
            lang.hitch this, f
    BaseClass.classname = "BaseClass"
    BaseClass
