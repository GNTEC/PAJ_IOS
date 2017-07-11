//
//  Extensions.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

extension RangeReplaceableCollection where Iterator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(_ object : Iterator.Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}

extension UIViewController  {
    
    func obtemString(_ idString: String?) -> String {
        return NSLocalizedString(idString!, comment: "")
    }
}


extension UIView  {
    
    func obtemString(_ idString: String?) -> String {
        return NSLocalizedString(idString!, comment: "")
    }
}

extension UIButton {
    
    func seleciona(_ adiciona:Bool) {
        
        self.isHighlighted = adiciona
        
        if adiciona {
            adicionaBorda()
        }
        else {
            removeBorda()
        }
        
    }
    
    func adicionaBorda() {
        
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.black.cgColor;
        
    }
    func removeBorda() {

        self.layer.borderColor = UIColor.clear.cgColor;
        
    }
}
