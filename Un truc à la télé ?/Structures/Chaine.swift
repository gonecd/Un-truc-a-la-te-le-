//
//  Chaine.swift
//  Un truc à la télé ?
//
//  Created by Cyril Delamare on 15/08/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation



class Chaine : NSObject
{
    var nom : String = String()
    var id : String = String()
    var icone : String = String()

    init(id: String)
    {
        self.id = id
    }
}
