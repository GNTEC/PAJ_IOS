//
//  CelulaPedidoComplexaPinturaTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 18/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class CelulaPedidoComplexaPinturaTableViewCell : UITableViewCell {
    @IBOutlet weak var label_pintura: UILabel!
    @IBOutlet weak var label_cor: UILabel!
    @IBOutlet weak var label_tipo: UILabel!
    @IBOutlet weak var label_acabamento: UILabel!
    @IBOutlet weak var imagem_fornece_tintas: UIImageView!
    @IBOutlet weak var imagem_nao_pintara: UIImageView!
    @IBOutlet weak var imagem_sim: UIImageView!
    @IBOutlet weak var imagem_nao: UIImageView!
    @IBOutlet weak var constraint_altura_painel_fornece_tintas: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_painel_nao_pintara: NSLayoutConstraint!
}