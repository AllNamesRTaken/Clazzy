(function() {

  define([], function() {
    var When;
    return When = function(promiseOrValue, callback, errback, progressHandler) {
      if (promiseOrValue && typeof promiseOrValue.then === "function") {
        return promiseOrValue.then(callback, errback, progressHandler);
      }
      if (callback) {
        return callback(promiseOrValue);
      } else {
        return promiseOrValue;
      }
    };
  });

}).call(this);