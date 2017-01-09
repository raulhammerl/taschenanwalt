//
//  Autounfall.swift
//  bspSaveData
//
//  Created by Maria Bittl on 08.01.17.
//  Copyright © 2017 Maria Bittl. All rights reserved.
//

import Foundation
import UIKit

class Autounfall: NSObject {
        
        var name: String
        var vorname: String
        var strasse: String
        var hausnummer: String
        var plz: String
        var wohnort: String
        var telefonnummer: String
        
        var besitzerAnwesend: Bool?;
        //if(besitzerAnwesenda == true)
        var anwesendName: String?;
        var anwesendVorname: String?;
        var anwesendStrasse: String?;
        var anwesendHausnummer: Int?;
        var anwesendPlz: Int?;
        var anwesendWohnort: String?;
        var anwesendTelefonnummer: String?;
        
        
        var verletzte: Bool?;
        var sachschaden: Bool?;
        var alkohol: Bool?;
        var autobahn: Bool?;
        var beteiligteAusland: Bool?;
        
        //GPS-Daten, Foto, Datum
        //var bilder = [Bilder](); // Bild wie speichern, wegen JSON
        var aktuellesDatum: String?;
        //let AktuellesDatum = NSDate()
        var longitude: Double?;
        var latitude: Double?;
        
        var anderePersonBeteiligt : Bool?;
        //if(anderePersonBeteiligt == true)
        var beteiligterName: String?;
        var beteiligterVorname: String?;
        var beteiligterStrasse: String?;
        var beteiligterHausnummer: Int?;
        var beteiligterPlz: Int?;
        var beteiligterWohnort: String?;
        var beteiligterTelefonnummer: String?;
        var beteiligterKennzeichen: String?;
        
        var zeugenAnwesend: Bool?;
        //if(zeugenAnwesend == true) Zeugen Klasse
        
        
        // Unterschrift??
        
        // Unfallhergang: laengere Text
        var unfallhergang: String?;
        
        //init () {} //default initializer
        //parameterized initializer
         override init(){
            name = "";
            vorname = "";
            strasse = "";
            hausnummer = "";
            plz = "";
            wohnort = "";
            telefonnummer = "";
        }
        
        
        
        
    

    
}
