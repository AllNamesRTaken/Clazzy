###
Copyright (C) 2012 Joel Brage

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
###
###
Howto:
define [
  "some/path/Clazzy" 
  "some/path/MyBaseClass" 
  "some/path/MyMixin" 
], (Class, MyBaseClass, MyMixin) ->
# Using the framwork.Lang style object declaration
# The first parameter in the array after the objects name will be treated as inheritance if it is also a declared class.
# If it is string it will just be another interface. Latter declared classes passed in will be treated as mixins as well as interfaces.
  Class "some.namespace.MyClass", MyBaseClass ["someInterface1", "someInterface2", MyMixin], 
    constructor: () ->
      @.myProperty1 = 1
      @.myProperty2 = 2
      @.myProperty3 = 3
    myFunc1: () ->
      # awesomeness goes here
    myFunc2: () ->
      # awesomeness goes here
-----------
myObject = new MyClass() # if MyClass module exists in the define
myObject = new some.namespace.MyClass()
myObject._fullname # -> ["some.namespace.MyClass", "some.path.MyBaseClass", "BaseClass"]
myObject.declaredClass # -> "some.namespace.MyClass"
myObject.toString() # -> "some.namespace.MyClass"
myObject._implements # ->  "someInterface1", "someInterface2", "some.path.MyMixin"
myObject.is "someInterface2" # -> true
myObject.isnt "a banana" # -> true
myObject.set "myProperty1", 42 # -> property is set
myObject.set "nonExistingProperty", 666 # -> throws Error
myObject.set "myProperty1" # -> returns 42
myObject.set "nonExistingProperty" # -> throws Error
myObject.myFunc1() # -> awesomeness

----------
Q&A:
Why interfaces?
Because I do dependency injection and need something to represent the functionality contract for my IoC.
Why set and get?
Because Dojo has an excelent aspect module that lets me latch on to (wrap) functions (which doesnt work with objects) and UI bound automatically updating UI.
###
define [
    "clazzy/abstraction/Lang" #used only for the clone functionality, replace if you want
    "clazzy/Exception" #super basic class
], (_lang, Exception) ->
    #Taken shamelessly from MDN
    unless Array::indexOf
        Array::indexOf = (searchElement) ->
            "use strict"
            throw new TypeError()    unless this?
            t = Object(this)
            len = t.length >>> 0
            return -1    if len is 0
            n = 0
            if arguments.length > 0
                n = Number(arguments[1])
                unless n is n
                    n = 0
                else n = (n > 0 or -1) * Math.floor(Math.abs(n))    if n isnt 0 and n isnt Infinity and n isnt -Infinity
            return -1    if n >= len
            k = (if n >= 0 then n else Math.max(len - Math.abs(n), 0))
            while k < len
                return k    if k of t and t[k] is searchElement
                k++
            -1
    #The class all other classes inherit from.
    class BaseClass
        declaredClass: "BaseClass"
        _implements: () -> []
        _fullname: () -> ["BaseClass"]
        constructor: () -> 
            if arguments.length and "object" is typeof arguments[0]
                @[key] = prop for key, prop of arguments[0]
            @_watchers = (prop, oldValue, newValue, index, self) ->
                if callbacks = @_watchers[key = '_' + prop]?.slice()
                    for callback in callbacks
                        throw new Exception("watcher is not a function for property: " + prop) if not callback.call?
                        callback.call(this, prop, oldValue, newValue, index, self)
                if callbacks = @_watchers['*']
                    for callback in callbacks
                        throw new Exception("watcher is not a function for property: " + prop) if not callback.call?
                        callback.call(this, prop, oldValue, newValue, index, self)
                this
            @_validators = (prop, oldValue, newValue, index, self) ->
                if callbacks = @_validators[key = '_' + prop]?.slice()
                    for callback in callbacks
                        throw new Exception("watcher is not a function for property: " + prop) if not callback.call?
                        return callback.call(this, prop, oldValue, newValue, index, self)
                0
            this
        is: (name) ->
            name = name.declaredClass if "object" is typeof name and name?.declaredClass
            name = name.classname if "function" is typeof name
            return true if name in @_fullname()
            return true if name in @_implements()
            false
        isnt: (name) ->
            not @is name
        set: (prop, value, index, self) -> 
            throw new Exception("IllegalPropertyNameException", "No property " + prop + " on class " + this.declaredClass) if this[prop] is undefined
            oldValue = this[prop]
            newValue = _lang.clone value
            if 1 is (cancel = this._validators(prop, oldValue, newValue, index, self))
                return oldValue

            if index? then this[prop][index] = newValue else this[prop] = newValue
            this._watchers(prop, oldValue, newValue, index, self)
            newValue
        get: (prop) -> 
            throw new Exception("IllegalPropertyNameException", "No property " + prop + " on class " + this.declaredClass) if this[prop] is undefined
            this[prop]
        watch: (prop, callback) ->
            key = if prop isnt '*' then '_' + prop else prop
            callbacks = @_watchers[key]
            callbacks = @_watchers[key] = [] if typeof callbacks isnt "object"
            callbacks.push(callback)
            return {
                remove: () ->
                    callbacks.splice(callbacks.indexOf(callback), 1)
            }
        validate: (prop, callback) ->
            key = '_' + prop
            callbacks = @_validators[key]
            callbacks = @_validators[key] = [] if typeof callbacks isnt "object"
            callbacks.push(callback)
            return {
                remove: () ->
                    callbacks.splice(callbacks.indexOf(callback), 1)
            }
        toString: () ->
            @declaredClass
    BaseClass.classname = "BaseClass"

    Class = (classname, inheritance, interfaces = [], jsonObject = {}) -> 
        throw new Exception("TypeException", "Inheritance can not be an Array") if inheritance instanceof Array
        throw new Exception("TypeException", "Interfaces must be an Array or null/undefined") if interfaces and not (interfaces instanceof Array)
        root = window;
        if !inheritance 
            parentClass = BaseClass
        else if "function" is typeof inheritance 
            parentClass = inheritance
        else 
            parentClass = root
            for part in inheritance.split(".")
                parentClass = parentClass[part]
        (jsonObject.constructor = () ->) if not jsonObject.hasOwnProperty('constructor')

        #-----------------------------------------------
        # Find out which interfaces are really mixins
        #-----------------------------------------------
        interfaces = interfaces.filter (el)->
            el?
        mixins = interfaces.filter (el)-> 
            "function" is typeof el
        interfaces = interfaces.map (el)->
            return el.classname if el.classname?
            el

        #-----------------------------------------------
        # Help functions normaly generated by coffescript
        # TODO: Replace __proto__ 
        #-----------------------------------------------
        hasProp = Object::hasOwnProperty
        inherit = (child, parent) ->
            for key of parent 
	            child[key] = parent[key] if hasProp.call(parent, key)
            ctor = () -> 
                this.constructor = child
                this
            ctor.prototype = parent.prototype
            child.prototype = new ctor
            return child

        chaining = (child, original, args) -> 
            chaining(child.prototype.constructor.__super__.constructor, original, args) if child.prototype.constructor.__super__
            child.prototype.constructor.apply original, args
            
        #-----------------------------------------------
        # Create Namespace
        #-----------------------------------------------
        ns = nameSpace = root
        for part in classname.split(".")
            ns[part] = {} if not ns[part]
            nameSpace = ns
            ns = ns[part]
            
        nameSpace[part] = (() -> 
            Obj = () ->
                chaining(Obj, this, arguments)

            inherit(Obj, parentClass)

            for func in mixins
                for key of func.prototype
                    Obj.prototype[key] = func.prototype[key]
            for key of jsonObject
                Obj.prototype[key] = jsonObject[key]

            Obj.prototype.constructor.__super__ = parentClass.prototype

            Obj.prototype._implements = () -> 
                return Obj.prototype.constructor.__super__._implements.call(this).concat(interfaces) 

            Obj.prototype._fullname = () -> 
                return [classname].concat(Obj.prototype.constructor.__super__._fullname.call(this))

            Obj.prototype.declaredClass = classname
            Obj.classname = classname
            return Obj
        )()
