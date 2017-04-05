//
//  ContextoAgendaCalendario.swift
//  Pintura a Jato
//
//  Created by daniel on 03/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ContextoAgendaCalendario {
    
    var mesSelecionado: Date?
    
    var modoSelecaoDataAtualFutura: Bool
    var diasServico: Int
    var valorPagamento: Float
    var id_orcamento: Int
    var id_orcamento_inicial: Int?
    var id_orcamento_editar: Int?
    
    // fluxo de inclusão+pagamento
    var horario_inicio: String?
    var data_inicial: String?
    var data_final: String?
    var valorDebito: Float
    var cartao:String?
    var cvv:String?
    var mes:String?
    var ano:String?
    var nome:String?
    //var codigo_pagamento:String?
    var descricao:String?
    var valorParcela: Float
    
    // do fluxo selecao data atual/futura
    var parcelas: Int?
    var id_cliente: Int?
    var tipoPagamento: TipoPagamento?
    var tipoMeioPagamento: TipoMeioPagamento?
    
    init() {
        modoSelecaoDataAtualFutura = false
        diasServico = 0
        valorPagamento = 0.0
        id_orcamento = 0
        valorDebito = 0.0
        valorParcela = 0.0
    }
}
