(function() {

  define(["dojo/main", "util/doh/main"], function(dojo, doh, declare, Exception) {
    return doh.register("clazzy.tests.BaseClass", [
      {
        name: "All_TESTS_FOR_BASECLASS_ARE_FOUND_IN_CLAZZY",
        runTest: function(t) {
          return doh.assertTrue(true);
        }
      }
    ]);
  });

}).call(this);
