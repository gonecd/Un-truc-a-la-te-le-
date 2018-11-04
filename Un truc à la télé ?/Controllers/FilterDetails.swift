//
//  FilterDetails.swift
//  Un truc à la télé ?
//
//  Created by Cyril Delamare on 23/09/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit


class FilterDetails: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var filterName: UITextField!
    @IBOutlet weak var graphe: GrapheFilter!
    @IBOutlet weak var filterDef: UIView!
    
    @IBOutlet weak var balisePicker: UIPickerView!
    @IBOutlet weak var operateurPicker: UIPickerView!
    @IBOutlet weak var valuePicker: UIPickerView!
    @IBOutlet weak var valeur: UITextField!
    @IBOutlet weak var filtreType: UISegmentedControl!
    
    var filtre : Filtre = Filtre.init(nom: "")
    var idxFiltre : Int = 0
    var table: UITableView!
    
    var noeudEdite : String = ""
    var editMode : String = ""
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.regular))

    override func viewDidLoad() {
        super.viewDidLoad()
     
        if (filtre.nom != "Swipe this to add a filter") {
            filterName.text = filtre.nom
        }
        
        graphe.vue = self
        graphe.filtre = filtre.noeudInitial

        filterDef.layer.cornerRadius = 20.0
        filterDef.layer.masksToBounds = true
        filterDef.layer.borderWidth = 3.0
        filterDef.layer.borderColor = UIColor.black.cgColor
        filterDef.isHidden = true
        
        balisePicker.layer.cornerRadius = 10.0
        balisePicker.layer.borderWidth = 0.5
        balisePicker.layer.borderColor = UIColor.blue.cgColor
        
        operateurPicker.layer.cornerRadius = 10.0
        operateurPicker.layer.borderWidth = 0.8
        operateurPicker.layer.borderColor = UIColor.black.cgColor
        
        valuePicker.layer.cornerRadius = 10.0
        valuePicker.layer.borderWidth = 0.8
        valuePicker.layer.borderColor = UIColor.black.cgColor
        
        blurEffectView.frame = graphe.frame
        blurEffectView.alpha = 0.7
        self.view.addSubview(blurEffectView)
        blurEffectView.isHidden = true
        
        self.view.bringSubviewToFront(filterDef)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func valid(_ sender: Any) {
        if (filterName.text != "") {
            if (filterName.text != filtre.nom) {
                let newFiltre : Filtre = Filtre(nom: filterName.text!)
                newFiltre.noeudInitial = filtre.noeudInitial
                filtres.append(newFiltre)
            }
            else{
                filtres[idxFiltre].noeudInitial = filtre.noeudInitial
            }
            
            saveFilters()
            table.reloadData()
            table.setNeedsDisplay()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func suppress(_ sender: Any) {
        if (idxFiltre != -1) {
            filtres.remove(at: idxFiltre)
            saveFilters()
            table.reloadData()
            table.setNeedsDisplay()
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    ///////////////////////////
    // SubFilters management //
    ///////////////////////////
    func removeSubFilter(index: String) {
        let ids = index.components(separatedBy: ".")
        var noeudPere : FiltreNoeud = filtre.noeudInitial
        for i in 1..<ids.count-1 { noeudPere = noeudPere.operandes[Int(ids[i])!] }
        noeudPere.operandes.remove(at: Int(ids[ids.count-1])!)
        
        graphe.refresh(filtreFrais : filtre.noeudInitial)
    }
    
    func editSubFilter(index: String) {
        let ids = index.components(separatedBy: ".")
        var noeud : FiltreNoeud = filtre.noeudInitial
        noeudEdite = index
        editMode = "edit"
        
        balisePicker.isHidden = false
        operateurPicker.isHidden = false
        valuePicker.isHidden = false
        valeur.isHidden = false
        filtreType.isHidden = true
        
        for i in 1..<ids.count { noeud = noeud.operandes[Int(ids[i])!] }
        
        if (noeud.operateur == "UNITAIRE") {
            let baliseIdx : Int = baliseIndex[noeud.balise] as! Int
            balisePicker.selectRow(baliseIdx, inComponent: 0, animated: true)
            pickerView(balisePicker, didSelectRow: baliseIdx, inComponent: 0)
            operateurPicker.selectRow(operationIndex(baliseIndex: baliseIdx, operation: noeud.operation), inComponent: 0, animated: true)
            valeur.text = noeud.valeur

            blurEffectView.isHidden = false
            filterDef.isHidden = false
        }
        else if (noeud.operateur == "AND") {
            noeud.operateur = "OR"
            graphe.refresh(filtreFrais : filtre.noeudInitial)
        }
        else if (noeud.operateur == "OR") {
            noeud.operateur = "AND"
            graphe.refresh(filtreFrais : filtre.noeudInitial)
        }
    }
    
    func addSubFilter(index: String) {
        balisePicker.isHidden = true
        operateurPicker.isHidden = true
        valuePicker.isHidden = true
        valeur.isHidden = true
        filtreType.isHidden = false
        
        filtreType.selectedSegmentIndex = UISegmentedControl.noSegment
        
        noeudEdite = index
        editMode = "add"

        blurEffectView.isHidden = false
        filterDef.isHidden = false
    }
    
    func operationIndex(baliseIndex: Int, operation: String) -> Int {
        for i in 0..<balisesTable[baliseIndex].operations.count {
            if (balisesTable[baliseIndex].operations[i] == operation) { return i }
        }
        return 0
    }
    
    @IBAction func cancelFiltUnit(_ sender: Any) {
        blurEffectView.isHidden = true
        filterDef.isHidden = true
    }
    
    @IBAction func validFiltUnit(_ sender: Any) {
        let ids = noeudEdite.components(separatedBy: ".")
        
        if (editMode == "edit") {
            var noeud : FiltreNoeud = filtre.noeudInitial
            for i in 1..<ids.count { noeud = noeud.operandes[Int(ids[i])!] }
            
            noeud.balise = balisesTable[balisePicker.selectedRow(inComponent: 0)].balise
            noeud.operation = balisesTable[balisePicker.selectedRow(inComponent: 0)].operations[operateurPicker.selectedRow(inComponent: 0)]
            
            if (balisesTable[balisePicker.selectedRow(inComponent: 0)].values.count > 0) {
                noeud.valeur = balisesTable[balisePicker.selectedRow(inComponent: 0)].values[valuePicker.selectedRow(inComponent: 0)]
            }
            else {
                noeud.valeur = valeur.text!
            }
        }
        else if (editMode == "add") {
            let noeud : FiltreNoeud = FiltreNoeud()
            noeud.operateur = "UNITAIRE"
            noeud.balise = balisesTable[balisePicker.selectedRow(inComponent: 0)].balise
            noeud.operation = balisesTable[balisePicker.selectedRow(inComponent: 0)].operations[operateurPicker.selectedRow(inComponent: 0)]
            if (balisesTable[balisePicker.selectedRow(inComponent: 0)].values.count > 0) {
                noeud.valeur = balisesTable[balisePicker.selectedRow(inComponent: 0)].values[valuePicker.selectedRow(inComponent: 0)]
            }
            else {
                noeud.valeur = valeur.text!
            }

            var noeudPere : FiltreNoeud = filtre.noeudInitial
            for i in 1..<ids.count-1 { noeudPere = noeudPere.operandes[Int(ids[i])!] }
            noeudPere.operandes.insert(noeud, at: Int(ids[ids.count-1])!+1)
        }
        
        graphe.refresh(filtreFrais : filtre.noeudInitial)
        
        blurEffectView.isHidden = true
        filterDef.isHidden = true
    }
    
    @IBAction func filtreTypeChoosed(_ sender: Any) {
        print("Filtre choisi = \(filtreType.selectedSegmentIndex)")
        
        if (filtreType.selectedSegmentIndex == 0) {
            balisePicker.isHidden = false
            operateurPicker.isHidden = false
            valuePicker.isHidden = false
            valeur.isHidden = false
            filtreType.isHidden = true

            balisePicker.selectRow(0, inComponent: 0, animated: true)
            pickerView(balisePicker, didSelectRow: 0, inComponent: 0)
            operateurPicker.selectRow(0, inComponent: 0, animated: true)
            valeur.text = ""
        }
        else if (filtreType.selectedSegmentIndex == 1) {
            let filtreTexte1 : FiltreNoeud = FiltreNoeud(operateur: "UNITAIRE", operandes: [], balise: "titre", operation: "CONTAINS[cd]", valeur: "Valeur à chercher")
            let filtreTexte2 : FiltreNoeud = FiltreNoeud(operateur: "UNITAIRE", operandes: [], balise: "sousTitre", operation: "CONTAINS[cd]", valeur: "Autre chose")
            let noeud : FiltreNoeud = FiltreNoeud(operateur: "AND", operandes:[filtreTexte1, filtreTexte2], balise: "", operation: "", valeur: "")

            let ids = noeudEdite.components(separatedBy: ".")
            var noeudPere : FiltreNoeud = filtre.noeudInitial
            for i in 1..<ids.count-1 { noeudPere = noeudPere.operandes[Int(ids[i])!] }
            noeudPere.operandes.insert(noeud, at: Int(ids[ids.count-1])!+1)
            
            graphe.refresh(filtreFrais : filtre.noeudInitial)
            
            blurEffectView.isHidden = true
            filterDef.isHidden = true
        }
        else {
            let filtreTexte1 : FiltreNoeud = FiltreNoeud(operateur: "UNITAIRE", operandes: [], balise: "titre", operation: "CONTAINS[cd]", valeur: "Valeur à chercher")
            let filtreTexte2 : FiltreNoeud = FiltreNoeud(operateur: "UNITAIRE", operandes: [], balise: "sousTitre", operation: "CONTAINS[cd]", valeur: "Autre chose")
            let noeud : FiltreNoeud = FiltreNoeud(operateur: "OR", operandes:[filtreTexte1, filtreTexte2], balise: "", operation: "", valeur: "")
            
            let ids = noeudEdite.components(separatedBy: ".")
            var noeudPere : FiltreNoeud = filtre.noeudInitial
            for i in 1..<ids.count-1 { noeudPere = noeudPere.operandes[Int(ids[i])!] }
            noeudPere.operandes.insert(noeud, at: Int(ids[ids.count-1])!+1)
            
            graphe.refresh(filtreFrais : filtre.noeudInitial)
            
            blurEffectView.isHidden = true
            filterDef.isHidden = true
        }

    }
    
    ////////////////////////
    // Pickers management //
    ////////////////////////
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == balisePicker) { return balisesTable.count }
        if (pickerView == operateurPicker) { return balisesTable[balisePicker.selectedRow(inComponent: 0)].operations.count }
        if (pickerView == valuePicker) { return balisesTable[balisePicker.selectedRow(inComponent: 0)].values.count }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        
        if (pickerView == balisePicker) {
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
                pickerLabel?.textAlignment = .center
            }
            pickerLabel?.text = balisesTable[row].description
            pickerLabel?.textColor = UIColor.blue
        }
        
        if (pickerView == operateurPicker) {
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont.systemFont(ofSize: 13.0)
                pickerLabel?.textAlignment = .center
            }
            pickerLabel?.text = operateursListe[balisesTable[balisePicker.selectedRow(inComponent: 0)].operations[row]] as? String
            pickerLabel?.textColor = UIColor.black
        }
        
        if (pickerView == valuePicker) {
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont.systemFont(ofSize: 13.0)
                pickerLabel?.textAlignment = .center
            }
            pickerLabel?.text = balisesTable[balisePicker.selectedRow(inComponent: 0)].values[row]
            pickerLabel?.textColor = UIColor.black
        }
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == balisePicker) {
            operateurPicker.selectRow(0, inComponent: 0, animated: true)
            operateurPicker.reloadAllComponents()
            operateurPicker.setNeedsDisplay()
            
            if (balisesTable[row].values.count > 0) {
                valuePicker.selectRow(0, inComponent: 0, animated: true)
                valuePicker.reloadAllComponents()
                valuePicker.setNeedsDisplay()
                valuePicker.isHidden = false
                valeur.isHidden = true
            }
            else {
                valuePicker.isHidden = true
                valeur.isHidden = false
            }
        }
    }
    
}
