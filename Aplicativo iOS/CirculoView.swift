//
//  CirculoView.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class CirculoView : UIView {
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
        let circleLayer = CAShapeLayer()
        circleLayer.bounds = CGRect(x: 0.0, y: 0.0, width: self.bounds.size.width, height: self.bounds.size.height)
        circleLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        circleLayer.path = path.cgPath
        circleLayer.strokeColor = self.tintColor.cgColor
        circleLayer.lineWidth = 2.0
        circleLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(circleLayer)
    }
}
