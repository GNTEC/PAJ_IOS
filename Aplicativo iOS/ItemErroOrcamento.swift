//
//  ItemErroOrcamento.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ItemErroOrcamento {
    
    var indice: Int
    var descricao: String?
    var ambiente: String?
    var tipoErroOrcamento: TipoErroOrcamento
    
    init(indice: Int, descricao: String?, ambiente:String?, tipoErroOrcamento: TipoErroOrcamento) {
        self.indice = indice
        self.descricao = descricao
        self.ambiente = ambiente
        self.tipoErroOrcamento = tipoErroOrcamento
    }
}