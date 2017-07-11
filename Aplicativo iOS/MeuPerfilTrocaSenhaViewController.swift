//
//  MeuPerfilTrocaSenhaViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class MeuPerfilTrocaSenhaViewController: UIViewController {
    
    @IBOutlet weak var text_senha_atual: UITextField!
    @IBOutlet weak var text_nova_senha: UITextField!
    @IBOutlet weak var text_confirma_nova_senha: UITextField!
    
    @IBOutlet weak var botao_confirmar: UIButton!
    @IBAction func onConfirmar(_ sender: AnyObject) {
        var mensagem: String?
    
        if text_nova_senha.text != text_confirma_nova_senha.text {
            mensagem = "Confirmação não coincide com nova senha"
        }
        
        if text_confirma_nova_senha.text!.isEmpty {
            mensagem = "Confirmação de senha está vazia"
        }

        if text_nova_senha.text!.isEmpty {
            mensagem = "Nova senha está vazia"
        }
        
        if text_senha_atual.text!.isEmpty {
            mensagem = "Senha atual está vazia"
        }
    
        if mensagem != nil {
            AvisoProcessamento.mensagemErroGenerico(mensagem)
            return
        }
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            //"id" : String.init(format:"%d", PinturaAJatoApi.obtemFranqueado()!.id),
            //"senhaAtual" : text_senha_atual.text!,
            //"novaSenha" : text_nova_senha.text!,
            //"confirmaNovaSenha" : text_confirma_nova_senha.text!
            "email" : PinturaAJatoApi.obtemFranqueado()!.email! as AnyObject,
            "senha_nova" : text_nova_senha.text! as AnyObject,
            "senha_atual" : text_senha_atual.text! as AnyObject,
            "senha_confirma" : text_confirma_nova_senha.text! as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.trocarSenhaApp(self.navigationController!.view, parametros:parametros, sucesso:{ (objeto:Resultado?) -> Bool in
        
            AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: objeto?.mensagem, destino: {
                if objeto?.erro == false {
                    self.navigationController?.popViewController(animated: true)
                }
            })
                
            return true
        })
    }
    
    override func viewDidLoad() {
        
        let size: CGSize = CGSize(width: 30, height: 30)
        let image = UIImage.init(icon:"icon-check", backgroundColor: UIColor.clear, iconColor: UIColor.white, iconScale: 1.0, andSize: size)
        botao_confirmar!.setImage(image, for: UIControlState())

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
