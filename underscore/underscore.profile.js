var profile = (function ()
{
    var copyOnly = function (filename, mid)
    {
        return minifiedFile.test(filename);
    };

    var jsFile = /\.js$/;
    var templateFile = /\/templates\//;
    var cssFile = /\.css$/;
    var htmlFile = /\.html$/;
    var imgFile = /\.png$/;
    var testFile = /\/tests\//;
    var mockFile = /\/mock\//;
    var minifiedFile = /\-min.js$/;
    // Resource tags are functions that provide hints to the compiler about a given file. The first argument is the
    // filename of the file, and the second argument is the module ID for the file.
    return {
        resourceTags: {
            // Files that contain test code.

            // Files that should be copied as-is without being modified by the build system.
            copyOnly: function (filename, mid)
            {
                return copyOnly(filename, mid);
            },

            ignore: function (filename, mid)
            {
                return minifiedFile.test(filename)
            }
        },
        trees: [
            [".", ".", /(\/\.)|(~$)/]
        ]
    };
} ());