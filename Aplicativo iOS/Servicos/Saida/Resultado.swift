//
//  Resultado.swift
//  teste_rede
//
//  Created by daniel on 23/08/16.
//  Copyright © 2016 teste. All rights reserved.
//

import Foundation
import ObjectMapper

class Resultado : Mappable {
    
    var id: Int
    var mensagem: String?
    var erro: Bool
    
    required init?(map: Map) {
        id = 0
        erro = false
    }
    
    func mapping(map: Map) {
        id    <- map["id"]
        mensagem   <- map["mensagem"]
        erro   <- map["erro"]

    }
    
}
