//
//  ContextoFinanceiro.swift
//  Pintura a Jato
//
//  Created by daniel on 06/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ContextoFinanceiro {
    
    var tipoRecebimento: TipoRecebimento?
    
    var recebimento: Recebimento?
    
    var id_orcamento: Int
    var id_pedido: Int
    var valorPagamento: Float
    var voltarHistorico: Bool
    
    init() {
        id_orcamento = 0
        id_pedido = 0
        valorPagamento = 0.0
        voltarHistorico = false
    }
}