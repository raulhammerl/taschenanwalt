 //
//  CasesTableViewController.swift
//  
//
//  Created by King Kraul on 06/01/2017.
//
//

import UIKit


class CasesTableViewCell: UITableViewCell {
   
   
    
    @IBOutlet weak var CasesHeadline: UILabel!
    
    @IBOutlet weak var CasesDescription: UILabel!
}

class CasesTableViewController: UITableViewController{

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
         do {
            let jsonCount = try jsonFile.getJSONData();
            return jsonCount.count
         }
         catch {
            print(error)
        }
        EmptyMessage(message: "Es gibt noch keine alten Fälle.", viewController: self)
        return 0
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "CasesTableViewCell", for: indexPath) as! CasesTableViewCell

       
        
        do {
            let json = try jsonFile.getJSONData();
            let item = json[indexPath.row]
            
            let usecase = item["Usecase"].string!
            
            let label = usecase.capitalized
            let datum = item["Datum"].string!
            cell.CasesHeadline?.text = label
            cell.CasesDescription?.text = "am " + datum
    
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
    
    
    //Wenn noch kein Eintrag in alte Fälle vorhanden ist
    func EmptyMessage(message:String, viewController:UITableViewController) {
        let messageLabel = UILabel(frame: CGRectMake(0,0,viewController.view.bounds.size.width, viewController.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        viewController.tableView.backgroundView = messageLabel;
        viewController.tableView.separatorStyle = .none;
    }
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }

 

}
 
