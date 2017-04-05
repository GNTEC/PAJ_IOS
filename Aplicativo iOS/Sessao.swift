//
//  Sessao.swift
//  Pintura a Jato
//
//  Created by daniel on 11/12/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class Sessao : Mappable {
    
    var id: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
    }
}
