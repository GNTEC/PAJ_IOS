//
//  ClienteBuscarSaida.swift
//  Pintura a Jato
//
//  Created by daniel on 18/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class ClienteBuscarSaida : Mappable {
    
    var resultado: Resultado?
    var cliente: Cliente?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resultado    <- map["resultado"]
        cliente   <- map["cliente"]
    }
}
