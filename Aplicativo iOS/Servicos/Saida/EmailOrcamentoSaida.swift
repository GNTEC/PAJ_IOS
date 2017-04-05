//
//  EmailOrcamentoSaida.swift
//  Pintura a Jato
//
//  Created by daniel on 09/10/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class EmailOrcamentoSaida: Mappable {
    
    var resultado: Resultado?
    var cliente: Cliente?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resultado    <- map["resultado"]
        cliente   <- map["cliente"]
    }
}
