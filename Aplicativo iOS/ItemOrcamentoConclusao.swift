//
//  ItemOrcamentoConclusao.swift
//  Pintura a Jato
//
//  Created by daniel on 11/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ItemOrcamentoConclusao : ItemOrcamento {
    
    var dias: Int
    var parcelas: Int
    var tipoPagamento: TipoPagamento

    override init() {
        dias = 0
        parcelas = 0
        tipoPagamento = TipoPagamento.Nenhum
        super.init()
        tipo = TipoItem.conclusao
    }
}
