// Generated by CoffeeScript 1.8.0

/*
This is shamelessly taken from the dojo project (v1.7.x) and just rewritten in coffeescript
All credit goes to the dojo team!
 */

(function() {
  define(["clazzy/Clazzy", "clazzy/Exception"], function(Class, Exception) {
    var Deferred, freeze, mutator, _hitch;
    mutator = function() {};
    freeze = Object.freeze || function() {};
    _hitch = function(that, func) {
      if (!that) {
        return func;
      } else {
        return function() {
          if (typeof func === "string") {
            func = that[func];
          }
          return func.apply(that, arguments || []);
        };
      }
    };
    return Deferred = Class("clazzy.Deferred", null, null, {
      constructor: function() {
        var caller, err, _ref, _ref1;
        this.canceller;
        this.result;
        this.finished;
        this.isError;
        this.head;
        this.nextListener;
        this.promise = {
          then: _hitch(this, this.then),
          cancel: _hitch(this, this.cancel)
        };
        this.deferred = this;
        freeze(this.promise);
        this.fired = -1;
        this.callback = this.resolve;
        this.errback = this.reject;
        try {
          caller = (_ref = this.constructor.caller) != null ? (_ref1 = _ref.caller) != null ? _ref1.caller : void 0 : void 0;
          this.fname = (caller != null ? caller.nom : void 0) || "unknown";
          this.cls = (caller != null ? caller.cls : void 0) || "unknown";
        } catch (_error) {
          err = _error;
          console.warn("strict mode used in a function calling Deferred");
        }
        return this;
      },
      complete: function(value) {
        'use strict';
        if (this.finished) {
          console.log("Deferred created in class: " + this.cls + " and function: " + this.fname);
          return (new Exception("DeferredException", "This deferred has already been resolved.")).Throw();
        }
        this.result = value;
        this.finished = true;
        this.notify();
        return void 0;
      },
      notify: function() {
        'use strict';
        var e, func, listener, mutated, newResult, unchanged;
        while (!mutated && this.nextListener) {
          listener = this.nextListener;
          this.nextListener = this.nextListener.next;
          if ((mutated = listener.progress === mutator)) {
            this.finished = false;
          }
          func = (this.isError ? listener.error : listener.resolved);
          if (func) {
            try {
              newResult = func(this.result);
              if (newResult && typeof newResult.then === "function") {
                newResult.then(_hitch(listener.deferred, "resolve"), _hitch(listener.deferred, "reject"), _hitch(listener.deferred, "progress"));
                continue;
              }
              unchanged = mutated && newResult === void 0;
              if (mutated && !unchanged) {
                this.isError = newResult instanceof Exception;
              }
              listener.deferred[unchanged && this.isError ? "reject" : "resolve"](unchanged ? this.result : newResult);
            } catch (_error) {
              e = _error;
              console.error(e);
              console.log("Deferred created in class: " + this.cls + " and function: " + this.fname);
              if (e.func != null) {
                console.log(e.func);
              }
              listener.deferred.reject(e);
            }
          } else {
            if (this.isError) {
              listener.deferred.reject(this.result);
            } else {
              listener.deferred.resolve(this.result);
            }
          }
        }
        return void 0;
      },
      resolve: function(value) {
        'use strict';
        this.fired = 0;
        this.results = [value, null];
        this.complete(value);
        return void 0;
      },
      reject: function(error) {
        'use strict';
        this.isError = true;
        this.fired = 1;
        this.complete(error);
        this.results = [null, error];
        return void 0;
      },
      progress: function(update) {
        'use strict';
        var listener, progress;
        listener = this.nextListener;
        while (listener) {
          progress = listener.progress;
          progress && progress(update);
          listener = listener.next;
        }
        return void 0;
      },
      addCallbacks: function(callback, errback) {
        'use strict';
        this.then(callback, errback, mutator);
        return this;
      },
      then: function(resolvedCallback, errorCallback, progressCallback) {
        var arg, argc, listener, returnDeferred, that;
        argc = arguments.length;
        while (argc) {
          if (((arg = arguments[argc - 1]) != null) && !arg.nom) {
            arguments[argc - 1].nom = "then";
            arguments[argc - 1].cls = "unknown";
          }
          argc--;
        }
        that = this;
        if (progressCallback === mutator) {
          returnDeferred = this;
        } else {
          returnDeferred = new Deferred();
          returnDeferred.canceller = function() {
            return this.cancel.apply(that, arguments || []);
          };
        }
        listener = {
          resolved: resolvedCallback,
          error: errorCallback,
          progress: progressCallback,
          deferred: returnDeferred
        };
        if (this.nextListener) {
          this.head = this.head.next = listener;
        } else {
          this.nextListener = this.head = listener;
        }
        if (this.finished) {
          this.notify();
        }
        return returnDeferred.promise;
      },
      cancel: function() {
        'use strict';
        var error;
        if (!this.finished) {
          error = this.canceller && this.canceller(this.deferred);
          if (!this.finished) {
            if (!(error instanceof Exception)) {
              error = new Exception("DeferredCancelError", error);
            }
            error.log = false;
            this.deferred.reject(error);
          }
        }
        return void 0;
      },
      addCallback: function(callback) {
        'use strict';
        return this.addCallbacks(_hitch(this, callback));
      },
      addErrback: function(errback) {
        'use strict';
        return this.addCallbacks(null, _hitch(this, errback));
      },
      addBoth: function(callback) {
        'use strict';
        var enclosed;
        enclosed = _hitch(this, callback);
        return this.addCallbacks(enclosed, enclosed);
      }
    });
  });

}).call(this);

//# sourceMappingURL=Deferred.js.map