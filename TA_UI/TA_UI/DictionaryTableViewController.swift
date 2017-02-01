import UIKit


class DictionaryCell: UITableViewCell{
    @IBOutlet weak var DicitonaryHeadline: UILabel!
    
}


class DictionaryTableViewController: UITableViewController, UISearchResultsUpdating {
    
    // Usecases anlegen
    let autounfall = UsecaseStore(name: "Autounfall", content: "Das richtige Vorgehen bei einem Autounfall hängt von der Art des Unfalls ab. Wurde beispielsweise nur ein parkendes Auto angefahren, ist es nicht nötig, die Unfallstelle zu sichern oder den Notruf zu wählen. Jedoch muss mindestens 30 Minuten am Auto auf den Besitzer gewartet werden. Falls dieser nicht auftaucht, sollte der Unfall bei der Polizei gemeldet und ein Zettel mit den eigenen Daten am Auto hinterlassen werden. Falls an dem Unfall hingegen ein anderer aktiver Verkehrsteilnehmer (z.B. ein anderer Autofahrer, ein Fahrradfahrer oder ein Fußgänger) beteiligt war, muss zuerst die Unfallstelle gesichert werden. Dafür muss die Warnblinkanlage eingeschaltet, die Warnweste angezogen und das Warndreieck aufgestellt werden. Falls es Verletzte oder Tote gibt, muss sofort der Notruf verständigt und Erste Hilfe geleistet werden. Außerdem ist die Polizei zu verständigen. Die Polizei muss ebenfalls verständigt werden, wenn erheblicher Sachschaden entstanden ist, einer der Beteiligten unter Alkohol- oder Drogeneinfluss steht, der Unfall auf der Autobahn stattgefunden hat oder einer der Beteiligten aus dem Ausland kommt bzw. ein im Ausland zugelassenes Auto fährt. Die Polizei übernimmt dann alle weiteren Schritte. Wenn es nicht nötig ist die Polizei zu rufen, sollten auf jeden Fall Beweisfotos der Situation und des Schadens gemacht werden. Außerdem sollte der Unfall möglichst genau dokumentiert werden, indem Datum, Uhrzeit, Location, evtl. Informationen zum Unfallhergang sowie Name, Anschrift, Telefonnummer und Autokennzeichen des beteiligten Verkehrsteilnehmers notiert werden. Anschließend sollte die Unfallstelle so schnell wie möglich geräumt werden. Das Dokument mit allen Informationen muss dann innerhalb von einer Woche bzw. innerhalb von 48 Stunden bei tödlichem Ausgang bei der Versicherung eingereicht werden.")
    
    let zugverspaetung = UsecaseStore(name: "Zugverspätung", content: "Bei einer Zugverspätung hängt es von der Dauer der Verspätung ab, ob man Anspruch auf eine Erstattung hat oder nicht. In der Regel wird für eine Verspätung unter 60 Minuten kein Geld erstattet, während für eine Verspätung zwischen 60 und 120 Minuten 25% des ursprünglichen Preises und ab 120 Minuten 50% erstattet werden. Für die Erstattung muss ein entsprechendes Formular mit Name, Adresse, Bankverbindung und Angaben zur betroffenen Zugfahrt eingereicht werden. Außerdem kann es hilfreich sein, sich die Verspätung durch das Zugpersonal oder andere Fahrgäste auf dem Formular schriftlich bestätigen zu lassen. Zusätzlich sollten die Fahrkartenbelege fotografiert oder gescannt und an das Formular angehängt werden. Für die Einreichung des Formulars bei der Bahn hat man anschließend ein Jahr Zeit.")
    
    let zugausfall = UsecaseStore(name: "Zugausfall", content: "Bei einem Zugausfall, der nicht in einer eventuell vorher vereinbarten Frist angekündigt wurde, besteht normalerweise das Recht auf eine volle Erstattung des erworbenen Zugtickets. Für die Erstattung muss ein entsprechendes Formular mit Name, Adresse, Bankverbindung und Angaben zur betroffenen Zugfahrt eingereicht werden. Außerdem kann es hilfreich sein, sich den Ausfall durch das Zugpersonal oder andere Fahrgäste auf dem Formular schriftlich bestätigen zu lassen. Zusätzlich sollten die Fahrkartenbelege fotografiert oder gescannt und an das Formular angehängt werden. Für die Einreichung des Formulars bei der Bahn hat man anschließend ein Jahr Zeit.")
    
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
        let path = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: path!) as! DictionaryCell
        
        
        if segue.identifier == "ShowDetails" {
            if let destination = segue.destination as? DictionaryDetailsViewController {
                
                if path != nil {
                    if (cell.DicitonaryHeadline?.text)! == "Autounfall" {
                        destination.content = autounfall.content
                        destination.logo = UIImage (named: "LogoAutounfall")
                        destination.headlineText = "Autounfall"
                        
                    } else if (cell.DicitonaryHeadline?.text)! == "Zugverspätung" {
                        destination.content = zugverspaetung.content
                        destination.logo = UIImage (named: "TrainLogoBluetoOrange")
                        destination.headlineText = "Zugverspätung"
                    } else {
                        destination.content = zugausfall.content
                        destination.logo = UIImage (named: "TrainLogoBluetoOrange")
                        destination.headlineText = "Zugausfall"
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
