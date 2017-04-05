//
//  CelulaLojaProdutosTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class CelulaLojaProdutosTableViewCell: UITableViewCell {
    @IBOutlet weak var imagemProduto: UIImageView!
    @IBOutlet weak var descricaoProduto: UILabel!
    @IBOutlet weak var valorUnitario: UILabel!
    @IBOutlet weak var botaoConfirmar: UIButton!
    @IBOutlet weak var descricaoQuantidade: UILabel!
    @IBOutlet weak var descricaoProduto2: UILabel!
    @IBOutlet weak var label_quantidade: UILabel!
    @IBOutlet weak var activity_imagem_produto: UIActivityIndicatorView!
    @IBOutlet weak var botao_mais: UIButton!
    @IBOutlet weak var botao_menos: UIButton!
    
    var imagem: Foundation.Data?
    var produto: Produto?
    
    @IBAction func onSelecionouMenos(_ sender: AnyObject) {
        
        if (produto?.quantidade > 0 ) {
            produto?.quantidade -= 1
        }
        
        label_quantidade.text = "\(produto!.quantidade)"
    }
    
    @IBAction func onSelecionouMais(_ sender: AnyObject) {
        
        produto?.quantidade += 1
        
        label_quantidade.text = "\(produto!.quantidade)"
    }
}
