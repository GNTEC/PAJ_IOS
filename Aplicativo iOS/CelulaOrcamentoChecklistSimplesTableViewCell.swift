//
//  CelulaOrcamentoChecklistSimplesTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 17/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation


import UIKit
class CelulaOrcamentoChecklistSimplesTableViewCell: UITableViewCell {
    @IBOutlet weak var numero: UILabel!
    @IBOutlet weak var texto: UILabel!
    @IBOutlet weak var botao_sim: UIButton!
    @IBOutlet weak var botao_nao: UIButton!
    
    var itemOrcamento: ItemOrcamentoSimples?
    
    @IBAction func onCliqueSim(_ sender: AnyObject) {

        botao_sim.isSelected = true
        botao_nao.isSelected = false
        
        itemOrcamento?.checkListAprovado = true
    }
    
    @IBAction func onCliqueNao(_ sender: AnyObject) {

        botao_sim.isSelected = false
        botao_nao.isSelected = true
        
        itemOrcamento?.checkListAprovado = false
    }
}
