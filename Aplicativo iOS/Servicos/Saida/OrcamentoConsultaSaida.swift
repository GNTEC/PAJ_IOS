//
//  OrcamentoConsultaSaida.swift
//  teste_rede
//
//  Created by daniel on 25/08/16.
//  Copyright © 2016 teste. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper

class OrcamentoConsultaSaida : Mappable {
    
    var resultado: Resultado?
    var cliente: Cliente?
    var franqueado: Franqueado?
    var orcamento: OrcamentoGerado?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resultado    <- map["resultado"]
        orcamento   <- map["orcamento"]
        cliente <- map["cliente"]
        franqueado <- map["franqueado"]
    }
    
}
