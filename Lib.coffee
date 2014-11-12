define [
    "clazzy/DeferredList" 
], (DeferredList) ->

    Lib = 
        deferList: (list, fireOnOneCallback, fireOnOneErrback, consumeErrors, canceller) -> 
            dl = new DeferredList()
            dl.run(list, fireOnOneCallback, fireOnOneErrback, consumeErrors, canceller)
            dl
        findClass: (name) -> 
            'use strict'
            return null if not window
            parts = name.split "."
            cls = window
            for p in parts
                return null if not cls[p]
                cls = cls[p]
            cls

