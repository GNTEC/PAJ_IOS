//
//  EsqueciSenhaViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 28/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class EsqueciSenhaViewController : UIViewController {
    
    @IBOutlet weak var imagem_email: FAImageView!
    @IBOutlet weak var text_email: UITextField!
    
    override func viewDidLoad() {

        self.imagem_email.image = UIImage(icon:"icon-envelope", backgroundColor: corCinzaFundoBullet(), iconColor: corCinzaBullet(), iconScale: 1.0, andSize: CGSize(width: 30, height:  30))

    }
    
    @IBAction func onSolicitarSenha(_ sender: AnyObject) {
        
        if text_email.text == nil || text_email.text!.isEmpty {
            
            AvisoProcessamento.mensagemErroGenerico("Email não pode estar vazio")
            
            return
        }
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "email" : text_email.text! as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
            ]
        
        api.lembrarSenha(self.navigationController!.view, parametros: parametros, sucesso: { (resultado: Resultado?) -> Bool in
          
            if resultado?.erro == false {
                AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: "Email de instruções enviado!", destino: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
            
            return true
        })
    }
}
