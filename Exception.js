// Generated by CoffeeScript 1.8.0
(function() {
  define([], function() {
    'use strict';
    var Exception;
    return Exception = (function() {
      function Exception(name, message) {
        this.name = name != null ? name : "Exception";
        this.message = message != null ? message : "Something went wrong.";
        this;
      }

      Exception.prototype.toString = function() {
        return "[" + this.name + "] " + this.message;
      };

      Exception.prototype.Throw = function() {
        console.log(this.toString());
        return this;
      };

      return Exception;

    })();
  });

}).call(this);

//# sourceMappingURL=Exception.js.map
