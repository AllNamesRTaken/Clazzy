define [
    "dojo/main" 
    "util/doh/main" 
    "clazzy/abstraction/Lang" 
    "dojo/cache"
    "dojo/_base/url"
    "clazzy/Exception"
    "clazzy/Deferred"
    "clazzy/Clazzy"
], (dojo, doh, lang, cache, _url, Exception, Deferred, Class) ->

    doh.register "clazzy.tests.abstraction.Lang", [
        name: "clone_objectWithObjectWithArrayInsideArray_areEqual"
        setUp: () ->
            #Arrange
            @testObject = {a:{b:[[true,true],[false,false]]}}
        runTest: (t) -> 
            #Act
            clone = lang.clone @testObject
            #Assert
            doh.assertEqual @testObject, clone
    ,
        name: "hitch_contextAndFunction_hitchedFunctionRunsSetContext"
        setUp: () ->
            #Arrange
            @context = {}
            @hitch = lang.hitch @context, () -> return this
        runTest: (t) ->
            #Act
            context = @hitch()
            #Assert
            doh.assertEqual @context, context
    ,
        name: "hitch_nullContextAndFunction_hitchedFunctionRunsThisContext"
        setUp: () ->
            #Arrange
            @context = null
            @hitch = lang.hitch @context, () -> return this
        runTest: (t) ->
            #Act
            context = @hitch()
            #Assert
            doh.assertEqual this, context
    ,
        name: "mixin_2nonOverlappingObjects_objectWithAllPropsFromBoth"
        setUp: () ->
            #Arrage
            @a = {p1:1, p2:2}
            @b = {p3:3, p4:4}
        runTest: (t) ->
            #Act
            c = lang.mixin(@a, @b)
            #Assert
            doh.assertTrue c.p1 and c.p2 and c.p3 and c.p4
    ,
        name: "mixin_2OverlappingObjects_overlappingPropTakenFromSecondObject"
        setUp: () ->
            #Arrage
            @a = {p1:1, p2:2}
            @b = {p2:3, p3:4}
        runTest: (t) ->
            #Act
            c = lang.mixin(@a, @b)
            #Assert
            doh.assertEqual c.p2, @b.p2
    ,
        name: "mixin_objectAndNull_shallowCloneOfObject"
        setUp: () ->
            #Arrage
            @a = {p3:3, p4:{p5:5}}
            @b = null
        runTest: (t) ->
            #Act
            c = lang.mixin(@a, @b)
            #Assert
            doh.assertEqual c, @a
            doh.assertTrue c.p4.p5 is @a.p4.p5
    ,
        name: "mixin_nullAndObject_shallowCloneOfObject"
        setUp: () ->
            #Arrage
            @a = null
            @b = {p3:3, p4:{p5:5}}
        runTest: (t) ->
            #Act
            c = lang.mixin(@a, @b)
            #Assert
            doh.assertEqual c, @b
            doh.assertTrue c.p4.p5 is @b.p4.p5
    ,
        name: "cache_url_correctString"
        setUp: () ->
            #Arrange
            @url = "../../clazzy/tests/abstraction/resources/dummy.txt"
            @content = "dummy"
        runTest: (t) -> 
            #Act
            url = cache new _url @url
            #Assert
            doh.assertEqual @content, url
    ,
        name: "filter_arrayAndEvenFunction_correctFilteredArray"
        setUp: () ->
            #Arrange
            @array = ['a','b','c','d']
            @target = ['a','c']
            @filter = (el, i) -> 0 is i%2
        runTest: (t) -> 
            #Act
            array = lang.filter @array, @filter
            #Assert
            doh.assertEqual @target, array
    ,
        name: "filter_emptyArrayAndEvenFunction_emptyArray"
        setUp: () ->
            #Arrange
            @array = []
            @target = []
            @filter = (el, i) -> 0 is i%2
        runTest: (t) -> 
            #Act
            array = lang.filter @array, @filter
            #Assert
            doh.assertEqual @target, array
    ,
        name: "filter_nullAndEvenFunction_emptyArray"
        setUp: () ->
            #Arrange
            @array = null
            @target = []
            @filter = (el, i) -> 0 is i%2
        runTest: (t) -> 
            #Act
            array = lang.filter @array, @filter
            #Assert
            doh.assertEqual @target, array
    ,
        name: "isArray_array_true"
        setUp: () ->
            #Arrange
            @array = []
        runTest: (t) -> 
            #Act
            isArray = lang.isArray @array
            #Assert
            doh.assertTrue isArray
    ,
        name: "isArray_null_false"
        setUp: () ->
            #Arrange
            @array = null
        runTest: (t) -> 
            #Act
            isArray = lang.isArray @array
            #Assert
            doh.assertFalse isArray
    ,
        name: "isFunction_function_true"
        setUp: () ->
            #Arrange
            @func = () -> null
        runTest: (t) -> 
            #Act
            isFunc = lang.isFunction @func
            #Assert
            doh.assertTrue isFunc
    ,
        name: "isFunction_null_false"
        setUp: () ->
            #Arrange
            @func = null
        runTest: (t) -> 
            #Act
            isFunc = lang.isFunction @func
            #Assert
            doh.assertFalse isFunc
    ]
