//
//  ConsultaManuaisTreinamentosSaida.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class ConsultaManuaisTreinamentosSaida : Mappable {
    
    var resultado: Resultado?
    var manual: [Manual]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        resultado <- map["resultado"]
        manual <- map["manual"]
        
    }
    
}
