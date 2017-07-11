//
//  CelulaOrcamentoChecklistComplexaAmbienteTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 17/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

import UIKit
class CelulaOrcamentoChecklistComplexaAmbienteTableViewCell: UITableViewCell {

    @IBOutlet weak var label_ambiente: UILabel!
    @IBOutlet weak var label_altura: UILabel!
    @IBOutlet weak var label_largura: UILabel!
    @IBOutlet weak var label_comprimento: UILabel!
    @IBOutlet weak var label_massa: UILabel!
    @IBOutlet weak var botao_sim: UIButton!
    @IBOutlet weak var botao_nao: UIButton!
    @IBOutlet weak var constraint_altura_altura: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_comprimento: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_massa: NSLayoutConstraint!
    
    var itemOrcamento: ItemOrcamentoComplexoDetalhe?
    
    @IBAction func onCliqueSim(_ sender: AnyObject) {
        
        botao_sim.isSelected = true
        botao_nao.isSelected = false
        
        itemOrcamento?.checklistAprovado = true
    }
    
    @IBAction func onCliqueNao(_ sender: AnyObject) {
        
        botao_sim.isSelected = false
        botao_nao.isSelected = true
        
        itemOrcamento?.checklistAprovado = false
    }
}
