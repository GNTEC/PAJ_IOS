//
//  BuscaAgendaOrcamentoSaida.swift
//  Pintura a Jato
//
//  Created by daniel on 03/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class BuscaAgendaOrcamentoSaida : Mappable {
    
    var resultado: Resultado?
    var agenda: [ItemHistoricoCalendario]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resultado <- map["resultado"]
        agenda    <- map["agenda"]

    }
    
}
