(function() {

  define(["dojo/main", "util/doh/main", "clazzy/Exception"], function(dojo, doh, exception) {
    return doh.register("clazzy.tests.Exception", [
      {
        name: "toString_null_nameUndMessageInString",
        setUp: function() {
          this.message = "--MESSAGE--";
          this.name = "--NAME--";
          return this.ex = new exception(this.name, this.message);
        },
        runTest: function(t) {
          var exString;
          exString = this.ex.toString();
          return doh.assertTrue(exString.indexOf(this.name) > -1 && exString.indexOf(this.message) > -1);
        }
      }
    ]);
  });

}).call(this);
