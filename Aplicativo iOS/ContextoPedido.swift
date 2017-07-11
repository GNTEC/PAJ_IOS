//
//  ContextoPedido.swift
//  Pintura a Jato
//
//  Created by daniel on 17/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ContextoPedido {
    var id_orcamento: Int
    var modoFinanceiro: Bool
    var sequencia: Int
    
    init() {
        id_orcamento = 0
        sequencia = 0
        modoFinanceiro = false
    }
}