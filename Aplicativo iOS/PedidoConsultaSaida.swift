//
//  PedidoConsultaSaida.swift
//  Pintura a Jato
//
//  Created by daniel on 16/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class PedidoConsultaSaida : Mappable {
    
    var resultado: Resultado?
    var orcamento: OrcamentoGerado?
    var checklist: OrcamentoGerado?
    var agenda: [ItemHistoricoCalendario]?
    var cliente: Cliente?
    var foto: [Foto]?
    var ponto: [Ponto]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        resultado <- map["resultado"]
        orcamento <- map["orcamento"]
        checklist <- map["checklist"]
        agenda <- map["agenda"]
        cliente <- map["cliente"]
        foto <- map["foto"]
        ponto <- map["ponto"]

    }
}
