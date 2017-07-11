//
//  ItemOrcamentoSimples.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ItemOrcamentoSimples: ItemOrcamento {
    
    var botoes: [BotaoItemOrcamento]?
    var itemSelecionado: String?
    var baseImagem: String?
    var checkListAprovado: Bool?
    var exibeBotoesCheckList: Bool
    
    override init() {
        checkListAprovado = false
        exibeBotoesCheckList = false
        super.init()
        tipo = TipoItem.simples
    }
    
    func textoSelecao() -> String? {
        
        var botao: BotaoItemOrcamento? = nil
        
        for botaoBuscado in botoes! {
            
            // Item pode não ter sido selecionado ainda
            if(itemSelecionado == nil){
                break;
            }
            
            if(itemSelecionado == (botaoBuscado.selecao)) {
                botao = botaoBuscado;
                break;
            }
        }
        
        if(botao == nil) {
            return "texto_vazio"
        }
        
        return botao?.idTextoSelecao;
    }

    override func valido(_ listaErros: inout Array<ItemErroOrcamento>) -> Bool {
        
        let contagem = listaErros.count
        
        if(itemSelecionado == nil || itemSelecionado!.isEmpty) {
            
            let itemErro = ItemErroOrcamento(indice: indice, descricao: texto(), ambiente: "Geral" , tipoErroOrcamento: .naoSelecionado)
            
            listaErros.append(itemErro);
        }
        
        return listaErros.count == contagem;
    }

    
}
