//
//  ClienteDetalheViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 06/11/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ClienteDetalheViewController : UIViewController {
    
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var telefone_fixo: UITextField!
    @IBOutlet weak var telefone_celular: UITextField!
    @IBOutlet weak var endereco: UITextField!
    @IBOutlet weak var complemento: UITextField!
    
    var id_cliente: Int?
    
    func defineIdCliente(_ id_cliente: Int) {
        self.id_cliente = id_cliente
    }
    
    override func viewDidLoad() {
        
        title = String(format: "Cliente #%06d", id_cliente!)
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id" : "\(id_cliente!)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.buscarClienteCadastroCompletoPorId(self.navigationController!.view, parametros: parametros, sucesso: { (objeto: Cliente?, resultado: Bool) -> Bool in
            
            self.nome.text = objeto?.nome
            self.email.text = objeto?.email
            self.telefone_fixo.text = objeto?.telefone
            self.telefone_celular.text = objeto?.celular
            self.endereco.text = "\(objeto?.logradouro != nil ? objeto!.logradouro! : ""), \(objeto?.numero != nil ? objeto!.numero! : "")"
            self.complemento.text = objeto?.complemento
            
            return true
        })
    }
}
