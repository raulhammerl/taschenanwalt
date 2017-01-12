

import Foundation
import UIKit

struct Faelle {
    
    var wohnort: String;
    var vorname:String;
    
    init(vorname:String, wohnort:String){
        self.vorname = vorname;
        self.wohnort = wohnort;
        // This is the call to the designated init.
        // defaulting to the Document directory. You can set this up to be any directory you want, or you can create convenience inits for both directories, if you want.
    }
 
    
    
    
}
