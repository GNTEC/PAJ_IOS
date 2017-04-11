//
//  ContextoOrcamento.swift
//  Pintura a Jato
//
//  Created by daniel on 11/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ContextoOrcamento {
    
    var id_orcamento: Int
    var id_cliente: Int
    var id_orcamento_inicial: Int?
    var id_orcamento_editar: Int?
    var valor_pago_inicial: Float?
    var valor_orcamento_inicial: Float?
    
    // confirmação para dados/pagamento
    var valorPagamento: Float?
    var diasServico: Int?
    var tipoMeioPagamento: TipoMeioPagamento?
    var tipoPagamento: TipoPagamento?
    var parcelas: Int?
    
    init() {
        id_orcamento = 0
        id_cliente = 0
    }
}
