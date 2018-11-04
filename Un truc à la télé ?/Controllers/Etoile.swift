//
//  Etoile.swift
//  Un truc à la télé ?
//
//  Created by Cyril DELAMARE on 03/11/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class Etoile: UIView {
    
    var nb : Int = 0
    
    override func draw(_ dirtyRect: CGRect) {
        super.draw(dirtyRect)
        
        if (nb > 4) { traceArc(debut: (6/3) * .pi, fin: (7/3) * .pi, couleur: UIColor(displayP3Red: 0, green: 1.0, blue: 0, alpha: 1)) }
        if (nb > 3) { traceArc(debut: (5/3) * .pi, fin: (6/3) * .pi, couleur: UIColor(displayP3Red: 0, green: 0.8, blue: 0, alpha: 1)) }
        if (nb > 2) { traceArc(debut: (4/3) * .pi, fin: (5/3) * .pi, couleur: UIColor(displayP3Red: 0, green: 0.6, blue: 0, alpha: 1)) }
        if (nb > 1) { traceArc(debut: (3/3) * .pi, fin: (4/3) * .pi, couleur: UIColor(displayP3Red: 0, green: 0.4, blue: 0, alpha: 1)) }
        
        if (nb > 0) {
           #imageLiteral(resourceName: "star-icon.png").draw(in: CGRect(x: 10.0, y:  10.0, width: 36.0, height: 36.0))
           traceArc(debut: (2/3) * .pi, fin: (3/3) * .pi, couleur: UIColor(displayP3Red: 0, green: 0.2, blue: 0, alpha: 1))
        }
    }
    
    func traceArc(debut : CGFloat, fin:CGFloat, couleur : UIColor) {
        let path : UIBezierPath = UIBezierPath()
        
        UIColor.white.setStroke()
        couleur.setFill()
        
        path.lineWidth = 5.0
        path.addArc(withCenter: CGPoint(x: 28.0, y: 28.0), radius: 25.0, startAngle: debut, endAngle: fin, clockwise: true)
        path.addArc(withCenter: CGPoint(x: 28.0, y: 28.0), radius: 21.0, startAngle: fin, endAngle: debut, clockwise: false)
        path.addArc(withCenter: CGPoint(x: 28.0, y: 28.0), radius: 25.0, startAngle: debut, endAngle: fin, clockwise: true)
        
        path.stroke()
        path.fill()
    }
    
    func setEtoiles(nbEtoiles: Int){
        nb = nbEtoiles
    }
}
