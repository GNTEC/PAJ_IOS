//
//  ItemOrcamentoComplexo.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ItemOrcamentoComplexo : ItemOrcamento {
    
    var tipoPintura: TipoPintura
    
    override init() {
        tipoPintura = TipoPintura.Nenhum
        super.init()
        tipo = TipoItem.complexo
    }

    override func valido(_ listaErros: inout Array<ItemErroOrcamento>) -> Bool {
        
        return true
    }
}
