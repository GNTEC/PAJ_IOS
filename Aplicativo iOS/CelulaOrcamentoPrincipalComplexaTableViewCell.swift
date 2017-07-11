//
//  CelulaOrcamentoPrincipalComplexaTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 19/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class CelulaOrcamentoPrincipalComplexaTableViewCell : UITableViewCell {
    
    @IBOutlet weak var label_indice: UILabel!
    @IBOutlet weak var label_nome_item: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var view = self.superview
        
        while view != nil && !(view is UITableView) {
            view = view?.superview
        }
        
        view?.endEditing(true)
    }
}
