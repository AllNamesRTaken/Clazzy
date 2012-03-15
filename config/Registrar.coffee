define [
    "clazzy/IoC"
    "clazzy/namelocators/TemplateNameLocator"
    "clazzy/TemplateRegistry"
    "dojo/cache"
    "dojo/_base/url"
], (ioc, templateNameLocator, templateRegistry, cache, url) -> 
    _SINGELTON = true
    _REGULAR = false    

    Registrar = 
        registerTemplate: (templateid, classname, templatestring, config) ->
            templateNameLocator.register templateid, classname, config
            templateRegistry.register templateid, templatestring, config
        
        registerClass: (interfacename, classname, singelton, config) ->
            ioc.register interfacename, classname, singelton, config

#
# Registration
#
    Registrar.registerClass "IMyNormalClass", "some.path.MyClass", _REGULAR
    Registrar.registerTemplate "TMyNormalClass", "some.path.MyClass", cache new _url("some/url/template.html")

    Registrar.registerClass "IMySingletonClass", "some.path.MyOtherClass", _REGULAR
    Registrar.registerTemplate "TMySingletonClass", "some.path.MyOtherClass", cache new _url("some/other/url/template.html")
    
    Registrar
