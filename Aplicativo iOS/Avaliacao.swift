//
//  Avaliacao.swift
//  Pintura a Jato
//
//  Created by daniel on 05/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class Avaliacao : Mappable {
    
    var pedidos: Int
    var media: Int
    
    required init?(map: Map) {
        pedidos = 0
        media = 0
    }
    
    func mapping(map: Map) {
        pedidos <- map["pedidos"]
        media <- map["media"]
    }
}
