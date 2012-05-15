/**
 * Boot for a new Coolstrap Application instance
 *
 * @namespace COOL
 * @class Boot
 *
 * @author Abraham Barrera <abarrerac@gmail.com> || @abraham_barrera
 */

COOL.Boot = (function(coolstrap, undefined) {
  return function() {
   
    //coolstrap.Boot.Resources.start(); //TODO: Boot resources
    coolstrap.Boot.Layout.start(); 
    coolstrap.Boot.Events.start(); 
    //coolstrap.Boot.Data.start(); //TODO: Boot data
    //coolstrap.Boot.Section.start(); //TODO: Boot sections
    //coolstrap.Boot.Article.start(); //TODO: Boot articles
    //coolstrap.Boot.Stats.start(); //TODO: Boot stats
  };

})(COOL);