
###
This is shamelessly taken from the dojo project (v1.7.x) and just rewritten in coffeescript
All credit goes to the dojo team!
###
define [
    "clazzy/Clazzy"
    "clazzy/Deferred"
], (Class, _deferred) ->

    Class "clazzy.DeferredList", _deferred, null, 
        run: (list, fireOnOneCallback, fireOnOneErrback, consumeErrors = true, canceller) -> 
            resultList = []
            #Deferred.call(this);
            self = this
            if list.length is 0 and not fireOnOneCallback
                this.resolve [0, []]

            deferredsFinished = 0
            addResult = (succeeded, result, count) ->
                resultList[count] = [succeeded, result]
                deferredsFinished++
                if deferredsFinished is list.length
                    self.resolve resultList
                undefined

            thenFunc = (i) ->
                item.then (result) ->
                    if fireOnOneCallback
                        self.resolve [i, result]
                        undefined
                    else
                        addResult true, result, i
                        undefined
                , (error) -> 
                    if fireOnOneErrback
                        self.reject error
                    else
                        addResult false, error, i
                    if consumeErrors
                        return null
                    throw error
                    undefined
            thenFunc(i) for item, i in list
            this
