//
//  Foto.swift
//  Pintura a Jato
//
//  Created by daniel on 16/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class Foto : Mappable {
    
    var id: Int
    var id_franquia: Int
    var id_orcamento: Int
    var id_sequencia: Int
    var antes_depois: String?
    var formato: String?
    var nome_arquivop: String?
    var nome_arquivog: String?
    var status: String?
    var atualizacao: String?
    
    required init?(_ map: Map) {
     
        id = 0
        id_franquia = 0
        id_orcamento = 0
        id_sequencia = 0
    }
    
    func mapping(_ map: Map) {
        
        id <- map["id"]
        id_franquia <- map["id_franquia"]
        id_orcamento <- map["id_orcamento"]
        id_sequencia <- map["id_sequencia"]
        antes_depois <- map["antes_depois"]
        formato <- map["formato"]
        nome_arquivog <- map["nome_arquivog"]
        nome_arquivop <- map["nome_arquivop"]
        status <- map["status"]
        atualizacao <- map["atualizacao"]
        
    }
}
