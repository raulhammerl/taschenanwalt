

import Foundation
import UIKit


class Faelle{
    
    var wohnort: String;
    var vorname:String;
    var identi: Int;
    
    init(vorname:String, wohnort:String, identi: Int){
        self.vorname = vorname;
        self.wohnort = wohnort;
        self.identi = identi;
        
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
