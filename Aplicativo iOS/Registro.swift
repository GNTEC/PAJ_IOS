//
//  Registro.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

enum TipoInformacao {
    case idOrcamento
    case idFranquia
    case idUsuario
}

class Registro {
    static func registraErro(_ mensagem: String?) {
        print(mensagem)
    }
    
    static func registraInformacao(_ chave: String, valor: AnyObject?) {

        let cl = Crashlytics.sharedInstance()

        cl.setObjectValue(valor, forKey: chave)

    }
    
    static func registraInformacao(_ tipoInformacao: TipoInformacao, valor: Int32) {
        
        let cl = Crashlytics.sharedInstance()
        
        switch tipoInformacao {
        case .idFranquia:
            cl.setIntValue(valor, forKey: "id_franquia")
            break
        case .idOrcamento:
            cl.setIntValue(valor, forKey: "id_orcamento")
            break
        case .idUsuario:
            cl.setIntValue(valor, forKey: "id_usuario")
            break
        }
    }
    
    static func registraAcessoTela(_ local: String, atributos: [String:AnyObject]?) {
    
    	Answers.logCustomEvent(withName: "Tela " + local,
                      customAttributes: atributos)
    }
    
    static func registraDebug(_ mensagem: String) {
        
        let cl = Crashlytics.sharedInstance()
        
        cl.logEvent(mensagem)
    }
    
    static func registraDebug(_ mensagem: String?) {
        
        print(mensagem);
    }
}
