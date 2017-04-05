//
//  CelulaPedidoComplexaAmbienteTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 18/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class CelulaPedidoComplexaAmbienteTableViewCell: UITableViewCell {
    @IBOutlet weak var label_ambiente: UILabel!
    @IBOutlet weak var label_altura: UILabel!
    @IBOutlet weak var label_largura: UILabel!
    @IBOutlet weak var label_comprimento: UILabel!
    @IBOutlet weak var label_massa: UILabel!
    @IBOutlet weak var imagem_sim: UIImageView!
    @IBOutlet weak var imagem_nao: UIImageView!
    @IBOutlet weak var constraint_altura_altura: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_comprimento: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_massa: NSLayoutConstraint!
}