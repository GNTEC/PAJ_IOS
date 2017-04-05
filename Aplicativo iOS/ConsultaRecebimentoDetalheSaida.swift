//
//  ConsultaRecebimentoDetalheSaida.swift
//  Pintura a Jato
//
//  Created by daniel on 06/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class ConsultaRecebimentoDetalheSaida : Mappable {
    
    var resultado: Resultado?
    
    var recebido: [RecebimentoDetalhe]?
    var receber: [RecebimentoDetalhe]?
    var cancelado: [RecebimentoDetalhe]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resultado <- map["resultado"]
        
        recebido <- map["recebido"]
        receber <- map["receber"]
        cancelado <- map["cancelado"]
        
    }
}
