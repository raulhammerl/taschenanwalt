import UIKit


class DictionaryCell: UITableViewCell{
    @IBOutlet weak var DicitonaryHeadline: UILabel!
}


class DictionaryTableViewController: UITableViewController, UISearchResultsUpdating {
    
    // Usecases anlegen
    let autounfall = UsecaseStore(name: "Autounfall", content: "Bei einem Autounfall ...")
    let zugverspaetung = UsecaseStore(name: "Zugverspätung", content: "Bei einer Zugverspätung ...")
    let zugausfall = UsecaseStore(name: "Zugausfall", content: "Bei einem Zugausfall ...")
    
    // Arrays für zu durchsuchende Elemente und gefundene Elemente anlegen
    var usecases = [UsecaseStore] ()
    var filteredUsecases = [UsecaseStore] ()
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Usecases in das Array der View laden
        usecases += [autounfall, zugverspaetung, zugausfall]
        
        // Bei Eintippen in Suchleiste wird TableView quasi durch neue TableView ersetzt (für die der ResultsController zuständig ist)
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
    
        // Suchleiste im Header einfügen
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        // Animationseinstellungen
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    
    
    // Funktion, die bei jeder Eingabe in Suchleiste aufgerufen wird
    func updateSearchResults(for searchController: UISearchController) {
        // Alle Elemente durchsuchen und Ergebnisse in Filterarray speichern
        self.filteredUsecases = self.usecases.filter { (usecase:UsecaseStore) -> Bool in
            if usecase.name.lowercased().contains(self.searchController.searchBar.text!.lowercased()) {
                return true
            } else {
                return false
            }
        }
        NSLog("filteredUseCases: \(self.filteredUsecases)")
        // TableView mit Ergebnissen updaten
        self.tableView.reloadData()
   
    }
    
    // Anzahl der Reihen in TableView festlegen
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredUsecases.count

        } else {
           return self.usecases.count
        }
    
    }
    
    // Elemente aus jeweiligem Array in jeweils eine Reihe der TableView schreiben
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DictionaryCell") as! DictionaryCell
        
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.DicitonaryHeadline?.text = self.filteredUsecases[indexPath.row].name
        } else {
            cell.DicitonaryHeadline?.text = self.usecases[indexPath.row].name
        }
        
        return cell
        
        
       /* if tableView == self.tableView {
         cell.DicitonaryHeadline?.text = self.usecases[indexPath.row].name

        } else {
            cell.DicitonaryHeadline?.text = self.filteredUsecases[indexPath.row].name
        }
        return cell*/
    }
    

    // Daten an die Detailansicht übergeben
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var path = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: path!) as! DictionaryCell
        
        
        if segue.identifier == "ShowDetails" {
            if let destination = segue.destination as? DictionaryDetailsViewController {
                
                if path != nil {
                    if (cell.DicitonaryHeadline?.text)! == "Autounfall" {
                        destination.content = autounfall.content
                    } else if (cell.DicitonaryHeadline?.text)! == "Zugverspätung" {
                        destination.content = zugverspaetung.content
                    } else {
                        destination.content = zugausfall.content
                    }
                } /*else {
                    
                    //WIESO?
                    path = resultsController.tableView.indexPathForSelectedRow
                    if (cell.DicitonaryHeadline?.text)! == "Autounfall" {
                        destination.content = autounfall.content
                    } else if (cell.DicitonaryHeadline?.text)! == "Zugverspätung" {
                        destination.content = zugverspaetung.content
                    } else {
                        destination.content = zugausfall.content
                    }
                }*/
            }
        }
    }
}
