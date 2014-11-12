(function() {

  define(["dojo/main", "util/doh/main", "clazzy/abstraction/Lang", "dojo/cache", "dojo/_base/url", "clazzy/Exception", "clazzy/Deferred", "clazzy/Clazzy"], function(dojo, doh, lang, cache, _url, Exception, Deferred, Class) {
    return doh.register("clazzy.tests.abstraction.Lang", [
      {
        name: "clone_objectWithObjectWithArrayInsideArray_areEqual",
        setUp: function() {
          return this.testObject = {
            a: {
              b: [[true, true], [false, false]]
            }
          };
        },
        runTest: function(t) {
          var clone;
          clone = lang.clone(this.testObject);
          return doh.assertEqual(this.testObject, clone);
        }
      }, {
        name: "hitch_contextAndFunction_hitchedFunctionRunsSetContext",
        setUp: function() {
          this.context = {};
          return this.hitch = lang.hitch(this.context, function() {
            return this;
          });
        },
        runTest: function(t) {
          var context;
          context = this.hitch();
          return doh.assertEqual(this.context, context);
        }
      }, {
        name: "hitch_nullContextAndFunction_hitchedFunctionRunsThisContext",
        setUp: function() {
          this.context = null;
          return this.hitch = lang.hitch(this.context, function() {
            return this;
          });
        },
        runTest: function(t) {
          var context;
          context = this.hitch();
          return doh.assertEqual(this, context);
        }
      }, {
        name: "mixin_2nonOverlappingObjects_objectWithAllPropsFromBoth",
        setUp: function() {
          this.a = {
            p1: 1,
            p2: 2
          };
          return this.b = {
            p3: 3,
            p4: 4
          };
        },
        runTest: function(t) {
          var c;
          c = lang.mixin(this.a, this.b);
          return doh.assertTrue(c.p1 && c.p2 && c.p3 && c.p4);
        }
      }, {
        name: "mixin_2OverlappingObjects_overlappingPropTakenFromSecondObject",
        setUp: function() {
          this.a = {
            p1: 1,
            p2: 2
          };
          return this.b = {
            p2: 3,
            p3: 4
          };
        },
        runTest: function(t) {
          var c;
          c = lang.mixin(this.a, this.b);
          return doh.assertEqual(c.p2, this.b.p2);
        }
      }, {
        name: "mixin_objectAndNull_shallowCloneOfObject",
        setUp: function() {
          this.a = {
            p3: 3,
            p4: {
              p5: 5
            }
          };
          return this.b = null;
        },
        runTest: function(t) {
          var c;
          c = lang.mixin(this.a, this.b);
          doh.assertEqual(c, this.a);
          return doh.assertTrue(c.p4.p5 === this.a.p4.p5);
        }
      }, {
        name: "mixin_nullAndObject_shallowCloneOfObject",
        setUp: function() {
          this.a = null;
          return this.b = {
            p3: 3,
            p4: {
              p5: 5
            }
          };
        },
        runTest: function(t) {
          var c;
          c = lang.mixin(this.a, this.b);
          doh.assertEqual(c, this.b);
          return doh.assertTrue(c.p4.p5 === this.b.p4.p5);
        }
      }, {
        name: "cache_url_correctString",
        setUp: function() {
          this.url = "../../clazzy/tests/abstraction/resources/dummy.txt";
          return this.content = "dummy";
        },
        runTest: function(t) {
          var url;
          url = cache(new _url(this.url));
          return doh.assertEqual(this.content, url);
        }
      }, {
        name: "filter_arrayAndEvenFunction_correctFilteredArray",
        setUp: function() {
          this.array = ['a', 'b', 'c', 'd'];
          this.target = ['a', 'c'];
          return this.filter = function(el, i) {
            return 0 === i % 2;
          };
        },
        runTest: function(t) {
          var array;
          array = lang.filter(this.array, this.filter);
          return doh.assertEqual(this.target, array);
        }
      }, {
        name: "filter_emptyArrayAndEvenFunction_emptyArray",
        setUp: function() {
          this.array = [];
          this.target = [];
          return this.filter = function(el, i) {
            return 0 === i % 2;
          };
        },
        runTest: function(t) {
          var array;
          array = lang.filter(this.array, this.filter);
          return doh.assertEqual(this.target, array);
        }
      }, {
        name: "filter_nullAndEvenFunction_emptyArray",
        setUp: function() {
          this.array = null;
          this.target = [];
          return this.filter = function(el, i) {
            return 0 === i % 2;
          };
        },
        runTest: function(t) {
          var array;
          array = lang.filter(this.array, this.filter);
          return doh.assertEqual(this.target, array);
        }
      }, {
        name: "isArray_array_true",
        setUp: function() {
          return this.array = [];
        },
        runTest: function(t) {
          var isArray;
          isArray = lang.isArray(this.array);
          return doh.assertTrue(isArray);
        }
      }, {
        name: "isArray_null_false",
        setUp: function() {
          return this.array = null;
        },
        runTest: function(t) {
          var isArray;
          isArray = lang.isArray(this.array);
          return doh.assertFalse(isArray);
        }
      }, {
        name: "isFunction_function_true",
        setUp: function() {
          return this.func = function() {
            return null;
          };
        },
        runTest: function(t) {
          var isFunc;
          isFunc = lang.isFunction(this.func);
          return doh.assertTrue(isFunc);
        }
      }, {
        name: "isFunction_null_false",
        setUp: function() {
          return this.func = null;
        },
        runTest: function(t) {
          var isFunc;
          isFunc = lang.isFunction(this.func);
          return doh.assertFalse(isFunc);
        }
      }
    ]);
  });

}).call(this);
