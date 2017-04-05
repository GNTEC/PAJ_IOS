//
//  CelulaOrcamentoChecklistComplexaPinturaTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 17/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class CelulaOrcamentoChecklistComplexaPinturaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label_pintura: UILabel!
    @IBOutlet weak var label_cor: UILabel!
    @IBOutlet weak var label_tipo: UILabel!
    @IBOutlet weak var label_acabamento: UILabel!
    @IBOutlet weak var imagem_fornece_tintas: UIImageView!
    @IBOutlet weak var imagem_nao_pintara: UIImageView!
    @IBOutlet weak var botao_sim: UIButton!
    @IBOutlet weak var botao_nao: UIButton!
    @IBOutlet weak var constraint_altura_painel_fornece_tintas: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_painel_nao_pintara: NSLayoutConstraint!
    
    var configuracaoTinta: ConfiguracaoTinta?
    
    @IBAction func onCliqueSim(_ sender: AnyObject) {
        
        botao_sim.isSelected = true
        botao_nao.isSelected = false
        
        configuracaoTinta?.checklistAprovado = true
    }
    
    @IBAction func onCliqueNao(_ sender: AnyObject) {
        
        botao_sim.isSelected = false
        botao_nao.isSelected = true
        
        configuracaoTinta?.checklistAprovado = false
    }
}
