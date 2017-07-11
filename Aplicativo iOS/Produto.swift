//
//  Produto.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class Produto : Mappable {
 
    var id: Int
    var quantidade: Int
    var nome: String?
    var imagem: String?
    var descricao: String?
    var valor: String?
    
    var valor_total: Float?
    var valor_unitario: String?
    
    required init?(map: Map) {
        id = 0
        quantidade = 0
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        quantidade <- map["quantidade"]
        nome <- map["nome"]
        imagem <- map["imagem"]
        descricao <- map["descricao"]
        valor <- map["valor"]
        valor_total <- map["valor_total"]
        if valor_total == nil {
            var valor_total_string: String?
            
            valor_total_string <- map["valor_total"]
            
            if valor_total_string != nil {
                self.valor_total = Float(valor_total_string!)
            }
        }
        valor_unitario <- map["valor_unitario"]
        
    }
}
