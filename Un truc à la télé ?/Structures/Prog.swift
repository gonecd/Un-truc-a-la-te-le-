//
//  Prog.swift
//  Un truc à la télé ?
//
//  Created by Cyril Delamare on 15/08/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation


class Prog : NSObject
{
    @objc var titre       : String = String()
    @objc var debut       : Date   = Date()
    @objc var fin         : Date   = Date()
    @objc var chaine      : String = String()
    @objc var sousTitre   : String = String()
    @objc var resume      : String = String()
    @objc var critique    : String = String()
    @objc var category    : String = String()
    @objc var capture     : String = String()
    @objc var casting     : [Cast] = []
    @objc var ratingCSA   : String = String()
    @objc var ratingTelerama     : String = String()
    @objc var aspect      : String = String()
    @objc var audio       : String = String()
    @objc var video       : String = String()
    @objc var annee       : String = String()
    @objc var inedit      : Bool = false
    @objc var pays        : String = String()
    @objc var soustitre   : String = String()
    @objc var episode     : String = String()
    @objc var duree       : String = String()

    init(chaine: String)
    {
        self.chaine = chaine
    }
}

class Cast : NSObject
{
    @objc var nom      : String = String()
    @objc var role     : String = String()
    
    init(nom: String, role: String)
    {
        self.nom = nom
        self.role = role
    }

}
