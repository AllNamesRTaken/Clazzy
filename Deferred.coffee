###
This is shamelessly taken from the dojo project (v1.7.x) and just rewritten in coffeescript
All credit goes to the dojo team!
###
define [
    "clazzy/Clazzy"
    "clazzy/Exception"
], (Class, Exception) ->
    'use strict'
    #return D
    mutator = () ->
    freeze = Object.freeze or () -> 
    _hitch = (that, func) ->
        if not that then func else () -> 
            func = that[func] if typeof func is "string"
            func.apply(that, arguments || [])

    # A deferred provides an API for creating and resolving a promise.
    Deferred = Class "clazzy.Deferred", null, null
        constructor: () ->
            S4 = () ->
                (((1+Math.random())*0x10000)|0).toString(16).substring(1)
            @guid = (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4())
            @id =  
            @canceller
            @result
            @finished
            @isError
            @head
            @nextListener
            @promise = 
                then: _hitch this, @then
                cancel: _hitch this, @cancel
            @deferred = this
            freeze @promise
            @fired = -1
            @callback = @resolve
            @errback = @reject
            this

        complete: (value) -> 
            throw new Exception("DeferredException", "This deferred has already been resolved.") if @finished
            @result = value
            @finished = true
            @notify()
            undefined
        notify: () -> 
            while(not mutated && @nextListener)
                listener = @nextListener
                @nextListener = @nextListener.next
                if((mutated = (listener.progress == mutator))) # assignment and check
                    @finished = false

                func = (if @isError then listener.error else listener.resolved)
                if func
                    try 
                        newResult = func @result
                        if newResult and typeof newResult.then is "function"
                            newResult.then _hitch(listener.deferred, "resolve"), _hitch(listener.deferred, "reject"), _hitch(listener.deferred, "progress")
                            continue

                        unchanged = mutated and newResult is undefined
                        if mutated and not unchanged
                            @isError = newResult instanceof Exception

                        listener.deferred[if unchanged and @isError then "reject" else "resolve"](if unchanged then @result else newResult)
                    catch e
                        console.warn e
                        listener.deferred.reject e
                else
                    if @isError
                        listener.deferred.reject @result
                    else 
                        listener.deferred.resolve @result
            undefined

        # calling resolve will resolve the promise
        resolve: (value) -> 
            @fired = 0
            @results = [value, null]
            @complete value
            undefined

        # calling error will indicate that the promise failed
        reject: (error) ->
            @isError = true
            @fired = 1
            @complete error
            @results = [null, error]
            undefined

        # call progress to provide updates on the progress on the completion of the promise
        progress: (update) -> 
            listener = @nextListener
            while listener
                progress = listener.progress
                progress and progress update
                listener = listener.next
            undefined
        addCallbacks: (callback, errback) ->
            @then callback, errback, mutator
            this
        then: (resolvedCallback, errorCallback, progressCallback) -> 
            if progressCallback == mutator 
                returnDeferred = this
            else 
                returnDeferred = new Deferred()
                returnDeferred.canceller = @cancel
            listener = 
                resolved: resolvedCallback,
                error: errorCallback,
                progress: progressCallback,
                deferred: returnDeferred
            if @nextListener
                @head = @head.next = listener
            else
                @nextListener = @head = listener
            @notify() if @finished
            returnDeferred.promise
        cancel: () ->
            if not @finished
                error = @canceller and @canceller @deferred
                if not @finished
                    if not (error instanceof Exception)
                        error = new Exception("DeferredCancelError", error)
                    error.log = false
                    @deferred.reject error

        addCallback: (callback) ->
            @addCallbacks _hitch(this, callback)
        addErrback: (errback) ->
            @addCallbacks null, _hitch(this, errback)
        addBoth: (callback) ->
            enclosed = _hitch(this, callback);
            @addCallbacks enclosed, enclosed
