// Generated by CoffeeScript 1.8.0
(function() {
  define(["clazzy/namelocators/NameLocator"], function(NameLocator) {
    'use strict';
    var InterfaceNameLocator, namelocator;
    namelocator = new NameLocator();
    return InterfaceNameLocator = {
      getConfig: function() {
        return namelocator.config;
      },
      setConfigTo: function(configname) {
        return namelocator.setConfigTo(configname);
      },
      register: function(interfaceName, className, config) {
        return namelocator.register(interfaceName, className, config);
      },
      findInterface: function(className) {
        return namelocator.findSource(className);
      },
      findClass: function(interfaceName) {
        return namelocator.findTarget(interfaceName);
      },
      hasClass: function(interfaceName) {
        return namelocator.hasTarget(interfaceName);
      },
      clear: function(all) {
        return namelocator.clear(all);
      }
    };
  });

}).call(this);

//# sourceMappingURL=InterfaceNameLocator.js.map