define [
    "dojo/main"
    "util/doh/main"
    "clazzy/Clazzy"
    "clazzy/Exception"
], (dojo, doh, declare, Exception) ->

    doh.register "clazzy.tests.Clazzy", [
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
            #Assert
            doh.assertError Exception, @obj, "set", ["prop2", @propValue]
    ,
        name: "objectSetter_propertyNameAndObjectValue_setValueIsAClone"
        setUp: () ->
            #Arrage
            @propValue = {p1:1}
            @obj = new (declare "namespace.dummy", null, null, {prop1: null})
        runTest: (t) ->
            #Act
            @obj.set "prop1", @propValue
            @propValue.p1 = 2
            #Assert
            doh.assertNotEqual(@propValue, @obj.prop1)
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
            )
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
        tearDown: () ->
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
            )
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
        tearDown: () ->
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
            )
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
        tearDown: () ->
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
            )
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
        tearDown: () ->
    ,
        name: "set_invalidatedProperty_propertyIsNotSet"
        setUp: () ->
            #Arrage
            @monkey = new (declare "namespace.Monkey", null, null, 
                constructor: () ->
                    @name = "affe"
                    @food = "banana"
            )
            @validateHandle = @monkey.validate 'food', (key, oldValue, newValue, index, self) ->
                1
        runTest: (t) ->
            #Act
            @monkey.set('food', 'plum')
            #Assert
            doh.assertEqual 'banana', @monkey.food
        tearDown: () ->
    ]
