//
//  Helper.swift
//  Un truc à la télé ?
//
//  Created by Cyril Delamare on 08/09/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

let AppDir     : URL               = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let ChainesDir : URL               = AppDir.appendingPathComponent("chaines")
let XMLDir     : URL               = AppDir.appendingPathComponent("xml")
let ConfigDir  : URL               = AppDir.appendingPathComponent("config")

var Master     : MasterViewController = MasterViewController()

var mesChainesTNT      : [String] = []
var mesChainesCable    : [String] = []
var mesChainesCurrent  : [String] = mesChainesTNT

var currentSource      : Int = csteTNT


func checkDirectories()
{
    do
    {
        print("Directory path = \(AppDir)")
        
        if (FileManager.default.fileExists(atPath: ChainesDir.path) == false) {
            try FileManager.default.createDirectory(at: ChainesDir, withIntermediateDirectories: false, attributes: nil)
        }
        
        if (FileManager.default.fileExists(atPath: XMLDir.path) == false) {
            try FileManager.default.createDirectory(at: XMLDir, withIntermediateDirectories: false, attributes: nil)
        }
        
        if (FileManager.default.fileExists(atPath: ConfigDir.path) == false) {
            try FileManager.default.createDirectory(at: ConfigDir, withIntermediateDirectories: false, attributes: nil)
        }
    }
    catch let error as NSError { print(error.localizedDescription); }
}

func loadConfig() {
    if (FileManager.default.fileExists(atPath: ConfigDir.appendingPathComponent("mesChainesTNT.plist").path)) {
        mesChainesTNT = NSKeyedUnarchiver.unarchiveObject(withFile: ConfigDir.appendingPathComponent("mesChainesTNT.plist").path) as! [String]
    }
    if (FileManager.default.fileExists(atPath: ConfigDir.appendingPathComponent("mesChainesCable.plist").path)) {
        mesChainesCable = NSKeyedUnarchiver.unarchiveObject(withFile: ConfigDir.appendingPathComponent("mesChainesCable.plist").path) as! [String]
    }
}

func saveMesChaines() {
    if (currentSource == csteTNT) {
        NSKeyedArchiver.archiveRootObject(mesChainesCurrent, toFile: ConfigDir.appendingPathComponent("mesChainesTNT.plist").path)
        mesChainesTNT = mesChainesCurrent
    }
    else {
        NSKeyedArchiver.archiveRootObject(mesChainesCurrent, toFile: ConfigDir.appendingPathComponent("mesChainesCable.plist").path)
        mesChainesCable = mesChainesCurrent
    }
}

func loadFilters() {
    if (FileManager.default.fileExists(atPath: ConfigDir.appendingPathComponent("Filtres").path)) {
        filtres = NSKeyedUnarchiver.unarchiveObject(withFile: ConfigDir.appendingPathComponent("Filtres").path) as! [Filtre]
    }
}

func saveFilters() {
    NSKeyedArchiver.archiveRootObject(filtres, toFile: ConfigDir.appendingPathComponent("Filtres").path)
}

func getImage(_ url: String) -> UIImage
{
    if (url == "") { return UIImage() }
    
    let pathToImage = ChainesDir.appendingPathComponent(URL(string: url)!.lastPathComponent).path
    
    if (FileManager.default.fileExists(atPath: pathToImage)) {
        return UIImage(contentsOfFile: pathToImage)!
    }
    else {
        let imageData = NSData(contentsOf: URL(string: url)!)
        if (imageData != nil) {
            imageData?.write(toFile: pathToImage, atomically: true)
            return UIImage(data: imageData! as Data)!
        }
    }
    
    return UIImage()
}

func loadImage(_ url: String) -> UIImage
{
    if (url == "") { return UIImage() }
    
    let imageData = NSData(contentsOf: URL(string: url)!)
    if (imageData != nil) { return UIImage(data: imageData! as Data)!}
    
    return UIImage()
}

func majuscule(mot : String) -> String {
    return mot.prefix(1).uppercased() + mot.dropFirst()
}
