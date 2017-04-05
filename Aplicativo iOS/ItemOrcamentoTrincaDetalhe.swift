//
//  ItemOrcamentoTrincaDetalhe.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ItemOrcamentoTrincaDetalhe : ItemOrcamento {
    
    var exibeBotaoExcluir: Bool
    var tamanhoTrinca: String? // Em cm
    var itemAmbiente: ItemAmbienteTrinca?
    
    // Para selecionar
    var listaAmbientes: [ItemAmbienteTrinca]?
    
    var id: Int
    
    override init() {
        exibeBotaoExcluir = false
        id = 0
        super.init()
        tipo = TipoItem.trincaDetalhe
    }
    
    init (novoIndice: Int, novaSequencia: Int, itemOrcamentoCopiar: ItemOrcamentoTrincaDetalhe) {
    
        exibeBotaoExcluir = (true);
        id = 0

        super.init(novoIndice: novoIndice, novaSequencia: novaSequencia,  idNovoTexto: "mascara_trinca", itemOrcamentoCopiar: itemOrcamentoCopiar);
    
        tamanhoTrinca = (itemOrcamentoCopiar.tamanhoTrinca);
        listaAmbientes = (itemOrcamentoCopiar.listaAmbientes);
        itemAmbiente = (itemOrcamentoCopiar.itemAmbiente);
    }
    
    override func valido(_ listaErros: inout Array<ItemErroOrcamento>) -> Bool {
        
        let contagem = listaErros.count
        
        if(tamanhoTrinca == nil || tamanhoTrinca!.isEmpty) {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Tamanho da trinca", ambiente:self.texto(), tipoErroOrcamento: .naoPreenchido));
        }
        if(itemAmbiente == nil) {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Ambiente da trinca", ambiente:self.texto(), tipoErroOrcamento: .naoSelecionado));
        }
        
        return listaErros.count == contagem;
    }
    
    func novaListaAmbientes(_ novaLista: [ItemAmbienteTrinca]?, novoNome: String?, nomeAntigo: String?, id_texto: String?, sequencia: Int?) {
        
        var selecao: ItemAmbienteTrinca? = nil;
        let itemNovo = ItemAmbienteTrinca(textoAlternativo: novoNome)
        
        // Se o ambiente que mudou de nome era o selecionado, atualiza
        if novoNome != nil && nomeAntigo != nil && id_texto != nil && sequencia != nil {
            
            let itemAntigo = ItemAmbienteTrinca(textoAlternativo: nomeAntigo, id_texto: id_texto, sequencia: sequencia!)
            
            if itemAmbiente!.equals(itemAntigo) {
                itemAmbiente = itemNovo
            }
        }

        self.listaAmbientes = novaLista
        
        // Se a nova lista não possui o item selecionado, deseleciona
        for item in listaAmbientes! {
            
            if item.equals(itemAmbiente!) {
                selecao = item;
                break;
            }
        }
        
        itemAmbiente = selecao
    }

    func defineAmbientePorTexto(_ textoAmbiente: String?) {

        self.itemAmbiente = nil

        if textoAmbiente == nil {
            return
        }

        for item in listaAmbientes! {

            if item.textoAmbiente() == textoAmbiente {
                self.itemAmbiente = item
                break
            }
        }

        // se não encontrar, fixou como nil
    }
}
