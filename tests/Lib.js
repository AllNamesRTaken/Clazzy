(function() {

  define(["dojo/main", "util/doh/main", "clazzy/Lib", "clazzy/Exception", "clazzy/Deferred", "clazzy/Clazzy"], function(dojo, doh, lib, Exception, Deferred, Class) {
    return doh.register("clazzy.tests.Lib", [
      {
        name: "deferList_2deferreds_resolving",
        setUp: function() {
          this.deferred1 = new Deferred();
          this.deferred1.resolve(1);
          this.deferred2 = new Deferred();
          return this.deferred2.resolve(2);
        },
        runTest: function(t) {
          var d;
          d = new doh.Deferred();
          lib.deferList([this.deferred1, this.deferred2]).then(d.getTestCallback(function(data) {
            var one, two;
            one = data[0][1];
            two = data[1][1];
            return doh.assertEqual(3, one + two);
          }));
          return d;
        }
      }, {
        name: "deferList_2deferreds_rejecting",
        setUp: function() {
          this.deferred1 = new Deferred();
          this.deferred1.resolve(1);
          this.deferred2 = new Deferred();
          return this.deferred2.reject(new Exception());
        },
        runTest: function(t) {
          var d;
          d = new doh.Deferred();
          lib.deferList([this.deferred1, this.deferred2]).then(d.getTestCallback(function(data) {
            var error, one;
            one = data[0][1];
            error = data[1][1];
            doh.assertEqual(1, one);
            return doh.assertTrue(error instanceof Exception);
          }));
          return d;
        }
      }, {
        name: "find_existingClass_found",
        setUp: function() {
          return this.cls = Class("tests.DummyClass");
        },
        runTest: function(t) {
          var cls;
          cls = lib.findClass("tests.DummyClass");
          return doh.assertEqual(this.cls, cls);
        }
      }, {
        name: "find_undefinedClass_null",
        runTest: function(t) {
          var cls;
          cls = lib.findClass("tests.UnexisingDummyClass");
          return doh.assertEqual(null, cls);
        }
      }
    ]);
  });

}).call(this);
