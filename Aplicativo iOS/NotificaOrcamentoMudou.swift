//
//  NotificaOrcamentoMudou.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

protocol NotificaOrcamentoMudou {
    
    func novoItemPrincipal(_ itemPrincipal: ItemOrcamento?) -> Void
    func mudouItemPrincipal(_ itemPrincipal: ItemOrcamento?) -> Void
    
    func novoSubitem(_ itemPrincipal: ItemOrcamento?, subitem: ItemOrcamento?) -> Void
    func removeSubitem(_ subitem: ItemOrcamento?) -> Void
    
    func selecionaCor(_ itemOrcamentoDetalhe: ItemOrcamento?, configuracaoTinta: ConfiguracaoTinta?) -> Bool
    
    func mudouOrcamentoValido(_ valido: Bool, listaErros: [ItemErroOrcamento]?) -> Void
    
    func novaConfiguracaoTinta(_ itemOrcamentoComplexoDetalhe: ItemOrcamentoComplexoDetalhe?, configuracaoTinta: ConfiguracaoTinta?) -> Void
    
    func selecionaMassaCorrida(_ itemOrcamento: ItemOrcamentoComplexoDetalhe?) -> Void
    
    func fimConfiguracaoTinta(_ itemOrcamentoComplexoDetalhe: ItemOrcamentoComplexoDetalhe?) -> Void
    
    func notificaErro(_ mensagem: String?, mensagemTecnica: String?) -> Void
    
    func listaAmbienteMudou(_ novoNome: String?, textoAlternativo: String?, id_texto: String?, sequencia: Int, listaAmbientes: [ItemAmbienteTrinca]?) -> Void

    func mudouSequenciaDetalheComplexo(_ itemOrcamentoDetalheAjustar: ItemOrcamentoComplexoDetalhe, novaSequencia: Int, antigaSequencia: Int) -> Void
    
    func mudouSequenciaTrincaDetalhe(_ itemOrcamentoTrincaDetalhe: ItemOrcamentoTrincaDetalhe , novaSequencia: Int , antigaSequencia: Int) -> Void
    
    func mudouNomeAmbiente(_ itemOrcamentoAtualizado: ItemOrcamentoComplexoDetalhe) -> Void

}
