//
//  PedidoDetalheFotoViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 06/11/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class PedidoDetalheFotoViewController : UIViewController {
    
    @IBOutlet weak var imagem_detalhe_foto: UIImageView!
    @IBOutlet weak var mensagem_erro_imagem: UILabel!
    @IBOutlet weak var activity_imagem: UIActivityIndicatorView!
    
    var contexto: ContextoPedidoDetalheFoto?
    
    func defineContexto(_ contexto: ContextoPedidoDetalheFoto?) {
        self.contexto = contexto
    }
    
    override func viewDidLoad() {
        
        self.title = contexto?.titulo
        
        // Imagem recem adicionada (sem url ainda)
        if contexto?.urlImagem == nil && contexto?.imagem != nil {
            self.activity_imagem.stopAnimating()
            self.imagem_detalhe_foto.image = contexto?.imagem
            self.imagem_detalhe_foto.isHidden = false
        }
        else {
            Imagem.carregaImagemUrlAssincrona(contexto!.urlImagem!,
                                              sucesso: { (imagem) in
            
                                                self.activity_imagem.stopAnimating()
                                                self.imagem_detalhe_foto.image = imagem
                                                self.imagem_detalhe_foto.isHidden = false
                
                }, falha: { (url) in
                    self.activity_imagem.stopAnimating()
                    self.mensagem_erro_imagem.isHidden = false
            })
        }
    }
}
