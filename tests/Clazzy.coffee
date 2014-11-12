define [
    "dojo/main"
    "util/doh/main"
    "clazzy/Clazzy"
    "clazzy/Exception"
], (dojo, doh, declare, Exception) ->

    doh.register "clazzy.tests.Clazzy", [

        name: "SETUP"
        setUp: (t) ->
            #Arrange
            t.originalThrow = Exception.prototype.Throw
            test = t
            test.thrown = false
            Exception.prototype.Throw = () ->
                test.thrown = true
        runTest: () -> 
            #Act
            #Assert
            doh.assertTrue true
    ,
        name: "declare_onlyNameSpacedName_ableToNewDeclaredClass"
        setUp: () ->
            #Arrage
            @classname = "namespace.dummy"
        runTest: (t) ->
            #Act
            cls = declare @classname
            obj = new cls()
            #Assert
            doh.assertEqual @classname, obj.declaredClass 
    ,
        name: "declare_nameSpacedNameAndObject_instanceHasObjectsProperties"
        setUp: () ->
            #Arrage
            @classname = "namespace.dummy"
            @obj = {p1:1, p2:2}
        runTest: (t) ->
            #Act
            cls = declare @classname, null, null, @obj
            obj = new cls()
            #Assert
            for key, value of @obj
                doh.assertEqual(value, obj[key])
    ,
        name: "declare_nameSpacedNameAndInterfaces_instanceHasInterfaces"
        setUp: () ->
            #Arrage
            @classname = "namespace.dummy"
            @interfaces = ["i1", "i2"]
        runTest: (t) ->
            #Act
            cls = declare @classname, null, @interfaces, null
            obj = new cls()
            #Assert
            doh.assertEqual(@interfaces, obj._implements())
    ,
        name: "declare_nameSpacedNameAndInterface_instanceIsInterface"
        setUp: () ->
            #Arrage
            @classname = "namespace.dummy"
            @interfaces = ["i1"]
        runTest: (t) ->
            #Act
            cls = declare @classname, null, @interfaces, null
            obj = new cls()
            #Assert
            doh.assertTrue obj.is(@interfaces[0])
    ,
        name: "declare_nameSpacedNameAndMixinInterface_instanceIsInterface"
        setUp: () ->
            #Arrage
            @classname1 = "namespace.dummy1"
            @classname2 = "namespace.dummy2"
            @interface = declare @classname2
            @interfaces = [@interface]
        runTest: (t) ->
            #Act
            cls = declare @classname1, null, @interfaces, null
            obj = new cls()
            #Assert
            doh.assertTrue obj.is(@classname2)
    ,
        name: "declare_nameSpacedNameAndMixinInterface_instanceHasMixinFunction"
        setUp: () ->
            #Arrage
            @classname1 = "namespace.dummy1"
            @classname2 = "namespace.dummy2"
            @interface = declare @classname2, null, null, { funk: () -> }
            @interfaces = [@interface]
        runTest: (t) ->
            #Act
            cls = declare @classname1, null, @interfaces, null
            obj = new cls()
            #Assert
            doh.assertTrue !!obj.funk
    ,
        name: "declare_nameSpacedNameWithoutInterface_instanceIsntInterface"
        setUp: () ->
            #Arrage
            @classname = "namespace.dummy"
            @interfaces = ["i1"]
        runTest: (t) ->
            #Act
            cls = declare @classname, null, null, null
            obj = new cls()
            #Assert
            doh.assertTrue(obj.isnt(@interfaces[0]))
    ,
        name: "declare_nameSpacedNameAndInheritance_correctFullName"
        setUp: () ->
            #Arrage
            @classname1 = "namespace.dummy1"
            @classname2 = "namespace.dummy2"
            @fullName = [@classname2, @classname1, "BaseClass"]
            @parentClass = declare @classname1
        runTest: (t) ->
            #Act
            cls = declare @classname2, @parentClass
            obj = new cls()
            #Assert
            doh.assertEqual(@fullName, obj._fullname())
    ,
        name: "declare_nameSpacedNameAndInheritanceString_correctFullName"
        setUp: () ->
            #Arrage
            @classname1 = "namespace.dummy1"
            @classname2 = "namespace.dummy2"
            @fullName = [@classname2, @classname1, "BaseClass"]
            @parentClass = declare @classname1
        runTest: (t) ->
            #Act
            cls = declare @classname2, @classname1
            obj = new cls()
            #Assert
            doh.assertEqual(@fullName, obj._fullname())
    ,
        name: "declare_inheritanceIsArray_throws"
        setUp: () ->
            #Arrage
            @classname1 = "namespace.dummy1"
            @classname2 = "namespace.dummy2"
            @parentClass = declare @classname1
        runTest: (t) ->
            @declare = declare
            #Act
            @declare(@classname2, [@parentClass])
            #Assert
            doh.assertTrue(t.thrown)
        tearDown: (t) ->
            t.thrown = false
    ,
        name: "declare_interfacesIsntArray_throws"
        setUp: () ->
            #Arrage
            @classname1 = "namespace.dummy1"
        runTest: (t) ->
            @declare = declare
            #Act
            @declare(@classname1, null, "someInterfaceName")
            #Assert
            doh.assertTrue(t.thrown)
        tearDown: (t) ->
            t.thrown = false
    ,
        name: "declare_nameSpacedNameInheritanceWithConstructors_constructorInheritance"
        setUp: () ->
            #Arrage
            @classname1 = "namespace.dummy1"
            @classname2 = "namespace.dummy2"
            obj1 = 
                constructor: () -> 
                    @testvalue = 1
            @obj2 = 
                constructor: () -> 
                    @testvalue++
            @cls1 = declare @classname1, null, null, obj1
        runTest: (t) ->
            #Act
            cls = declare @classname2, @cls1, null, @obj2
            obj = new cls()
            #Assert
            doh.assertEqual(2, obj.testvalue)
    ,
        name: "objectGetter_propertyName_returnsValue"
        setUp: () ->
            #Arrage
            @propValue = 1
            @obj = new (declare "namespace.dummy", null, null, {prop1: @propValue})()
        runTest: (t) ->
            #Act
            value = @obj.get "prop1"
            #Assert
            doh.assertEqual(@propValue, value)
    ,
        name: "objectGetter_nonExisting_throws"
        setUp: () ->
            #Arrage
            @propValue = 1
            @obj = new (declare "namespace.dummy", null, null, {})()
        runTest: (t) ->
            #Act
            @obj.set("prop1", @propValue)
            #Assert
            doh.assertTrue(t.thrown)
        tearDown: (t) ->
            t.thrown = false
    ,
        name: "objectSetter_propertyNameAndObjectValue_setsValue"
        setUp: () ->
            #Arrage
            @propValue = {p1:1}
            @obj = new (declare "namespace.dummy", null, null, {prop1: null})()
        runTest: (t) ->
            #Act
            @obj.set "prop1", @propValue
            #Assert
            doh.assertEqual(@propValue, @obj.prop1)
    ,
        name: "objectSetter_nonExistingProperty_throws"
        setUp: () ->
            #Arrage
            @propValue = {p1:1}
            @obj = new (declare "namespace.dummy", null, null, {prop1: null})()
        runTest: (t) ->
            #Act
            @obj.set("prop2", @propValue)
            #Assert
            doh.assertTrue(t.thrown)
        tearDown: (t) ->
            t.thrown = false
    ,
        name: "objectSetter_propertyNameAndObjectValue_setValueIsNotClone"
        setUp: () ->
            #Arrage
            @propValue = {p1:1}
            @obj = new (declare "namespace.dummy", null, null, {prop1: null})
        runTest: (t) ->
            #Act
            @obj.set "prop1", @propValue
            @propValue.p1 = 2
            #Assert
            doh.assertEqual(@propValue, @obj.prop1)
    ,
        name: "objectSetter_propertyNameValueAndIndex_setValueAtIndex"
        setUp: () ->
            #Arrage
            @propValue = 1
            @index = 2
            @obj = new (declare "namespace.dummy", null, null, {prop1: [0,0,0]})()
        runTest: (t) ->
            #Act
            @obj.set "prop1", @propValue, @index
            #Assert
            doh.assertEqual(@propValue, @obj.prop1[@index])
    ,
        name: "declaredClass_none_correctClassName"
        setUp: () ->
            #Arrage
            @classname = "namespace.dummy"
            @obj = new (declare @classname)()
        runTest: (t) ->
            #Act
            classname = @obj.declaredClass
            #Assert
            doh.assertEqual @classname, classname 
    ,
        name: "toString_none_correctClassName"
        setUp: () ->
            #Arrage
            @classname = "namespace.dummy"
            @obj = new (declare @classname)()
        runTest: (t) ->
            #Act
            classname = @obj.toString()
            #Assert
            doh.assertEqual @classname, classname 
    ,
        name: "is_definedClass_true"
        setUp: () ->
            #Arrage
            @declaredClass = declare "namespace.dummy"
            @obj = new @declaredClass()
        runTest: (t) ->
            #Act
            same = @obj.is @declaredClass
            #Assert
            doh.assertTrue same
    ,
        name: "is_otherDefinedClass_false"
        setUp: () ->
            #Arrage
            @declaredClass1 = declare "namespace.dummy1"
            @declaredClass2 = declare "namespace.dummy2"
            @obj = new @declaredClass1()
        runTest: (t) ->
            #Act
            same = @obj.is @declaredClass2
            #Assert
            doh.assertFalse same
    ,
        name: "is_instance_true"
        setUp: () ->
            #Arrage
            @declaredClass = declare "namespace.dummy"
            @obj = new @declaredClass()
        runTest: (t) ->
            #Act
            same = @obj.is new @declaredClass()
            #Assert
            doh.assertTrue same
    ,
        name: "is_inheritedClassName_true"
        setUp: () ->
            #Arrage
            @declaredClass = declare "namespace.dummy"
            @obj = new @declaredClass()
        runTest: (t) ->
            #Act
            same = @obj.is declare "BaseClass"
            #Assert
            doh.assertTrue same
    ,
        name: "set_watchedProperty_callsWatchFunction"
        setUp: () ->
            #Arrage
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                    @name = "affe"
                    @food = "banana"
                    @watched = false
                    @oldValue = false
                    @newValue = false
            )()
            @watchHandle = @monkey.watch 'food', (key, oldValue, newValue, index, self) ->
                this.watched = true
                this.oldValue = oldValue
                this.newValue = newValue
        runTest: (t) ->
            #Act
            @monkey.set('food', 'plum')
            #Assert
            doh.assertTrue @monkey.watched
            doh.assertEqual 'banana', @monkey.oldValue
            doh.assertEqual 'plum', @monkey.newValue
        tearDown: (t) ->
    ,
        name: "set_property_callsCatchAllWatchFunction"
        setUp: () ->
            #Arrage
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                    @name = "affe"
                    @food = "banana"
                    @watched = false
                    @oldValue = false
                    @newValue = false
            )()
            @watchHandle = @monkey.watch '*', (key, oldValue, newValue, index, self) ->
                this.uberwatched = true
                this.oldValue = oldValue
                this.newValue = newValue
        runTest: (t) ->
            #Act
            @monkey.set('food', 'plum')
            #Assert
            doh.assertTrue @monkey.uberwatched
            doh.assertEqual 'banana', @monkey.oldValue
            doh.assertEqual 'plum', @monkey.newValue
        tearDown: (t) ->
    ,
        name: "remove_watcherHandle_watcherIsNotInvokedByPropertyChange"
        setUp: () ->
            #Arrage
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                    @name = "affe"
                    @food = "banana"
                    @watched = false
                    @oldValue = false
                    @newValue = false
            )()
            @watchHandle = @monkey.watch 'food', (key, oldValue, newValue, index, self) ->
                this.watched = true
                this.oldValue = oldValue
                this.newValue = newValue
            @watchHandle.remove()
        runTest: (t) ->
            #Act
            @monkey.set('food', 'plum')
            #Assert
            doh.assertFalse @monkey.watched
            doh.assertFalse @monkey.oldValue
            doh.assertFalse @monkey.newValue
        tearDown: (t) ->
    ,
        name: "set_validatedProperty_callsValidatorFunction"
        setUp: () ->
            #Arrage
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                    @name = "affe"
                    @food = "banana"
                    @validated = false
                    @oldValue = false
                    @newValue = false
            )()
            @validateHandle = @monkey.validate 'food', (key, oldValue, newValue, index, self) ->
                this.validated = true
                this.oldValue = oldValue
                this.newValue = newValue
                0
        runTest: (t) ->
            #Act
            @monkey.set('food', 'plum')
            #Assert
            doh.assertTrue @monkey.validated
            doh.assertEqual 'banana', @monkey.oldValue
            doh.assertEqual 'plum', @monkey.newValue
        tearDown: (t) ->
    ,
        name: "remove_validatorHandle_validatorIsNotInvokedByPropertyChange"
        setUp: () ->
            #Arrage
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                    @name = "affe"
                    @food = "banana"
                    @validated = false
                    @oldValue = false
                    @newValue = false
            )()
            @validateHandle = @monkey.validate 'food', (key, oldValue, newValue, index, self) ->
                this.validated = true
                this.oldValue = oldValue
                this.newValue = newValue
                0
            @validateHandle.remove()
        runTest: (t) ->
            #Act
            @monkey.set('food', 'plum')
            #Assert
            doh.assertFalse @monkey.validated
            doh.assertFalse @monkey.oldValue
            doh.assertFalse @monkey.newValue
        tearDown: (t) ->
    ,
        name: "set_invalidatedProperty_propertyIsNotSet"
        setUp: () ->
            #Arrage
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                    @name = "affe"
                    @food = "banana"
            )()
            @validateHandle = @monkey.validate 'food', (key, oldValue, newValue, index, self) ->
                1
        runTest: (t) ->
            #Act
            @monkey.set('food', 'plum')
            #Assert
            doh.assertEqual 'banana', @monkey.food
        tearDown: (t) ->
    ,
        name: "addValidator_regexp_validatorWorks"
        setUp: () ->
            #Arrage
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                    @name = "affe"
                    @food = "banana"
            )()
        runTest: (t) ->
            #Act
            @validateHandle = @monkey.addValidator 'food', /fikon/
            @monkey.set('food', 'fikon')
            @monkey.set('food', 'plum')
            #Assert
            doh.assertEqual 'fikon', @monkey.food
        tearDown: (t) ->
    ,
        name: "lock_nameAndDeferred_locks"
        setUp: () ->
            #Arrage
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                    @name = "affe"
                    @food = "banana"
            )()
            @deferred = 
                addBoth: ()->
        runTest: (t) ->
            #Act
            @monkey.lock "name", @deferred
            @monkey.set "name", "olle"
            #Assert
            doh.assertEqual 'affe', @monkey.name
        tearDown: (t) ->
    ,
        name: "unlock_lockedProp_unlocks"
        setUp: () ->
            #Arrage
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                    @name = "affe"
                    @food = "banana"
            )()
        runTest: (t) ->
            #Act
            @monkey.lock "name"
            @monkey.unlock "name"
            @monkey.set "name", "olle"
            #Assert
            doh.assertEqual 'olle', @monkey.name
        tearDown: (t) ->
    ,
        name: "set_connectedProperty_callsConnectedValidatorFunction"
        setUp: () ->
            #Arrage
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                    @name = "affe"
                    @food = "banana"
                    @validated = false
                    @oldValue = false
                    @newValue = false
            )()
            @handler = new (declare "namespace.MonkeyOwner", null, null, 
                constructor: () ->
                    @monkeyname = "affe"
            )()
            @handler.connect "monkeyname", @monkey, "name"
            @validateHandle = @monkey.validate 'name', (key, oldValue, newValue, index, self) ->
                this.validated = true
                this.oldValue = oldValue
                this.newValue = newValue
                0
        runTest: (t) ->
            #Act
            @handler.set('monkeyname', 'tiger')
            #Assert
            doh.assertTrue @monkey.validated
            doh.assertEqual 'affe', @monkey.oldValue
            doh.assertEqual 'tiger', @monkey.newValue
        tearDown: (t) ->
    ,
        name: "remove_connectionHandle_validatorIsNotInvokedByPropertyChange"
        setUp: () ->
            #Arrage
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                    @name = "affe"
                    @food = "banana"
                    @validated = false
                    @oldValue = false
                    @newValue = false
            )()
            @handler = new (declare "namespace.MonkeyOwner", null, null, 
                constructor: () ->
                    @monkeyname = "affe"
            )()
            @handler.connect "monkeyname", @monkey, "name"
            @validateHandle = @monkey.validate 'name', (key, oldValue, newValue, index, self) ->
                this.validated = true
                this.oldValue = oldValue
                this.newValue = newValue
                0
            @validateHandle.remove()
        runTest: (t) ->
            #Act
            @handler.set('monkeyname', 'tiger')
            #Assert
            doh.assertFalse @monkey.validated
            doh.assertFalse @monkey.oldValue
            doh.assertFalse @monkey.newValue
        tearDown: (t) ->
    ,
        name: "set_invalidatedConnectedProperty_propertyIsNotSet"
        setUp: () ->
            #Arrage
            @originalMonkeyName = oName = "affe"
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                    @name = oName
                    @food = "banana"
            )()
            @handler = new (declare "namespace.MonkeyOwner", null, null, 
                constructor: () ->
                    @monkeyname = oName
            )()
            @handler.connect "monkeyname", @monkey, "name"
            @validateHandle = @monkey.validate 'name', (key, oldValue, newValue, index, self) ->
                1
        runTest: (t) ->
            #Act
            @handler.set('monkeyname', 'tiger')
            #Assert
            doh.assertEqual @originalMonkeyName, @monkey.name
        tearDown: (t) ->
    ,

        name: "inherited_unexisting_throws"
        setUp: () ->
            #Arrage
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                eat: (food) ->
                    food
            )()
        runTest: (t) ->
            #Act
            @monkey.inherited("eat", "namespace.Monkey", ["banana"])
            #Assert
            doh.assertTrue(t.thrown)
        tearDown: (t) ->
            t.thrown = false
    ,
        name: "inherited_existing_inheritedCalled"
        setUp: () ->
            #Arrage
            Monkey = declare "namespace.Monkey", null, null, 
                constructor: () ->
                eat: (food) ->
                    food
            @baboon = new (declare "namespace.Baboon", Monkey, null, 
                constructor: () ->
                eat: (food) ->
                    @inherited()
            )()
        runTest: (t) ->
            #Act
            eaten = @baboon.eat('banana')
            #Assert
            doh.assertEqual 'banana', eaten
        tearDown: (t) ->
    ,
        name: "TEARDOWN"
        setUp: () ->
            #Arrange
        runTest: () -> 
            #Act
            #Assert
            doh.assertTrue true
        tearDown: (t) ->
            Exception.prototype.Throw = t.originalThrow
    ]
