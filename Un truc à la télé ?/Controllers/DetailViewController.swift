//
//  DetailViewController.swift
//  Un truc à la télé ?
//
//  Created by Cyril Delamare on 10/06/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit


class CellProgramme: UITableViewCell {
    
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var debut: UILabel!
    @IBOutlet weak var fin: UILabel!
    @IBOutlet weak var sousTitre: UILabel!
    @IBOutlet weak var chaine: UIImageView!
    @IBOutlet weak var categorie: UILabel!
    @IBOutlet weak var jour: UILabel!
    @IBOutlet weak var capture: UIImageView!
    
    @IBOutlet weak var ratingCSA: UIImageView!
    @IBOutlet weak var inedit: UIImageView!
    @IBOutlet weak var etoiles: Etoile!
    
    var index: Int = 0
}


class DetailViewController: UITableViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet var liste: UITableView!
    
    var DispProgs   : [Prog] = [Prog]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DispProgs = db.Programme
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: NSDate? {
        didSet {
            // Update the view.
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DispProgs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellProgramme", for: indexPath) as! CellProgramme
        
        cell.titre.text = DispProgs[indexPath.row].titre
        cell.jour.text = dateOuput.string(from: DispProgs[indexPath.row].debut)
        cell.debut.text = timeOuput.string(from: DispProgs[indexPath.row].debut)
        cell.fin.text = timeOuput.string(from: DispProgs[indexPath.row].fin)
        cell.sousTitre.text = DispProgs[indexPath.row].sousTitre
        cell.chaine.image = getImage((db.Chaines[DispProgs[indexPath.row].chaine] as! Chaine).icone)
        cell.categorie.text = majuscule(mot: DispProgs[indexPath.row].category)
        
        if (DispProgs[indexPath.row].annee == "" ) { cell.categorie.text = majuscule(mot: DispProgs[indexPath.row].category) }
        else { cell.categorie.text = majuscule(mot: DispProgs[indexPath.row].category) + " (" + DispProgs[indexPath.row].annee + ")" }
        cell.index = indexPath.row
        
        if (DispProgs[indexPath.row].ratingCSA == "-10")                { cell.ratingCSA.image = #imageLiteral(resourceName: "CSA10.png") }
        else if (DispProgs[indexPath.row].ratingCSA == "-12")           { cell.ratingCSA.image = #imageLiteral(resourceName: "CSA12.png") }
        else if (DispProgs[indexPath.row].ratingCSA == "-16")           { cell.ratingCSA.image = #imageLiteral(resourceName: "CSA16.png") }
        else if (DispProgs[indexPath.row].ratingCSA == "Tout public")   { cell.ratingCSA.image = #imageLiteral(resourceName: "CSAPP.png") }
        else                                                            { cell.ratingCSA.image = UIImage() }

        if (DispProgs[indexPath.row].ratingTelerama == "5/5")       { cell.etoiles.setEtoiles(nbEtoiles: 5); }
        else if (DispProgs[indexPath.row].ratingTelerama == "4/5")  { cell.etoiles.setEtoiles(nbEtoiles: 4); }
        else if (DispProgs[indexPath.row].ratingTelerama == "3/5")  { cell.etoiles.setEtoiles(nbEtoiles: 3); }
        else if (DispProgs[indexPath.row].ratingTelerama == "2/5")  { cell.etoiles.setEtoiles(nbEtoiles: 2); }
        else if (DispProgs[indexPath.row].ratingTelerama == "1/5")  { cell.etoiles.setEtoiles(nbEtoiles: 1); }
        else                                                        { cell.etoiles.setEtoiles(nbEtoiles: 0); }

        if (DispProgs[indexPath.row].inedit )   { cell.inedit.image = #imageLiteral(resourceName: "Inedit.jpg") }
        else                                    { cell.inedit.image = UIImage() }

        cell.capture.image = loadImage(DispProgs[indexPath.row].capture)
        
        cell.etoiles.setNeedsDisplay()
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func filtrer(predicat : NSPredicate)
    {
        DispProgs = db.Programme.filter { predicat.evaluate(with: $0) }
        
        self.liste.reloadData()
        self.view.setNeedsDisplay()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let fiche : FicheController = segue.destination as! FicheController
        let tableCell : CellProgramme = sender as! CellProgramme
        
        fiche.prog = DispProgs[tableCell.index]
    }
}

