//
//  MasterViewController.swift
//  Un truc à la télé ?
//
//  Created by Cyril Delamare on 10/06/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit


class CellFilter: UITableViewCell  {
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var quantite: UILabel!
    @IBOutlet weak var infos: UIButton!
    
    var index: Int = 0
}



class MasterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var viewConfigure: UIView!
    @IBOutlet weak var viewFilters: UITableView!
    var detailViewController: DetailViewController? = nil
    
    @IBOutlet weak var tableFilters: UITableView!
  
    var filtreOriginel : Filtre = Filtre(nom: "Swipe this to add a filter")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Master = self
        
        dateOuput.locale = Locale.current
        dateOuput.dateFormat = "cccc dd MMMM"
        timeOuput.locale = Locale.current
        timeOuput.dateFormat = "HH:mm"
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = controllers[controllers.count-1] as? DetailViewController
        }
        
        print("------------------------------------------------------------")
        print("Initialisation")
        checkDirectories()
        loadConfig()
        loadFilters()

        let filtreTexte1 : FiltreNoeud = FiltreNoeud(operateur: "UNITAIRE", operandes: [], balise: "titre", operation: "CONTAINS[cd]", valeur: "titi")
        let filtreTexte2 : FiltreNoeud = FiltreNoeud(operateur: "UNITAIRE", operandes: [], balise: "sousTitre", operation: "CONTAINS[cd]", valeur: "toto")
        let filtre : FiltreNoeud = FiltreNoeud(operateur: "AND", operandes:[filtreTexte1, filtreTexte2], balise: "", operation: "", valeur: "")
        filtreOriginel.noeudInitial = filtre
        
        mesChainesCurrent = mesChainesTNT
        print("Loading File")
        db.Donwload(source : "TNT", force : false)
        print("Reading Data")
        db.DataRead()
        print("------------------------------------------------------------")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func menuSearch(_ sender: Any) {
        viewSearch.isHidden = false
        viewFilters.isHidden = true
        viewConfigure.isHidden = true
        self.filter(sender)
    }
    
    @IBAction func menuFilters(_ sender: Any) {
        viewSearch.isHidden = true
        viewFilters.isHidden = false
        viewConfigure.isHidden = true
        self.tableFilters.reloadData()
        self.tableFilters.setNeedsDisplay()
    }
    
    @IBAction func menuConfigure(_ sender: Any) {
        viewSearch.isHidden = true
        viewFilters.isHidden = true
        viewConfigure.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueFilter") {
            let idxFiltre : Int = sender as! Int
            let filterView : FilterDetails = segue.destination as! FilterDetails

            if (idxFiltre >= 0) {
                filterView.filtre = filtres[idxFiltre].copy() as! Filtre
                filterView.idxFiltre = idxFiltre
            }
            else {
                filterView.filtre = filtreOriginel.copy() as! Filtre
                filterView.idxFiltre = -1
            }
            filterView.table = tableFilters
        }
    }

    

    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // SubView Search
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var mot: UITextField!
    @IBOutlet weak var titre: UISwitch!
    @IBOutlet weak var soustitre: UISwitch!
    @IBOutlet weak var resume: UISwitch!
    @IBOutlet weak var categories: UIPickerView!
    @IBOutlet weak var jour: UISegmentedControl!
    @IBOutlet weak var heure: UISegmentedControl!
    
    @IBAction func jourChanged(_ sender: Any) {
        if ( (jour.selectedSegmentIndex == 0)
            || ( (jour.selectedSegmentIndex == 2) && ( (heure.selectedSegmentIndex == 1) || (heure.selectedSegmentIndex == 2) ) ) )
        {
            heure.selectedSegmentIndex = 0
        }
        
        self.filter(sender)
    }
    
    @IBAction func heureChanged(_ sender: Any) {
        if ( (heure.selectedSegmentIndex == 1)
            || (heure.selectedSegmentIndex == 2)
            || ( (heure.selectedSegmentIndex == 3) && (jour.selectedSegmentIndex == 0) )
            || ( (heure.selectedSegmentIndex == 4) && (jour.selectedSegmentIndex == 0) ) )
        {
            jour.selectedSegmentIndex = 1
        }
        
        self.filter(sender)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int                                     { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int      { return Categories.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent: Int) -> String? { return Categories[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent: Int)            { self.filter(pickerView) }
    
    func buildPredicat() -> NSPredicate
    {
        var predicatForm : String = ""
        var predicatArgs : [Any] = []
        let cal: Calendar = Calendar(identifier: .gregorian)
        
        // Suppression des programmes passés
        let now : Date = Date()
        let tomorrow : Date = cal.date(byAdding: .day, value: 1, to: now)!
        var debut : Date = Date()
        var fin : Date = Date()
        
        if ( (jour.selectedSegmentIndex == 0) && (heure.selectedSegmentIndex == 0) ) { debut = now; fin = cal.date(byAdding: .day, value: 10, to: now)!; }
        if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 1) ) { debut = now; fin = now; }
        if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 2) ) { debut = cal.date(byAdding: .minute, value: 1, to: now)!; fin = cal.date(byAdding: .minute, value: 10, to: now)!; }
        if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 0) ) { debut = cal.date(bySettingHour: 0, minute: 0, second: 0, of: now)!; fin = cal.date(bySettingHour: 23, minute: 59, second: 0, of: now)!; }
        if ( (jour.selectedSegmentIndex == 2) && (heure.selectedSegmentIndex == 0) ) { debut = cal.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow)!; fin = cal.date(bySettingHour: 23, minute: 59, second: 0, of: tomorrow)!; }
        if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 3) ) { debut = cal.date(bySettingHour: 20, minute: 45, second: 0, of: now)!; fin = cal.date(bySettingHour: 21, minute: 15, second: 0, of: now)!; }
        if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 4) ) { debut = cal.date(bySettingHour: 22, minute: 15, second: 0, of: now)!; fin = cal.date(bySettingHour: 23, minute: 0, second: 0, of: now)!; }
        if ( (jour.selectedSegmentIndex == 2) && (heure.selectedSegmentIndex == 3) ) { debut = cal.date(bySettingHour: 20, minute: 45, second: 0, of: tomorrow)!; fin = cal.date(bySettingHour: 21, minute: 15, second: 0, of: tomorrow)!; }
        if ( (jour.selectedSegmentIndex == 2) && (heure.selectedSegmentIndex == 4) ) { debut = cal.date(bySettingHour: 22, minute: 15, second: 0, of: tomorrow)!; fin = cal.date(bySettingHour: 23, minute: 0, second: 0, of: tomorrow)!; }
        
        if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 1) ) { predicatForm.append("debut <= %@ AND fin >= %@") }
        else if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 3) ) { predicatForm.append("debut >= %@ AND debut <= %@ AND fin >= %@") }
        else if ( (jour.selectedSegmentIndex == 2) && (heure.selectedSegmentIndex == 3) ) { predicatForm.append("debut >= %@ AND debut <= %@ AND fin >= %@") }
        else { predicatForm.append("debut >= %@ AND debut <= %@") }
        
        predicatArgs.append(debut)
        predicatArgs.append(fin)
        if (heure.selectedSegmentIndex == 3) { predicatArgs.append(fin) }
        
        // Choix de la categorie
        if (categories.selectedRow(inComponent: 0) != 0) {
            predicatForm.append(" AND category CONTAINS[cd] %@")
            predicatArgs.append(Categories[categories.selectedRow(inComponent: 0)])
        }
        
        // Filtrage par mot clé
        if ( (mot.text != "") && ( titre.isOn || soustitre.isOn || resume.isOn) ){
            predicatForm.append(" AND (")
            var started : Bool = false
            
            if (titre.isOn) {
                predicatForm.append(" titre CONTAINS[cd] %@")
                predicatArgs.append(mot.text!)
                started = true
            }
            
            if (soustitre.isOn) {
                if (started) { predicatForm.append(" OR") }
                predicatForm.append(" sousTitre CONTAINS[cd] %@")
                predicatArgs.append(mot.text!)
                started = true
            }
            
            if (resume.isOn) {
                if (started) { predicatForm.append(" OR") }
                predicatForm.append(" resume CONTAINS[cd] %@")
                predicatArgs.append(mot.text!)
            }
            
            predicatForm.append(" ) ")
        }
        
        return NSPredicate.init(format: predicatForm, argumentArray: predicatArgs)
    }
    
    @IBAction func filter(_ sender: Any) {
        detailViewController?.filtrer(predicat: self.buildPredicat())
    }
    
    

    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // SubView Filters
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtres.count+1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row > 0) {
            detailViewController?.filtrer(predicat: filtres[indexPath.row-1].toPredicat())
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFilter", for: indexPath) as! CellFilter
        
        if (indexPath.row == 0) {
            cell.nom.text = filtreOriginel.nom
            cell.nom.font = UIFont.italicSystemFont(ofSize: 20.0)
            cell.quantite.text = "-"
        }
        else {
            let predicat : NSPredicate = filtres[indexPath.row-1].toPredicat()
            let tmpProgs = db.Programme.filter { predicat.evaluate(with: $0) }
            cell.nom.text = filtres[indexPath.row-1].nom
            cell.quantite.text = String(tmpProgs.count)
        }
        
        cell.quantite.layer.cornerRadius = 12
        cell.quantite.layer.masksToBounds = true

        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.performSegue(withIdentifier: "segueFilter", sender: editActionsForRowAt.row-1)
        }
        edit.backgroundColor = .gray
        
        return [edit]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // SubView Configure
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var source: UISegmentedControl!

    
    @IBAction func changeSource(_ sender: Any) {
        print("Changing Source")
        
        currentSource = (sender as! UISegmentedControl).selectedSegmentIndex

        if (currentSource == csteTNT) {
            mesChainesCurrent = mesChainesTNT
            db.Donwload(source : "TNT", force : true)
        }
        else {
            mesChainesCurrent = mesChainesCable
            db.Donwload(source : "Cable", force : true)
        }
        
        db.DataRead()
        db.Programme = db.Programme.sorted { $0.debut < $1.debut }
    }
    
    
    
}

