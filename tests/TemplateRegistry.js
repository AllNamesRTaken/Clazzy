(function() {

  define(["dojo/main", "util/doh/main", "clazzy/TemplateRegistry", "clazzy/Exception"], function(dojo, doh, templateRegistry, Exception) {
    return doh.register("clazzy.TemplateRegistry", [
      {
        name: "SETUP",
        setUp: function(t) {
          var test;
          t.originalThrow = Exception.prototype.Throw;
          test = t;
          test.Thrown = false;
          return Exception.prototype.Throw = function() {
            return test.Thrown = true;
          };
        },
        runTest: function() {
          return doh.assertTrue(true);
        }
      }, {
        name: "get_registeredTemplateId_templateString",
        setUp: function() {
          this.testString = 'abc123';
          return templateRegistry.register('myTemplateId', this.testString);
        },
        runTest: function(t) {
          var template;
          template = templateRegistry.get('myTemplateId');
          return doh.assertEqual(this.testString, template);
        }
      }, {
        name: "get_null_throws",
        setUp: function() {},
        runTest: function(t) {
          templateRegistry.get(null);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          return t.Thrown = false;
        }
      }, {
        name: "get_notRegisteredTemplateId_defaultTemplateString",
        setUp: function() {
          return this.testString = '<div>Template not available</div>';
        },
        runTest: function(t) {
          var template;
          template = templateRegistry.get('undefinedKey');
          return doh.assertEqual(this.testString, template);
        }
      }, {
        name: "setConfigTo_configname_configIsChanged",
        setUp: function() {},
        runTest: function() {
          templateRegistry.setConfigTo("someNewName");
          return doh.assertEqual("someNewName", templateRegistry.config);
        }
      }, {
        name: "setConfigTo_nonStringConfigname_throws",
        setUp: function() {},
        runTest: function(t) {
          templateRegistry.setConfigTo(0);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          return t.Thrown = false;
        }
      }, {
        name: "register_nullTemplateId_throws",
        setUp: function() {},
        runTest: function(t) {
          templateRegistry.register(null);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          return t.Thrown = false;
        }
      }, {
        name: "Register_nullTemplateString_throws",
        setUp: function() {},
        runTest: function(t) {
          templateRegistry.register("valid", null);
          return doh.assertTrue(t.Thrown);
        },
        tearDown: function(t) {
          return t.Thrown = false;
        }
      }, {
        name: "TEARDOWN",
        setUp: function() {},
        runTest: function() {
          return doh.assertTrue(true);
        },
        tearDown: function(t) {
          return Exception.prototype.Throw = t.originalThrow;
        }
      }
    ]);
  });

}).call(this);
