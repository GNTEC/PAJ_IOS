//
//  CelulaComplexaOrcamentoConfirmacaoAmbienteTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class CelulaComplexaOrcamentoConfirmacaoAmbienteTableViewCell : UITableViewCell {
    @IBOutlet weak var label_tipo_pintura: UILabel!
    
    @IBOutlet weak var label_ambiente: UILabel!
    @IBOutlet weak var label_altura: UILabel!
    @IBOutlet weak var label_largura: UILabel!
    @IBOutlet weak var label_comprimento: UILabel!
    @IBOutlet weak var label_massa: UILabel!
    @IBOutlet weak var label_valor: UILabel!
    
    @IBOutlet weak var constraint_altura_altura: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_comprimento: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_massa: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_painel: NSLayoutConstraint!
}