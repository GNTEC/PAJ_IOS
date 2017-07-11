//
//  HistoricoSaida.swift
//  teste_rede
//
//  Created by daniel on 25/08/16.
//  Copyright © 2016 teste. All rights reserved.
//

import Foundation
import ObjectMapper

class HistoricoSaida : Mappable {
    
    var resultado: Resultado?
    var orcamento: [OrcamentoDetalhe]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resultado    <- map["resultado"]
        orcamento   <- map["orcamento"]
    }
    
}
