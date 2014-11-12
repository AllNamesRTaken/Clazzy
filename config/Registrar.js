(function() {

  define(["clazzy/IoC", "clazzy/namelocators/TemplateNameLocator", "clazzy/TemplateRegistry", "dojo/cache", "dojo/_base/url"], function(ioc, templateNameLocator, templateRegistry, cache, url) {
    var Registrar, _REGULAR, _SINGELTON;
    _SINGELTON = true;
    _REGULAR = false;
    Registrar = {
      registerTemplate: function(templateid, classname, templatestring, config) {
        templateNameLocator.register(templateid, classname, config);
        return templateRegistry.register(templateid, templatestring, config);
      },
      registerClass: function(interfacename, classname, singelton, config) {
        return ioc.register(interfacename, classname, singelton, config);
      }
    };
    Registrar.registerClass("IMyNormalClass", "some.path.MyClass", _REGULAR);
    Registrar.registerTemplate("TMyNormalClass", "some.path.MyClass", cache(new _url("some/url/template.html")));
    Registrar.registerClass("IMySingletonClass", "some.path.MyOtherClass", _REGULAR);
    Registrar.registerTemplate("TMySingletonClass", "some.path.MyOtherClass", cache(new _url("some/other/url/template.html")));
    return Registrar;
  });

}).call(this);
