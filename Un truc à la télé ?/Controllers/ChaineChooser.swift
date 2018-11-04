//
//  ChaineChooser.swift
//  Un truc à la télé ?
//
//  Created by Cyril Delamare on 09/09/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class CellChaine : UICollectionViewCell {
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var logo: UIImageView!
}


class ChaineChooser: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    var modif : Bool = false
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func closeView(gesture: UISwipeGestureRecognizer) -> Void {
        if (modif) {
            saveMesChaines()
            db.DataRead()
        }
        
        dismiss(animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return db.Chaines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellChaine", for: indexPath as IndexPath) as! CellChaine
        
        cell.logo.image = getImage((db.Chaines[db.ChainesArray[indexPath.row]] as! Chaine).icone)
        cell.nom.text = (db.Chaines[db.ChainesArray[indexPath.row]] as! Chaine).nom
        
        if (mesChainesCurrent.contains(db.ChainesArray[indexPath.row])) {
            cell.nom.textColor = UIColor.blue
            cell.backgroundColor = UIColor.white
        }
        else {
            cell.nom.textColor = UIColor.black
            cell.backgroundColor = UIColor.lightGray
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell : CellChaine = collectionView.cellForItem(at: indexPath) as! CellChaine
        
        if (cell.nom.textColor == UIColor.blue) {
            cell.nom.textColor = UIColor.black
            cell.backgroundColor = UIColor.lightGray
            mesChainesCurrent.remove(at: mesChainesCurrent.index(of: db.ChainesArray[indexPath.row])!)

        }
        else {
            cell.nom.textColor = UIColor.blue
            mesChainesCurrent.append(db.ChainesArray[indexPath.row])
            cell.backgroundColor = UIColor.white
        }

        modif = true
    }
}
