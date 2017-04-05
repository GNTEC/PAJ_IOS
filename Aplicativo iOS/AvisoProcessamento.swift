//
//  AvisoProcessamento.swift
//  Pintura a Jato
//
//  Created by daniel on 05/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class AvisoProcessamento {
    
    static var Titulo: String = "Pintura a Jato"
    
    static func mensagemErroGenerico(_ mensagem: String?) {
        
        let alert:UIAlertView = UIAlertView.init(title:"Erro", message: mensagem, delegate: self, cancelButtonTitle: "Fechar")
        
        alert.show()
    }

    static func mensagemErroGenerico(_ mensagem: String?, mensagemTecnica: String?) {
        
        var mensagem_final = mensagem!
        
        #if DEBUG
            mensagem_final += "DEBUG: " + mensagemTecnica!
        #endif
        
        let alert:UIAlertView = UIAlertView.init(title:"Erro", message: mensagem_final, delegate: self, cancelButtonTitle: "Fechar")
        
        alert.show()
    }
    
    static func mensagemSucessoGenerico(_ viewController:UIViewController, mensagem: String?, destino: @escaping () -> Void) {
        
        let alert = UIAlertController.init(title:Titulo, message:mensagem!, preferredStyle:UIAlertControllerStyle.alert);
        
        let defaultAction = UIAlertAction.init(title:"Fechar", style:UIAlertActionStyle.default,
            handler: { (action: UIAlertAction) -> Void in
                destino()
            })
        
        alert.addAction(defaultAction)
        
        viewController.present(alert, animated:true, completion:nil)
    }
}
