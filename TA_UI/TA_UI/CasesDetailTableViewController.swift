//
//  CasesDetailTableViewController.swift
//  TA_UI
//
//  Created by King Kraul on 11/01/2017.
//  Copyright © 2017 Taschenanwalt. All rights reserved.
//

import Foundation
import UIKit

class CasesHeadlineTableViewCell: UITableViewCell {
    @IBOutlet weak var HeaderImage: UIImageView!
    @IBOutlet weak var HeaderDate: UILabel!
    @IBOutlet weak var HeaderTitel: UILabel!
    @IBOutlet weak var HeaderLocation: UILabel!
}

class CasesDetailDescriptionCell: UITableViewCell {
    @IBOutlet weak var DescriptionHeadline: UILabel!
    @IBOutlet weak var DescriptionText: UITextView!
}

class CasesDetailPersonCell: UITableViewCell {
    
    
    @IBOutlet weak var PersonName: UILabel!
    
    @IBOutlet weak var PersonAdresse: UILabel!
    @IBOutlet var Kennzeichen: UILabel!
    @IBOutlet var Sachschaden: UILabel!
    @IBOutlet var Verletzte: UILabel!
    @IBOutlet weak var PersonKennzeichen: UILabel!
    
   
    @IBOutlet weak var PersonTelefon: UILabel!
}

class CasesDetailTrainCell: UITableViewCell {
    @IBOutlet weak var TrainStartStation: UILabel!
    @IBOutlet weak var TrainEndStation: UILabel!
    @IBOutlet weak var TrainID: UILabel!
    @IBOutlet weak var TrainStatus: UILabel!
    @IBOutlet weak var TrainIban: UILabel!
    @IBOutlet weak var TrainName: UILabel!
    @IBOutlet weak var TrainAddress: UILabel!
}

class CasesImageCell: UITableViewCell{
    @IBOutlet weak var CasesImage1: UIImageView!
    
}

class CasesDetailAttributesCell: UITableViewCell{
    
    @IBOutlet weak var AttributesVerletzte: UILabel!
 
    @IBOutlet weak var AttributesSachschaden: UILabel!
}


class CasesDetailTableViewController: UITableViewController {
        
    var listId = Int()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController?.isNavigationBarHidden = false
        
     
        
    }
    
    
    // Daten an die Detailansicht übergeben
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let path = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: path!) as! CasesImageCell
        
        if segue.identifier == "ShowImageDetail" {
            if let destination = segue.destination as? ImageDetailView {
                destination.imageToShow = cell.CasesImage1?.image
            }
        }
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        do {
            
            let item = try jsonFile.getJSONData();
            let usecase = item[listId]["Usecase"].string!
            var anzahlRowAutounfall = 4
            
            switch (usecase){
            case "autounfall":
                if(item[listId]["Name"].string! == ""){
                    anzahlRowAutounfall -= 1
                }
                if(item[listId]["Unfallhergang"].string! == ""){
                    anzahlRowAutounfall -= 1
                }
                
                if(item[listId]["Sachschaden"].string! == "" && item[listId]["Verletzte"].string! == ""){
                    anzahlRowAutounfall -= 1
                }
                if (item[listId]["ImageFile0"].string == nil){
                    anzahlRowAutounfall -= 1
                }
                return anzahlRowAutounfall
                
            case "zugverspätung": return 3
            case "zugausfall":   return 3
            default: print ("database error"); return 0}
            
        }catch {
            print("json error: \(error)"); return 0}
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let row = indexPath.row
        
        
        do {
            
            let item = try jsonFile.getJSONData();
            let usecase = item[listId]["Usecase"].string!
            
            
            
            switch (usecase){
                
                
            case "autounfall":
                
                switch (row){
                    
                case 0 :
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CasesHeadlineTableViewCell")as! CasesHeadlineTableViewCell
                    
                    let datum = item[listId]["Datum"].string!
                    let ort = item[listId]["Stadt"].string!
                    cell.HeaderImage?.image = UIImage (named:"LogoAutounfall")
                    cell.HeaderTitel?.text = usecase.capitalized
                    cell.HeaderLocation?.text = ort
                    cell.HeaderDate?.text = datum
                    
                    return cell
                    
                case 1 :
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CasesImageCell")as! CasesImageCell
                
                    let getImageFile:FileSaveHelper = FileSaveHelper(fileName: "", fileExtension: .JPG, subDirectory: "Images",directory: .documentDirectory);
                    
                    
                    if let imagefile = item[listId]["ImageFile0"].string{
                        do {
                            print("imagefile: " + imagefile);
                            try cell.CasesImage1?.image = getImageFile.getImage(imagePath:imagefile);
                        } catch {
                            print(error)
                        }
                        
                    }
                    
                   /* if let imagefile2 = item[listId]["ImageFile1"].string{
                        do {
                            print("imagefile: " + imagefile2);
                            try cell.CasesImage2?.image = getImageFile.getImage(imagePath:imagefile2);
                        } catch {
                            print(error)
                        }
                        
                    }*/
                    
                    
                    return cell
                    
                case 2 :
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CasesDetailDescriptionCell") as! CasesDetailDescriptionCell
                    
                    let beschreibung = item[listId]["Unfallhergang"].string!
                    cell.DescriptionHeadline?.text = "Unfallhergang"
                    cell.DescriptionText?.text = beschreibung
                    
                    return cell
                    
                case 3 :
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CasesDetailPersonCell") as! CasesDetailPersonCell
                    
                    
                    
                    let name = item[listId]["Name"].string!
                    let adresse = item[listId]["Adresse"].string!
                    let telefon = item[listId]["Telefonnummer"].string!
                    let kennzeichen = item[listId]["Kennzeichen"].string!
                    let verletzte = item[listId]["Verletzte"].string!
                    let sachschaden = item[listId]["Sachschaden"].string!
                    
                    
                    
                    //cell.PersonHeadline?.text = "Beteiligter"
                    cell.PersonName?.text = name
                    cell.PersonAdresse?.text = adresse
                    cell.PersonTelefon?.text = telefon
                    cell.PersonKennzeichen?.text = kennzeichen
                    cell.Verletzte?.text = verletzte
                    cell.Sachschaden?.text = sachschaden
                    
                    
                    return cell
                    
                    /*case 4:
                     
                     //Zelle auf Sachschaden Verletzte anpassen
                     let cell = tableView.dequeueReusableCell(withIdentifier: "CasesDetailPersonCell") as! CasesDetailPersonCell
                     
                     // let verletzte = item[listId]["Verletzte"].string!
                     
                     return cell*/
                    
                    
                default: print("presentation error")
                let cell = tableView.dequeueReusableCell(withIdentifier: "CasesDetailTrainCell")as! CasesDetailTrainCell
                return cell
                }
                
                
                
                
            case "zugausfall", "zugverspätung":
                
                switch (row){
                    
                case 0 :
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CasesHeadlineTableViewCell")as! CasesHeadlineTableViewCell
                    let datum = item[listId]["Datum"].string!
                    cell.HeaderImage?.image = UIImage (named:"TrainLogoOrangetoGrey")
                    
                    cell.HeaderTitel?.text = usecase.capitalized
                
                    cell.HeaderDate?.text = datum
                    
                    return cell
                    
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CasesImageCell")as! CasesImageCell
                   
                    let fallNummerImage = String(listId);
                    let getImageFile:FileSaveHelper = FileSaveHelper(fileName: fallNummerImage + "0", fileExtension: .JPG, subDirectory: "Images",directory: .documentDirectory);
                    
                    if let imagefile = item[listId]["ImageFile0"].string{
                        do {
                            try cell.CasesImage1?.image = getImageFile.getImage(imagePath:imagefile);
                        } catch {
                            print(error)
                        }
                        
                    }
                   /* if let imagefile2 = item[listId]["ImageFile1"].string{
                        do {
                            print("imagefile: " + imagefile2);
                            try cell.CasesImage2?.image = getImageFile.getImage(imagePath:imagefile2);
                        } catch {
                            print(error)
                        }
                        
                    } */
                    
                    
                    return cell
                case 2:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CasesDetailTrainCell")as! CasesDetailTrainCell
                    
                    let name = item[listId]["Name"].string!
                    let adresse = item[listId]["Adresse"].string!
                    let bankverbindung = item[listId]["Bankverbindung"].string!
                    let startbahnhof = item[listId]["Startbahnhof"].string!
                    let zielbahnhof = item[listId]["Zielbahnhof"].string!
                    let zugid = item[listId]["ZugID"].string!

                    
                    cell.TrainName?.text = name
                    cell.TrainAddress?.text = adresse
                    cell.TrainIban?.text = bankverbindung
                    cell.TrainStartStation?.text = startbahnhof
                    cell.TrainEndStation?.text = zielbahnhof
                    cell.TrainID?.text = zugid
                    cell.TrainStatus?.text = "ausgefallen"
                    
                    return cell
                    
                    
                    
                default: print("presentation error")
                //CHANGE
                let cell = tableView.dequeueReusableCell(withIdentifier: "CasesDetailTrainCell")as! CasesDetailTrainCell
                return cell
                }
                
            default: print("presentation error no usecase")
            
            //CHANGE
            let cell = tableView.dequeueReusableCell(withIdentifier: "CasesDetailTrainCell")as! CasesDetailTrainCell
            return cell
            }
            
            
            
            
        }catch {
            print("json error: \(error)")
            let cell = tableView.dequeueReusableCell(withIdentifier: "CasesDetailTrainCell")as! CasesDetailTrainCell
            return cell}
    }
}


