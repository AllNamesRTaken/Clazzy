// Generated by CoffeeScript 1.3.1
(function() {

  define(["dojo/main", "util/doh/main", "clazzy/Clazzy", "clazzy/Exception"], function(dojo, doh, declare, Exception) {
    return doh.register("clazzy.tests.Clazzy", [
      {
        name: "SETUP",
        setUp: function(t) {
          var test;
          t.originalThrow = Exception.prototype.Throw;
          test = t;
          test.thrown = false;
          return Exception.prototype.Throw = function() {
            return test.thrown = true;
          };
        },
        runTest: function() {
          return doh.assertTrue(true);
        }
      }, {
        name: "declare_onlyNameSpacedName_ableToNewDeclaredClass",
        setUp: function() {
          return this.classname = "namespace.dummy";
        },
        runTest: function(t) {
          var cls, obj;
          cls = declare(this.classname);
          obj = new cls();
          return doh.assertEqual(this.classname, obj.declaredClass);
        }
      }, {
        name: "declare_nameSpacedNameAndObject_instanceHasObjectsProperties",
        setUp: function() {
          this.classname = "namespace.dummy";
          return this.obj = {
            p1: 1,
            p2: 2
          };
        },
        runTest: function(t) {
          var cls, key, obj, value, _ref, _results;
          cls = declare(this.classname, null, null, this.obj);
          obj = new cls();
          _ref = this.obj;
          _results = [];
          for (key in _ref) {
            value = _ref[key];
            _results.push(doh.assertEqual(value, obj[key]));
          }
          return _results;
        }
      }, {
        name: "declare_nameSpacedNameAndInterfaces_instanceHasInterfaces",
        setUp: function() {
          this.classname = "namespace.dummy";
          return this.interfaces = ["i1", "i2"];
        },
        runTest: function(t) {
          var cls, obj;
          cls = declare(this.classname, null, this.interfaces, null);
          obj = new cls();
          return doh.assertEqual(this.interfaces, obj._implements());
        }
      }, {
        name: "declare_nameSpacedNameAndInterface_instanceIsInterface",
        setUp: function() {
          this.classname = "namespace.dummy";
          return this.interfaces = ["i1"];
        },
        runTest: function(t) {
          var cls, obj;
          cls = declare(this.classname, null, this.interfaces, null);
          obj = new cls();
          return doh.assertTrue(obj.is(this.interfaces[0]));
        }
      }, {
        name: "declare_nameSpacedNameAndMixinInterface_instanceIsInterface",
        setUp: function() {
          this.classname1 = "namespace.dummy1";
          this.classname2 = "namespace.dummy2";
          this["interface"] = declare(this.classname2);
          return this.interfaces = [this["interface"]];
        },
        runTest: function(t) {
          var cls, obj;
          cls = declare(this.classname1, null, this.interfaces, null);
          obj = new cls();
          return doh.assertTrue(obj.is(this.classname2));
        }
      }, {
        name: "declare_nameSpacedNameAndMixinInterface_instanceHasMixinFunction",
        setUp: function() {
          this.classname1 = "namespace.dummy1";
          this.classname2 = "namespace.dummy2";
          this["interface"] = declare(this.classname2, null, null, {
            funk: function() {}
          });
          return this.interfaces = [this["interface"]];
        },
        runTest: function(t) {
          var cls, obj;
          cls = declare(this.classname1, null, this.interfaces, null);
          obj = new cls();
          return doh.assertTrue(!!obj.funk);
        }
      }, {
        name: "declare_nameSpacedNameWithoutInterface_instanceIsntInterface",
        setUp: function() {
          this.classname = "namespace.dummy";
          return this.interfaces = ["i1"];
        },
        runTest: function(t) {
          var cls, obj;
          cls = declare(this.classname, null, null, null);
          obj = new cls();
          return doh.assertTrue(obj.isnt(this.interfaces[0]));
        }
      }, {
        name: "declare_nameSpacedNameAndInheritance_correctFullName",
        setUp: function() {
          this.classname1 = "namespace.dummy1";
          this.classname2 = "namespace.dummy2";
          this.fullName = [this.classname2, this.classname1, "BaseClass"];
          return this.parentClass = declare(this.classname1);
        },
        runTest: function(t) {
          var cls, obj;
          cls = declare(this.classname2, this.parentClass);
          obj = new cls();
          return doh.assertEqual(this.fullName, obj._fullname());
        }
      }, {
        name: "declare_nameSpacedNameAndInheritanceString_correctFullName",
        setUp: function() {
          this.classname1 = "namespace.dummy1";
          this.classname2 = "namespace.dummy2";
          this.fullName = [this.classname2, this.classname1, "BaseClass"];
          return this.parentClass = declare(this.classname1);
        },
        runTest: function(t) {
          var cls, obj;
          cls = declare(this.classname2, this.classname1);
          obj = new cls();
          return doh.assertEqual(this.fullName, obj._fullname());
        }
      }, {
        name: "declare_inheritanceIsArray_throws",
        setUp: function() {
          this.classname1 = "namespace.dummy1";
          this.classname2 = "namespace.dummy2";
          return this.parentClass = declare(this.classname1);
        },
        runTest: function(t) {
          this.declare = declare;
          this.declare(this.classname2, [this.parentClass]);
          return doh.assertTrue(t.thrown);
        },
        tearDown: function(t) {
          return t.thrown = false;
        }
      }, {
        name: "declare_interfacesIsntArray_throws",
        setUp: function() {
          return this.classname1 = "namespace.dummy1";
        },
        runTest: function(t) {
          this.declare = declare;
          this.declare(this.classname1, null, "someInterfaceName");
          return doh.assertTrue(t.thrown);
        },
        tearDown: function(t) {
          return t.thrown = false;
        }
      }, {
        name: "declare_nameSpacedNameInheritanceWithConstructors_constructorInheritance",
        setUp: function() {
          var obj1;
          this.classname1 = "namespace.dummy1";
          this.classname2 = "namespace.dummy2";
          obj1 = {
            constructor: function() {
              return this.testvalue = 1;
            }
          };
          this.obj2 = {
            constructor: function() {
              return this.testvalue++;
            }
          };
          return this.cls1 = declare(this.classname1, null, null, obj1);
        },
        runTest: function(t) {
          var cls, obj;
          cls = declare(this.classname2, this.cls1, null, this.obj2);
          obj = new cls();
          return doh.assertEqual(2, obj.testvalue);
        }
      }, {
        name: "objectGetter_propertyName_returnsValue",
        setUp: function() {
          this.propValue = 1;
          return this.obj = new (declare("namespace.dummy", null, null, {
            prop1: this.propValue
          }))();
        },
        runTest: function(t) {
          var value;
          value = this.obj.get("prop1");
          return doh.assertEqual(this.propValue, value);
        }
      }, {
        name: "objectGetter_nonExisting_throws",
        setUp: function() {
          this.propValue = 1;
          return this.obj = new (declare("namespace.dummy", null, null, {}))();
        },
        runTest: function(t) {
          this.obj.set("prop1", this.propValue);
          return doh.assertTrue(t.thrown);
        },
        tearDown: function(t) {
          return t.thrown = false;
        }
      }, {
        name: "objectSetter_propertyNameAndObjectValue_setsValue",
        setUp: function() {
          this.propValue = {
            p1: 1
          };
          return this.obj = new (declare("namespace.dummy", null, null, {
            prop1: null
          }))();
        },
        runTest: function(t) {
          this.obj.set("prop1", this.propValue);
          return doh.assertEqual(this.propValue, this.obj.prop1);
        }
      }, {
        name: "objectSetter_nonExistingProperty_throws",
        setUp: function() {
          this.propValue = {
            p1: 1
          };
          return this.obj = new (declare("namespace.dummy", null, null, {
            prop1: null
          }))();
        },
        runTest: function(t) {
          this.obj.set("prop2", this.propValue);
          return doh.assertTrue(t.thrown);
        },
        tearDown: function(t) {
          return t.thrown = false;
        }
      }, {
        name: "objectSetter_propertyNameAndObjectValue_setValueIsNotClone",
        setUp: function() {
          this.propValue = {
            p1: 1
          };
          return this.obj = new (declare("namespace.dummy", null, null, {
            prop1: null
          }));
        },
        runTest: function(t) {
          this.obj.set("prop1", this.propValue);
          this.propValue.p1 = 2;
          return doh.assertEqual(this.propValue, this.obj.prop1);
        }
      }, {
        name: "objectSetter_propertyNameValueAndIndex_setValueAtIndex",
        setUp: function() {
          this.propValue = 1;
          this.index = 2;
          return this.obj = new (declare("namespace.dummy", null, null, {
            prop1: [0, 0, 0]
          }))();
        },
        runTest: function(t) {
          this.obj.set("prop1", this.propValue, this.index);
          return doh.assertEqual(this.propValue, this.obj.prop1[this.index]);
        }
      }, {
        name: "declaredClass_none_correctClassName",
        setUp: function() {
          this.classname = "namespace.dummy";
          return this.obj = new (declare(this.classname))();
        },
        runTest: function(t) {
          var classname;
          classname = this.obj.declaredClass;
          return doh.assertEqual(this.classname, classname);
        }
      }, {
        name: "toString_none_correctClassName",
        setUp: function() {
          this.classname = "namespace.dummy";
          return this.obj = new (declare(this.classname))();
        },
        runTest: function(t) {
          var classname;
          classname = this.obj.toString();
          return doh.assertEqual(this.classname, classname);
        }
      }, {
        name: "is_definedClass_true",
        setUp: function() {
          this.declaredClass = declare("namespace.dummy");
          return this.obj = new this.declaredClass();
        },
        runTest: function(t) {
          var same;
          same = this.obj.is(this.declaredClass);
          return doh.assertTrue(same);
        }
      }, {
        name: "is_otherDefinedClass_false",
        setUp: function() {
          this.declaredClass1 = declare("namespace.dummy1");
          this.declaredClass2 = declare("namespace.dummy2");
          return this.obj = new this.declaredClass1();
        },
        runTest: function(t) {
          var same;
          same = this.obj.is(this.declaredClass2);
          return doh.assertFalse(same);
        }
      }, {
        name: "is_instance_true",
        setUp: function() {
          this.declaredClass = declare("namespace.dummy");
          return this.obj = new this.declaredClass();
        },
        runTest: function(t) {
          var same;
          same = this.obj.is(new this.declaredClass());
          return doh.assertTrue(same);
        }
      }, {
        name: "is_inheritedClassName_true",
        setUp: function() {
          this.declaredClass = declare("namespace.dummy");
          return this.obj = new this.declaredClass();
        },
        runTest: function(t) {
          var same;
          same = this.obj.is(declare("BaseClass"));
          return doh.assertTrue(same);
        }
      }, {
        name: "set_watchedProperty_callsWatchFunction",
        setUp: function() {
          this.monkey = new (declare("namespace.Monkey", null, null, {
            constructor: function() {
              this.name = "affe";
              this.food = "banana";
              this.watched = false;
              this.oldValue = false;
              return this.newValue = false;
            }
          }))();
          return this.watchHandle = this.monkey.watch('food', function(key, oldValue, newValue, index, self) {
            this.watched = true;
            this.oldValue = oldValue;
            return this.newValue = newValue;
          });
        },
        runTest: function(t) {
          this.monkey.set('food', 'plum');
          doh.assertTrue(this.monkey.watched);
          doh.assertEqual('banana', this.monkey.oldValue);
          return doh.assertEqual('plum', this.monkey.newValue);
        },
        tearDown: function(t) {}
      }, {
        name: "set_property_callsCatchAllWatchFunction",
        setUp: function() {
          this.monkey = new (declare("namespace.Monkey", null, null, {
            constructor: function() {
              this.name = "affe";
              this.food = "banana";
              this.watched = false;
              this.oldValue = false;
              return this.newValue = false;
            }
          }))();
          return this.watchHandle = this.monkey.watch('*', function(key, oldValue, newValue, index, self) {
            this.uberwatched = true;
            this.oldValue = oldValue;
            return this.newValue = newValue;
          });
        },
        runTest: function(t) {
          this.monkey.set('food', 'plum');
          doh.assertTrue(this.monkey.uberwatched);
          doh.assertEqual('banana', this.monkey.oldValue);
          return doh.assertEqual('plum', this.monkey.newValue);
        },
        tearDown: function(t) {}
      }, {
        name: "remove_watcherHandle_watcherIsNotInvokedByPropertyChange",
        setUp: function() {
          this.monkey = new (declare("namespace.Monkey", null, null, {
            constructor: function() {
              this.name = "affe";
              this.food = "banana";
              this.watched = false;
              this.oldValue = false;
              return this.newValue = false;
            }
          }))();
          this.watchHandle = this.monkey.watch('food', function(key, oldValue, newValue, index, self) {
            this.watched = true;
            this.oldValue = oldValue;
            return this.newValue = newValue;
          });
          return this.watchHandle.remove();
        },
        runTest: function(t) {
          this.monkey.set('food', 'plum');
          doh.assertFalse(this.monkey.watched);
          doh.assertFalse(this.monkey.oldValue);
          return doh.assertFalse(this.monkey.newValue);
        },
        tearDown: function(t) {}
      }, {
        name: "set_validatedProperty_callsValidatorFunction",
        setUp: function() {
          this.monkey = new (declare("namespace.Monkey", null, null, {
            constructor: function() {
              this.name = "affe";
              this.food = "banana";
              this.validated = false;
              this.oldValue = false;
              return this.newValue = false;
            }
          }))();
          return this.validateHandle = this.monkey.validate('food', function(key, oldValue, newValue, index, self) {
            this.validated = true;
            this.oldValue = oldValue;
            this.newValue = newValue;
            return 0;
          });
        },
        runTest: function(t) {
          this.monkey.set('food', 'plum');
          doh.assertTrue(this.monkey.validated);
          doh.assertEqual('banana', this.monkey.oldValue);
          return doh.assertEqual('plum', this.monkey.newValue);
        },
        tearDown: function(t) {}
      }, {
        name: "remove_validatorHandle_validatorIsNotInvokedByPropertyChange",
        setUp: function() {
          this.monkey = new (declare("namespace.Monkey", null, null, {
            constructor: function() {
              this.name = "affe";
              this.food = "banana";
              this.validated = false;
              this.oldValue = false;
              return this.newValue = false;
            }
          }))();
          this.validateHandle = this.monkey.validate('food', function(key, oldValue, newValue, index, self) {
            this.validated = true;
            this.oldValue = oldValue;
            this.newValue = newValue;
            return 0;
          });
          return this.validateHandle.remove();
        },
        runTest: function(t) {
          this.monkey.set('food', 'plum');
          doh.assertFalse(this.monkey.validated);
          doh.assertFalse(this.monkey.oldValue);
          return doh.assertFalse(this.monkey.newValue);
        },
        tearDown: function(t) {}
      }, {
        name: "set_invalidatedProperty_propertyIsNotSet",
        setUp: function() {
          this.monkey = new (declare("namespace.Monkey", null, null, {
            constructor: function() {
              this.name = "affe";
              return this.food = "banana";
            }
          }))();
          return this.validateHandle = this.monkey.validate('food', function(key, oldValue, newValue, index, self) {
            return 1;
          });
        },
        runTest: function(t) {
          this.monkey.set('food', 'plum');
          return doh.assertEqual('banana', this.monkey.food);
        },
        tearDown: function(t) {}
      }, {
        name: "addValidator_regexp_validatorWorks",
        setUp: function() {
          return this.monkey = new (declare("namespace.Monkey", null, null, {
            constructor: function() {
              this.name = "affe";
              return this.food = "banana";
            }
          }))();
        },
        runTest: function(t) {
          this.validateHandle = this.monkey.addValidator('food', /fikon/);
          this.monkey.set('food', 'fikon');
          this.monkey.set('food', 'plum');
          return doh.assertEqual('fikon', this.monkey.food);
        },
        tearDown: function(t) {}
      }, {
        name: "lock_nameAndDeferred_locks",
        setUp: function() {
          this.monkey = new (declare("namespace.Monkey", null, null, {
            constructor: function() {
              this.name = "affe";
              return this.food = "banana";
            }
          }))();
          return this.deferred = {
            addBoth: function() {}
          };
        },
        runTest: function(t) {
          this.monkey.lock("name", this.deferred);
          this.monkey.set("name", "olle");
          return doh.assertEqual('affe', this.monkey.name);
        },
        tearDown: function(t) {}
      }, {
        name: "unlock_lockedProp_unlocks",
        setUp: function() {
          return this.monkey = new (declare("namespace.Monkey", null, null, {
            constructor: function() {
              this.name = "affe";
              return this.food = "banana";
            }
          }))();
        },
        runTest: function(t) {
          this.monkey.lock("name");
          this.monkey.unlock("name");
          this.monkey.set("name", "olle");
          return doh.assertEqual('olle', this.monkey.name);
        },
        tearDown: function(t) {}
      }, {
        name: "set_connectedProperty_callsConnectedValidatorFunction",
        setUp: function() {
          this.monkey = new (declare("namespace.Monkey", null, null, {
            constructor: function() {
              this.name = "affe";
              this.food = "banana";
              this.validated = false;
              this.oldValue = false;
              return this.newValue = false;
            }
          }))();
          this.handler = new (declare("namespace.MonkeyOwner", null, null, {
            constructor: function() {
              return this.monkeyname = "affe";
            }
          }))();
          this.handler.connect("monkeyname", this.monkey, "name");
          return this.validateHandle = this.monkey.validate('name', function(key, oldValue, newValue, index, self) {
            this.validated = true;
            this.oldValue = oldValue;
            this.newValue = newValue;
            return 0;
          });
        },
        runTest: function(t) {
          this.handler.set('monkeyname', 'tiger');
          doh.assertTrue(this.monkey.validated);
          doh.assertEqual('affe', this.monkey.oldValue);
          return doh.assertEqual('tiger', this.monkey.newValue);
        },
        tearDown: function(t) {}
      }, {
        name: "remove_connectionHandle_validatorIsNotInvokedByPropertyChange",
        setUp: function() {
          this.monkey = new (declare("namespace.Monkey", null, null, {
            constructor: function() {
              this.name = "affe";
              this.food = "banana";
              this.validated = false;
              this.oldValue = false;
              return this.newValue = false;
            }
          }))();
          this.handler = new (declare("namespace.MonkeyOwner", null, null, {
            constructor: function() {
              return this.monkeyname = "affe";
            }
          }))();
          this.handler.connect("monkeyname", this.monkey, "name");
          this.validateHandle = this.monkey.validate('name', function(key, oldValue, newValue, index, self) {
            this.validated = true;
            this.oldValue = oldValue;
            this.newValue = newValue;
            return 0;
          });
          return this.validateHandle.remove();
        },
        runTest: function(t) {
          this.handler.set('monkeyname', 'tiger');
          doh.assertFalse(this.monkey.validated);
          doh.assertFalse(this.monkey.oldValue);
          return doh.assertFalse(this.monkey.newValue);
        },
        tearDown: function(t) {}
      }, {
        name: "set_invalidatedConnectedProperty_propertyIsNotSet",
        setUp: function() {
          var oName;
          this.originalMonkeyName = oName = "affe";
          this.monkey = new (declare("namespace.Monkey", null, null, {
            constructor: function() {
              this.name = oName;
              return this.food = "banana";
            }
          }))();
          this.handler = new (declare("namespace.MonkeyOwner", null, null, {
            constructor: function() {
              return this.monkeyname = oName;
            }
          }))();
          this.handler.connect("monkeyname", this.monkey, "name");
          return this.validateHandle = this.monkey.validate('name', function(key, oldValue, newValue, index, self) {
            return 1;
          });
        },
        runTest: function(t) {
          this.handler.set('monkeyname', 'tiger');
          return doh.assertEqual(this.originalMonkeyName, this.monkey.name);
        },
        tearDown: function(t) {}
      }, {
        name: "inherited_unexisting_throws",
        setUp: function() {
          return this.monkey = new (declare("namespace.Monkey", null, null, {
            constructor: function() {},
            eat: function(food) {
              return food;
            }
          }))();
        },
        runTest: function(t) {
          this.monkey.inherited("eat", "namespace.Monkey", ["banana"]);
          return doh.assertTrue(t.thrown);
        },
        tearDown: function(t) {
          return t.thrown = false;
        }
      }, {
        name: "inherited_existing_inheritedCalled",
        setUp: function() {
          var Monkey;
          Monkey = declare("namespace.Monkey", null, null, {
            constructor: function() {},
            eat: function(food) {
              return food;
            }
          });
          return this.baboon = new (declare("namespace.Baboon", Monkey, null, {
            constructor: function() {},
            eat: function(food) {
              return this.inherited();
            }
          }))();
        },
        runTest: function(t) {
          var eaten;
          eaten = this.baboon.eat('banana');
          return doh.assertEqual('banana', eaten);
        },
        tearDown: function(t) {}
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
