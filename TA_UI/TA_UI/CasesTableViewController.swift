//
//  CasesTableViewController.swift
//  
//
//  Created by King Kraul on 06/01/2017.
//
//

import UIKit


class CasesTableViewCell: UITableViewCell {
   
    @IBOutlet weak var CasesLogo: UIImageView!
    
    @IBOutlet weak var CasesHeadline: UILabel!
    
    @IBOutlet weak var CasesDescription: UILabel!
}

class CasesTableViewController: UITableViewController{

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
         do {
            let jsonCount = try jsonFile.getJSONData();
            return jsonCount.count
         }
         catch {
            print(error)
        }
        return 0
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "CasesTableViewCell", for: indexPath) as! CasesTableViewCell

       
        
        do {
            let json = try jsonFile.getJSONData();
            let item = json[indexPath.row]
            
            let usecase = item["Usecase"].string!
            if(usecase == "autounfall"){
                cell.CasesLogo.image = UIImage (named: "LogoAutounfall")
            }
            if(usecase == "zugverspätung"){
                cell.CasesLogo.image = UIImage (named: "TrainLogoOrangetoGrey")

            }
            if(usecase == "zugausfall"){
                cell.CasesLogo.image = UIImage (named: "TrainLogoOrangetoGrey")
                
            }
            
            let label = usecase + " " + item["ID"].string!
            let datum = item["Datum"].string!
            cell.CasesHeadline?.text = label
            
            
            cell.CasesDescription?.text = datum
    
        }
        catch {
            print(error)
        }
        
        return cell
        
    }
    
    //Übergibt die Id, der geklickten Cell an CasesDetailTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fallDetail", let destination = segue.destination as? CasesDetailTableViewController, let listIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.listId = listIndex;
        }
    }
    

 

}
