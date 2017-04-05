//
//  LojaListaPedidosSaida.swift
//  Pintura a Jato
//
//  Created by daniel on 06/12/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class LojaListaPedidosSaida : Mappable {
    
    var resultado: Resultado?
    var pedidos: [PedidoLoja]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        resultado    <- map["resultado"]
        pedidos  <- map["pedidos"]
    }
}
