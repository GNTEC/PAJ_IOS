//
//  LojaDetalhePedidoSaida.swift
//  Pintura a Jato
//
//  Created by daniel on 06/12/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class LojaDetalhePedidoSaida : Mappable {
 
    var resultado: Resultado?
    var pedido: PedidoLoja?
    var produtos: [Produto]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        resultado    <- map["resultado"]
        pedido  <- map["pedido"]
        produtos <- map["produtos"]
    }
}
