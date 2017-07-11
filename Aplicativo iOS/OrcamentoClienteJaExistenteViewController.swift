//
//  OrcamentoClienteJaExistenteViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 18/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

import UIKit
class OrcamentoClienteJaExistenteViewController: UIViewController {
    @IBOutlet weak var imagem_email: FAImageView!
    @IBOutlet weak var imagem_cpf: FAImageView!
    @IBOutlet weak var imagem_cnpj: FAImageView!
    @IBOutlet weak var edit_email: UITextField!
    @IBOutlet weak var edit_cpf: UITextField!
    @IBOutlet weak var edit_cnpj: UITextField!
    
    var contexto_orcamento: ContextoOrcamento?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let size = CGSize(width: 24, height: 24)
        self.imagem_email.image = UIImage(icon: "icon-envelope", backgroundColor: self.corCinzaFundoBullet(), iconColor: self.corCinzaBullet(), iconScale: 1.0, andSize: size)
        self.imagem_cpf.image = UIImage(icon: "icon-list-alt", backgroundColor: self.corCinzaFundoBullet(), iconColor: self.corCinzaBullet(), iconScale: 1.0, andSize: size)
        self.imagem_cnpj.image = UIImage(icon: "icon-building", backgroundColor: self.corCinzaFundoBullet(), iconColor: self.corCinzaBullet(), iconScale: 1.0, andSize: size)
        
#if DEBUG
        //edit_email.text = ("jose@uol.com.br");
        edit_email.text = ("anifocci@gmail.com");
        edit_cpf.text = ("000.000.000-00");
#endif
        
        title = "Cliente Já Existente"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func onEscolheuCliente(_ sender: AnyObject) {
        
        var pesquisa: String
        
        if !edit_email.text!.isEmpty {
            pesquisa = "Email"
        }
        else if !edit_cpf.text!.isEmpty {
            pesquisa = "Cpf"
        }
        else if !edit_cnpj.text!.isEmpty {
            pesquisa = "Cnpj"
        }
        else {
            AvisoProcessamento.mensagemErroGenerico("Favor informar um campo para pesquisa.")
            return
        }
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "email": edit_email.text! as AnyObject,
            "cpf" : edit_cpf.text! as AnyObject,
            "cnpj": edit_cnpj.text! as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.buscarClientePor(self.navigationController!.view, tipo: pesquisa, parametros: parametros, sucesso: { (objeto:Cliente?, resultado: Resultado?) -> Bool in
            
            if !resultado!.erro {
                self.contexto_orcamento = ContextoOrcamento()
                
                self.contexto_orcamento?.id_cliente = objeto!.id
            
                self.performSegue(withIdentifier: "SegueClienteExistenteParaOrcamentoPrincipal", sender: self)
            }
            else {
                AvisoProcessamento.mensagemErroGenerico(resultado?.mensagem)
            }
            
            return true
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueClienteExistenteParaOrcamentoPrincipal" {
            
            let vc = segue.destination as! OrcamentoPrincipalViewController
            
            vc.defineContexto(self.contexto_orcamento)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
