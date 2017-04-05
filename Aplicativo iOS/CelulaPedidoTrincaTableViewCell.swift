//
//  CelulaPedidoTrincaTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 18/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class CelulaPedidoTrincaTableViewCell : UITableViewCell {
    @IBOutlet weak var numero: UILabel!
    @IBOutlet weak var texto: UILabel!
    @IBOutlet weak var sim_ou_nao: UILabel!
    @IBOutlet weak var quantidade: UILabel!
    @IBOutlet weak var imagem_sim: UIImageView!
    @IBOutlet weak var imagem_nao: UIImageView!
}