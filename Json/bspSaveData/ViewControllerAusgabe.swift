//
//  ViewControllerAusgabe.swift
//  bspSaveData
//
//  Created by Maria Bittl on 08.01.17.
//  Copyright © 2017 Maria Bittl. All rights reserved.
//

import UIKit

class ViewControllerAusgabe: UIViewController {
    @IBOutlet var bild: UIImageView!
    @IBOutlet var text: UITextField!
    @IBOutlet var text1: UITextField!
    @IBOutlet var text2: UITextField!
    @IBOutlet weak var label: UILabel!
    var uebergabe1:String = "";
    var uebergabe2:String = "";

    override func viewDidLoad() {
        super.viewDidLoad()

        //text.text = uebergabe1;
        //text1.text = uebergabe2;
        
        let object1:Autounfall = Autounfall();
        object1.name = uebergabe1;
        object1.vorname = uebergabe2;
        print(object1.name);
        print(object1.vorname);
        
        
               // text.text = "Hallo";
        /* let name: String = text.text!;
         //let name = "Maria";
         let vorname = "Bittl";
         let strasse = "Ringstrasse";
         let hausnummer = "8";
         let plz = "85132";
         let wohnort = "Schönau";
         let telefonnummer = "14234034720";*/
        
        //Create a dictionary with data for converting to JSON. This could be data retrieved from the web or a dictionary created in the app.
        /* let jsonDict = [["name":name, "vorname":vorname, "strasse":strasse, "hausnummer":hausnummer, "plz":plz, "wohnort":wohnort, "telefonnummer":telefonnummer],  ["Platform":"ddd", "Favorite Food":"bla!"],  ["Language":name, "Platform":"ddd", "Favorite Food":"bla!"],  ["Language":name, "Platform":"ddd", "Favorite Food":"bla!"]];*/
        
        /*  var jsonDict = [String]()
         for i in 0 ..< 100 {
         jsonDict.append("Test\(i)")
         }*/
        
        //Array mit Daten aus Chat
        /*var jsonDict = [String]();
         jsonDict.append(text.text!);*/
        //    var jsonDict: Dictionary<String,String>;
       
       
        
        //Dictionary mit Daten aus Chat
        let jsonDict = ["First" : object1.name , "Second" : object1.vorname];
        //jsonDict["Name"] =  object1.name;
        //jsonDict["Vorname"] = object1.vorname;
       // jsonDict["Strasse"] = "Add";
       // jsonDict["Hausnummer"] = "Add";
       // jsonDict["PLZ"] = "Add";
       // jsonDict["Wohnort"] = "Add";
       // jsonDict["Fifth"] = "Add";
       
        //Create the jsonFile object.
        let jsonFile:FileSaveHelper = FileSaveHelper(fileName:"jsonFile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
        
        
        //Try to save the file. If there are any errors, print them out.
        do {
            try jsonFile.saveFile(dataForJson: jsonDict as AnyObject)
        }
        catch {
            print(error)
        }
        
        
        //Print out whether the file exists.
        print("JSON file exists: \(jsonFile.fileExists)")
        
        
        
       /* // Create the instance of FileSaveHelper using one of our convenience inits. We don’t specify the directory here so it will default to the Document directory.
        let imageToSave = FileSaveHelper(fileName: "aRandomDog", fileExtension: .JPG, subDirectory: "Dogs")
        
        //We have to use a do-try-catch because our saveFile method throws.
        do {
            // want to make sure the app doesn’t crash so I’m using a guard statement. In this instance, it’s a little overkill because I know the image exists, but if you were downloading one from the internet it is a good idea to use.
            guard let image = UIImage(named: "dog") else {
                print("Error getting image")
                return
            }
            // Now we save our file using the try keyword and our saveFile(imageFile:) method.
            try imageToSave.saveFileImage(image: image)
        }
            //If there is an error, we will print it to the console window.
        catch {
            print(error)
        }
        
        
        //Bild aus  File ausgeben
        do {
            print(try imageToSave.getImage())
            try bild.image = imageToSave.getImage()
        } catch {
            print(error)
        }*/
        // Daten aus Json File ausgeben
        
        
       
      
        
        
        
      do {
         print(try jsonFile.getJSONData())
        //print(jsonFile.items[0]);
        var item1 = jsonFile.items[0];
        print(item1["First"]);
        
        text1.text = item1["First"] as! String?;
        
        let personArray = try jsonFile.getJSONData().value(forKey: "Second");
        text.text = personArray as! String?;
        
        // text.text = item["name"] as? String
        // text1.text = item1["Name"] as? String
         //text2.text = item["Vorname"] as? String
         //text.text = item as? AnyObject
         //jsonFile.getJSONData().description;
         } catch {
         print(error)
         }
        
        
        
    }

    
   /* override func viewWillAppear(_ animated: Bool) {
        
        
          let jsonDict = ["First" : "Maria", "Second" : "Bittl"];
        //Create the jsonFile object.
        let jsonFile:FileSaveHelper = FileSaveHelper(fileName:"jsonFile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
        
        
        //Try to save the file. If there are any errors, print them out.
        do {
            try jsonFile.saveFile(dataForJson: jsonDict as AnyObject)
        }
        catch {
            print(error)
        }
        

    }*/
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
