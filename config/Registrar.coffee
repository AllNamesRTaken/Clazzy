define [
    "clazzy/namelocators/DtoNameLocator"
    "clazzy/IoC"
    "clazzy/namelocators/RestUrlNameLocator"
    "clazzy/namelocators/TemplateNameLocator"
    "clazzy/TemplateRegistry"
    "dojo/cache"
    "dojo/_base/url"
], (dtoNameLocator, ioc, restUrlNameLocator, templateNameLocator, templateRegistry, cache, url) -> 
    _SINGELTON = true
    _REGULAR = false    

    Registrar = 
        registerTemplate: (templateid, classname, templatestring, config) ->
            templateNameLocator.register templateid, classname, config
            templateRegistry.register templateid, templatestring, config
        
        registerClass: (interfacename, classname, singelton, dtoname, resturl, config) ->
            ioc.register interfacename, classname, singelton, config
            dtoNameLocator.register dtoname, classname, config if dtoname?
            restUrlNameLocator.register resturl, classname, config if resturl?

#
# Core registration
#
# Server side glue
    dtoNameLocator.register "_List", "System.Collections.Generic.List`1[[WI4Lab.Dto.Objects.Controls.WiControlDto, WI4Lab]], mscorlib"

# Core services
    Registrar.registerClass "IDtoNameLocator", "clazzy.namelocators.DtoNameLocator", _SINGELTON
    Registrar.registerClass "IRestUrlNameLocator", "clazzy.namelocators.RestUrlNameLocator", _SINGELTON
    Registrar.registerClass "IInterfaceNameLocator", "clazzy.namelocators.InterfaceNameLocator", _SINGELTON
    Registrar.registerClass "IIoC", "clazzy.IoC", _SINGELTON

# Core lib
    Registrar.registerClass "IAutoMapper", "clazzy.lib.AutoMapper", _SINGELTON
    Registrar.registerClass "IAutoMapperConfig", "clazzy.config.AutoMapperConfig", _SINGELTON
    Registrar.registerClass "ICrudService", "clazzy.mock.RestService", _SINGELTON
    Registrar.registerClass "ISerializer", "clazzy.lib.JsonSerializer", _SINGELTON
    Registrar.registerClass "IPopulator", "clazzy.lib.Populator", _SINGELTON
    Registrar.registerClass "IRefresher", "clazzy.lib.Refresher", _SINGELTON

#
# Services registration
#
    Registrar.registerClass "IUpdater", "clazzy.services.Updater", _SINGELTON
    Registrar.registerClass "ICreator", "clazzy.services.Creator", _SINGELTON
    Registrar.registerClass "IRenderer", "clazzy.services.Renderer", _SINGELTON

#
# Module registration
#
    Registrar.registerClass "IBaseContainer", "clazzy.basemodules.BaseContainer", _REGULAR

    Registrar.registerClass "IPage", "clazzy.examplemodule.Page.main", _REGULAR, "PageDtoName", "/Page"
    Registrar.registerTemplate "TPage", "clazzy.examplemodule.Page.main", cache new _url("clazzy/examplemodule/page/templates/Page.html")

    Registrar.registerClass "IText", "clazzy.examplemodule.Text.main", _REGULAR, "TextDtoName"
    Registrar.registerTemplate "TText", "clazzy.examplemodule.Text.main", cache new _url("clazzy/examplemodule/text/templates/Text.html")
    
    Registrar
