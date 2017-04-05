//
//  ConsultaAvaliacaoSaida.swift
//  Pintura a Jato
//
//  Created by daniel on 05/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class ConsultaAvaliacaoSaida : Mappable {
    
    var resultado: Resultado?
    var avaliacao: Avaliacao?
    
    required init?(_ map: Map) {

    }
    
    func mapping(_ map: Map) {
        resultado <- map["resultado"]
        avaliacao <- map["avaliacao"]
    }
}
