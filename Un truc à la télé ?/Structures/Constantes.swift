//
//  Constantes.swift
//  Un truc à la télé ?
//
//  Created by Cyril Delamare on 01/09/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

let Categories : [String] = [ "", "clips", "divertissement", "documentaire", "débat", "feuilleton", "film", "humour",
    "jeu", "jeunesse", "journal", "loterie", "magazine", "météo", "one man show", "théâtre", "sport", "série",
    "talk-show", "téléfilm", "téléréalité", "variétés" ]

let dateOuput  : DateFormatter     = DateFormatter()
let timeOuput  : DateFormatter     = DateFormatter()


let csteTNT         : Int = 0
let csteCable       : Int = 1

let csteInedit      : Int = 1
let csteRediffusion : Int = 2

let baliseIndex : NSDictionary = [
    "titre" : 0,
    "debut" : 1,
    "fin" : 2,
    "chaine" : 3,
    "sousTitre" : 4,
    "resume" : 5,
    "critique" : 6,
    "category" : 7,
    "ratingCSA" : 8,
    "ratingTelerama" : 9,
    "aspect" : 10,
    "audio" : 11,
    "video" : 12,
    "annee" : 13,
    "inedit" : 14,
    "pays" : 15,
    "soustitre" : 16,
    "episode" : 17,
    "duree" : 18
]

let balisesTable: Array = [
    (balise: "titre", description: "Titre du programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "debut", description: "Heure de début", operations: ["=", ">", "<"], values: []),
    (balise: "fin", description: "Heure de fin", operations: ["=", ">", "<"], values: []),
    (balise: "chaine", description: "Chaîne de diffusion", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "sousTitre", description: "Sous titre du programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "resume", description: "Résumé du programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "critique", description: "Critique Télérama", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "category", description: "Catégorie de programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    //    "capture" : "ZZZ capture",
    //    "casting" : "ZZZ casting",
    (balise: "ratingCSA", description: "Signalétique CSA", operations: ["=", "IN", "!="], values: ["-10", "-12", "-16", "Tout public", ""]),
    (balise: "ratingTelerama", description: "Etoiles Télérama", operations: ["=", "IN", "!="], values: ["1/5", "2/5", "3/5", "4/5", "5/5", ""]),
    (balise: "aspect", description: "Format d'image", operations: ["=", "IN", "!="], values: ["4:3", "16:9", ""]),
    (balise: "audio", description: "Bande audio", operations: ["=", "IN", "!="], values: ["bilingual", "dolby", "stereo", ""]),
    (balise: "video", description: "Format vidéo", operations: ["=", "IN", "!="], values: ["HDTV", ""]),
    (balise: "annee", description: "Année de première diffusion", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "inedit", description: "Inédit / Rediffusion", operations: ["=", "IN", "!="], values: ["true", "false", ""]),
    (balise: "pays", description: "Pays d'origine", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "soustitre", description: "Sous Titrage", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "episode", description: "Episode numéro", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "duree", description: "Durée du programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: [])
]

let operateursListe: NSDictionary = [
    "=" : "est égal à",
    ">" : "est supérieur à",
    "<" : "est inférieur à",
    "!=" : "est différent de",
    "IN" : "est l'un de",
    "BEGINSWITH[cd]" : "commence avec",
    "CONTAINS[cd]" : "contient",
    "ENDSWITH[cd]" : "finit avec",
    "LIKE[cd]" : "ressemble à",
    "MATCHES" : "matche (regex)"
]

