//
//  CartaoPagamentoSaida.swift
//  Pintura a Jato
//
//  Created by daniel on 28/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class CartaoPagamentoSaida : Mappable {
    
    var resultado: Resultado?
    var pedido: PedidoGetNet?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resultado    <- map["resultado"]
        pedido   <- map["pedido"]
    }
}
