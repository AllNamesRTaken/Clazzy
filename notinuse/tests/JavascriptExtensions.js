(function() {

  define(["dojo/main", "util/doh/main", "clazzy/JavascriptExtensions"], function(dojo, doh, ext) {
    return doh.register("clazzy.tests.JavascriptExtensions", [
      {
        name: "Array.indexOf_CharArray_findsIndex",
        runTest: function(t) {
          var array, index, originalIndexOf;
          originalIndexOf = Array.prototype.indexOf;
          Array.prototype.indexOf = ext.Array.indexOf;
          array = ["a", "b", "c"];
          index = array.indexOf("b");
          doh.assertEqual(1, index);
          return Array.prototype.indexOf = originalIndexOf;
        }
      }, {
        name: "Array.indexOf_NumberArray_findsIndex",
        runTest: function(t) {
          var array, index, originalIndexOf;
          originalIndexOf = Array.prototype.indexOf;
          Array.prototype.indexOf = ext.Array.indexOf;
          array = [1, 2, 3];
          index = array.indexOf(2);
          doh.assertEqual(1, index);
          return Array.prototype.indexOf = originalIndexOf;
        }
      }, {
        name: "Array.indexOf_emptyArray_minus1",
        runTest: function(t) {
          var array, index, originalIndexOf;
          originalIndexOf = Array.prototype.indexOf;
          Array.prototype.indexOf = ext.Array.indexOf;
          array = [];
          index = array.indexOf(2);
          doh.assertEqual(-1, index);
          return Array.prototype.indexOf = originalIndexOf;
        }
      }, {
        name: "Array.indexOf_CharArray_findsIndexFrom",
        runTest: function(t) {
          var array, index, originalIndexOf;
          originalIndexOf = Array.prototype.indexOf;
          Array.prototype.indexOf = ext.Array.indexOf;
          array = ["a", "b", "c", "b"];
          index = array.indexOf("b", 2);
          doh.assertEqual(3, index);
          return Array.prototype.indexOf = originalIndexOf;
        }
      }
    ]);
  });

}).call(this);
