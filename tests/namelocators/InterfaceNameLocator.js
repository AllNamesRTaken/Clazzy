(function() {

  define(["dojo/main", "util/doh/main", "clazzy/namelocators/InterfaceNameLocator", "clazzy/Exception"], function(dojo, doh, interfaceNameLocator, Exception) {
    return doh.register("clazzy.tests.namelocators.InterfaceNameLocators", [
      {
        name: "SETUP",
        setUp: function(t) {
          var test;
          t.originalThrow = Exception.prototype["Throw"];
          test = t;
          test.Thrown = false;
          return Exception.prototype["Throw"] = function() {
            return test.Thrown = true;
          };
        },
        runTest: function() {
          return doh.assertTrue(true);
        }
      }, {
        name: "getConfig_null_configName",
        setUp: function() {
          return this.configName = "default";
        },
        runTest: function(t) {
          var config;
          config = interfaceNameLocator.getConfig();
          return doh.assertEqual(this.configName, config);
        }
      }, {
        name: "setConfigTo_configName_configNameIsChanged",
        setUp: function() {
          return this.configName = "newName";
        },
        runTest: function(t) {
          var config;
          interfaceNameLocator.setConfigTo(this.configName);
          config = interfaceNameLocator.getConfig();
          return doh.assertEqual(this.configName, config);
        },
        tearDown: function(t) {
          return interfaceNameLocator.setConfigTo("default");
        }
      }, {
        name: "register_newInterfaceNameAndClassName_noError",
        setUp: function() {
          this.interfaceName = "myInterface";
          return this.className = "myClass";
        },
        runTest: function(t) {
          interfaceNameLocator.register(this.interfaceName, this.className);
          return doh.assertTrue(true);
        },
        tearDown: function(t) {
          return interfaceNameLocator.clear();
        }
      }, {
        name: "findInterface_className_found",
        setUp: function() {
          this.interfaceName = "myInterface";
          this.className = "myClass";
          return interfaceNameLocator.register(this.interfaceName, this.className);
        },
        runTest: function(t) {
          var interfejs;
          interfejs = interfaceNameLocator.findInterface(this.className);
          return doh.assertEqual(this.interfaceName, interfejs);
        },
        tearDown: function(t) {
          return interfaceNameLocator.clear();
        }
      }, {
        name: "findInterface_notExisting_throws",
        setUp: function(t) {
          this.interfaceName = "myInterface";
          return this.className = "myClass";
        },
        runTest: function(t) {
          interfaceNameLocator.findInterface(this.className);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          interfaceNameLocator.clear();
          return t.Thrown = false;
        }
      }, {
        name: "findClass_interfaceName_found",
        setUp: function() {
          this.interfaceName = "myInterface";
          this.className = "myClass";
          return interfaceNameLocator.register(this.interfaceName, this.className);
        },
        runTest: function(t) {
          var name;
          name = interfaceNameLocator.findClass(this.interfaceName);
          return doh.assertEqual(this.className, name);
        },
        tearDown: function(t) {
          return interfaceNameLocator.clear();
        }
      }, {
        name: "findClass_notExisting_found",
        setUp: function() {
          this.interfaceName = "myInterface";
          return this.className = "myClass";
        },
        runTest: function(t) {
          interfaceNameLocator.findClass(this.interfaceName);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          interfaceNameLocator.clear();
          return t.Thrown = false;
        }
      }, {
        name: "clear_null_configIsCleared",
        setUp: function() {
          this.interfaceName = "myInterface";
          this.className = "myClass";
          return interfaceNameLocator.register(this.interfaceName, this.className);
        },
        runTest: function(t) {
          interfaceNameLocator.clear();
          interfaceNameLocator.findInterface(this.className);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          return t.Thrown = false;
        }
      }, {
        name: "clear_all_allConfigsAreCleared",
        setUp: function() {
          this.interfaceName = "myInterface";
          this.className = "myClass";
          this.config1 = "config1";
          this.config2 = "config2";
          interfaceNameLocator.register(this.interfaceName, this.className, this.config1);
          return interfaceNameLocator.register(this.interfaceName, this.className, this.config2);
        },
        runTest: function(t) {
          var all;
          interfaceNameLocator.clear(all = true);
          interfaceNameLocator.setConfigTo(this.config1);
          interfaceNameLocator.findInterface(this.className);
          doh.assertTrue(t.Thrown);
          t.Thrown = false;
          interfaceNameLocator.setConfigTo(this.config2);
          interfaceNameLocator.findInterface(this.className);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          return t.Thrown = false;
        }
      }, {
        name: "hasClass_notRegisteredInterfaceName_false",
        setUp: function() {
          return this.interfaceName = "myInterface";
        },
        runTest: function(t) {
          var exits;
          exits = interfaceNameLocator.hasClass(this.interfaceName);
          return doh.assertFalse(exits);
        },
        tearDown: function(t) {
          return interfaceNameLocator.clear();
        }
      }, {
        name: "hasClass_registeredInterfaceName_true",
        setUp: function() {
          this.interfaceName = "myInterface";
          this.className = "myClass";
          return interfaceNameLocator.register(this.interfaceName, this.className);
        },
        runTest: function(t) {
          var exits;
          exits = interfaceNameLocator.hasClass(this.interfaceName);
          return doh.assertTrue(exits);
        },
        tearDown: function(t) {
          return interfaceNameLocator.clear();
        }
      }, {
        name: "TEARDOWN",
        setUp: function() {},
        runTest: function() {
          return doh.assertTrue(true);
        },
        tearDown: function(t) {
          return Exception.prototype["Throw"] = t.originalThrow;
        }
      }
    ]);
  });

}).call(this);
