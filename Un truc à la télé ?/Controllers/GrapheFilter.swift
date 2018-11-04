//
//  GrapheFilter.swift
//  Un truc à la télé ?
//
//  Created by Cyril Delamare on 23/09/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class GrapheFilter: UIView {
    
    var predicat : String = ""
    var arguments : [Any] = []
    var filtre : FiltreNoeud = FiltreNoeud()
    var initialized = false
    var vue : FilterDetails = FilterDetails()
    
    let xmax : Int = 974
    let hunit : Int = 30
    
    override func draw(_ dirtyRect: CGRect) {
        for subview in (self.subviews).reversed() {
            subview.removeFromSuperview()
        }
        
        super.draw(dirtyRect)
        let _ : Int = drawFilter(filtre: filtre, ystart: 20, profondeur: 0, index: "0")
    }
    
    
    ////////////////////////
    // Drawing management //
    ////////////////////////
    func drawFilter(filtre: FiltreNoeud, ystart : Int, profondeur : Int, index: String) -> Int {
        var size : Int = ystart
        
        if (filtre.operateur == "UNITAIRE") {
            drawUnit(y: ystart, balise: filtre.balise, operation: filtre.operation, valeur: filtre.valeur, profondeur: profondeur, index: index)
            return 50
        }
        else {
            size = size + 25
            var cpt : Int = 0
            for unPredicat in filtre.operandes {
                size = size + drawFilter(filtre: unPredicat, ystart: size, profondeur: profondeur+1, index: index + "." + String(cpt))
                cpt = cpt + 1
            }
            
            drawOperation(y: ystart, h: size-ystart, profondeur : profondeur, type : filtre.operateur, index: index)
            return size-ystart+25
        }
    }
    
    func drawOperation(y: Int, h: Int, profondeur: Int, type: String, index: String) {
        let x : Int = 20 + (100 * profondeur)
        
        let uneView : UIView = UIView(frame: CGRect(x: x, y: y, width: xmax-(20*profondeur)-x, height :h))
        uneView.backgroundColor = UIColor.white
        uneView.layer.cornerRadius = 10.0
        uneView.layer.borderWidth = 0.5
        uneView.layer.borderColor = UIColor.black.cgColor
        uneView.layer.shadowColor = UIColor.gray.cgColor
        uneView.layer.shadowOffset = CGSize(width: 5, height: 5)
        uneView.layer.shadowOpacity = 0.7
        uneView.layer.shadowRadius = 4.0
        self.addSubview(uneView)
        self.sendSubviewToBack(uneView)
        
        let unOperateur : UILabel = UILabel(frame: CGRect(x: x+20, y: y+10, width: 80, height: 28))
        unOperateur.text = type
        unOperateur.textColor = UIColor.black
        unOperateur.font = UIFont.boldSystemFont(ofSize: 32.0)
        self.addSubview(unOperateur)

        self.addSubview(drawButton(x: x+10, y: y+55, width: 20, text: "-", action: #selector(removeUnit), index: index))
        self.addSubview(drawButton(x: x+35, y: y+55, width: 30, text: "ed", action: #selector(editUnit), index: index))
        self.addSubview(drawButton(x: x+70, y: y+55, width: 20, text: "+", action: #selector(addUnit), index: index))
    }
    
    func drawUnit(y: Int, balise: String, operation: String, valeur : String, profondeur : Int, index: String) {
        let x : Int = 20 + (100 * profondeur)
        
        let uneView : UIView = UIView(frame: CGRect(x: x, y: y, width: xmax-(20*profondeur)-x, height :hunit))
        uneView.backgroundColor = UIColor.white
        uneView.layer.cornerRadius = 10.0
        uneView.layer.borderWidth = 0.5
        uneView.layer.borderColor = UIColor.black.cgColor
        uneView.layer.shadowColor = UIColor.gray.cgColor
        uneView.layer.shadowOffset = CGSize(width: 5, height: 5)
        uneView.layer.shadowOpacity = 0.7
        uneView.layer.shadowRadius = 4.0
        self.addSubview(uneView)

        let uneBalise : UILabel = UILabel(frame: CGRect(x: x+10, y: y+7, width: 180, height: 20))
        uneBalise.text = balisesTable[baliseIndex[balise] as? Int ?? 0].description
        uneBalise.textColor = UIColor.blue
        uneBalise.font = UIFont.boldSystemFont(ofSize: 13.0)
        self.addSubview(uneBalise)
        
        let uneOperation : UILabel = UILabel(frame: CGRect(x: x+200, y: y+7, width: 100, height: 20))
        uneOperation.text = operateursListe[operation] as? String ?? ""
        uneOperation.textColor = UIColor.black
        uneOperation.font = UIFont.systemFont(ofSize: 13.0)
        self.addSubview(uneOperation)
        
        let uneValeur : UILabel = UILabel(frame: CGRect(x: x+300, y: y+7, width: 200, height: 20))
        uneValeur.text = valeur
        uneValeur.textColor = UIColor.blue
        uneValeur.font = UIFont.systemFont(ofSize: 13.0)
        self.addSubview(uneValeur)
        
        self.addSubview(drawButton(x: xmax-(20*profondeur)-90, y: y+5, width: 20, text: "-", action: #selector(removeUnit), index: index))
        self.addSubview(drawButton(x: xmax-(20*profondeur)-62, y: y+5, width: 30, text: "ed", action: #selector(editUnit), index: index))
        self.addSubview(drawButton(x: xmax-(20*profondeur)-25, y: y+5, width: 20, text: "+", action: #selector(addUnit), index: index))
    }
    
    func drawButton(x: Int, y: Int, width: Int, text: String, action: Selector, index: String) -> UIButton {
        let button = UIButton(frame: CGRect(x: x, y: y, width: width, height: hunit-10))
        
        button.setTitle(text, for: .normal)
        button.restorationIdentifier = index
        button.addTarget(self, action: action, for: .touchUpInside)

        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 12.0)

        button.layer.cornerRadius = 10.0
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4.0

        return button
    }
    
    ////////////////////////
    // Actions management //
    ////////////////////////
    @objc func removeUnit(sender: UIButton!) {
        self.vue.removeSubFilter(index: sender.restorationIdentifier!)
    }
    
    @objc func editUnit(sender: UIButton!) {
        self.vue.editSubFilter(index: sender.restorationIdentifier!)
    }
    
    @objc func addUnit(sender: UIButton!) {
        self.vue.addSubFilter(index: sender.restorationIdentifier!)
    }
    
    func refresh(filtreFrais : FiltreNoeud) {
        filtre = filtreFrais
        setNeedsDisplay()
    }
}
