//
//  Cliente.swift
//  Pintura a Jato
//
//  Created by daniel on 14/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class Cliente : Mappable {
    
    var id: Int
    var id_franquia: Int
    var id_usuario: Int
    var id_cliente: Int
    var id_endereco: Int
    var nome: String?
    var email: String?
    var telefone: String?
    var telefone1: String?
    var celular: String?
    var cpf: String?
    var rg: String?
    var cep: String?
    var logradouro: String?
    var numero: String?
    var complemento: String?
    var bairro: String?
    var cidade: String?
    var uf: String?
    
    required init?(map: Map) {
        
        id = 0
        id_franquia = 0
        id_usuario = 0
        id_cliente = 0
        id_endereco = 0
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        id_franquia <- map["id_franquia"]
        id_usuario <- map["id_usuario"]
        
        var id_cliente_string : String?
        
        id_cliente_string <- map["id_cliente"]
        
        if id_cliente_string == nil {
            id_cliente <- map["id_cliente"]
        }
        else {
            id_cliente = Int(id_cliente_string!)!
        }
        
        id_endereco <- map["id_endereco"]
        nome <- map["nome"]
        email <- map["email"]
        telefone <- map["telefone"]
        telefone1 <- map["telefone1"]
        celular <- map["celular"]
        cpf <- map["cpf"]
        rg <- map["rg"]
        cep <- map["cep"]
        logradouro <- map["logradouro"]
        numero <- map["numero"]
        complemento <- map["complemento"]
        bairro <- map["bairro"]
        cidade <- map["cidade"]
        uf <- map["uf"]
        
    }
}
