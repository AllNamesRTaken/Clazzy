(function() {

  define(["dojo/main", "util/doh/main", "clazzy/namelocators/TemplateNameLocator", "clazzy/Exception"], function(dojo, doh, templateNameLocator, Exception) {
    return doh.register("clazzy.tests.namelocators.TemplateNameLocator", [
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
          config = templateNameLocator.getConfig();
          return doh.assertEqual(this.configName, config);
        }
      }, {
        name: "setConfigTo_configName_configNameIsChanged",
        setUp: function() {
          return this.configName = "newName";
        },
        runTest: function(t) {
          var config;
          templateNameLocator.setConfigTo(this.configName);
          config = templateNameLocator.getConfig();
          return doh.assertEqual(this.configName, config);
        },
        tearDown: function(t) {
          return templateNameLocator.setConfigTo("default");
        }
      }, {
        name: "configExists_existingConfig_true",
        setUp: function() {
          return this.configName = "default";
        },
        runTest: function(t) {
          return doh.assertTrue(templateNameLocator.configExists(this.configName));
        },
        tearDown: function(t) {}
      }, {
        name: "configExists_notExistingConfig_true",
        setUp: function() {
          return this.configName = "nonExistingConfigName";
        },
        runTest: function(t) {
          return doh.assertFalse(templateNameLocator.configExists(this.configName));
        },
        tearDown: function(t) {}
      }, {
        name: "configIsEmpty_emptyConfig_true",
        setUp: function() {},
        runTest: function(t) {
          var empty;
          empty = templateNameLocator.configIsEmpty("default");
          return doh.assertTrue(empty);
        },
        tearDown: function(t) {}
      }, {
        name: "configIsEmpty_nonEmptyConfig_false",
        setUp: function() {
          return templateNameLocator.register("mySource", "myTarget");
        },
        runTest: function(t) {
          var empty;
          empty = templateNameLocator.configIsEmpty("default");
          return doh.assertFalse(empty);
        },
        tearDown: function(t) {
          return templateNameLocator.clear();
        }
      }, {
        name: "register_newTemplateNameAndClassName_noError",
        setUp: function() {
          this.templateName = "myTemplate";
          return this.className = "myClass";
        },
        runTest: function(t) {
          templateNameLocator.register(this.templateName, this.className);
          return doh.assertTrue(true);
        },
        tearDown: function(t) {
          return templateNameLocator.clear();
        }
      }, {
        name: "findTemplate_className_found",
        setUp: function() {
          this.templateName = "myTemplate";
          this.className = "myClass";
          return templateNameLocator.register(this.templateName, this.className);
        },
        runTest: function(t) {
          var template;
          template = templateNameLocator.findTemplate(this.className);
          return doh.assertEqual(this.templateName, template);
        },
        tearDown: function(t) {
          return templateNameLocator.clear();
        }
      }, {
        name: "findTemplate_notExisting_throws",
        setUp: function() {
          this.templateName = "myTemplate";
          return this.className = "myClass";
        },
        runTest: function(t) {
          templateNameLocator.findTemplate(this.className);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          templateNameLocator.clear();
          return t.Thrown = false;
        }
      }, {
        name: "findClass_templateName_found",
        setUp: function() {
          this.templateName = "myTemplate";
          this.className = "myClass";
          return templateNameLocator.register(this.templateName, this.className);
        },
        runTest: function(t) {
          var name;
          name = templateNameLocator.findClass(this.templateName);
          return doh.assertEqual(this.className, name);
        },
        tearDown: function(t) {
          return templateNameLocator.clear();
        }
      }, {
        name: "findClass_notExisting_found",
        setUp: function() {
          this.templateName = "myTemplate";
          return this.className = "myClass";
        },
        runTest: function(t) {
          templateNameLocator.findClass(this.templateName);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          templateNameLocator.clear();
          return t.Thrown = false;
        }
      }, {
        name: "clear_null_configIsCleared",
        setUp: function() {
          this.templateName = "myTemplate";
          this.className = "myClass";
          return templateNameLocator.register(this.templateName, this.className);
        },
        runTest: function(t) {
          templateNameLocator.clear();
          templateNameLocator.findTemplate(this.className);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          return t.Thrown = false;
        }
      }, {
        name: "clear_all_allConfigsAreCleared",
        setUp: function() {
          this.templateName = "myTemplate";
          this.className = "myClass";
          this.config1 = "config1";
          this.config2 = "config2";
          templateNameLocator.register(this.templateName, this.className, this.config1);
          return templateNameLocator.register(this.templateName, this.className, this.config2);
        },
        runTest: function(t) {
          var all;
          templateNameLocator.clear(all = true);
          templateNameLocator.setConfigTo(this.config1);
          templateNameLocator.findTemplate(this.className);
          doh.assertTrue(t.Thrown);
          t.Thrown = false;
          templateNameLocator.setConfigTo(this.config2);
          templateNameLocator.findTemplate(this.className);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          return t.Thrown = false;
        }
      }, {
        name: "hasTemplate_notRegisteredTemplateName_false",
        setUp: function() {
          return this.className = "myClass";
        },
        runTest: function(t) {
          var exits;
          exits = templateNameLocator.hasTemplate(this.className);
          return doh.assertFalse(exits);
        },
        tearDown: function(t) {
          return templateNameLocator.clear();
        }
      }, {
        name: "hasTemplate_registeredTemplateName_true",
        setUp: function() {
          this.templateName = "myTemplate";
          this.className = "myClass";
          return templateNameLocator.register(this.templateName, this.className);
        },
        runTest: function(t) {
          var exits;
          exits = templateNameLocator.hasTemplate(this.className);
          return doh.assertTrue(exits);
        },
        tearDown: function(t) {
          return templateNameLocator.clear();
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
