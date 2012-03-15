Clazzy
------
**In short**

This example uses Clazzy and shows how to declare classes with inheritance and an interface, and will then call some functions on the newly created object.

**a little longer**
The code below defines a module that needs three resources, the Clazzy function, some ~BaseClass that we want to inherit from and some other class that we want to use as Mixin. The module uses the Clazzy to declare a new Class called ~MyClass, including namespace, inheritance, 2 interfaces and our mixin. 

```coffeescript
define [
  "clazzy/Clazzy" 
  "some/path/MyBaseClass" 
  "some/path/MyMixin" 
], (Class, MyMixin) ->
  Class "some.other.path.MyClass", MyBaseClass, ["someInterface1", "someInterface2", MyMixin], 
    constructor: () ->
      @.myProperty1 = 1
      @.myProperty2 = 2
      @.myProperty3 = 3
    myFunc1: () ->
      # awesomeness goes here
    myFunc2: () ->
      # awesomeness goes here
```

Now we can instanciate it and try some of our neat functionality.

```coffeescript
myObject = new MyClass()
myObject._fullname # -> ["some.other.path.MyClass", "some.path.MyBaseClass", "BaseClass"]
myObject.declaredClass # -> "some.other.path.MyClass"
myObject.toString() # -> "some.other.path.MyClass"
myObject._implements # ->  "someInterface1", "someInterface2", "some.path.MyMixin"
myObject.is "someInterface2" # -> true
myObject.isnt "a banana" # -> true
myObject.set "myProperty1", 42 # -> property is set
myObject.set "nonExistingProperty", 666 # -> throws Error
myObject.set "myProperty1" # -> returns 42
myObject.set "nonExistingProperty" # -> throws Error
myObject.myFunc1() # -> awesomeness
```

Sweet! But why the setters and getters? Well they let us jack in and observe when the function is called and what was set or get using e.g. dojos aspect module since it is now a function and not a javascript object property.