//
//  LojaAdicionarCartaoViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class LojaAdicionarCartaoViewController: UIViewController {
    @IBOutlet weak var imagem_nome: UIImageView!
    @IBOutlet weak var imagem_numero: UIImageView!
    @IBOutlet weak var imagem_validade: UIImageView!
    @IBOutlet weak var imagem_cvv: UIImageView!
    @IBOutlet weak var botao_check: UIButton!
    
    @IBOutlet weak var edit_nome_portador: UITextField!
    @IBOutlet weak var edit_numero_cartao: VSTextField!
    @IBOutlet weak var edit_validade: VSTextField!
    @IBOutlet weak var edit_cvv: VSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imagem_nome.image = self.iconeBotao("user", cor: self.corCinzaBullet(), corFundo: self.corCinzaFundoBullet())
        self.imagem_numero.image = self.iconeBotao("credit-card", cor: self.corCinzaBullet(), corFundo: self.corCinzaFundoBullet())
        self.imagem_validade.image = self.iconeBotao("calendar", cor: self.corCinzaBullet(), corFundo: self.corCinzaFundoBullet())
        self.imagem_cvv.image = self.iconeBotao("lock", cor: self.corCinzaBullet(), corFundo: self.corCinzaFundoBullet())
        botao_check!.setImage(self.iconeBotao("check", cor: UIColor.white, corFundo: self.corLaranja()), for: UIControlState())
        
        edit_numero_cartao.setFormatting("####-####-####-####", replacementChar: "#")
        edit_validade.setFormatting("##/##", replacementChar: "#")
        edit_cvv.setFormatting("###", replacementChar: "#")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func onConfirmar(_ sender: AnyObject) {
        
        var mensagem: String?
        
        if edit_cvv.text!.isEmpty {
            mensagem = "Código de segurança não pode estar vazio"
        }
        if edit_validade.text!.isEmpty {
            mensagem = "Validade não pode estar vazia"
        }
        if edit_numero_cartao.text!.isEmpty {
            mensagem = "Número do cartão não pode estar vazio"
        }
        if edit_nome_portador.text!.isEmpty {
            mensagem = "Nome do portador não pode estar vazio"
        }

        let numero = edit_numero_cartao.text!
        let tipo = numero.substring(to: numero.characters.index(numero.startIndex, offsetBy: 1))
        
        if tipo != "4" && tipo != "5" {
            mensagem = "Cartão inválido. Deve ser Visa ou Mastercard"
        }
        
        if mensagem != nil {
            AvisoProcessamento.mensagemErroGenerico(mensagem)
            return
        }
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            
            "id_franquia" : String.init(format:"%d", PinturaAJatoApi.obtemFranqueado()!.id_franquia) as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
            "nome" : edit_nome_portador.text! as AnyObject,
            "numero" : numero as AnyObject,
            "validade" : edit_validade.text! as AnyObject,
            "bandeira" : tipo == "4" ? "visa" : "mastercard" as AnyObject,
            "cvv" : edit_cvv.text!
        ]
        
        api.incluirCartao(self.navigationController!.view, parametros: parametros, sucesso: { (objeto:Resultado?) -> Bool in
        
            AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: objeto?.mensagem, destino: {
                if objeto?.erro == false {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
            return true
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
