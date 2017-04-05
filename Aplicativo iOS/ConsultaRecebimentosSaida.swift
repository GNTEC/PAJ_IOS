//
//  ConsultaRecebimentosSaida.swift
//  Pintura a Jato
//
//  Created by daniel on 06/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class ConsultaRecebimentosSaida: Mappable {
    
    var resultado: Resultado?
    
    var recebido: [Recebimento]?
    var receber: [Recebimento]?
    var cancelado: [Recebimento]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resultado <- map["resultado"]

        recebido <- map["recebido"]
        receber <- map["receber"]
        cancelado <- map["cancelado"]
        
    }
}
