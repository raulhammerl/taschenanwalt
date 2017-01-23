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
    @IBOutlet weak var PersonHeadline: UILabel!

    @IBOutlet weak var PersonName: UILabel!
    @IBOutlet weak var PersonAdresse: UILabel!
    @IBOutlet weak var PersonTelefon: UILabel!

    @IBOutlet var Kennzeichen: UILabel!

}




class CasesDetailTableViewController: UITableViewController {
    
    
    var listId = Int()
    
    override func viewWillAppear(_ animated: Bool) {
//        self.tableView.separatorStyle = .none
        self.view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       
        var flag = indexPath.row
        
        print(listId);
        
        switch (flag){
                
            case 0 :
                  let cell = tableView.dequeueReusableCell(withIdentifier: "CasesHeadlineTableViewCell")as! CasesHeadlineTableViewCell
                do {
                    
                    let item = try jsonFile.getJSONData();
                    
                    let usecase = item[listId]["Usecase"].string!
                    let datum = item[listId]["Datum"].string!
                    let ort = item[listId]["Location"].string!
                    if(usecase == "autounfall"){
                        cell.HeaderImage?.image = UIImage (named:"LogoAutounfall")
                    }
                    if(usecase == "zugverspätung"){
                        cell.HeaderImage?.image = UIImage (named:"TrainLogoOrangetoGrey")
                    }
                    
                    
                    cell.HeaderTitel?.text = usecase
                    cell.HeaderLocation?.text = ort
                    cell.HeaderDate?.text = datum
                    
                }
                catch {
                    print(error)
                }
            
            return cell
            
            
            case 1 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "CasesDetailDescriptionCell") as! CasesDetailDescriptionCell

                cell.DescriptionHeadline?.text = "Beschreibung"
                cell.DescriptionText?.text = "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim.Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim"
                
               
        
            return cell
            
        case 2 :
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CasesDetailPersonCell") as! CasesDetailPersonCell
            
            do {
                
                let item = try jsonFile.getJSONData();
                
               let name = item[listId]["Name"].string!
                if(name != ""){
                
                let adresse = item[listId]["Adresse"].string!
                let telefon = item[listId]["Telefonnummer"].string!
                let kennzeichen = item[listId]["Kennzeichen"].string!
                
                cell.PersonHeadline?.text = "Beteiligter"
                cell.PersonName?.text = name
                cell.PersonAdresse?.text = adresse
                cell.PersonTelefon?.text = telefon
                cell.Kennzeichen?.text = kennzeichen
                }else{
                    cell.PersonName?.text = "Es war keine andere Person am Autounfall beteiligt oder der Besitzer war innerhalb von 30 Minuten nicht auffindbar. Du hast womöglich einen Zettel mit deinen Daten hinterlassen und die Polizei informiert."

                }
                
            }
            catch {
                print(error)
            }

            
           
            return cell
            
        default: print("error"); let cell = tableView.dequeueReusableCell(withIdentifier: "CasesHeadlineTableViewCell", for: indexPath) as! CasesHeadlineTableViewCell; return cell; break
        }
    }
    
    
}
