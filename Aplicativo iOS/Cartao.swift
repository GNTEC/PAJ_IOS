//
//  Cartao.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class Cartao: Mappable {
    
    var id: String?
    var idFranquia: String?
    var nome: String?
    var bandeira: String?
    var numero: String?
    var validade: String?
    var atualizacao: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        if id == nil {
            var id_int: Int?
            
            id_int <- map["id"]
            
            if id_int != nil {
                id = String(id_int!)
            }
            
        }
        idFranquia <- map["idFranquia"]
        nome <- map["nome"]
        bandeira <- map["bandeira"]
        numero <- map["numero"]
        validade <- map["validade"]
        atualizacao <- map["atualizacao"]
        
    }
}
