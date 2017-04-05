//
//  Recebimento.swift
//  Pintura a Jato
//
//  Created by daniel on 06/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class Recebimento : Mappable {
    
    var mes : String?
    var ano : String?
    var periodo : String?
    var total: Float?
    
    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        mes <- map["mes"]
        ano <- map["ano"]
        periodo <- map["periodo"]
        total <- map["total"]
    }
    
}
