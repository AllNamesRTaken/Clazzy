(function() {

  define(["clazzy/Clazzy"], function(Class) {
    return Class("clazzy.tests.helpers.Helper2", null, null, {
      __dependencies: ["IHelper1"],
      constructor: function(args) {
        return this;
      },
      getHelper1: function() {
        return this.IHelper1;
      }
    });
  });

}).call(this);
