define [
], () ->
    When = (promiseOrValue, callback, errback, progressHandler) ->
        if(promiseOrValue and typeof promiseOrValue.then is "function")
            return promiseOrValue.then(callback, errback, progressHandler)
        return if callback then callback(promiseOrValue) else promiseOrValue
