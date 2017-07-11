//
//  LojaCalculoPedidoSaida.swift
//  Pintura a Jato
//
//  Created by daniel on 06/11/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class LojaCalculoPedidoSaida : Mappable {
    
    var resultado: Resultado?
    var calculo: CalculoPedido?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resultado    <- map["resultado"]
        calculo  <- map["calculo"]
    }
}
