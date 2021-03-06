define [
    "clazzy/abstraction/Lang"
    "clazzy/Exception"
    "clazzy/BaseClass"
], (lang, Exception, BaseClass) ->

    #-----------------------------------------------
    # Help functions normaly generated by coffescript 
    #-----------------------------------------------
    hasProp = Object::hasOwnProperty
    __extend = (child, parent) ->
        'use strict'
        for key of parent 
            child[key] = parent[key] if hasProp.call(parent, key)
        ctor = () -> 
            this.constructor = child
            this
        ctor.prototype = parent.prototype
        child.prototype = new ctor()
        return child

    constructorChaining = (child, original, args) -> 
        constructorChaining(child.prototype.constructor.__super__.constructor, original, args) if child.prototype.constructor.__super__
        child.prototype.constructor.apply original, args

    #-----------------------------------------------
    # Helper Functions
    # 
    #-----------------------------------------------
    _getInheritance = (inheritance, root)->
        'use strict'
        if not inheritance 
            parent = BaseClass
        else if "function" is typeof inheritance 
            parent = inheritance
        else 
            parent = root
            for part in inheritance.split(".")
                parent = parent[part]
        parent

    _getNameSpace = (classname, root) ->
        'use strict'
        nameSpace = ns = root
        for part in classname.split(".")
            ns[part] = {} if not ns[part]
            nameSpace = ns
            ns = ns[part]
        [nameSpace, part]
    #-----------------------------------------------
    # The Class define function
    # 
    #-----------------------------------------------
    Class = (classname, inheritance, interfaces = [], jsonObject = {}) -> 
        'use strict'
        if inheritance instanceof Array then return (new Exception("TypeException", "Inheritance can not be an Array")).Throw()
        if interfaces and not (interfaces instanceof Array) then return (new Exception("TypeException", "Interfaces must be an Array or null/undefined")).Throw()
        root = if window? then window else {}

        parentClass = _getInheritance(inheritance, root) 
        (jsonObject.constructor = () ->) if not jsonObject.hasOwnProperty('constructor')

        #-----------------------------------------------
        # Find out which interfaces are really mixins
        #-----------------------------------------------
        interfaces = lang.filter interfaces, (el)->
            el?
        mixins = lang.filter interfaces, (el)-> 
            "function" is typeof el
        interfaces = lang.map interfaces, (el)->
            return el.classname if el.classname?
            el
            
        #-----------------------------------------------
        # Create Namespace
        #-----------------------------------------------
        [nameSpace, part] = _getNameSpace(classname, root)
            
        nameSpace[part] = (() -> 
            ProtoFn = () ->
                constructorChaining(ProtoFn, originalPrototype = this, arguments)

            __extend(ProtoFn, parentProtoFn = parentClass)

            for func in mixins
                for own key of func.prototype when key isnt "constructor"
                    ProtoFn.prototype[key] = func.prototype[key]
            for key of jsonObject
                ProtoFn.prototype[key] = jsonObject[key]
            ProtoFn.prototype.constructor = jsonObject.constructor # because IE8 is a *****

            ProtoFn.prototype.constructor.__super__ = parentClass.prototype
            ProtoFn.prototype.__super__ = parentClass.prototype

            ProtoFn.prototype._implements = () -> 
                return ProtoFn.prototype.constructor.__super__._implements.call(this).concat(interfaces) 

            ProtoFn.prototype._fullname = () -> 
                return [classname].concat(ProtoFn.prototype.constructor.__super__._fullname.call(this))

            for own prop, func of ProtoFn.prototype when "function" is typeof func
                (pprop = ProtoFn.prototype[prop]).nom = prop
                pprop.cls = classname

            ProtoFn.prototype.declaredClass = classname
            ProtoFn.classname = classname
            return ProtoFn
        )()
    if window? then window.Class = Class
    Class
    