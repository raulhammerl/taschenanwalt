

import Foundation
import UIKit


class Faelle{
    
    var identi: Int;
    
    //Welcher Fall, zB Autounfall, Zugverspätung
    //var art: String;

    //Daten von
    var vorname:String;
    /*var nachname: String;
    var strasse: String;
    var hausnummer: String;
    var plz: String;*/
    var wohnort: String;
   // var telefonnr: String;
   // var kennzeichen: String;
    
    
    var datum: String;
    //var Unfallort: String;

    /*var unfallHergang: String;
    
    var verletzte: Bool;
    var sachschaden: Bool;
    var autobahn: Bool;
    var alkohol: Bool;
    var ausland: Bool;*/
    
    init(vorname:String, wohnort:String, identi: Int, datum: String){
        self.vorname = vorname;
        self.wohnort = wohnort;
        self.identi = identi;
        self.datum = datum;
        
        
        // This is the call to the designated init.
        // defaulting to the Document directory. You can set this up to be any directory you want, or you can create convenience inits for both directories, if you want.
    }
 
    
    
    
}




/*class Object {
    var id: Int = 1
}
class Animal: Object {
    var weight: Double = 2.5
    var age: Int = 2
    var name: String? = "An animal"
}
class Cat: Animal {
    var fur: Bool = true
}*/
