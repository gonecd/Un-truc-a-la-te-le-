//
//  Filtre.swift
//  Un truc à la télé ?
//
//  Created by Cyril Delamare on 09/09/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation


class FiltreNoeud : NSObject, NSCoding, NSCopying
{
    var operateur : String = ""
    var operandes : [FiltreNoeud] = []
    var balise    : String = ""
    var operation : String = ""
    var valeur    : String = ""
    
    
    override init() {
        super.init()
    }
    
    init(operateur: String, operandes: [FiltreNoeud], balise: String, operation: String, valeur: String) {
        self.operateur = operateur
        self.operandes = operandes
        self.balise = balise
        self.operation = operation
        self.valeur = valeur
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = FiltreNoeud(operateur: operateur, operandes:[], balise: balise, operation: operation, valeur: valeur)
        for unNoeud in operandes {
            copy.operandes.append(unNoeud.copy() as! FiltreNoeud)
        }
        return copy
    }
    
    required init(coder decoder: NSCoder) {
        self.operateur = decoder.decodeObject(forKey: "operateur") as? String ?? ""
        self.operandes = decoder.decodeObject(forKey: "operandes") as? [FiltreNoeud] ?? []
        self.balise = decoder.decodeObject(forKey: "balise") as? String ?? ""
        self.operation = decoder.decodeObject(forKey: "operation") as? String ?? ""
        self.valeur = decoder.decodeObject(forKey: "valeur") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.operateur, forKey: "operateur")
        coder.encode(self.operandes, forKey: "operandes")
        coder.encode(self.balise, forKey: "balise")
        coder.encode(self.operation, forKey: "operation")
        coder.encode(self.valeur, forKey: "valeur")
    }
    
    func toPredicatComponents() -> (description: String, arguments : [Any]) {
        var description : String = ""
        var arguments : [Any] = []
        
        if (self.operateur == "UNITAIRE") {
            description = "( " + self.balise + " " + self.operation + " %@ )"
            arguments.append(self.valeur)
        }
        else {
            var chaine : String = "( "
            var args : [Any] = []

            for unPredicat in self.operandes {
                let predicatComps : (description : String, arguments : [Any]) = unPredicat.toPredicatComponents()

                chaine = chaine + " " + predicatComps.description + " " + self.operateur
                args.append(contentsOf: predicatComps.arguments)
            }
            chaine.removeLast(self.operateur.count)
            chaine = chaine + ")"
            
            description = chaine
            arguments = args
        }

        return (description, arguments)
    }
    
}


class Filtre : NSObject, NSCoding, NSCopying
{

    var nom          : String = String()
    var noeudInitial : FiltreNoeud = FiltreNoeud()

    init(nom: String) {
        self.nom = nom
    }
    
    required init(coder decoder: NSCoder) {
        self.nom = decoder.decodeObject(forKey: "nom") as? String ?? ""
        self.noeudInitial = decoder.decodeObject(forKey: "noeudInitial") as? FiltreNoeud ?? FiltreNoeud()
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Filtre(nom: nom)
        copy.noeudInitial = noeudInitial.copy() as! FiltreNoeud
        return copy
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.nom, forKey: "nom")
        coder.encode(self.noeudInitial, forKey: "noeudInitial")
    }

    func toPredicat() -> NSPredicate {
        let predicatComps : (description : String, arguments : [Any]) = self.noeudInitial.toPredicatComponents()
        return NSPredicate(format: predicatComps.description, argumentArray: predicatComps.arguments)
    }

}
