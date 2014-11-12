(function() {

  define(["dojo/main", "util/doh/main", "clazzy/namelocators/NameLocator", "clazzy/Exception"], function(dojo, doh, NameLocator, Exception) {
    var nameLocator;
    nameLocator = new NameLocator();
    return doh.register("clazzy.tests.namelocators.NameLocator", [
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
        name: "setConfigTo_configName_configNameIsChanged",
        setUp: function() {
          return this.configName = "newName";
        },
        runTest: function(t) {
          var config;
          nameLocator.setConfigTo(this.configName);
          config = nameLocator.config;
          return doh.assertEqual(this.configName, config);
        },
        tearDown: function(t) {
          return nameLocator.setConfigTo("default");
        }
      }, {
        name: "register_newSourceNameAndTargetName_noError",
        setUp: function() {
          this.sourceName = "mySource";
          return this.targetName = "myTarget";
        },
        runTest: function(t) {
          nameLocator.register(this.sourceName, this.targetName);
          return doh.assertTrue(true);
        },
        tearDown: function(t) {
          return nameLocator.clear();
        }
      }, {
        name: "configExists_existingConfig_true",
        setUp: function() {
          return this.configName = "default";
        },
        runTest: function(t) {
          return doh.assertTrue(nameLocator.configExists(this.configName));
        },
        tearDown: function(t) {}
      }, {
        name: "configExists_notExistingConfig_false",
        setUp: function() {
          return this.configName = "nonExistingConfigName";
        },
        runTest: function(t) {
          return doh.assertFalse(nameLocator.configExists(this.configName));
        },
        tearDown: function(t) {}
      }, {
        name: "configIsEmpty_emptyConfig_true",
        setUp: function() {},
        runTest: function(t) {
          var empty;
          empty = nameLocator.configIsEmpty("default");
          return doh.assertTrue(empty);
        },
        tearDown: function(t) {}
      }, {
        name: "configIsEmpty_nonEmptyConfig_false",
        setUp: function() {
          return nameLocator.register("mySource", "myTarget");
        },
        runTest: function(t) {
          var empty;
          empty = nameLocator.configIsEmpty("default");
          return doh.assertFalse(empty);
        },
        tearDown: function(t) {
          return nameLocator.clear();
        }
      }, {
        name: "findSource_targetName_found",
        setUp: function() {
          this.sourceName = "mySource";
          this.targetName = "myTarget";
          return nameLocator.register(this.sourceName, this.targetName);
        },
        runTest: function(t) {
          var source;
          source = nameLocator.findSource(this.targetName);
          return doh.assertEqual(this.sourceName, source);
        },
        tearDown: function(t) {
          return nameLocator.clear();
        }
      }, {
        name: "findSource_notExisting_throws",
        setUp: function() {
          this.sourceName = "mySource";
          return this.targetName = "myTarget";
        },
        runTest: function(t) {
          nameLocator.findSource(this.targetName);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          nameLocator.clear();
          return t.Thrown = false;
        }
      }, {
        name: "findSource_null_arrayWithAll",
        setUp: function() {
          this.sourceName = "mySource";
          this.targetName = "myTarget";
          return nameLocator.register(this.sourceName, this.targetName);
        },
        runTest: function(t) {
          var array;
          array = nameLocator.findSource();
          return doh.assertEqual(this.sourceName, array[0]);
        },
        tearDown: function(t) {
          return nameLocator.clear();
        }
      }, {
        name: "findTarget_sourceName_found",
        setUp: function() {
          this.sourceName = "mySource";
          this.targetName = "myTarget";
          return nameLocator.register(this.sourceName, this.targetName);
        },
        runTest: function(t) {
          var name;
          name = nameLocator.findTarget(this.sourceName);
          return doh.assertEqual(this.targetName, name);
        },
        tearDown: function(t) {
          return nameLocator.clear();
        }
      }, {
        name: "findTarget_notExisting_found",
        setUp: function() {
          this.sourceName = "mySource";
          return this.targetName = "myTarget";
        },
        runTest: function(t) {
          nameLocator.findTarget(this.sourceName);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          nameLocator.clear();
          return t.Thrown = false;
        }
      }, {
        name: "findTarget_null_arrayWithAll",
        setUp: function() {
          this.sourceName = "mySource";
          this.targetName = "myTarget";
          return nameLocator.register(this.sourceName, this.targetName);
        },
        runTest: function(t) {
          var array;
          array = nameLocator.findTarget();
          return doh.assertEqual(this.targetName, array[0]);
        },
        tearDown: function(t) {
          return nameLocator.clear();
        }
      }, {
        name: "clear_null_configIsCleared",
        setUp: function() {
          this.sourceName = "mySource";
          this.targetName = "myTarget";
          return nameLocator.register(this.sourceName, this.targetName);
        },
        runTest: function(t) {
          nameLocator.clear();
          nameLocator.findSource(this.targetName);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          return t.Thrown = false;
        }
      }, {
        name: "clear_all_allConfigsAreCleared",
        setUp: function() {
          this.sourceName = "mySource";
          this.targetName = "myTarget";
          this.config1 = "config1";
          this.config2 = "config2";
          nameLocator.register(this.sourceName, this.targetName, this.config1);
          return nameLocator.register(this.sourceName, this.targetName, this.config2);
        },
        runTest: function(t) {
          var all;
          nameLocator.clear(all = true);
          nameLocator.setConfigTo(this.config1);
          nameLocator.findSource(this.targetName);
          doh.assertTrue(t.Thrown);
          t.Thrown = false;
          nameLocator.setConfigTo(this.config2);
          nameLocator.findSource(this.targetName);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          return t.Thrown = false;
        }
      }, {
        name: "hasSource_notRegisteredSourceName_false",
        setUp: function() {
          return this.targetName = "myTarget";
        },
        runTest: function(t) {
          var exits;
          exits = nameLocator.hasSource(this.targetName);
          return doh.assertFalse(exits);
        },
        tearDown: function(t) {
          return nameLocator.clear();
        }
      }, {
        name: "hasSource_registeredSourceName_true",
        setUp: function() {
          this.sourceName = "mySource";
          this.targetName = "myTarget";
          return nameLocator.register(this.sourceName, this.targetName);
        },
        runTest: function(t) {
          var exits;
          exits = nameLocator.hasSource(this.targetName);
          return doh.assertTrue(exits);
        },
        tearDown: function(t) {
          return nameLocator.clear();
        }
      }, {
        name: "hasTarget_notRegisteredTargetName_false",
        setUp: function() {
          return this.sourceName = "myTarget";
        },
        runTest: function(t) {
          var exits;
          exits = nameLocator.hasTarget(this.sourceName);
          return doh.assertFalse(exits);
        },
        tearDown: function(t) {
          return nameLocator.clear();
        }
      }, {
        name: "hasTarget_RegisteredTargetName_false",
        setUp: function() {
          this.sourceName = "mySource";
          this.targetName = "myTarget";
          return nameLocator.register(this.sourceName, this.targetName);
        },
        runTest: function(t) {
          var exits;
          exits = nameLocator.hasTarget(this.sourceName);
          return doh.assertTrue(exits);
        },
        tearDown: function(t) {
          return nameLocator.clear();
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
