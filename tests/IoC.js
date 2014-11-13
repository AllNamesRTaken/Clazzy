// Generated by CoffeeScript 1.3.1
(function() {

  define(["dojo/main", "util/doh/main", "clazzy/IoC", "clazzy/Clazzy", "clazzy/abstraction/Lang", "clazzy/Lib", "dojo/cache", "dojo/_base/url", "clazzy/namelocators/TemplateNameLocator", "clazzy/TemplateRegistry"], function(dojo, doh, ioc, Class, lang, lib, cache, _url, templateNameLocator, templateRegistry) {
    var registerTemplate;
    registerTemplate = function(templateid, classname, templatestring, config) {
      templateNameLocator.register(templateid, classname, config);
      return templateRegistry.register(templateid, templatestring, config);
    };
    return doh.register("clazzy.tests.IoC", [
      {
        name: "SETUP",
        setUp: function() {
          Class("tests.SingelDummy", null, null, {
            constructor: function() {
              this.addModel({
                a: null,
                b: null
              });
              return this;
            }
          });
          Class("tests.NormalDummy", null, null, {
            constructor: function() {
              this.addModel({
                a: null,
                b: null
              });
              return this;
            }
          });
          Class("tests.NormalDummyWithDeps", null, null, {
            __dependencies: ["IHelper1"],
            constructor: function() {
              this.addModel({
                a: null,
                b: null
              });
              return this;
            }
          });
          Class("tests.NormalDummyWithDepsInTemplate", null, null, {
            __dependencies: [],
            constructor: function() {
              this.addModel({
                a: null,
                b: null
              });
              return this;
            }
          });
          ioc.setConfig("default");
          ioc.register("ISingelton", "tests.SingelDummy", true);
          ioc.register("INormal", "tests.NormalDummy", false);
          ioc.register("IHelper1", "clazzy.tests.helpers.Helper1", false);
          ioc.register("IHelper2", "clazzy.tests.helpers.Helper2", false);
          registerTemplate("THelper2", "clazzy.tests.helpers.Helper2", cache(new _url("../../../lib/clazzy/tests/helpers/HelperTemplate.html")));
          return registerTemplate("DepsTemplate", "tests.NormalDummyWithDepsInTemplate", cache(new _url("../../../lib/clazzy/tests/helpers/DepsTemplate.html")));
        },
        runTest: function(t) {
          return doh.assertTrue(true);
        }
      }, {
        name: "get_interfaceWithValues_callsGetByClass",
        setUp: function() {
          ioc.setConfig("default");
          this.originalGetByClass = ioc.getByClass;
          ioc.getByClass = function(classname, values) {
            return {
              classname: classname,
              values: values
            };
          };
          return this.values = {
            a: 1,
            b: 2
          };
        },
        runTest: function(t) {
          var result;
          result = ioc.get("INormal", this.values);
          doh.assertEqual("tests.NormalDummy", result.classname);
          return doh.assertEqual(this.values, result.values);
        },
        tearDown: function(t) {
          return ioc.getByClass = this.originalGetByClass;
        }
      }, {
        name: "getByClass_singeltonClassWithValues_singeltonInstance",
        setUp: function() {
          return this.values = {
            a: 1,
            b: 2
          };
        },
        runTest: function(t) {
          var d, deferred;
          d = new doh.Deferred();
          deferred = lib.deferList([ioc.getByClass("tests.SingelDummy", this.values), ioc.getByClass("tests.SingelDummy", this.values)]);
          deferred.then(d.getTestCallback(lang.hitch(this, function(data) {
            doh.assertEqual(this.values.a, data[0][1].get("a"));
            doh.assertEqual("tests.SingelDummy", data[0][1].declaredClass);
            return doh.assertTrue(data[0][1] === data[1][1]);
          })));
          return d;
        }
      }, {
        name: "getByClass_normalClassWithValues_normalInstance",
        setUp: function() {
          return this.values = {
            a: 1,
            b: 2
          };
        },
        runTest: function(t) {
          var d, deferred;
          d = new doh.Deferred();
          deferred = lib.deferList([ioc.getByClass("tests.NormalDummy", this.values), ioc.getByClass("tests.NormalDummy", this.values)]);
          deferred.then(d.getTestCallback(lang.hitch(this, function(data) {
            doh.assertEqual(this.values.a, data[0][1].get("a"));
            doh.assertEqual("tests.NormalDummy", data[0][1].declaredClass);
            return doh.assertTrue(data[0][1] !== data[1][1]);
          })));
          return d;
        }
      }, {
        name: "setConfig_configName_configIsChanged",
        setUp: function() {
          this.originalConfigName = ioc.getConfig();
          return this.configName = "newConfig";
        },
        runTest: function(t) {
          ioc.setConfig(this.configName);
          return doh.assertEqual(this.configName, ioc.getConfig());
        },
        tearDown: function(t) {
          return ioc.setConfig(this.originalConfigName);
        }
      }, {
        name: "getByClass_ExistingNotRequiredClassWithNotRequiredDependencies_instanceWithDependencies",
        setUp: function() {},
        runTest: function(t) {
          var d;
          d = new doh.Deferred();
          ioc.getByClass("tests.NormalDummyWithDeps").then(d.getTestCallback(lang.hitch(this, function(instance) {
            doh.assertEqual("tests.NormalDummyWithDeps", instance.declaredClass);
            return doh.assertEqual("clazzy.tests.helpers.Helper1", instance.IHelper1.declaredClass);
          })));
          return d;
        }
      }, {
        name: "get_notRequiredClassWithDependencies_instanceWithDependencies",
        setUp: function() {},
        runTest: function(t) {
          var d;
          d = new doh.Deferred();
          ioc.get("IHelper2").then(d.getTestCallback(lang.hitch(this, function(instance) {
            doh.assertEqual("clazzy.tests.helpers.Helper2", instance.declaredClass);
            return doh.assertEqual("clazzy.tests.helpers.Helper1", instance.getHelper1().declaredClass);
          })));
          return d;
        }
      }, {
        name: "get_ExistingNotRequiredClassWithDependeciesInTemplate_dependenciesAreRequired",
        setUp: function() {},
        runTest: function(t) {
          var d;
          d = new doh.Deferred();
          doh.assertFalse(!!clazzy.tests.helpers.Helper3);
          ioc.getByClass("tests.NormalDummyWithDepsInTemplate").then(d.getTestCallback(lang.hitch(this, function(instance) {
            return doh.assertTrue(!!clazzy.tests.helpers.Helper3);
          })));
          return d;
        }
      }
    ]);
  });

}).call(this);