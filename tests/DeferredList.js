(function() {

  define(["dojo/main", "util/doh/main", "clazzy/DeferredList", "clazzy/Exception", "clazzy/Deferred"], function(dojo, doh, DeferredList, Exception, Deferred) {
    return doh.register("clazzy.tests.DeferredList", [
      {
        name: "run_2deferreds_resolving",
        setUp: function() {
          this.deferred1 = new Deferred();
          this.deferred1.resolve(1);
          this.deferred2 = new Deferred();
          this.deferred2.resolve(2);
          return this.deferredList = new DeferredList();
        },
        runTest: function(t) {
          var d;
          d = new doh.Deferred();
          this.deferredList.then(d.getTestCallback(function(data) {
            var one, two;
            one = data[0][1];
            two = data[1][1];
            return doh.assertEqual(3, one + two);
          }));
          this.deferredList.run([this.deferred1, this.deferred2]);
          return d;
        }
      }, {
        name: "run_2deferreds_rejecting",
        setUp: function() {
          this.deferred1 = new Deferred();
          this.deferred2 = new Deferred();
          return this.deferredList = new DeferredList();
        },
        runTest: function(t) {
          var d;
          d = new doh.Deferred();
          this.deferredList.then(d.getTestCallback(function(data) {
            var error, one;
            one = data[0][1];
            error = data[1][1];
            doh.assertEqual(1, one);
            return doh.assertTrue(error instanceof Exception);
          }));
          this.deferredList.run([this.deferred1, this.deferred2]);
          this.deferred1.resolve(1);
          this.deferred2.resolve(new Exception());
          return d;
        }
      }, {
        name: "run_2deferredsFireOnCallback_resolving",
        setUp: function() {
          this.deferred1 = new Deferred();
          this.deferred2 = new Deferred();
          return this.deferredList = new DeferredList();
        },
        runTest: function(t) {
          var d;
          d = new doh.Deferred();
          this.deferredList.then(d.getTestCallback(function(data) {
            var value, whichDeferred;
            whichDeferred = data[0];
            value = data[1];
            doh.assertEqual(0..whichDeferred);
            return doh.assertEqual(42, value);
          }));
          this.deferredList.run([this.deferred1, this.deferred2], true);
          this.deferred1.resolve(42);
          return d;
        }
      }, {
        name: "run_2deferredsFireOnErrbackDontConsumeErrors_rejectingThrows",
        setUp: function() {
          this.deferred1 = new Deferred();
          this.deferred2 = new Deferred();
          return this.deferredList = new DeferredList();
        },
        runTest: function(t) {
          this.deferredList.then(function(data) {
            return false;
          }, function(error) {
            return false;
          });
          this.deferredList.run([this.deferred1, this.deferred2], false, true, false);
          try {
            return this.deferred1.reject(new Exception());
          } catch (e) {
            return doh.assertTrue(e instanceof Exception);
          }
        }
      }, {
        name: "run_2deferredsFireOnErrbackConsumeErrors_resolvingWithError",
        setUp: function() {
          this.deferred1 = new Deferred();
          this.deferred2 = new Deferred();
          return this.deferredList = new DeferredList();
        },
        runTest: function(t) {
          var d;
          d = new doh.Deferred();
          this.deferredList.then(function(data) {
            return false;
          }, d.getTestCallback(function(data) {
            return doh.assertTrue(data instanceof Exception);
          }));
          this.deferredList.run([this.deferred1, this.deferred2], false, true, true);
          this.deferred1.resolve(1);
          this.deferred2.reject(new Exception());
          return d;
        }
      }
    ]);
  });

}).call(this);
