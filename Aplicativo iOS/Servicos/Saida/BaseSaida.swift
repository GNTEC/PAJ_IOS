//
//  BaseSaida.swift
//  teste_rede
//
//  Created by daniel on 23/08/16.
//  Copyright © 2016 teste. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseSaida : Mappable {

    var resultado: Resultado?

    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        resultado    <- map["resultado"]
    }
}
