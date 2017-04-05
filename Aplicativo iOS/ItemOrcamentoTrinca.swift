//
//  ItemOrcamentoTrinca.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ItemOrcamentoTrinca : ItemOrcamentoSimples {
    
    var quantidade: Int
    //var checkListAprovado: Bool
    
    override init() {
        quantidade = 0
        super.init()
        tipo = TipoItem.trinca
    }
    
    /*func int getTextoSelecao() {
    
    String itemSelecionado = getItemSelecionado();
    
    return (itemSelecionado != null && itemSelecionado.contentEquals("true")) ? R.string.literal_sim : R.string.literal_nao;
    }*/
    
    func aumentaQuantidade() {
        self.quantidade += 1
    }
    
    func diminuiQuantidade() {
        self.quantidade -= 1
    }
    
    /*override func valido(inout listaErros: Array<ItemErroOrcamento>) -> Bool {
        return true
    }*/
}
