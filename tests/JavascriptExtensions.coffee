define [
    "dojo/main"
    "util/doh/main"
    "clazzy/JavascriptExtensions"
], (dojo, doh, ext) ->
    doh.register "clazzy.tests.JavascriptExtensions", [
        name: "Array.indexOf_CharArray_findsIndex"
        runTest: (t) ->
            originalIndexOf = Array::indexOf
            Array::indexOf = ext.Array.indexOf
            array = ["a", "b", "c"]
            index = array.indexOf("b")
            doh.assertEqual 1, index
            Array::indexOf = originalIndexOf
    ,
        name: "Array.indexOf_NumberArray_findsIndex"
        runTest: (t) ->
            originalIndexOf = Array::indexOf
            Array::indexOf = ext.Array.indexOf
            array = [1,2,3]
            index = array.indexOf(2)
            doh.assertEqual 1, index
            Array::indexOf = originalIndexOf
    ,
        name: "Array.indexOf_emptyArray_minus1"
        runTest: (t) ->
            originalIndexOf = Array::indexOf
            Array::indexOf = ext.Array.indexOf
            array = []
            index = array.indexOf(2)
            doh.assertEqual -1, index
            Array::indexOf = originalIndexOf
    ,
        name: "Array.indexOf_CharArray_findsIndexFrom"
        runTest: (t) ->
            originalIndexOf = Array::indexOf
            Array::indexOf = ext.Array.indexOf
            array = ["a", "b", "c", "b"]
            index = array.indexOf("b", 2)
            doh.assertEqual 3, index
            Array::indexOf = originalIndexOf
    ]
