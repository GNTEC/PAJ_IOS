//
//  Franqueado.swift
//  teste_rede
//
//  Created by daniel on 23/08/16.
//  Copyright © 2016 teste. All rights reserved.
//

import Foundation
import ObjectMapper

class Franqueado : Mappable {
    
    var id: Int
    var id_franquia: Int
    var nome: String?
    var sobrenome: String?
    var razaoSocial: String?
    var nomeFantasia: String?
    var cnpj: String?
    var email: String?
    var foto: String?
    var telefone1: String?
    var telefone2: String?
    var perfil: Int?

    var endereco_fiscal: Endereco?
    var endereco_entrega: Endereco?

    
    required init?( map: Map) {
        id = 0
        id_franquia = 0
    }
    
    func mapping( map: Map) {
        
        id <- map["id"]
        id_franquia <- map["id_franquia"]
        sobrenome <- map["sobrenome"]
        razaoSocial <- map["razaoSocial"]
        nomeFantasia <- map["nomeFantasia"]
        cnpj <- map["cnpj"]
        email <- map["email"]
        foto <- map["foto"]
        telefone1 <- map["telefone1"]
        telefone2 <- map["telefone2"]
        
        endereco_fiscal <- map["endereco_fiscal"]
        endereco_entrega <- map["endereco_entrega"]
        
        perfil <- map["perfil"]
        
        
        //id    <- map["id"]
//        id_franquia   <- map["id_franquia"]
//        nome   <- map["nome"]
//        sobrenome   <- map["sobrenome"]
//        razaoSocial   <- map["razaoSocial"]
//        nomeFantasia   <- map["nomeFantasia"]
//        cnpj   <- map["cnpj"]
//        email   <- map["email"]
//        foto   <- map["foto"]
//        telefone1   <- map["telefone1"]
//        telefone2   <- map["telefone2"]
//        
//        endereco_fiscal   <- map["endereco_fiscal"]
//        endereco_entrega   <- map["endereco_entrega"]
//        
//        perfil <- map["perfil"]
    }
    
}
