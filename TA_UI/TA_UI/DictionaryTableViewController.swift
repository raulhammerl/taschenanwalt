import UIKit

class DictionaryTableViewController: UITableViewController, UISearchResultsUpdating {
    
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
        
        // Daten in die Tabelle laden
        loadSampleUsecases()
        
        // Bei Eintippen in Suchleiste wird TableView quasi durch neue TableView ersetzt (für die der ResultsController zuständig ist)
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        
        // Resultscontroller mitteilen, wo er nach den Daten schauen soll
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        // Suchleiste im Header einfügen
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        // Zuständig für Update der Ergebnisse nach Eingabe in Suchleiste
        self.searchController.searchResultsUpdater = self
        
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
        // TableView mit Ergebnissen updaten
        self.resultsController.tableView.reloadData()
        self.resultsController.tableView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    }
    
    // Anzahl der Reihen in TableView festlegen
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return self.usecases.count
        } else {
            return self.filteredUsecases.count
        }
    }
    
    // Elemente aus jeweiligem Array in jeweils eine Reihe der TableView schreiben
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        if tableView == self.tableView {
            cell.textLabel?.text = self.usecases[indexPath.row].name
        } else {
            cell.textLabel?.text = self.filteredUsecases[indexPath.row].name
        }
        return cell
    }
    
    // Funktion, die bei Klick auf einen Usecase aufgerufen wird
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Zur Detailansicht wechseln
        self.performSegue(withIdentifier: "ShowDetails", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     // Daten an die Detailansicht übergeben
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            if let destination = segue.destination as? DictionaryDetailsViewController {
                let path = tableView.indexPathForSelectedRow
                if tableView == self.tableView {
                    destination.content = self.usecases[(path?.row)!].content
                } else {
     
                }
            }
        }
     }*/
    
    // Inhalte laden
    private func loadSampleUsecases() {
        let autounfall = UsecaseStore(name: "Autounfall", content: "Bei einem Autounfall ...")
        let zugverspaetung = UsecaseStore(name: "Zugverspätung", content: "Bei einer Zugverspätung ...")
        let zugausfall = UsecaseStore(name: "Zugausfall", content: "Bei einem Zugausfall ...")
        usecases += [autounfall, zugverspaetung, zugausfall]
    }
}
