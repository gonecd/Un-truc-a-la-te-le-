//
//  ProgramData.swift
//  Un truc à la télé ?
//
//  Created by Cyril Delamare on 12/08/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

var db           : ProgramData       = ProgramData.init()
var filtres      : [Filtre]          = []
let dateXML      : DateFormatter     = DateFormatter()
let dateXMLshort : DateFormatter     = DateFormatter()



class ProgramData : NSObject, XMLParserDelegate
{
    var parsedValue  : String = ""
    var valSvg  : String = ""
    var parserScope  : Int = 0
    let parserChaine : Int = 0
    let parserProgs  : Int = 1
    
    var Chaines         : NSMutableDictionary = NSMutableDictionary()
    var ChainesArray    : [String] = []
    var uneChaine       : Chaine = Chaine(id: "")
    
    var Programme   : [Prog] = [Prog]()
    var unProg      : Prog = Prog(chaine: "")
    
    override init()
    {
        dateXML.locale = Locale.current
        dateXML.dateFormat = "yyyyMMddHHmmss Z"
        dateXMLshort.locale = Locale.current
        dateXMLshort.dateFormat = "yyyyMMddHHmm Z"
    }
    
    func Donwload(source : String, force : Bool)
    {
        let TNT   : String = "https://www.xmltv.fr/guide/tvguide.xml"
        let Cable : String = "https://racacaxtv.ga/xmltv/xmltv.xml"
        var sourceURL : String = ""
        
        if (source == "TNT") { sourceURL = TNT }
        else { sourceURL = Cable }
        
        if FileManager.default.fileExists(atPath: XMLDir.appendingPathComponent("data.xml").path) {
            if (force == false) {
                // On ne download que si le fichier a plus de 24h (= 86400s)
                let attributs = try! FileManager.default.attributesOfItem(atPath: XMLDir.appendingPathComponent("data.xml").path)
                let modifDate: Date = attributs[FileAttributeKey.modificationDate] as! Date
                if (modifDate.timeIntervalSinceNow > -86400) { return }
            }
            
            try! FileManager.default.removeItem(at: XMLDir.appendingPathComponent("data.xml"))
        }
        
        let rawData = NSData(contentsOf: URL(string: sourceURL)!)
        try! rawData?.write(to: XMLDir.appendingPathComponent("data.xml"))
    }
    
    func DataRead()
    {
        let parser = XMLParser(contentsOf: XMLDir.appendingPathComponent("data.xml"))
        parser?.delegate = self

        Programme.removeAll()
        ChainesArray.removeAll()
        Chaines.removeAllObjects()
        
        if (parser?.parse())! {
            Programme = Programme.sorted { $0.debut < $1.debut }
            print("Parsing Fini")
        }
    }
    
    
    
    func parser(_ parser: XMLParser, didStartElement: String, namespaceURI: String?, qualifiedName: String?, attributes: [String : String] = [:])
    {
        parsedValue = ""
        
        if (didStartElement == "channel") { parserScope = parserChaine }
        else if (didStartElement == "programme") { parserScope = parserProgs }
        
        if (parserScope == parserChaine) {
            if (didStartElement == "channel") { uneChaine = Chaine.init(id : attributes["id"]!) }
            else if (didStartElement == "icon") {
                if (attributes["src"]!.starts(with: "http://")) { uneChaine.icone = (attributes["src"]!).replacingOccurrences(of: "http://", with: "https://") }
                else if (attributes["src"]!.starts(with: "//")) { uneChaine.icone = (attributes["src"]!).replacingOccurrences(of: "//", with: "https://") }
            }
        }
        
        if (parserScope == parserProgs) {
            if (didStartElement == "programme") {
                unProg = Prog.init(chaine : attributes["channel"]!)
                unProg.debut = dateXML.date(from: attributes["start"]!)!
                
                if ((attributes["stop"]!).count == 20) {
                    
                    unProg.fin = dateXML.date(from: attributes["stop"]!)! }
                else {
                    
                    unProg.fin = dateXMLshort.date(from: attributes["stop"]!)! }
                
            }
            else if (didStartElement == "icon") { if (unProg.capture == "" ) { unProg.capture = (attributes["src"]!).replacingOccurrences(of: "http://", with: "https://") } }
            else if (didStartElement == "length") { unProg.duree = attributes["units"]! }
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        parsedValue += string
    }
    
    func parser(_ parser: XMLParser, didEndElement: String, namespaceURI: String?, qualifiedName: String?)
    {
        if (parserScope == parserChaine)
        {
            if (didEndElement == "display-name")    { uneChaine.nom = parsedValue }
            else if (didEndElement == "channel")    { Chaines.setValue(uneChaine, forKey: uneChaine.id); ChainesArray.append(uneChaine.id); }
            else if (didEndElement == "icon")       {  }
            else { print ("Balise de chaine inconnue : " + didEndElement) }
        }
        
        if (parserScope == parserProgs)
        {
            if (didEndElement == "title")                   { unProg.titre = parsedValue }
            else if (didEndElement == "desc")               {
                if let range = parsedValue.range(of: "Critique : ") {
                    unProg.resume = String(parsedValue[..<range.lowerBound])
                    unProg.critique = String(parsedValue[range.upperBound...])
                }
                else { unProg.resume = parsedValue }
            }
            else if (didEndElement == "sub-title")          { unProg.sousTitre = parsedValue }
            else if (didEndElement == "category")           { unProg.category = parsedValue }
            else if (didEndElement == "credits")            { /* Nothing to do */ }
            else if (didEndElement == "director")           { let unGars : Cast = Cast(nom : parsedValue, role : "Réalisateur"); unProg.casting.append(unGars) }
            else if (didEndElement == "editor")             { let unGars : Cast = Cast(nom : parsedValue, role : "Editeur"); unProg.casting.append(unGars) }
            else if (didEndElement == "presenter")          { let unGars : Cast = Cast(nom : parsedValue, role : "Présentateur"); unProg.casting.append(unGars) }
            else if (didEndElement == "composer")           { let unGars : Cast = Cast(nom : parsedValue, role : "Compositeur"); unProg.casting.append(unGars) }
            else if (didEndElement == "writer")             { let unGars : Cast = Cast(nom : parsedValue, role : "Auteur"); unProg.casting.append(unGars) }
            else if (didEndElement == "actor")              { let unGars : Cast = Cast(nom : parsedValue, role : "Acteur"); unProg.casting.append(unGars) }
            else if (didEndElement == "guest")              { let unGars : Cast = Cast(nom : parsedValue, role : "Invité"); unProg.casting.append(unGars) }
            else if (didEndElement == "date")               { unProg.annee = parsedValue }
            else if (didEndElement == "year")               { unProg.annee = parsedValue }
            else if (didEndElement == "icon")               { /* Nothing to do */ }
            else if (didEndElement == "country")            { unProg.pays = parsedValue }
            else if (didEndElement == "audio")              { /* Nothing to do */ }
            else if (didEndElement == "stereo")             { unProg.audio = parsedValue }
            else if (didEndElement == "video")              { /* Nothing to do */ }
            else if (didEndElement == "aspect")             { unProg.aspect = parsedValue }
            else if (didEndElement == "language")           { unProg.soustitre = parsedValue }
            else if (didEndElement == "subtitles")          { /* Nothing to do */ }
            else if (didEndElement == "previously-shown")   { unProg.inedit = false }
            else if (didEndElement == "premiere")           { unProg.inedit = true }
            else if (didEndElement == "rating")             { unProg.ratingCSA = valSvg }
            else if (didEndElement == "star-rating")        { unProg.ratingTelerama = valSvg }
            else if (didEndElement == "value")              { valSvg = parsedValue }
            else if (didEndElement == "length")             { unProg.duree = parsedValue + " " + unProg.duree }
            else if (didEndElement == "quality")            { unProg.video = parsedValue }
            else if (didEndElement == "episode-num")        { unProg.episode = parsedValue }
            else if (didEndElement == "tv")                 { /* Nothing to do */ }
                
            else if (didEndElement == "programme")          { if (mesChainesCurrent.contains(unProg.chaine)) { Programme.append(unProg) } }
                
            else { print ("Balise de programme inconnue : " + didEndElement) }
        }
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print("###" + parseError.localizedDescription)
    }
    
    
}
