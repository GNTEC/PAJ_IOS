//
//  PedidoLoja.swift
//  Pintura a Jato
//
//  Created by daniel on 06/12/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class PedidoLoja : Mappable {
    
    var data_pedido : String?
    var id: Int
    var valor: Float
    var valor_total: Float
    var valor_unitario : Float
    var status : String?

    required init?(_ map: Map) {
        
        id = 0
        valor_total = 0.0
        valor_unitario = 0.0
        valor = 0.0
    }
    
    func mapping(_ map: Map) {
        
        data_pedido <- map["data_pedido"]
        id <- map["id"]
        
        var valor_total_string : String?
        valor_total_string <- map["valor_total"]
        
        if valor_total_string != nil {
            self.valor_total = Float(valor_total_string!)!
        }
        
        var valor_unitario_string : String?

        valor_unitario_string <- map["valor_unitario"]
        
        if valor_unitario_string != nil {
            self.valor_unitario = Float(valor_unitario_string!)!
        }

        var valor_string : String?
        
        valor_string <- map["valor"]
        
        if valor_string != nil {
            self.valor = Float(valor_string!)!
        }
        
        status <- map["status"]
        
    }
}
