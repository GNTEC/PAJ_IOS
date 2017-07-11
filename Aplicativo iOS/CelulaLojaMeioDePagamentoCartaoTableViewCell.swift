//
//  CelulaLojaMeioDePagamentoCartaoTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

typealias efetivaRemoverCartao = (_ cartao: Cartao?) -> Void;

class CelulaLojaMeioDePagamentoCartaoTableViewCell: UITableViewCell {
    @IBOutlet weak var imagemBandeira: UIImageView!
    @IBOutlet weak var nomeBandeira: UILabel!
    @IBOutlet weak var numCartao: UILabel!
    @IBOutlet weak var imagemEditar: UIImageView!
    
    var cartao: Cartao?
    var efetivaRemover: efetivaRemoverCartao?
    
    override func awakeFromNib() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        
        imagemEditar.isUserInteractionEnabled = true
        imagemEditar.addGestureRecognizer(gesture)
    }
    
    func tap(_ sender: UITapGestureRecognizer) {
    
        if sender.state == .ended {

            if cartao == nil {
                return
            }
    
            self.efetivaRemover?(self.cartao)
        }
    }
}
