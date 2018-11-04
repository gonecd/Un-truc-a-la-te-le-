//
//  FicheController.swift
//  Un truc à la télé ?
//
//  Created by Cyril Delamare on 02/09/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class FicheController: UIViewController
{
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var soustitre: UILabel!
    @IBOutlet weak var categorie: UILabel!
    @IBOutlet weak var chaine: UIImageView!
    @IBOutlet weak var resume: UITextView!
    @IBOutlet weak var critique: UITextView!
    @IBOutlet weak var capture: UIImageView!
    @IBOutlet weak var casting: UITextView!
    @IBOutlet weak var jour: UILabel!
    @IBOutlet weak var debut: UILabel!
    @IBOutlet weak var fin: UILabel!
    @IBOutlet weak var audio: UILabel!
    @IBOutlet weak var video: UILabel!
    @IBOutlet weak var annee: UILabel!
    @IBOutlet weak var inedit: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var pays: UILabel!
    @IBOutlet weak var episode: UILabel!
    @IBOutlet weak var duree: UILabel!
    @IBOutlet weak var aspect: UIImageView!
    @IBOutlet weak var ratingCSA: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    var prog : Prog = Prog(chaine: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        

        titre.text = prog.titre
        soustitre.text = prog.sousTitre
        
        categorie.text = majuscule(mot: prog.category)
        resume.text = prog.resume
        critique.text = prog.critique
        jour.text = dateOuput.string(from: prog.debut)
        debut.text = timeOuput.string(from: prog.debut)
        fin.text = timeOuput.string(from: prog.fin)
        audio.text = majuscule(mot: prog.audio)
        video.text = majuscule(mot: prog.video)
        annee.text = prog.annee
        
        if (prog.aspect == "4:3")       { aspect.image = #imageLiteral(resourceName: "icone4-3.jpg") }
        else if (prog.aspect == "16:9") { aspect.image = #imageLiteral(resourceName: "icone16-9.jpg")}
        
        if (prog.ratingCSA == "-10")                { ratingCSA.image = #imageLiteral(resourceName: "CSA10.png") }
        else if (prog.ratingCSA == "-12")           { ratingCSA.image = #imageLiteral(resourceName: "CSA12.png") }
        else if (prog.ratingCSA == "-16")           { ratingCSA.image = #imageLiteral(resourceName: "CSA16.png") }
        else if (prog.ratingCSA == "Tout public")   { ratingCSA.image = #imageLiteral(resourceName: "CSAPP.png") }

        if (prog.ratingTelerama == "5/5")       { star1.image = #imageLiteral(resourceName: "star-icon.png"); star2.image = #imageLiteral(resourceName: "star-icon.png"); star3.image = #imageLiteral(resourceName: "star-icon.png"); star4.image = #imageLiteral(resourceName: "star-icon.png"); star5.image = #imageLiteral(resourceName: "star-icon.png"); }
        else if (prog.ratingTelerama == "4/5")  { star1.image = #imageLiteral(resourceName: "star-icon.png"); star2.image = #imageLiteral(resourceName: "star-icon.png"); star3.image = #imageLiteral(resourceName: "star-icon.png"); star4.image = #imageLiteral(resourceName: "star-icon.png"); }
        else if (prog.ratingTelerama == "3/5")  { star1.image = #imageLiteral(resourceName: "star-icon.png"); star2.image = #imageLiteral(resourceName: "star-icon.png"); star3.image = #imageLiteral(resourceName: "star-icon.png"); }
        else if (prog.ratingTelerama == "2/5")  { star1.image = #imageLiteral(resourceName: "star-icon.png"); star2.image = #imageLiteral(resourceName: "star-icon.png"); }
        else if (prog.ratingTelerama == "1/5")  { star1.image = #imageLiteral(resourceName: "star-icon.png"); }

        if (prog.inedit) { inedit.text = "Inédit" }
        else { inedit.text = "Redifusion" }
        
        subtitle.text = majuscule(mot: prog.soustitre)
        pays.text = majuscule(mot: prog.pays)
        duree.text = prog.duree

        if (prog.episode != "") {
            let composants = prog.episode.split(separator: ".", omittingEmptySubsequences: false)
            if (composants[1] == "") { episode.text = "Sais \(Int(composants[0])! + 1)" }
            else { episode.text = "Sais \(Int(composants[0])! + 1) Ep \(Int(composants[1])! + 1)" }
        }
        else
        {
            episode.text = ""
        }
        
        chaine.image = getImage((db.Chaines[prog.chaine] as! Chaine).icone)

        capture.image = loadImage(prog.capture)
        
        var castingText : String = String()
        for unGars in prog.casting {
            castingText = castingText.appendingFormat("%@\t: \t%@\n", unGars.role, unGars.nom)
        }
        casting.text = castingText

    }

    @objc func closeView(gesture: UISwipeGestureRecognizer) -> Void {
        dismiss(animated: true, completion: nil)
    }
}
