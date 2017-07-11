//
//  OrcamentoNovoClienteViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 18/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

import UIKit
class OrcamentoNovoClienteViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var imagem_nome: FAImageView!
    @IBOutlet weak var imagem_cep: FAImageView!
    @IBOutlet weak var imagem_email: FAImageView!
    @IBOutlet weak var imagem_telefone: FAImageView!
    @IBOutlet weak var edit_nome: UITextField!
    @IBOutlet weak var edit_cep: VSTextField!
    @IBOutlet weak var edit_email: UITextField!
    @IBOutlet weak var edit_telefone: VSTextField!
    
    var contexto_orcamento : ContextoOrcamento?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let size = CGSize(width: 30, height: 30)
        self.imagem_nome.image = UIImage(icon: "icon-user", backgroundColor: self.corCinzaFundoBullet(), iconColor: self.corCinzaBullet(), iconScale: 1.0, andSize: size)
        self.imagem_cep.image = UIImage(icon: "icon-map-marker", backgroundColor: self.corCinzaFundoBullet(), iconColor: self.corCinzaBullet(), iconScale: 1.0, andSize: size)
        self.imagem_email.image = UIImage(icon: "icon-envelope", backgroundColor: self.corCinzaFundoBullet(), iconColor: self.corCinzaBullet(), iconScale: 1.0, andSize: size)
        self.imagem_telefone.image = UIImage(icon: "icon-phone", backgroundColor: self.corCinzaFundoBullet(), iconColor: self.corCinzaBullet(), iconScale: 1.0, andSize: size)
        
        title = "Novo Cliente"
        
        edit_cep.setFormatting("#####-###", replacementChar: "#")
        edit_telefone.setFormatting("(##)#####-####", replacementChar: "#")
        
        #if DEBUG
            edit_cep.text = ("05396345");
            edit_nome.text = ("Jose da Silva");
            edit_email.text = ("jose@uol.com.br");
            edit_telefone.text = ("(11) 4556-3763");
        #endif
        
        edit_nome.delegate = self;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == edit_nome {
            
            textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
        }
        
        return false
    }

    @IBAction func onCriarCliente(_ sender: AnyObject) {
        
        let api = PinturaAJatoApi()
        
        let parametros : [String:AnyObject] = [
            "cep": edit_cep.text! as AnyObject,
            "nome" : edit_nome.text! as AnyObject,
            "email" : edit_email.text! as AnyObject,
            "telefone" : edit_telefone.text! as AnyObject,
            "id_tipo_cadastro": "3" as AnyObject,
            "id_franquia" : "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.incluirCliente(self.navigationController!.view, parametros: parametros, sucesso: { (objeto: Cliente?, resultado: Resultado?) -> Bool in
            
            if resultado!.erro {
            
                AvisoProcessamento.mensagemErroGenerico(resultado?.mensagem)
                
                return false
            }
            
            let mensagem = String(format: "Cliente incluído com sucesso\nid: #%06d\nNome: %@\nTelefone: %@\nCEP: %@", objeto!.id_cliente, objeto!.nome!, objeto!.telefone!, objeto!.cep!)
            
            AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: mensagem, destino: { 
                
                self.contexto_orcamento = ContextoOrcamento()
                
                self.contexto_orcamento?.id_cliente = objeto!.id_cliente
                
                self.performSegue(withIdentifier: "SegueNovoClienteParaOrcamentoPrincipal", sender: self)
            })
          
            return true
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueNovoClienteParaOrcamentoPrincipal" {
            
            let vc = segue.destination as! OrcamentoPrincipalViewController
            
            vc.defineContexto(self.contexto_orcamento)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
