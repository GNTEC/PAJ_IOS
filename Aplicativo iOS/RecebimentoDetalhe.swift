//
//  RecebimentoDetalhe.swift
//  Pintura a Jato
//
//  Created by daniel on 06/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class RecebimentoDetalhe : Mappable {
    
    var pedido : String?
    var periodo : String?
    var total: Float?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        pedido <- map["pedido"]
        periodo <- map["periodo"]
        total <- map["total"]
    }
}
