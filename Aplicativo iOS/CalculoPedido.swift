//
//  CalculoPedido.swift
//  Pintura a Jato
//
//  Created by daniel on 06/11/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class CalculoPedido : Mappable {
    
    var produtos: [Produto]?
    var valor_total: Float?
    
    required init?(_ map: Map) {
    }
    
    func mapping(_ map: Map) {
        
        produtos <- map["produtos"]
        valor_total <- map["valor_total"]
        
    }
}
