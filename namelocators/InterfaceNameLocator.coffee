define [
    "clazzy/namelocators/NameLocator"
], (NameLocator) ->
    'use strict'

    namelocator = new NameLocator()
    InterfaceNameLocator = 
        getConfig: () -> 
            namelocator.config
        
        setConfigTo: (configname) ->
            namelocator.setConfigTo configname

        register: (interfaceName, className, config) ->
            namelocator.register interfaceName, className, config

        findInterface: (className) ->
            namelocator.findSource className

        findClass: (interfaceName) ->
            namelocator.findTarget interfaceName
        
        hasClass: (interfaceName) ->
            namelocator.hasTarget interfaceName

        clear: (all) -> 
            namelocator.clear all
