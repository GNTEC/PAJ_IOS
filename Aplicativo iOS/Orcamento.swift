//
//  Orcamento.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class Orcamento {
    
    var sequenciaAmbiente: Int
    var sequenciaParedeAvulsa: [Int:Int]?
    var sequenciaTetoAvulso: [Int:Int]?
    var sequenciaTrinca: Int
    var sequenciaItemPrincipal: Int
    
    var indiceOrcamento: Int
    var indiceSelecaoPrimeiraPintura: Int
    var indiceSelecaoImovelDesocupado: Int
    var indiceSelecaoTipoLocalPintado: Int
    // Indice do item que faz a troca do tipo de pintura
    var indiceSelecaoTipoPintura: Int
    var indiceTrincaRaiz: Int

    static var cachePatternsTexto: [String:NSRegularExpression?]?

    // Lista para exibir no spinner de trinca
    var listaAmbientes: [ItemAmbienteTrinca]?
    
    // Usado no checklist
    var id: Int
    
    var itensOrcamento: [ItemOrcamento]?
    var id_cliente: Int
    var id_pedido: Int
    
    var forma_de_pagamento: String?
    var meio_de_pagamento: String?
    
    var dias_servico: String?
    var numero_parcelas: String?
    
    var valores_agregados: [String:AnyObject]?
    
    var resultadoCalculo: ResultadoCalculo?
    
    init(notificaOrcamentoMudou: NotificaOrcamentoMudou?) {
        
        sequenciaAmbiente = 0
        sequenciaParedeAvulsa = [:]
        sequenciaTetoAvulso = [:]
        sequenciaTrinca = 0
        sequenciaItemPrincipal = 0
        indiceOrcamento = 100
        indiceSelecaoPrimeiraPintura = 0
        indiceSelecaoImovelDesocupado = 0
        indiceSelecaoTipoLocalPintado = 0
        indiceSelecaoTipoPintura = 0
        indiceTrincaRaiz = 0
        id = 0
        id_pedido = 0
        id_cliente = 0
        
        mNotificadorMudanca = notificaOrcamentoMudou
    }
    
    func adicionaOrcamentoInicial() {
        itensOrcamento = criaOrcamentoInicial(true);
    }
    
    static func criaNovoOrcamento(_ notificaOrcamentoMudou: NotificaOrcamentoMudou?) ->  Orcamento? {
        
        mOrcamento = Orcamento(notificaOrcamentoMudou: notificaOrcamentoMudou)
        
        return Orcamento.obtemOrcamento()
    }
    
    func selecionouPossuiTrinca(_ possuiTrinca: Bool) {
        
        let itemOrcamentoTrinca = buscaPrimeiroItemPorTipo(TipoItem.trinca) as! ItemOrcamentoTrinca?
        
        // Selecionou no item de trinca, o botão sim. Cria o primeiro subitem (detalhe)
        if (possuiTrinca) {
            
            let novaSequenciaTrinca = self.novaSequenciaTrinca();
            
            let itemOrcamentoTrincaDetalhe = ItemOrcamentoTrincaDetalhe();
            itemOrcamentoTrincaDetalhe.exibeBotaoExcluir = (false); // Não pode excluir o item em princípio
            itemOrcamentoTrincaDetalhe.indice = novoIndiceOrcamento()
            itemOrcamentoTrincaDetalhe.sequencia = (novaSequenciaTrinca);
            itemOrcamentoTrincaDetalhe.idTexto = "mascara_trinca"
            
            let array = [ItemAmbienteTrinca](listaAmbientes!)
            
            itemOrcamentoTrincaDetalhe.listaAmbientes = (array);
            
            itemOrcamentoTrinca?.quantidade = (1);
            
            itensOrcamento!.append(itemOrcamentoTrincaDetalhe);
            
            if(mNotificadorMudanca != nil) {
                mNotificadorMudanca!.novoSubitem(itemOrcamentoTrinca, subitem: itemOrcamentoTrincaDetalhe);
            }
            
        } else {
            
            removeItensTipo(TipoItem.trincaDetalhe);
            
            itemOrcamentoTrinca?.quantidade = (0);
            
            sequenciaTrinca = 0;
        }
        
        let itemOrcamentoSimples = buscaItemOrcamentoPorIndice(indiceTrincaRaiz) as! ItemOrcamentoSimples?
        
        itemOrcamentoSimples!.itemSelecionado = (possuiTrinca ? "true" : "false");
        
    }
    
    func novoDetalheTrinca(_ item: ItemOrcamentoTrincaDetalhe) {
        
        let itemOrcamentoRaiz = buscaPrimeiroItemPorTipo(TipoItem.trinca) as! ItemOrcamentoTrinca?
        
        //assert itemOrcamentoRaiz != nil;
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        let novaSequencia = novaSequenciaTrinca();
        
        let itemOrcamentoNovo = ItemOrcamentoTrincaDetalhe();
        itemOrcamentoNovo.indice = (novoIndiceOrcamento());
        itemOrcamentoNovo.sequencia = (novaSequencia);
        itemOrcamentoNovo.idTexto = "mascara_trinca"
        itemOrcamentoNovo.exibeBotaoExcluir = (true);
        
        let array = [ItemAmbienteTrinca](listaAmbientes!)
        
        itemOrcamentoNovo.listaAmbientes = (array);
        
        itemOrcamentoRaiz!.aumentaQuantidade();
        
        itensOrcamento!.append(itemOrcamentoNovo);
        
        if(mNotificadorMudanca != nil) {
            mNotificadorMudanca!.novoSubitem(itemOrcamentoRaiz, subitem: itemOrcamentoNovo);
        }
    }
    
    // FIXME: Contigência, remover quando não houver mais trinca em parede avulsa/teto avulso sem ambiente pai
    func buscaItemAmbienteTrinca(_ texto: String?) -> ItemAmbienteTrinca? {
    
        if ( listaAmbientes == nil || listaAmbientes?.count == 0) {
            return nil;
        }
    
        for itemAmbienteTrinca in listaAmbientes! {
    
            let textoItem = itemAmbienteTrinca.texto();
    
            let tamanhoMenor = textoItem?.characters.count < texto?.characters.count ? textoItem?.characters.count : texto?.characters.count;
    
            let range = (textoItem!.startIndex ..< textoItem!.characters.index(textoItem!.startIndex, offsetBy: tamanhoMenor!));
            let textoParcial = textoItem?.substring(with: range);
    
            if textoParcial == texto {
                return itemAmbienteTrinca;
            }
        }
    
        return nil;
    }
    
    func buscaItemAmbienteTrinca(_ texto: String?, textoPai: String?) -> ItemAmbienteTrinca? {

        if listaAmbientes == nil || listaAmbientes?.count == 0 {
            return nil;
        }

        var textoBuscar : String?
        
        if textoPai == nil {
            textoBuscar = texto
        }
        else {
            textoBuscar = String(format: "%@ (%@)", texto!, textoPai!);
        }

        for itemAmbienteTrinca in listaAmbientes! {

            if (itemAmbienteTrinca.texto() == textoBuscar) {
                return itemAmbienteTrinca;
            }
        }

        return nil;
    }
    
    func atualizaSequenciaItemComplexoDetalhe(_ tipoDetalheComplexo: TipoDetalheComplexo, itemOrcamentoPai: ItemOrcamento?) {
        
        var novaSequencia = 0, antigaSequencia = 0
        
        Registro.registraDebug( "atualizaSequenciaItemComplexoDetalhe: (0) inicio. Tipo esperado: \(tipoDetalheComplexo.rawValue), indice pai: \(itemOrcamentoPai)");
        
        for itemOrcamentoAjustar in itensOrcamento! {
            
            // Somente os detalhe complexo (Ambiente, ParedeAvulsa)
            if !(itemOrcamentoAjustar is ItemOrcamentoComplexoDetalhe) {
                continue
            }
            
            let itemOrcamentoDetalheAjustar = itemOrcamentoAjustar as! ItemOrcamentoComplexoDetalhe
            
            Registro.registraDebug("atualizaSequenciaItemComplexoDetalhe: (1) item: " + itemOrcamentoDetalheAjustar.texto()!);
            
            // Ambiente ou Ambiente Completo
            if tipoDetalheComplexo == .Ambiente || tipoDetalheComplexo == .AmbienteCompleto  {
                
                Registro.registraDebug("atualizaSequenciaItemComplexoDetalhe: (2) é ambiente: " + itemOrcamentoDetalheAjustar.tipoDetalheComplexo.rawValue);
                
                // Não é do tipo correto
                if itemOrcamentoDetalheAjustar.tipoDetalheComplexo != .Ambiente && itemOrcamentoDetalheAjustar.tipoDetalheComplexo != .AmbienteCompleto {
                    
                    Registro.registraDebug("atualizaSequenciaItemComplexoDetalhe: (2a) não é do tipo esperado: " + itemOrcamentoDetalheAjustar.tipoDetalheComplexo.rawValue);
                    continue
                }
            }
                // Teto avulso ou Parede avulsa só precisa bater o tipo
            else if (itemOrcamentoDetalheAjustar.tipoDetalheComplexo != tipoDetalheComplexo) {
                
                Registro.registraDebug("atualizaSequenciaItemComplexoDetalhe: (2b) não é do tipo esperado: " + itemOrcamentoDetalheAjustar.tipoDetalheComplexo.rawValue);
                
                continue;
            }
            
            // Quando é teto/parede avulsa, só pode remover se for item do mesmo pai
            if ( (tipoDetalheComplexo == TipoDetalheComplexo.ParedeAvulsa || tipoDetalheComplexo == TipoDetalheComplexo.TetoAvulso) && itemOrcamentoDetalheAjustar.itemOrcamentoPai?.indice != itemOrcamentoPai?.indice) {
                
                Registro.registraDebug("atualizaSequenciaItemComplexoDetalhe: (3) não é do mesmo pai: item/pai esperado \(itemOrcamentoDetalheAjustar.indice)/\(itemOrcamentoPai?.indice)");
                continue;
            }
            
            if !itemOrcamentoDetalheAjustar.usaSequencia() {
                
                Registro.registraDebug("atualizaSequenciaItemComplexoDetalhe: (4) usaSequencia: " + itemOrcamentoDetalheAjustar.usaSequencia().description);
                continue
            }
            
            novaSequencia += 1
            
            Registro.registraDebug("atualizaSequenciaItemComplexoDetalhe: (5) novaSequencia: \(novaSequencia)");
            
            // Já está com a sequência correta, não precisa ajustar
            if itemOrcamentoDetalheAjustar.sequencia == novaSequencia {
                Registro.registraDebug("atualizaSequenciaItemComplexoDetalhe: (6) sequencia já está correta: \(itemOrcamentoDetalheAjustar.sequencia == novaSequencia)");
                continue
            }
            
            antigaSequencia = itemOrcamentoDetalheAjustar.sequencia
            
            Registro.registraDebug("atualizaSequenciaItemComplexoDetalhe: (7) antiga sequencia: \(antigaSequencia)");
            
            itemOrcamentoDetalheAjustar.sequencia = novaSequencia
            
            Registro.registraDebug("atualizaSequenciaItemComplexoDetalhe: (8) texto: \(itemOrcamentoDetalheAjustar.texto())");
            
            // Atualiza o nome do ambiente nas configurações de tintas
            itemOrcamentoDetalheAjustar.configuracaoTintaTeto?.nomeAmbiente = itemOrcamentoDetalheAjustar.texto()
            itemOrcamentoDetalheAjustar.configuracaoTintaPortas?.nomeAmbiente = itemOrcamentoDetalheAjustar.texto()
            itemOrcamentoDetalheAjustar.configuracaoTintaJanelas?.nomeAmbiente = itemOrcamentoDetalheAjustar.texto()
            itemOrcamentoDetalheAjustar.configuracaoTintaParedes?.nomeAmbiente = itemOrcamentoDetalheAjustar.texto()
            
            Registro.registraDebug("atualizaSequenciaItemComplexoDetalhe: (9) chama notificador ?: \(mNotificadorMudanca != nil)");
            
            if(mNotificadorMudanca != nil) {
                mNotificadorMudanca!.mudouSequenciaDetalheComplexo(itemOrcamentoDetalheAjustar, novaSequencia: novaSequencia, antigaSequencia: antigaSequencia)
            }
        }
        
        Registro.registraDebug("atualizaSequenciaItemComplexoDetalhe: (10) fim");
    }


    func excluirSubitemOrcamento(_ itemOrcamento: ItemOrcamento) {

        let indice = itemOrcamento.indice;

        // O itemOrcamento que vem pode ser uma cópia, por isso remover pelo índice
        let itemOrcamentoRemover = buscaItemOrcamentoPorIndice(indice)

        if(itemOrcamentoRemover != nil) {

            let index = itensOrcamento!.index(where: { (item:ItemOrcamento) -> Bool in
                return itemOrcamentoRemover!.indice == item.indice
            })

            itensOrcamento!.remove(at: index!);
        }

        // TODO: ajustar este caso
        if (itemOrcamento.tipo == TipoItem.complexoDetalhe) {

            let itemOrcamentoComplexoDetalhe = itemOrcamento as! ItemOrcamentoComplexoDetalhe

            ///////////////////////////////////////////////////////////////////////////////////////

            // Monta uma lista dos ambientes filhos a remover primeiro

            var listaItemOrcamentoFilhoRemover : [ItemOrcamentoComplexoDetalhe]?

            for itemOrcamentoFilho in itensOrcamento! {

                if ( !(itemOrcamentoFilho is  ItemOrcamentoComplexoDetalhe) ) {
                    continue;
                }

                let itemOrcamentoComplexoDetalheFilho = itemOrcamentoFilho as! ItemOrcamentoComplexoDetalhe

                if (itemOrcamentoComplexoDetalheFilho.itemOrcamentoPai?.indice == itemOrcamentoComplexoDetalhe.indice) {

                    if ( listaItemOrcamentoFilhoRemover == nil ) {
                        listaItemOrcamentoFilhoRemover = [ItemOrcamentoComplexoDetalhe]();
                    }

                    listaItemOrcamentoFilhoRemover!.append(itemOrcamentoComplexoDetalheFilho);
                }
            }

            // Remove os filhos se existirem
            if (listaItemOrcamentoFilhoRemover != nil && listaItemOrcamentoFilhoRemover?.count > 0) {

                for itemOrcamentoComplexoDetalheFilhoRemover in listaItemOrcamentoFilhoRemover! {

                    let indice = listaItemOrcamentoFilhoRemover?.index(where: { (elemento) -> Bool in
                        return elemento.indice == itemOrcamentoComplexoDetalheFilhoRemover.indice
                    })

                    itensOrcamento?.remove(at: indice!)

                    if (mNotificadorMudanca != nil) {
                        mNotificadorMudanca!.removeSubitem(itemOrcamentoComplexoDetalheFilhoRemover);
                    }

                    removeAmbiente(itemOrcamentoComplexoDetalheFilhoRemover.textoAlternativo,
                                   id_texto: itemOrcamentoComplexoDetalheFilhoRemover.idTexto,
                                   sequencia: itemOrcamentoComplexoDetalheFilhoRemover.sequencia,
                                   textoAlternativoPai: itemOrcamentoComplexoDetalhe.textoAlternativo,
                                   id_texto_pai: itemOrcamentoComplexoDetalhe.idTexto,
                                   sequencia_pai: itemOrcamentoComplexoDetalhe.sequencia);

                }
            }

            ///////////////////////////////////////////////////////////////////////////////////////


            if itemOrcamentoComplexoDetalhe.tipoDetalheComplexo == TipoDetalheComplexo.Ambiente {

                removeAmbiente(itemOrcamento.textoAlternativo, id_texto: itemOrcamento.idTexto, sequencia: itemOrcamento.sequencia);
            }
            else {

                let itemOrcamentoPai = itemOrcamentoComplexoDetalhe.itemOrcamentoPai

                removeAmbiente(itemOrcamento.textoAlternativo,
                    id_texto: itemOrcamento.idTexto,
                    sequencia: itemOrcamento.sequencia,
                    textoAlternativoPai: itemOrcamentoPai!.textoAlternativo,
                    id_texto_pai: itemOrcamentoPai!.idTexto,
                    sequencia_pai: itemOrcamentoPai!.sequencia);
            }

            
            ///////////////////////////////////////////////////////////////////////////////////////
            
            // Ajusta os números das sequências para sempre serem sequenciais sem furos no meio. Ex:
            // 1,2,3,4 para 1,2,3 e não 1,3,4, caso se remova o segundo item....
            
            ///////////////////////////////////////////////////////////////////////////////////////
            
            let tipoDetalheComplexo = itemOrcamentoComplexoDetalhe.tipoDetalheComplexo
            
            atualizaSequenciaItemComplexoDetalhe(tipoDetalheComplexo, itemOrcamentoPai: itemOrcamentoComplexoDetalhe.itemOrcamentoPai)

            /*if (itemOrcamentoComplexoDetalhe.tipoDetalheComplexo == TipoDetalheComplexo.Ambiente) {
                sequenciaAmbiente = novaSequencia
            }
            else if itemOrcamentoComplexoDetalhe.tipoDetalheComplexo == TipoDetalheComplexo.ParedeAvulsa {
                sequenciaParedeAvulsa![itemOrcamentoComplexoDetalhe.indice] = novaSequencia
            }*/
            
            
        } else if (itemOrcamento.tipo == TipoItem.trincaDetalhe) {
            
            ///////////////////////////////////////////////////////////////////////////////////////
            
            // Ajusta os números das sequências para sempre serem sequenciais sem furos no meio. Ex:
            // 1,2,3,4 para 1,2,3 e não 1,3,4, caso se remova o segundo item....
            
            ///////////////////////////////////////////////////////////////////////////////////////
            
            var novaSequencia = 0, antigaSequencia = 0
            
            for itemOrcamentoAjustar in itensOrcamento! {

                // Somente os detalhe Trinca
                if !(itemOrcamentoAjustar is ItemOrcamentoTrincaDetalhe) {
                    continue
                }
                
                let itemOrcamentoDetalheAjustar = itemOrcamentoAjustar as! ItemOrcamentoTrincaDetalhe
                
                novaSequencia += 1
                
                // Já está com a sequência correta, não precisa ajustar
                if itemOrcamentoDetalheAjustar.sequencia == novaSequencia {
                    continue
                }
                
                antigaSequencia = itemOrcamentoDetalheAjustar.sequencia
                
                itemOrcamentoDetalheAjustar.sequencia = novaSequencia
                
                if(mNotificadorMudanca != nil) {
                    mNotificadorMudanca!.mudouSequenciaTrincaDetalhe(itemOrcamentoDetalheAjustar, novaSequencia: novaSequencia, antigaSequencia: antigaSequencia)
                }
            }
            
            // Revalida se o contador está correto.
            //ajustaSequenciaTrinca(indice)
            
            // No item de trinca existe um contador de quantos itens foram adicionados. Atualiza.
            let itemOrcamentoTrinca = buscaPrimeiroItemPorTipo(TipoItem.trinca) as! ItemOrcamentoTrinca?
            
            itemOrcamentoTrinca!.diminuiQuantidade();
        }
        
        if(mNotificadorMudanca != nil) {
            mNotificadorMudanca!.removeSubitem(itemOrcamento);
        }
    }
    
    /*func ajustaSequenciaParedeAvulsa(indiceAmbiente: Int) {
    
        var maiorSequencia = 1;
    
        for itemOrcamento in itensOrcamento! {
    
            if (!(itemOrcamento is ItemOrcamentoComplexoDetalhe)) {
                continue;
            }
    
            let itemOrcamentoComplexoDetalhe = itemOrcamento as! ItemOrcamentoComplexoDetalhe
    
            // Só buscamos as Paredes avulsas, ignoramos os ambientes
            if ( itemOrcamentoComplexoDetalhe.tipoDetalheComplexo != TipoDetalheComplexo.ParedeAvulsa ) {
                continue;
            }
    
            // Só queremos as paredes do ambiente informado
            if ( itemOrcamentoComplexoDetalhe.itemOrcamentoPai?.indice != indiceAmbiente) {
                continue;
            }
    
            if ( itemOrcamento.sequencia > maiorSequencia) {
                maiorSequencia = itemOrcamento.sequencia
            }
        }
    
        sequenciaParedeAvulsa.put(indiceAmbiente, maiorSequencia);
    }*/
    
    /*func ajustaSequenciaTrinca(indice: Int) {
    
        var maiorSequencia = 1;
    
        for itemOrcamento in itensOrcamento! {
    
            if (!(itemOrcamento is ItemOrcamentoTrincaDetalhe)) {
                continue;
            }
            
    
            if ( itemOrcamento.sequencia > maiorSequencia) {
                maiorSequencia = itemOrcamento.sequencia
            }
        }
    
        sequenciaTrinca = maiorSequencia;
    }*/
    
    // Ajusta o número da sequência de ambiente para o menor possível
    /*func ajustaSequenciaAmbiente(indice:Int) {
    
        var maiorSequencia = 1;
    
        for itemOrcamento in itensOrcamento! {
    
            if (!(itemOrcamento is ItemOrcamentoComplexoDetalhe)) {
                continue;
            }
    
            let itemOrcamentoComplexoDetalhe = itemOrcamento as! ItemOrcamentoComplexoDetalhe
    
            if itemOrcamentoComplexoDetalhe.tipoDetalheComplexo != TipoDetalheComplexo.Ambiente {
                continue;
            }
    
            if itemOrcamento.sequencia > maiorSequencia {
                maiorSequencia = itemOrcamento.sequencia
            }
        }
    
        sequenciaAmbiente = maiorSequencia;
    }*/
    
    func novoDetalheComplexo(_ itemOrcamento: ItemOrcamentoComplexoDetalhe, tipoDetalheComplexo: TipoDetalheComplexo) {
        
        let itemOrcamentoRaiz = buscaPrimeiroItemPorTipo(TipoItem.complexo) as! ItemOrcamentoComplexo?
        
        //assert itemOrcamentoRaiz != null;
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        var novaSequencia: Int
        var idDescricaoItem: String?
        
        switch tipoDetalheComplexo {
        case TipoDetalheComplexo.Ambiente:
            novaSequencia = novaSequenciaAmbiente();
            idDescricaoItem =  "mascara_ambiente"
            break
        case TipoDetalheComplexo.AmbienteCompleto:
            novaSequencia = novaSequenciaAmbiente();
            idDescricaoItem =  "mascara_ambiente"
            break
        case TipoDetalheComplexo.ParedeAvulsa:
            novaSequencia = -1;
            idDescricaoItem = "mascara_parede_avulsa"
            break
        case TipoDetalheComplexo.TetoAvulso:
            novaSequencia = -1;
            idDescricaoItem = "mascara_teto_avulso"
            break
        }

        let itemOrcamentoNovo = criaNovoItemOrcamentoComplexoDetalhe(itemOrcamentoRaiz!.tipoPintura, tipoDetalheComplexo: tipoDetalheComplexo, idTexto: idDescricaoItem, sequencia: novaSequencia);
        itemOrcamentoNovo.tipoDetalheComplexo = tipoDetalheComplexo
        
        // Detalhes de parede avulsa
        if(tipoDetalheComplexo == TipoDetalheComplexo.ParedeAvulsa) {
            itemOrcamentoNovo.exibeBotaoParedeAvulsa = (false);
            itemOrcamentoNovo.exibeComprimento = (false);
            itemOrcamentoNovo.exibeAltura = (true);
            itemOrcamentoNovo.exibeQuantidadeInterruptores = (true);
            itemOrcamentoNovo.exibeQuantidadePortas = (true);
            itemOrcamentoNovo.exibeQuantidadeJanelas = (true);
            itemOrcamentoNovo.exibeBotaoTetoAvulso = false;
            itemOrcamentoNovo.exibeBotaoAmbienteCompleto = false;
            

            var itemOrcamentoPai: ItemOrcamento?

            // Está adicionando de um item de ambiente
            if itemOrcamento.tipoDetalheComplexo == .Ambiente || itemOrcamento.tipoDetalheComplexo == .AmbienteCompleto {
                itemOrcamentoNovo.itemOrcamentoPai = itemOrcamento
                novaSequencia = novaSequenciaParedeAvulsa(itemOrcamento.indice)

                itemOrcamentoPai = itemOrcamento
            }
            else {
                // Está adicionando de outra parede avulsa, adicionamos o ambiente pai da original
                itemOrcamentoNovo.itemOrcamentoPai = itemOrcamento.itemOrcamentoPai
                novaSequencia = novaSequenciaParedeAvulsa(itemOrcamento.itemOrcamentoPai!.indice)

                itemOrcamentoPai = itemOrcamento.itemOrcamentoPai
            }
            
            itemOrcamentoNovo.atualizaNomeAmbienteOuSequencia(nil, novaSequencia: novaSequencia)

            itemOrcamentoNovo.atualizaNomeAmbienteOuSequencia(novaSequencia)

            adicionaAmbiente(nil, id_texto: idDescricaoItem, sequencia: itemOrcamentoNovo.sequencia, textoAlternativoPai: itemOrcamentoPai!.textoAlternativo, id_texto_pai: itemOrcamentoPai!.idTexto, sequencia_pai: itemOrcamentoPai!.sequencia);

        }
        // Detalhes de teto avulso
        else if(tipoDetalheComplexo == TipoDetalheComplexo.TetoAvulso) {
            itemOrcamentoNovo.exibeBotaoParedeAvulsa = (false);
            itemOrcamentoNovo.exibeComprimento = (true);
            itemOrcamentoNovo.exibeAltura = (false);
            itemOrcamentoNovo.exibeQuantidadeInterruptores = (false);
            itemOrcamentoNovo.exibeQuantidadePortas = (false);
            itemOrcamentoNovo.exibeQuantidadeJanelas = (false);
            itemOrcamentoNovo.exibeBotaoTetoAvulso = (false);
            itemOrcamentoNovo.exibeBotaoAmbienteCompleto = false;
            
            var itemOrcamentoPai: ItemOrcamento?

            // Está adicionando de um item de ambiente
            if (itemOrcamento.tipoDetalheComplexo == TipoDetalheComplexo.Ambiente) || itemOrcamento.tipoDetalheComplexo == .AmbienteCompleto {
                itemOrcamentoNovo.itemOrcamentoPai = itemOrcamento
                novaSequencia = novaSequenciaTetoAvulso(itemOrcamento.indice)

                itemOrcamentoPai = itemOrcamento
            }
            else {
                // Está adicionando de outro teto, adicionamos o ambiente pai da original
                itemOrcamentoNovo.itemOrcamentoPai = itemOrcamento.itemOrcamentoPai
                novaSequencia = novaSequenciaTetoAvulso(itemOrcamento.itemOrcamentoPai!.indice)

                itemOrcamentoPai = itemOrcamento.itemOrcamentoPai
            }

            itemOrcamentoNovo.atualizaNomeAmbienteOuSequencia(nil, novaSequencia: novaSequencia)

            adicionaAmbiente(nil, id_texto: idDescricaoItem, sequencia: itemOrcamentoNovo.sequencia, textoAlternativoPai: itemOrcamentoPai!.textoAlternativo, id_texto_pai: itemOrcamentoPai!.idTexto, sequencia_pai: itemOrcamentoPai!.sequencia);
        }
        else {
            
            adicionaAmbiente(nil, id_texto: idDescricaoItem, sequencia: itemOrcamentoNovo.sequencia);
        }

        itensOrcamento!.append(itemOrcamentoNovo);
        
        if(mNotificadorMudanca != nil) {
            mNotificadorMudanca!.novoSubitem(itemOrcamentoRaiz, subitem: itemOrcamentoNovo);
        }
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
    }
    
    func selecionaCores(_ itemOrcamento: ItemOrcamentoComplexoDetalhe) {
        
        if (mNotificadorMudanca == nil) {
            return;
        }
        
        // As janelas serão sobrepostas, por isso coloca na ordem inversa....
        
        if(itemOrcamento.configuracaoMassaCorrida) {
            mNotificadorMudanca!.selecionaMassaCorrida(itemOrcamento);
        }
        
        if (itemOrcamento.configuracaoTintaTeto != nil) {
            
            itemOrcamento.configuracaoTintaTeto!.nomeAmbiente = itemOrcamento.texto()
            
            mNotificadorMudanca!.selecionaCor(itemOrcamento, configuracaoTinta: itemOrcamento.configuracaoTintaTeto);
        }
        
        let itemTipoPintura = buscaItemOrcamentoPorIndice(indiceSelecaoTipoPintura) as! ItemOrcamentoSimples?
        
        let tipoPintura = TipoPintura(rawValue: itemTipoPintura!.itemSelecionado!);
        
        if(tipoPintura == TipoPintura.ParedesETeto || tipoPintura == TipoPintura.SomenteParedes) {
            
            let stringQuantidadeJanelas = itemOrcamento.quantidadeJanelas,
            stringQuantidadePortas = itemOrcamento.quantidadePortas;
            
            let quantidadeJanelas = (stringQuantidadeJanelas == nil || stringQuantidadeJanelas!.isEmpty) ? 0 : Int(stringQuantidadeJanelas!),
            quantidadePortas = (stringQuantidadePortas == nil || stringQuantidadePortas!.isEmpty) ? 0 : Int(stringQuantidadePortas!);
            
            // Neste ponto podem não ter sido adicionadas ainda as configuração de cores, ou podem
            // ter sido adicionadas, mas o usuário mudou para 0
            
            if(quantidadeJanelas <= 0) {
                itemOrcamento.setConfiguracaoTinta(LocalPintura.Janelas, configuracaoTinta: nil);
            }
            else {
                
                if (itemOrcamento.configuracaoTintaJanelas == nil) {
                    itemOrcamento.adicionaConfiguracaoTinta(LocalPintura.Janelas);
                }
                
                itemOrcamento.configuracaoTintaJanelas!.nomeAmbiente = itemOrcamento.texto()
                
                if mNotificadorMudanca != nil {
                    mNotificadorMudanca!.selecionaCor(itemOrcamento, configuracaoTinta: itemOrcamento.configuracaoTintaJanelas);
                }
            }
            
            if(quantidadePortas <= 0) {
                itemOrcamento.setConfiguracaoTinta(LocalPintura.Portas, configuracaoTinta: nil);
            }
            else {
                
                if (itemOrcamento.configuracaoTintaPortas == nil) {
                    itemOrcamento.adicionaConfiguracaoTinta(LocalPintura.Portas);
                }
                
                itemOrcamento.configuracaoTintaPortas!.nomeAmbiente = itemOrcamento.texto()

                if mNotificadorMudanca != nil {
                    mNotificadorMudanca!.selecionaCor(itemOrcamento, configuracaoTinta: itemOrcamento.configuracaoTintaPortas);
                }
            }
        }
        
        if (itemOrcamento.configuracaoTintaParedes != nil) {
            
            itemOrcamento.configuracaoTintaParedes!.nomeAmbiente = itemOrcamento.texto()
            
            mNotificadorMudanca!.selecionaCor(itemOrcamento, configuracaoTinta: itemOrcamento.configuracaoTintaParedes);
        }
    }
    
    func duplicarItemOrcamento(_ itemOrcamento: ItemOrcamento) {
        
        if (itemOrcamento.tipo == TipoItem.trincaDetalhe) {
            
            let novaSequenciaTrinca = self.novaSequenciaTrinca();
            
            let itemOrcamentoDuplicado : ItemOrcamentoTrincaDetalhe = ItemOrcamentoTrincaDetalhe(novoIndice: novoIndiceOrcamento(), novaSequencia: novaSequenciaTrinca, itemOrcamentoCopiar: itemOrcamento as! ItemOrcamentoTrincaDetalhe);
            
            itemOrcamentoDuplicado.exibeBotaoExcluir = (true);
            
            itensOrcamento!.append(itemOrcamentoDuplicado);
            
            let itemOrcamentoRaiz = buscaPrimeiroItemPorTipo(TipoItem.trinca) as! ItemOrcamentoTrinca?
            
            itemOrcamentoRaiz!.aumentaQuantidade();
            
            //assert itemOrcamentoRaiz != nil;
            
            if(mNotificadorMudanca != nil) {
                mNotificadorMudanca!.novoSubitem(itemOrcamentoRaiz, subitem: itemOrcamentoDuplicado);
            }
            
        } else if (itemOrcamento.tipo == TipoItem.complexoDetalhe) {
            
            var novaSequencia: Int
            var idDescricaoItem: String?
            
            let itemOrcamentoOriginal = itemOrcamento as! ItemOrcamentoComplexoDetalhe
            
            if(itemOrcamentoOriginal.tipoDetalheComplexo == TipoDetalheComplexo.Ambiente || itemOrcamentoOriginal.tipoDetalheComplexo == TipoDetalheComplexo.AmbienteCompleto) {
                novaSequencia = novaSequenciaAmbiente();
                idDescricaoItem = "mascara_ambiente"
            }
            else if itemOrcamentoOriginal.tipoDetalheComplexo == TipoDetalheComplexo.ParedeAvulsa {
                novaSequencia = novaSequenciaParedeAvulsa(itemOrcamentoOriginal.itemOrcamentoPai!.indice);
                idDescricaoItem = "mascara_parede_avulsa"
            }
            else if itemOrcamentoOriginal.tipoDetalheComplexo == TipoDetalheComplexo.TetoAvulso {
                novaSequencia = novaSequenciaTetoAvulso(itemOrcamentoOriginal.itemOrcamentoPai!.indice);
                idDescricaoItem = "mascara_teto_avulso"
            }
            else {
                return
            }
            
            let itemOrcamentoDuplicado : ItemOrcamentoComplexoDetalhe = ItemOrcamentoComplexoDetalhe(novoIndice: novoIndiceOrcamento(), novaSequencia: novaSequencia, idNomeItem: idDescricaoItem, itemOrcamentoCopiar: itemOrcamento as! ItemOrcamentoComplexoDetalhe);

            itemOrcamentoDuplicado.exibeBotaoExcluir = (true);
            itemOrcamentoDuplicado.tipoDetalheComplexo = (itemOrcamentoOriginal.tipoDetalheComplexo);
            
            // Detalhes de parede avulsa
            if(itemOrcamentoOriginal.tipoDetalheComplexo == TipoDetalheComplexo.ParedeAvulsa) {
                itemOrcamentoDuplicado.exibeBotaoParedeAvulsa = (false);
                itemOrcamentoDuplicado.exibeComprimento = (false);
                
                // Está adicionando de outra parede avulsa, adicionamos o ambiente pai da original
                itemOrcamentoDuplicado.itemOrcamentoPai = itemOrcamentoOriginal.itemOrcamentoPai

                let itemOrcamentoPai = itemOrcamentoOriginal.itemOrcamentoPai

                adicionaAmbiente(nil, id_texto: idDescricaoItem, sequencia: novaSequencia, textoAlternativoPai: itemOrcamentoPai!.textoAlternativo, id_texto_pai: itemOrcamentoPai!.idTexto, sequencia_pai: itemOrcamentoPai!.sequencia);

            }
            // Detalhes do teto avulso
            else if(itemOrcamentoOriginal.tipoDetalheComplexo == TipoDetalheComplexo.TetoAvulso) {
                itemOrcamentoDuplicado.exibeBotaoParedeAvulsa = (false);
                itemOrcamentoDuplicado.exibeBotaoTetoAvulso = (false);
                itemOrcamentoDuplicado.exibeComprimento = (true);
                itemOrcamentoDuplicado.exibeAltura = (false);
                itemOrcamentoDuplicado.exibeQuantidadeInterruptores = (false);
                itemOrcamentoDuplicado.exibeQuantidadePortas = (false);
                itemOrcamentoDuplicado.exibeQuantidadeJanelas = (false);

                // Está adicionando de outro teto avulso, adicionamos o ambiente pai da original
                itemOrcamentoDuplicado.itemOrcamentoPai = itemOrcamentoOriginal.itemOrcamentoPai;

                let itemOrcamentoPai = itemOrcamentoOriginal.itemOrcamentoPai
                
                adicionaAmbiente(nil, id_texto: idDescricaoItem, sequencia: novaSequencia, textoAlternativoPai: itemOrcamentoPai!.textoAlternativo, id_texto_pai: itemOrcamentoPai!.idTexto, sequencia_pai: itemOrcamentoPai!.sequencia);
            }
            else {
                adicionaAmbiente(nil, id_texto: idDescricaoItem, sequencia: novaSequencia);
            }

            itensOrcamento!.append(itemOrcamentoDuplicado);
            
            let itemOrcamentoRaiz = buscaPrimeiroItemPorTipo(TipoItem.complexo)
            
            //assert itemOrcamentoRaiz != nil;
            
            if(mNotificadorMudanca != nil) {
                mNotificadorMudanca!.novoSubitem(itemOrcamentoRaiz, subitem: itemOrcamentoDuplicado);
            }
        }
    }
    
    
    func selecionaPintura(_ tipoPintura: TipoPintura) {
        
        var itemComplexoRaiz : ItemOrcamentoComplexo? = nil
        
        itemComplexoRaiz = buscaPrimeiroItemPorTipo(TipoItem.complexo) as! ItemOrcamentoComplexo?
        
        let descricao = descricaoItemComplexo(tipoPintura);
        
        // Limpa a lista antes
        listaAmbientes = nil;
        
        if (itemComplexoRaiz == nil) {
            
            itemComplexoRaiz = ItemOrcamentoComplexo();
            
            itemComplexoRaiz?.indice = (novoIndiceOrcamento());
            //itemComplexoRaiz.sequencia = (novaSequenciaItemPrincipal());
            itemComplexoRaiz?.idTexto = (descricao);
            itemComplexoRaiz?.exibeSequencia = (false);
            
            itensOrcamento!.append(itemComplexoRaiz!);
            
            if(mNotificadorMudanca != nil) {
                mNotificadorMudanca!.novoItemPrincipal(itemComplexoRaiz);
            }
            
        } else {
            
            itemComplexoRaiz?.idTexto = (descricao);
            
            if(mNotificadorMudanca != nil) {
                mNotificadorMudanca!.mudouItemPrincipal(itemComplexoRaiz);
            }
            
            removeItensTipo(TipoItem.complexoDetalhe);
            
            sequenciaAmbiente = 0;
        }
        
        itemComplexoRaiz?.tipoPintura = (tipoPintura);
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        let tipoDetalheComplexo = TipoDetalheComplexo.Ambiente
        
        // Adiciona o detalhe
        
        // Padrão é ambiente
        let id_texto = "mascara_ambiente"

        let itemComplexoDetalhe: ItemOrcamentoComplexoDetalhe = criaNovoItemOrcamentoComplexoDetalhe(tipoPintura, tipoDetalheComplexo: tipoDetalheComplexo, idTexto: id_texto, sequencia: novaSequenciaAmbiente());
        
        itemComplexoDetalhe.exibeBotaoExcluir = (false);
        itemComplexoDetalhe.tipoDetalheComplexo = tipoDetalheComplexo
        itemComplexoDetalhe.exibeBotaoTetoAvulso = true

        // Quando é paredes e teto os ambientes já são completos, não precisa do botão
        if( tipoPintura != TipoPintura.ParedesETeto ) {
            itemComplexoDetalhe.exibeBotaoAmbienteCompleto = (true);
        }

        adicionaAmbiente(nil, id_texto: itemComplexoDetalhe.idTexto, sequencia: itemComplexoDetalhe.sequencia);
        
        itensOrcamento!.append(itemComplexoDetalhe);
        
        if(mNotificadorMudanca != nil) {
            mNotificadorMudanca!.novoSubitem(itemComplexoRaiz, subitem: itemComplexoDetalhe);
        }
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        // Adiciona também o item da trinca se ainda não existe...
        
        if (!existeItemTipo(TipoItem.trinca)) {
            
            let itemOrcamentoTrinca = ItemOrcamentoTrinca();
            itemOrcamentoTrinca.indice = novoIndiceOrcamento()
            itemOrcamentoTrinca.sequencia = novaSequenciaItemPrincipal()
            itemOrcamentoTrinca.idTextoAjuda = "ajuda_passo_5";
            itemOrcamentoTrinca.botoes = [
                BotaoItemOrcamento(imagemH: "retina_6a_h", imagemA: "retina_6a", idTexto: "literal_sim", idTextoResposta: "resposta_trinca_sim", textoSelecao: "true"),
                BotaoItemOrcamento(imagemH: "retina_6b_h", imagemA: "retina_6b", idTexto: "literal_nao", idTextoResposta: "resposta_trinca_nao", textoSelecao: "false")
            ]
            
            itemOrcamentoTrinca.idTexto = "pergunta_simples6"
            
            indiceTrincaRaiz = itemOrcamentoTrinca.indice;
            
            itensOrcamento!.append(itemOrcamentoTrinca);
            
            if(mNotificadorMudanca != nil) {
                mNotificadorMudanca!.novoItemPrincipal(itemOrcamentoTrinca);
            }
        }
        
    }
    
    func existeItemTipo(_ tipoItem: TipoItem) -> Bool {
        
        for itemOrcamento in itensOrcamento! {
            if (itemOrcamento.tipo == tipoItem) {
                return true;
            }
        }
        
        return false;
    }
    
    
    func adicionaAmbiente(_ textoAlternativo: String?, id_texto: String?, sequencia: Int?) {
        
        if(listaAmbientes == nil) {
            listaAmbientes = Array<ItemAmbienteTrinca>();
        }
        
        let itemAmbienteTrinca = ItemAmbienteTrinca(textoAlternativo: textoAlternativo, id_texto: id_texto, sequencia: sequencia)

        listaAmbientes!.append(itemAmbienteTrinca);
        
        let array = [ItemAmbienteTrinca](listaAmbientes!);
        
        if(mNotificadorMudanca != nil) {
            mNotificadorMudanca!.listaAmbienteMudou(nil, textoAlternativo: nil, id_texto: nil, sequencia: 0, listaAmbientes: array);
        }
    }

    func adicionaAmbiente(_ textoAlternativo: String?, id_texto: String?, sequencia: Int?, textoAlternativoPai: String?, id_texto_pai: String?, sequencia_pai: Int) {

        if(listaAmbientes == nil) {
            listaAmbientes = Array<ItemAmbienteTrinca>();
        }

        let itemAmbienteTrinca = ItemAmbienteTrinca(textoAlternativo: textoAlternativo, id_texto: id_texto, sequencia: sequencia, textoAlternativoPai: textoAlternativoPai, id_texto_pai: id_texto_pai, sequencia_pai: sequencia_pai)

        let indice = listaAmbientes?.index(where: { (elemento) -> Bool in
            return elemento.equals(itemAmbienteTrinca)
        })

        if indice != nil {
            return
        }

        listaAmbientes!.append(itemAmbienteTrinca);

        let array = [ItemAmbienteTrinca](listaAmbientes!);

        if(mNotificadorMudanca != nil) {
            mNotificadorMudanca!.listaAmbienteMudou(nil, textoAlternativo: nil, id_texto: nil, sequencia: 0, listaAmbientes: array);
        }
    }


    func criaNovoItemOrcamentoComplexoDetalhe(_ tipoPintura: TipoPintura, tipoDetalheComplexo: TipoDetalheComplexo, idTexto: String?, sequencia: Int) -> ItemOrcamentoComplexoDetalhe {
        
        let itemComplexoDetalhe = ItemOrcamentoComplexoDetalhe();
        
        itemComplexoDetalhe.idTexto = idTexto
        //itemComplexoDetalhe.sequencia = sequencia
        itemComplexoDetalhe.atualizaNomeAmbienteOuSequencia(sequencia)
        itemComplexoDetalhe.indice = (novoIndiceOrcamento());
        
        // Os itens de portas e janelas dependem do cliente ter colocado estes parâmetros, por isso
        // não são adicionados aqui

        // Injeta um ambiente completo, ignorando o que foi escolhido para tipoPintura
        if ( tipoDetalheComplexo == TipoDetalheComplexo.AmbienteCompleto ) {
            // Deve ser os mesmos itens de ParedesETeto, mas sem as regras de avulso
            itemComplexoDetalhe.adicionaConfiguracaoTinta(LocalPintura.Paredes);
            itemComplexoDetalhe.adicionaConfiguracaoTinta(LocalPintura.Teto);
            itemComplexoDetalhe.configuracaoMassaCorrida = (true);
        }
        else {

            switch (tipoPintura) {
            case TipoPintura.ParedesETeto:
                // Se é teto avulso, não tem parede pra pintar
                if tipoDetalheComplexo != TipoDetalheComplexo.TetoAvulso {
                    itemComplexoDetalhe.adicionaConfiguracaoTinta(LocalPintura.Paredes);
                }
                // Se é parede avulsa, não tem teto pra pintar
                if tipoDetalheComplexo != TipoDetalheComplexo.ParedeAvulsa {
                    itemComplexoDetalhe.adicionaConfiguracaoTinta(LocalPintura.Teto);
                }
                itemComplexoDetalhe.configuracaoMassaCorrida = (true);
                break;
            case TipoPintura.SomenteParedes:
                // Se é teto avulso, não tem parede pra pintar
                if tipoDetalheComplexo != TipoDetalheComplexo.TetoAvulso {
                    itemComplexoDetalhe.adicionaConfiguracaoTinta(LocalPintura.Paredes);
                }
                itemComplexoDetalhe.configuracaoMassaCorrida = (true);
                break;
            case TipoPintura.SomenteTeto:
                // Se é parede avulsa, não tem teto pra pintar
                if tipoDetalheComplexo != TipoDetalheComplexo.ParedeAvulsa {
                    itemComplexoDetalhe.adicionaConfiguracaoTinta(LocalPintura.Teto);
                }
                itemComplexoDetalhe.configuracaoMassaCorrida = (true);
                break;
            default:
                break
            }
        }
        
        ajustaExibicaoItemOrcamento(tipoPintura, itemOrcamentoComplexoDetalhe: itemComplexoDetalhe, tipoDetalheComplexo: tipoDetalheComplexo);
        
        return itemComplexoDetalhe;
    }
    
    func selecionouOpcaoSimples(_ itemOrcamentoSimples: ItemOrcamentoSimples) {
        
        /*let itemOrcamento = buscaItemOrcamentoPorIndice(itemOrcamentoSimples.indice) as! ItemOrcamentoSimples?
         
         if(itemOrcamento == nil) {
         return;
         }
         
         itemOrcamento!.itemSelecionado = itemOrcamentoSimples.itemSelecionado*/
    }
    
    func ajustaExibicaoItemOrcamento(_ tipoPintura: TipoPintura, itemOrcamentoComplexoDetalhe: ItemOrcamentoComplexoDetalhe, tipoDetalheComplexo: TipoDetalheComplexo) {
        
        if ( tipoDetalheComplexo == TipoDetalheComplexo.AmbienteCompleto ) {
            // Os demais itens devem ser iguais a ParedesETeto
        }
        else {
            switch (tipoPintura) {
            case TipoPintura.ParedesETeto:
                break;
            case TipoPintura.SomenteParedes:
                itemOrcamentoComplexoDetalhe.exibeComprimento = (false);
                break;
            case TipoPintura.SomenteTeto:
                itemOrcamentoComplexoDetalhe.exibeAltura = (false);
                itemOrcamentoComplexoDetalhe.exibeQuantidadePortas = (false);
                itemOrcamentoComplexoDetalhe.exibeQuantidadeJanelas = (false);
                itemOrcamentoComplexoDetalhe.exibeQuantidadeInterruptores = (false);
                break;
            default:
                break
            }
        }
    }
    
    func removeItensTipo(_ tipoItem: TipoItem) -> Int {
        
        var itensRemover = Array<ItemOrcamento>()
        
        // Monta a lista de itens a remover
        
        for itemOrcamento in itensOrcamento! {
            
            if (itemOrcamento.tipo == tipoItem) {
                itensRemover.append(itemOrcamento);
            }
        }
        
        // Remove da lista interna
        for itemOrcamento in itensRemover {
            
            let indice = itensOrcamento?.index(where: { (item: ItemOrcamento) -> Bool in
                return item === itemOrcamento
            })
            
            itensOrcamento?.remove(at: indice!)
            
            if(mNotificadorMudanca != nil) {
                mNotificadorMudanca!.removeSubitem(itemOrcamento);
            }
        }
        
        return itensRemover.count;
    }
    
    func validaNotificaOrcamentoValido() {
        
        var listaErros = Array<ItemErroOrcamento>();
        
        let orcamentoValido = valido(&listaErros);
        
        if(mNotificadorMudanca != nil) {
            mNotificadorMudanca!.mudouOrcamentoValido(orcamentoValido, listaErros: listaErros);
        }
    }
    
    func valido(_ listaErros: inout Array<ItemErroOrcamento>) -> Bool {
        
        var valido = true;
        
        for itemOrcamento in itensOrcamento! {
            
            if(!itemOrcamento.valido(&listaErros)) {
                valido = false;
            }
        }
        
        return valido;
    }
    
    func buscaItemOrcamentoPorId(_ id: Int) -> ItemOrcamento? {
        
        for itemOrcamento in itensOrcamento! {
            
            if itemOrcamento is ItemOrcamentoComplexoDetalhe {
                
                let itemOrcamentoComplexoDetalhe = itemOrcamento as! ItemOrcamentoComplexoDetalhe
                
                if (itemOrcamentoComplexoDetalhe.id == id) {
                    return itemOrcamento;
                }
            }
            else if(itemOrcamento is ItemOrcamentoTrincaDetalhe) {
                
                let itemOrcamentoTrincaDetalhe = itemOrcamento as! ItemOrcamentoTrincaDetalhe
                
                if (itemOrcamentoTrincaDetalhe.id == id) {
                    return itemOrcamento;
                }
            }
            
        }
        
        return nil;
    }
    
    func atualizaChecklistTrincas(_ aprovado: Bool) {

        let itemOrcamentoTrinca = buscaPrimeiroItemPorTipo(TipoItem.trinca) as! ItemOrcamentoTrinca

        itemOrcamentoTrinca.checkListAprovado = aprovado
    }

    func atualizaChecklistPergunta(_ numeroPergunta: Int, aprovado: Bool) {
        
        var sequenciaPergunta = 1;
        
        for itemOrcamento in itensOrcamento! {
            
            if(!(itemOrcamento.tipo == TipoItem.simples && itemOrcamento is ItemOrcamentoSimples)) {
                continue;
            }
            
            if(sequenciaPergunta == numeroPergunta) {
                
                let itemOrcamentoSimples = itemOrcamento as! ItemOrcamentoSimples;
                itemOrcamentoSimples.checkListAprovado = aprovado
                break;
            }
            
            sequenciaPergunta += 1
        }
    }
    
    func gerarConteudoApiChecklist(_ idFranquia: Int) -> Dictionary<String, AnyObject>? {
        
        var raiz = Dictionary<String, AnyObject>()
        
        var numero_pergunta = 1;
        
        do {
            
            raiz["id_franquia"] = idFranquia as AnyObject?
            raiz["id_sessao"] = PinturaAJatoApi.obtemIdSessao() as AnyObject?
            raiz["id_orcamento"] = id as AnyObject?
            
            for itemOrcamento in itensOrcamento! {
                if(!(itemOrcamento.tipo == TipoItem.simples && itemOrcamento is ItemOrcamentoSimples)) {
                    continue;
                }
                
                let itemOrcamentoSimples = itemOrcamento as! ItemOrcamentoSimples
                
                raiz[String(format:"pergunta_%d", numero_pergunta)] = itemOrcamentoSimples.checkListAprovado as AnyObject?
                
                numero_pergunta += 1
            }
            
            var array_item_orcamento = Array<Dictionary<String, AnyObject>>()
            
            let locaisPintura = [ LocalPintura.Teto, LocalPintura.Paredes, LocalPintura.Janelas, LocalPintura.Portas ]
            
            //ItemOrcamentoComplexo itemOrcamentoComplexo = (ItemOrcamentoComplexo)buscaPrimeiroItemPorTipo(TipoItem.Complexo);
            
            for itemOrcamento in itensOrcamento! {
                if(!(itemOrcamento.tipo == TipoItem.complexoDetalhe && itemOrcamento is ItemOrcamentoComplexoDetalhe)) {
                    continue;
                }
                
                var json_item_complexo = Dictionary<String, AnyObject>()
                
                let itemOrcamentoComplexoDetalhe = itemOrcamento as! ItemOrcamentoComplexoDetalhe
                
                json_item_complexo["id"] = itemOrcamentoComplexoDetalhe.id as AnyObject?
                json_item_complexo["resposta"] = itemOrcamentoComplexoDetalhe.checklistAprovado as AnyObject?
                
                var array_itens_pintura = Array<Dictionary<String, AnyObject>>()
                
                for localPintura in locaisPintura {
                    
                    let configuracaoTinta = itemOrcamentoComplexoDetalhe.configuracaoTinta(localPintura);
                    
                    if(configuracaoTinta == nil) {
                        continue;
                    }
                    
                    var item_pintura = Dictionary<String, AnyObject>()
                    
                    item_pintura["id"] = configuracaoTinta!.id as AnyObject?
                    item_pintura["resposta"] = configuracaoTinta?.checklistAprovado as AnyObject?
                    
                    
                    array_itens_pintura.append(item_pintura)
                }
                
                if(array_itens_pintura.count > 0) {
                    json_item_complexo["item_pintura"] = array_itens_pintura as AnyObject?
                }
                
                array_item_orcamento.append(json_item_complexo)
                
            }
            
            raiz["orcamento_item"] = array_item_orcamento as AnyObject?
            
            ////////////////////////////////////////////////////////////////////////////////////////
            
            let itemOrcamentoTrinca =  buscaPrimeiroItemPorTipo(TipoItem.trinca) as! ItemOrcamentoTrinca
            
            raiz["trincas"] = itemOrcamentoTrinca.checkListAprovado as AnyObject?

            //if(itemOrcamentoTrinca.itemSelecionado == "true") {
                
                var array_itens_trinca = Array<Dictionary<String, AnyObject>>()
                
                for itemOrcamento in itensOrcamento! {
                    
                    if(!(itemOrcamento.tipo == TipoItem.trincaDetalhe && itemOrcamento is  ItemOrcamentoTrincaDetalhe)) {
                        continue;
                    }
                    
                    let itemOrcamentoTrincaDetalhe = itemOrcamento as! ItemOrcamentoTrincaDetalhe
                    
                    var item_trinca = Dictionary<String, AnyObject>()
                    
                    item_trinca["id"] = itemOrcamentoTrincaDetalhe.id as AnyObject?
                    item_trinca["resposta"] = itemOrcamentoTrinca.checkListAprovado as AnyObject?
                    
                    array_itens_trinca.append(item_trinca)
                }
                
                raiz["orcamento_trinca"] = array_itens_trinca as AnyObject?
            //}
            
        }
        catch  {
            
            //Registro.registraExcecao("Falha gerando conteúdo JSON", ex);
            
            return nil
        }
        
        return raiz;
    }
    
    func gerarConteudoApiInsercao(_ idFranquia: Int) ->  Dictionary<String, AnyObject>? {
        
        var raiz = Dictionary<String, AnyObject>();
        
        var numero_pergunta = 1;
        
        do {
            
            let version = Bundle.main.infoDictionary?["CFBundleVersion"]
            
            raiz["id_franquia"] = (idFranquia as AnyObject?);
            raiz["id_sessao"] = PinturaAJatoApi.obtemIdSessao() as AnyObject?
            raiz["id_cliente"] = (id_cliente as AnyObject?);
            raiz["status"] = (1 as AnyObject?);
            raiz["descricao"] = "Orçamento gerado via iOS (app:\(version)) às \(Date())" as AnyObject?
            
            if(resultadoCalculo == nil)
            {
                raiz["valor"] = 0.0 as AnyObject?
            }
            else
            {
                raiz["valor"] = resultadoCalculo!.valorTotal as AnyObject?
            }
            
            if(resultadoCalculo == nil)
            {
                raiz["valor_bruto"] = 0.0 as AnyObject?
            }
            else
            {
                raiz["valor_bruto"] = resultadoCalculo!.valorTotal as AnyObject?
            }
            
            if(resultadoCalculo == nil)
            {
                raiz["dias_servico"] = 0 as AnyObject?
            }
            else
            {
                raiz["dias_servico"] = resultadoCalculo!.diasTotal as AnyObject?
            }
            
            //raiz["valor"] = (resultadoCalculo == nil ? 0.0 : resultadoCalculo!.valorTotal);
            //raiz["valor_bruto"] = (resultadoCalculo == nil ? 0.0 : resultadoCalculo!.valorTotal);
            //raiz["dias_servico"] = resultadoCalculo == nil ? 0 : (resultadoCalculo!.diasTotal) as AnyObject?;
            
            for itemOrcamento in itensOrcamento! {
                
                if(!(itemOrcamento.tipo == TipoItem.simples && itemOrcamento is ItemOrcamentoSimples)){
                    continue;
                }
                
                let itemOrcamentoSimples = itemOrcamento as! ItemOrcamentoSimples;
                
                raiz[String(format: "pergunta_%d", numero_pergunta)] = (itemOrcamentoSimples.itemSelecionado as AnyObject?)
                numero_pergunta += 1
            }
            
            var array_item_orcamento = Array<Dictionary<String, AnyObject>>()
            
            let locaisPintura: [LocalPintura] =  [ LocalPintura.Teto, LocalPintura.Paredes, LocalPintura.Janelas, LocalPintura.Portas];
            
            //ItemOrcamentoComplexo itemOrcamentoComplexo = (ItemOrcamentoComplexo)buscaPrimeiroItemPorTipo(TipoItem.Complexo);
            
            for itemOrcamento in itensOrcamento! {
                
                if(!(itemOrcamento.tipo == TipoItem.complexoDetalhe && itemOrcamento is ItemOrcamentoComplexoDetalhe)) {
                    continue;
                }
                
                var json_item_complexo = Dictionary<String, AnyObject>()
                
                let itemOrcamentoComplexoDetalhe = itemOrcamento as! ItemOrcamentoComplexoDetalhe;
                
                json_item_complexo["tipo_registro"] = (itemOrcamentoComplexoDetalhe.tipoDetalheComplexo.rawValue as AnyObject?);
                json_item_complexo["descricao"] = (itemOrcamentoComplexoDetalhe.texto() as AnyObject?);
                json_item_complexo["altura"] = (itemOrcamentoComplexoDetalhe.altura as AnyObject?);
                json_item_complexo["largura"] = (itemOrcamentoComplexoDetalhe.largura as AnyObject?);
                json_item_complexo["comprimento"] = (itemOrcamentoComplexoDetalhe.comprimento as AnyObject?);
                json_item_complexo["portas"] = (itemOrcamentoComplexoDetalhe.quantidadePortas as AnyObject?);
                json_item_complexo["janelas"] = (itemOrcamentoComplexoDetalhe.quantidadeJanelas as AnyObject?);
                json_item_complexo["interruptores"] = (itemOrcamentoComplexoDetalhe.quantidadeInterruptores as AnyObject?);
                json_item_complexo["indice"] = itemOrcamentoComplexoDetalhe.indice as AnyObject?
                
                if(itemOrcamentoComplexoDetalhe.configuracaoMassaCorrida) {
                    let necessitaMassaCorridaString = (itemOrcamentoComplexoDetalhe.necessitaMassaCorrida == nil ? "0" : (itemOrcamentoComplexoDetalhe.necessitaMassaCorrida! ? "1" : "0"))
                    json_item_complexo["massa_corrida"] = necessitaMassaCorridaString as AnyObject?
                }
                
                var array_itens_pintura = Array< Dictionary<String, AnyObject> >()
                
                for localPintura in locaisPintura {
                    
                    let configuracaoTinta = itemOrcamentoComplexoDetalhe.configuracaoTinta(localPintura);
                    
                    if(configuracaoTinta == nil) {
                        continue;
                    }
                    
                    //if(array_itens_pintura == nil) {
                    //    array_itens_pintura = NSMutableArray();
                    //}
                    
                    var item_pintura = Dictionary<String, AnyObject>()
                    
                    item_pintura["nao_pintar"] = (configuracaoTinta!.naoPintara ? 1 as AnyObject : 0 as AnyObject?);
                    item_pintura["tipo_registro"] = (configuracaoTinta!.localPintura.rawValue as AnyObject?);
                    
                    if(!configuracaoTinta!.naoPintara) {
                        
                        item_pintura["fornecer_tintas"] = (configuracaoTinta!.clienteForneceTintas ? 1 as AnyObject : 0 as AnyObject?);
                        
                        if (!configuracaoTinta!.clienteForneceTintas) {
                            item_pintura["cor"] = (configuracaoTinta!.cor.rawValue as AnyObject?)
                            item_pintura["acabamento"] = (configuracaoTinta!.acabamento.rawValue as AnyObject?);
                            item_pintura["tipo_tinta"] = (configuracaoTinta!.tipo.rawValue as AnyObject?);
                        }
                    }
                    
                    array_itens_pintura.append(item_pintura);
                }
                
                if(array_itens_pintura.count > 0) {
                    json_item_complexo["item_pintura"] = (array_itens_pintura as AnyObject?);
                }
                
                array_item_orcamento.append(json_item_complexo);
                
            }
            
            if(array_item_orcamento.count > 0) {
                raiz["orcamento_item"] = (array_item_orcamento as AnyObject?);
            }

            /////////////////////////////////////////////////////////////////////
            
            let itemOrcamentoTrinca = buscaPrimeiroItemPorTipo(TipoItem.trinca) as! ItemOrcamentoTrinca?;
            
            if(itemOrcamentoTrinca != nil && itemOrcamentoTrinca!.itemSelecionado != nil && itemOrcamentoTrinca!.itemSelecionado == "true") {
                
                var array_itens_trinca = Array<Dictionary<String, AnyObject>>()
                
                for itemOrcamento in itensOrcamento! {
                    
                    if(!(itemOrcamento.tipo == TipoItem.trincaDetalhe && itemOrcamento is ItemOrcamentoTrincaDetalhe)) {
                        continue;
                    }
                    
                    let itemOrcamentoTrincaDetalhe = itemOrcamento as! ItemOrcamentoTrincaDetalhe
                    
                    var item_trinca = Dictionary<String, AnyObject>()
                    
                    item_trinca["tamanho"] = (itemOrcamentoTrincaDetalhe.tamanhoTrinca as AnyObject?);
                    item_trinca["tipo_registro"] = ("Trinca" as AnyObject?);
                    item_trinca["ambiente"] = (itemOrcamentoTrincaDetalhe.itemAmbiente?.textoAmbiente() as AnyObject?);
                    item_trinca["ambiente_pai"] = (itemOrcamentoTrincaDetalhe.itemAmbiente?.textoAmbientePai() as AnyObject?);
                    item_trinca["indice"] = itemOrcamentoTrincaDetalhe.indice as AnyObject?
                    
                    array_itens_trinca.append(item_trinca);
                }
                
                if(array_itens_trinca.count > 0) {
                    raiz["orcamento_trinca"] = (array_itens_trinca as AnyObject?);
                }
            }
            
            
            /////////////////////////////////////////////////////////////////////
            
            // Adiciona valores agregados (ex: cálculo da tinta)
            
            if valores_agregados != nil {
                
                for item_agregado in valores_agregados! {
                    
                    raiz[item_agregado.0] = item_agregado.1
                }
            }
            
            
        }
        catch /*(JSONException ex)*/ {
            
            Registro.registraErro("Falha gerando conteúdo JSON inserção");
            
            return nil;
        }
        
        return raiz;
    }
    
    func buscaPrimeiroItemPorTipo(_ tipoItem: TipoItem) ->  ItemOrcamento? {
        
        for itemOrcamento in itensOrcamento! {
            
            if (itemOrcamento.tipo == tipoItem) {
                return itemOrcamento;
            }
        }
        
        return nil;
    }
    
    func criaOrcamentoInicial(_ notifica: Bool) -> [ItemOrcamento]? {
        
        var orcamentoInicial = [ItemOrcamento]();
        
        let item1 = ItemOrcamentoSimples();
        item1.indice = novoIndiceOrcamento();
        item1.sequencia = novaSequenciaItemPrincipal()
        item1.idTexto = "pergunta_simples1";
        item1.idTextoAjuda = "ajuda_passo_1";
        
        item1.botoes = [
            BotaoItemOrcamento(imagemH: "retina_1a_h", imagemA: "retina_1a", idTexto: "literal_1a_pintura", idTextoResposta: "resposta_simples1_sim", textoSelecao: "true"),
            BotaoItemOrcamento(imagemH: "retina_1b_h", imagemA: "retina_1b", idTexto: "literal_repintura", idTextoResposta: "resposta_simples1_nao", textoSelecao: "false")
        ];
        
        indiceSelecaoPrimeiraPintura = item1.indice;
        
        orcamentoInicial.append(item1);
        
        if notifica {
            mNotificadorMudanca!.novoItemPrincipal(item1);
        }
        
        let item2 = ItemOrcamentoSimples()
        item2.indice = novoIndiceOrcamento()
        item2.sequencia = novaSequenciaItemPrincipal()
        item2.idTexto = "pergunta_simples2"
        item2.idTextoAjuda = "ajuda_passo_2";
        
        item2.botoes = [
            BotaoItemOrcamento(imagemH: "retina_2a_h", imagemA: "retina_2a", idTexto: "literal_sim", idTextoResposta: "resposta_simples2_sim", textoSelecao: "true"),
            BotaoItemOrcamento(imagemH: "retina_2b_h", imagemA: "retina_2b", idTexto: "literal_nao", idTextoResposta: "resposta_simples2_nao", textoSelecao: "false")
        ]
        
        indiceSelecaoImovelDesocupado = item2.indice;
        
        orcamentoInicial.append(item2);
        
        if notifica {
            mNotificadorMudanca!.novoItemPrincipal(item2);
        }
        
        /*ItemOrcamentoSimples item3 = ItemOrcamentoSimples();
         item3.indice = novoIndiceOrcamento());
         item3.sequencia = novaSequenciaItemPrincipal());
         item3.setTexto(mContext.getString("pergunta_simples3));
         item3.botoes = [ {
         BotaoItemOrcamento("retina_3a_h, "retina_3a, "Sim"),
         BotaoItemOrcamento("retina_3b_h, "retina_3b, "Não")
         });
         
         orcamentoInicial.add(item3);
         
         if(notifica)
         mNotificadorMudanca.novoItemPrincipal(TipoNotificacao.Adicionado, item3);*/
        
        
        let item4 = ItemOrcamentoSimples()
        item4.indice = novoIndiceOrcamento()
        item4.sequencia = novaSequenciaItemPrincipal()
        item4.idTexto = "pergunta_simples4"
        item4.idTextoAjuda = "ajuda_passo_3";
        
        item4.botoes = [
            BotaoItemOrcamento(imagemH: "retina_4a_h", imagemA: "retina_4a", idTexto: "literal_gesso", idTextoResposta: "resposta_simples4_gesso", textoSelecao: TipoAmbiente.Gesso.rawValue),
            BotaoItemOrcamento(imagemH: "retina_4b_h", imagemA: "retina_4b", idTexto: "literal_reboco", idTextoResposta: "resposta_simples4_reboco", textoSelecao: TipoAmbiente.Reboco.rawValue),
            BotaoItemOrcamento(imagemH: "retina_4c_h", imagemA: "retina_4c", idTexto: "literal_massa", idTextoResposta: "resposta_simples4_massa", textoSelecao: TipoAmbiente.Massa.rawValue)
        ]
        
        indiceSelecaoTipoLocalPintado = item4.indice
        
        orcamentoInicial.append(item4);
        
        if notifica {
            mNotificadorMudanca!.novoItemPrincipal(item4);
        }
        
        let item5 = ItemOrcamentoSimples()
        item5.indice = novoIndiceOrcamento()
        item5.sequencia = novaSequenciaItemPrincipal()
        item5.idTexto = "pergunta_simples5"
        item5.idTextoAjuda = "ajuda_passo_4";
        
        item5.botoes = [
            BotaoItemOrcamento(imagemH: "retina_5a_h", imagemA: "retina_5a", idTexto: "literal_paredes_teto", idTextoResposta: "resposta_simples_o_que_sera_pintado", textoSelecao: TipoPintura.ParedesETeto.rawValue),
            BotaoItemOrcamento(imagemH: "retina_5b_h", imagemA: "retina_5b", idTexto: "literal_somente_paredes", idTextoResposta: "resposta_simples_o_que_sera_pintado", textoSelecao: TipoPintura.SomenteParedes.rawValue),
            BotaoItemOrcamento(imagemH: "retina_5c_h", imagemA: "retina_5c", idTexto: "literal_somente_teto", idTextoResposta: "resposta_simples_o_que_sera_pintado", textoSelecao: TipoPintura.SomenteTeto.rawValue)
        ]
        
        indiceSelecaoTipoPintura = item5.indice
        
        orcamentoInicial.append(item5);
        
        if(notifica) {
            mNotificadorMudanca!.novoItemPrincipal(item5)
        }
        
        return orcamentoInicial;
    }
    
    static func extraiSequenciaTexto(_ texto: String?, idTexto: String) -> Int? {

        var pattern : NSRegularExpression? = nil

        let indice = cachePatternsTexto?.index(forKey: idTexto)

        if ( indice == nil ) {

            let textoMascara = mOrcamento!.obtemString(idTexto)

            do {
                pattern = try NSRegularExpression(pattern: textoMascara.replacingOccurrences(of: "%d", with: "(\\d+)"), options: .caseInsensitive)
            }
            catch {

            }

            cachePatternsTexto![idTexto] = pattern
        }
        else {
            pattern = cachePatternsTexto![idTexto]!
        }

        let range = NSRange(location:0, length: texto!.characters.count)

        let matches = pattern?.matches(in: texto!, options: NSRegularExpression.MatchingOptions.anchored, range: range)

        if matches == nil || matches?.count == 0 {
            return nil
        }

        let captura = matches![0].rangeAt(1)

        let texto2 = texto! as NSString

        return Int( texto2.substring(with: captura) );
    }


    static func recriaOrcamentoGerado(_ orcamentoGerado: OrcamentoGerado, notificaOrcamentoMudou: NotificaOrcamentoMudou?, parcial: Bool ) -> Orcamento? {
        
        cachePatternsTexto = [String:NSRegularExpression?]()

        mOrcamento = Orcamento(notificaOrcamentoMudou: notificaOrcamentoMudou);
        
        mOrcamento?.itensOrcamento = mOrcamento?.criaOrcamentoInicial(false);
        
        mOrcamento?.id = orcamentoGerado.id
        
        var tipoPintura = TipoPintura.Nenhum;
        
        // Supostamente só existem os itens simples....
        for itemOrcamento in (mOrcamento?.itensOrcamento)! {
            
            let itemOrcamentoSimples = itemOrcamento as! ItemOrcamentoSimples
            
            itemOrcamentoSimples.exibeBotoesCheckList = true
            
            if(mOrcamento!.eSelecaoPrimeiraPintura(itemOrcamento)) {
                itemOrcamentoSimples.itemSelecionado = orcamentoGerado.pergunta_1
            }
            else if(mOrcamento!.eSelecaoImovelDesocupado(itemOrcamento)) {
                itemOrcamentoSimples.itemSelecionado = orcamentoGerado.pergunta_2
            }
            else if(mOrcamento!.eSelecaoTipoLocalPintado(itemOrcamento)) {
                itemOrcamentoSimples.itemSelecionado = orcamentoGerado.pergunta_3
            }
            else if(mOrcamento!.eSelecaoTipoPintura(itemOrcamento)) {
                itemOrcamentoSimples.itemSelecionado = orcamentoGerado.pergunta_4
                
                itemOrcamentoSimples.exibeBotoesCheckList = false
                
                if(orcamentoGerado.pergunta_4 != nil) {
                    tipoPintura = TipoPintura(rawValue: orcamentoGerado.pergunta_4!)!
                }
            }
        }
        
        if(orcamentoGerado.orcamento_item != nil) {
            
            var ultimoAmbienteCriado: ItemOrcamentoComplexoDetalhe? = nil
            let descricao = mOrcamento!.descricaoItemComplexo(tipoPintura);
            
            let itemOrcamentoComplexo = ItemOrcamentoComplexo();
            
            itemOrcamentoComplexo.indice = mOrcamento!.novoIndiceOrcamento()
            itemOrcamentoComplexo.tipoPintura = tipoPintura
            //itemOrcamentoComplexo.sequencia = mOrcamento.novaSequenciaAmbiente());
            itemOrcamentoComplexo.idTexto = descricao
            itemOrcamentoComplexo.exibeSequencia = false
            
            mOrcamento!.itensOrcamento!.append(itemOrcamentoComplexo);
            
            for orcamentoItem in orcamentoGerado.orcamento_item! {
                
                let itemOrcamentoComplexoDetalhe = ItemOrcamentoComplexoDetalhe()
                
                let tipoDetalheComplexo = TipoDetalheComplexo(rawValue: orcamentoItem.tipo_registro!)
                
                itemOrcamentoComplexoDetalhe.id = orcamentoItem.id
                itemOrcamentoComplexoDetalhe.altura = orcamentoItem.altura
                itemOrcamentoComplexoDetalhe.largura = orcamentoItem.largura
                itemOrcamentoComplexoDetalhe.comprimento = orcamentoItem.comprimento
                itemOrcamentoComplexoDetalhe.tipoDetalheComplexo = (tipoDetalheComplexo)!;
                if orcamentoItem.massa_corrida != nil {
                    itemOrcamentoComplexoDetalhe.necessitaMassaCorrida = (orcamentoItem.massa_corrida! == 1);
                }
                itemOrcamentoComplexoDetalhe.quantidadeInterruptores = String(format:"%d", orcamentoItem.interruptores);
                itemOrcamentoComplexoDetalhe.quantidadeJanelas = String(format:"%d", orcamentoItem.janelas);
                itemOrcamentoComplexoDetalhe.quantidadePortas = String(format:"%d", orcamentoItem.portas);
                
                var novaSequencia: Int?
                let idDescricaoItem: String?
                
                novaSequencia = nil

                if(tipoDetalheComplexo == TipoDetalheComplexo.Ambiente || tipoDetalheComplexo == TipoDetalheComplexo.AmbienteCompleto) {

                    //novaSequencia = mOrcamento!.novaSequenciaAmbiente();
                    idDescricaoItem =  "mascara_ambiente"
                    
                    novaSequencia = extraiSequenciaTexto(orcamentoItem.descricao, idTexto: idDescricaoItem!)
                    
                    // É o 1o ambiente, não deixa excluir
                    if ( ultimoAmbienteCriado == nil ) {
                        itemOrcamentoComplexoDetalhe.exibeBotaoExcluir = (false);
                    }
                    
                    ultimoAmbienteCriado = itemOrcamentoComplexoDetalhe
                    itemOrcamentoComplexoDetalhe.exibeBotaoTetoAvulso = true;
                    itemOrcamentoComplexoDetalhe.configuracaoMassaCorrida = true;

                    mOrcamento!.adicionaAmbiente(novaSequencia == nil ? orcamentoItem.descricao : nil, id_texto: idDescricaoItem, sequencia: novaSequencia);

                }
                else if tipoDetalheComplexo == TipoDetalheComplexo.ParedeAvulsa {

                    idDescricaoItem = "mascara_parede_avulsa"

                    if ultimoAmbienteCriado != nil {

                        novaSequencia = extraiSequenciaTexto(orcamentoItem.descricao, idTexto: idDescricaoItem!)

                        //novaSequencia = mOrcamento!.novaSequenciaParedeAvulsa(ultimoAmbienteCriado!.indice);
                        itemOrcamentoComplexoDetalhe.itemOrcamentoPai = ultimoAmbienteCriado
                    }
                    else {
                        novaSequencia = 1; // Contingência, não deve acontecer
                    }
                    itemOrcamentoComplexoDetalhe.exibeComprimento = (false);
                    itemOrcamentoComplexoDetalhe.exibeBotaoParedeAvulsa = (false);
                    itemOrcamentoComplexoDetalhe.exibeBotaoTetoAvulso = (false);
                    itemOrcamentoComplexoDetalhe.exibeAltura = (true);
                    itemOrcamentoComplexoDetalhe.exibeQuantidadeInterruptores = (true);
                    itemOrcamentoComplexoDetalhe.exibeQuantidadePortas = (true);
                    itemOrcamentoComplexoDetalhe.exibeQuantidadeJanelas = (true);
                    itemOrcamentoComplexoDetalhe.exibeBotaoAmbienteCompleto = (false);
                    itemOrcamentoComplexoDetalhe.configuracaoMassaCorrida = true;

                    mOrcamento!.adicionaAmbiente(novaSequencia == nil ? orcamentoItem.descricao : nil, id_texto: idDescricaoItem, sequencia: novaSequencia, textoAlternativoPai: ultimoAmbienteCriado?.textoAlternativo, id_texto_pai: ultimoAmbienteCriado!.idTexto, sequencia_pai: ultimoAmbienteCriado!.sequencia);

                }
                else if tipoDetalheComplexo == TipoDetalheComplexo.TetoAvulso {

                    idDescricaoItem =  "mascara_teto_avulso"

                    if ultimoAmbienteCriado != nil {

                        novaSequencia = extraiSequenciaTexto(orcamentoItem.descricao, idTexto: idDescricaoItem!)

                        //novaSequencia = mOrcamento!.novaSequenciaTetoAvulso(ultimoAmbienteCriado!.indice);
                        itemOrcamentoComplexoDetalhe.itemOrcamentoPai = ultimoAmbienteCriado
                    }
                    else {
                        novaSequencia = 1; // Contingência, não deve acontecer
                    }
                    itemOrcamentoComplexoDetalhe.exibeComprimento = (true);
                    itemOrcamentoComplexoDetalhe.exibeBotaoParedeAvulsa = (false);
                    itemOrcamentoComplexoDetalhe.exibeBotaoTetoAvulso = (false);
                    itemOrcamentoComplexoDetalhe.exibeAltura = (false);
                    itemOrcamentoComplexoDetalhe.exibeQuantidadeInterruptores = (false);
                    itemOrcamentoComplexoDetalhe.exibeQuantidadePortas = (false);
                    itemOrcamentoComplexoDetalhe.exibeQuantidadeJanelas = (false);
                    itemOrcamentoComplexoDetalhe.exibeBotaoAmbienteCompleto = (false);
                    itemOrcamentoComplexoDetalhe.configuracaoMassaCorrida = true;

                    mOrcamento!.adicionaAmbiente(novaSequencia == nil ? orcamentoItem.descricao : nil, id_texto: idDescricaoItem, sequencia: novaSequencia, textoAlternativoPai: ultimoAmbienteCriado?.textoAlternativo, id_texto_pai: ultimoAmbienteCriado!.idTexto, sequencia_pai: ultimoAmbienteCriado!.sequencia);
                }
                else {
                    return nil
                }

                ////////////////////////////////////////////////////////////////

                if novaSequencia != nil {
                    itemOrcamentoComplexoDetalhe.sequencia = novaSequencia!
                }
                else {
                    itemOrcamentoComplexoDetalhe.textoAlternativo = orcamentoItem.descricao
                }

                itemOrcamentoComplexoDetalhe.idTexto = idDescricaoItem
                
                ////////////////////////////////////////////////////////////////

                mOrcamento!.ajustaExibicaoItemOrcamento(tipoPintura, itemOrcamentoComplexoDetalhe: itemOrcamentoComplexoDetalhe, tipoDetalheComplexo: tipoDetalheComplexo!);
                
                itemOrcamentoComplexoDetalhe.indice = mOrcamento!.novoIndiceOrcamento()
                
                mOrcamento!.itensOrcamento!.append(itemOrcamentoComplexoDetalhe);
                
                ////////////////////////////////////////////////////////////////


                // Configuração das tintas
                if(orcamentoItem.item_pintura != nil) {
                    
                    for orcamentoItemPintura in orcamentoItem.item_pintura! {
                        
                        let localPintura = LocalPintura(rawValue: orcamentoItemPintura.tipo_registro!)
                        
                        let configuracaoTinta = ConfiguracaoTinta(localPintura: localPintura!)
                        
                        configuracaoTinta.id = (orcamentoItemPintura.id);
                        configuracaoTinta.nomeItem = (orcamentoItemPintura.tipo_registro);
                        configuracaoTinta.clienteForneceTintas = (orcamentoItemPintura.fornecer_tintas == 1);
                        configuracaoTinta.naoPintara = (orcamentoItemPintura.nao_pintar == 1);
                        
                        if(configuracaoTinta.naoPintara == false && configuracaoTinta.clienteForneceTintas == false) {
                            configuracaoTinta.tipo = orcamentoItemPintura.tipo_tinta == nil ? TipoTinta.Nenhum : (TipoTinta(rawValue: orcamentoItemPintura.tipo_tinta!))!;
                            
                            let acabamento = orcamentoItemPintura.acabamento == nil ?  nil  : orcamentoItemPintura.acabamento == "Semi-brilho" ? "Semibrilho" : orcamentoItemPintura.acabamento;
                            
                            configuracaoTinta.acabamento = acabamento == nil ? AcabamentoTinta.Nenhum : (AcabamentoTinta(rawValue: acabamento!))!;
                            configuracaoTinta.cor = orcamentoItemPintura.cor == nil ? CorTinta.Nenhum :(CorTinta(rawValue: orcamentoItemPintura.cor!))!;
                        }
                        
                        itemOrcamentoComplexoDetalhe.setConfiguracaoTinta(configuracaoTinta);
                    }
                    
                }
            }
        }
        
        var array : [ItemAmbienteTrinca]?;
        
        if mOrcamento?.listaAmbientes != nil {
            array = [ItemAmbienteTrinca](mOrcamento!.listaAmbientes!)
        }
        
        // Quando não for parcial, sempre cria (ex: vindo do refazer orçamento)
        // Quando for parcial, se tiver uma trinca e já tiver selecionado uma pintura cria...
        if(!parcial || (parcial && /*(orcamentoGerado.getOrcamento_trinca() != nil) &&*/ tipoPintura != TipoPintura.Nenhum) ) {
            
            let itemOrcamentoTrinca = ItemOrcamentoTrinca();
            itemOrcamentoTrinca.indice = mOrcamento!.novoIndiceOrcamento()
            itemOrcamentoTrinca.sequencia = mOrcamento!.novaSequenciaItemPrincipal()
            itemOrcamentoTrinca.idTextoAjuda = "ajuda_passo_5"
            
            itemOrcamentoTrinca.botoes = [
                BotaoItemOrcamento(imagemH: "retina_6a_h", imagemA: "retina_6a", idTexto: "literal_sim", idTextoResposta: "resposta_trinca_sim", textoSelecao: "true"),
                BotaoItemOrcamento(imagemH: "retina_6b_h", imagemA: "retina_6b", idTexto: "literal_nao", idTextoResposta: "resposta_trinca_nao", textoSelecao: "false")
            ]
            
            itemOrcamentoTrinca.idTexto = "pergunta_simples6"
            
            mOrcamento!.indiceTrincaRaiz = itemOrcamentoTrinca.indice
            
            mOrcamento!.itensOrcamento!.append(itemOrcamentoTrinca);
            
            if orcamentoGerado.orcamento_trinca != nil && orcamentoGerado.orcamento_trinca?.count > 0 {
                
                itemOrcamentoTrinca.quantidade = (orcamentoGerado.orcamento_trinca!.count)
                itemOrcamentoTrinca.itemSelecionado = ("true");
                
                for orcamentoTrinca in orcamentoGerado.orcamento_trinca! {
                    
                    let itemOrcamentoTrincaDetalhe = ItemOrcamentoTrincaDetalhe()
                    
                    var ambienteTrinca = mOrcamento?.buscaItemAmbienteTrinca(orcamentoTrinca.ambiente, textoPai: orcamentoTrinca.ambiente_pai)
                    
                    //FIXME: Contingência para os orçamentos sem pai ainda. Usa o 1o ambiente que encontrar...
                    if ( ambienteTrinca == nil ) {
                        ambienteTrinca = mOrcamento?.buscaItemAmbienteTrinca(orcamentoTrinca.ambiente);
                    }

                    itemOrcamentoTrincaDetalhe.id = (orcamentoTrinca.id);
                    itemOrcamentoTrincaDetalhe.indice = mOrcamento!.novoIndiceOrcamento()
                    itemOrcamentoTrincaDetalhe.tamanhoTrinca = (String(format:"%d", orcamentoTrinca.tamanho))
                    itemOrcamentoTrincaDetalhe.itemAmbiente = ambienteTrinca
                    itemOrcamentoTrincaDetalhe.sequencia = mOrcamento!.novaSequenciaTrinca()
                    itemOrcamentoTrincaDetalhe.idTexto = "mascara_trinca"
                    itemOrcamentoTrincaDetalhe.listaAmbientes = array

                    mOrcamento!.itensOrcamento!.append(itemOrcamentoTrincaDetalhe);
                }
                
            } else {
                
                itemOrcamentoTrinca.quantidade = (0);
                itemOrcamentoTrinca.itemSelecionado = ("false");
            }
            
        }
        
        return mOrcamento;
    }
    
    
    static var mOrcamento: Orcamento?
    var mNotificadorMudanca: NotificaOrcamentoMudou?
    
    static func obtemOrcamento() -> Orcamento? {
        return mOrcamento
    }
    
    static func limpaOrcamento() {
        mOrcamento = nil
    }
    
    
    func novoIndiceOrcamento() -> Int {
        
        let indice = indiceOrcamento
        indiceOrcamento += 1
        return indice
    }
    
    func novaSequenciaAmbiente() -> Int {

        var sequenciaAmbiente = 0

        Registro.registraDebug("novaSequenciaAmbiente: buscando nova sequência");

        for itemOrcamento in itensOrcamento! {

            if ( !(itemOrcamento is ItemOrcamentoComplexoDetalhe) ) {
                continue;
            }

            let itemOrcamentoComplexoDetalhe = itemOrcamento as! ItemOrcamentoComplexoDetalhe

            Registro.registraDebug("novaSequenciaAmbiente: texto item: " + itemOrcamentoComplexoDetalhe.texto()!);
            Registro.registraDebug("novaSequenciaAmbiente: usaSequencia: " + itemOrcamentoComplexoDetalhe.usaSequencia().description);

            if ( itemOrcamentoComplexoDetalhe.tipoDetalheComplexo != TipoDetalheComplexo.Ambiente && itemOrcamentoComplexoDetalhe.tipoDetalheComplexo != TipoDetalheComplexo.AmbienteCompleto) {

                Registro.registraDebug("novaSequenciaAmbiente: ignorado não é ambiente: texto item: " + itemOrcamentoComplexoDetalhe.texto()!);
                continue;
            }

            if (itemOrcamento.usaSequencia() && itemOrcamento.sequencia > sequenciaAmbiente) {
                sequenciaAmbiente = itemOrcamento.sequencia

                Registro.registraDebug("novaSequenciaAmbiente: sequência atualizada: " + sequenciaAmbiente.description);
            }
        }

        Registro.registraDebug("novaSequenciaAmbiente: nova sequência retornada: \(sequenciaAmbiente + 1)");

        return sequenciaAmbiente + 1;
    }
    
    func novaSequenciaParedeAvulsa(_ indiceAmbiente: Int) -> Int {
        
        var sequencia = 1
        
        let valor = sequenciaParedeAvulsa![indiceAmbiente]
        
        if valor != nil {
            sequencia = valor! + 1
        }

        sequenciaParedeAvulsa![indiceAmbiente] = sequencia

        return sequencia
    }
    
    func novaSequenciaTetoAvulso(_ indiceAmbiente: Int) -> Int {

        var sequencia = 1

        let valor = sequenciaTetoAvulso![indiceAmbiente]

        if valor != nil {
            sequencia = valor! + 1
        }

        sequenciaTetoAvulso![indiceAmbiente] = sequencia

        return sequencia
    }

    func novaSequenciaTrinca() -> Int {
        sequenciaTrinca += 1
        return sequenciaTrinca
    }
    
    func novaSequenciaItemPrincipal() -> Int {
        sequenciaItemPrincipal += 1
        return sequenciaItemPrincipal
    }
    
    func eSelecaoTipoPintura(_ itemOrcamento: ItemOrcamento) -> Bool {
        return itemOrcamento.indice == indiceSelecaoTipoPintura;
    }
    func eSelecaoTipoLocalPintado(_ itemOrcamento: ItemOrcamento) -> Bool {
        return itemOrcamento.indice == indiceSelecaoTipoLocalPintado
    }
    func eSelecaoPrimeiraPintura(_ itemOrcamento: ItemOrcamento) -> Bool {
        return itemOrcamento.indice == indiceSelecaoPrimeiraPintura;
    }
    func eSelecaoImovelDesocupado(_ itemOrcamento: ItemOrcamento) -> Bool {
        return itemOrcamento.indice == indiceSelecaoImovelDesocupado;
    }
    
    func descricaoItemComplexo(_ tipoPintura: TipoPintura) -> String? {
        
        switch (tipoPintura) {
        case  TipoPintura.ParedesETeto:
            return "literal_paredes_teto"
        case TipoPintura.SomenteParedes:
            return "literal_somente_paredes"
        case TipoPintura.SomenteTeto:
            return "literal_somente_teto"
        default:
            return nil;
        }
    }
    
    func obtemString(_ idString: String?) -> String {
        return NSLocalizedString(idString!, comment: "")
    }


    func removeAmbiente(_ textoAlternativo: String?, id_texto: String?, sequencia: Int) {

        if(listaAmbientes == nil) {
            return;
        }
        
        let itemARemover = ItemAmbienteTrinca(textoAlternativo: textoAlternativo, id_texto: id_texto, sequencia: sequencia)
        
        let indice = listaAmbientes?.index(where: { (elemento) -> Bool in
            return itemARemover.equals(elemento)
        })
        
        if indice == nil {
            return
        }

        listaAmbientes?.remove(at: indice!)

        let array = [ItemAmbienteTrinca](listaAmbientes!)

        if mNotificadorMudanca != nil {
            mNotificadorMudanca!.listaAmbienteMudou(nil, textoAlternativo: nil, id_texto: nil, sequencia: 0, listaAmbientes: array);
        }
    }
    
    func mudaNomeAmbiente(_ itemOrcamento: ItemOrcamento , itemOrcamentoPai: ItemOrcamento, novoNome: String?) {
    
        if listaAmbientes == nil {
            return;
        }
    
        let itemBuscar = ItemAmbienteTrinca(textoAlternativo: itemOrcamento.textoAlternativo, id_texto: itemOrcamento.idTexto, sequencia: itemOrcamento.sequencia, textoAlternativoPai: itemOrcamentoPai.textoAlternativo, id_texto_pai: itemOrcamentoPai.idTexto, sequencia_pai: itemOrcamentoPai.sequencia);
    
        mudaNomeAmbienteInterno(itemBuscar, novoNome: novoNome);
    }
    
    func mudaNomeAmbiente(_ textoAlternativo: String?, id_texto: String?, sequencia: Int?, novoNome: String?) {

        if(listaAmbientes == nil) {
            return;
        }
        
        let itemAmbienteTrinca = ItemAmbienteTrinca(textoAlternativo: textoAlternativo, id_texto: id_texto, sequencia: sequencia);


        mudaNomeAmbienteInterno(itemAmbienteTrinca, novoNome: novoNome)
    }
    
    func mudaNomeAmbienteInterno(_ itemBuscar: ItemAmbienteTrinca, novoNome: String?) {
        
        var itemAtualRenomear: ItemAmbienteTrinca?
        
        let indice = listaAmbientes?.index(where: { (elemento) -> Bool in
            return itemBuscar.equals(elemento)
        })
        
        if indice == nil {
            
            let mensagem = "Houve um erro ao renomear o ambiente"
            let mensagemTecnica = String(format: "Ambiente não existia na lista ao renomear: [%@] para [%@]", itemBuscar.texto()!, novoNome!);
            
            Registro.registraDebug(mensagemTecnica);
            
            if mNotificadorMudanca != nil {
                mNotificadorMudanca!.notificaErro(mensagem, mensagemTecnica: mensagemTecnica);
            }
            
            return;
        }
        
        itemAtualRenomear = listaAmbientes![indice!]
        
        // Guarda o nome velho
        let nomeAtual = itemAtualRenomear!.texto();
        
        itemAtualRenomear!.defineNovoNome(novoNome);
        
        // Muda os itens o qual o ambiente pai é o renomeado
        for itemAmbienteTrinca in listaAmbientes! {
            
            let itemAmbienteTrincaPai = itemAmbienteTrinca.itemAmbientePai();
            
            // Não possui ambiente pai?
            if (itemAmbienteTrincaPai == nil) {
                continue;
            }
            
            if (itemAmbienteTrincaPai!.equals(itemBuscar)) {
                itemAmbienteTrinca.defineNovoNomePai(novoNome);
            }
            
        }
        
        // Duplica a lista
        let array = [ItemAmbienteTrinca](listaAmbientes!)
        
        // Notifica a UI da mudança
        if mNotificadorMudanca != nil {
            mNotificadorMudanca!.listaAmbienteMudou(novoNome, textoAlternativo: nomeAtual, id_texto: itemBuscar.id_texto, sequencia: itemBuscar.sequencia, listaAmbientes: array);
        }
    }

    func removeAmbiente(_ textoAlternativo: String?, id_texto: String?, sequencia: Int, textoAlternativoPai: String?, id_texto_pai: String?, sequencia_pai: Int) {

        if(listaAmbientes == nil) {
            return;
        }

        let itemAmbienteTrinca = ItemAmbienteTrinca(textoAlternativo: textoAlternativo, id_texto: id_texto, sequencia: sequencia, textoAlternativoPai: textoAlternativoPai, id_texto_pai: id_texto_pai, sequencia_pai: sequencia_pai);

        let indice = listaAmbientes?.index(where: { (elemento) -> Bool in
            return itemAmbienteTrinca.equals(elemento)
        })

        if indice == nil {
            return
        }

        listaAmbientes?.remove(at: indice!)

        let array = [ItemAmbienteTrinca](listaAmbientes!)
        
        if mNotificadorMudanca != nil {
            mNotificadorMudanca!.listaAmbienteMudou(itemAmbienteTrinca.texto(), textoAlternativo: textoAlternativo, id_texto: nil, sequencia: 0, listaAmbientes: array);
        }
    }
    
    /*func ajustaExibicaoItemOrcamento(tipoPintura: TipoPintura, itemOrcamentoComplexoDetalhe: ItemOrcamentoComplexoDetalhe) {
     
     switch (tipoPintura) {
     case TipoPintura.ParedesETeto:
     break;
     case TipoPintura.SomenteParedes:
     itemOrcamentoComplexoDetalhe.exibeComprimento = (false);
     break;
     case TipoPintura.SomenteTeto:
     itemOrcamentoComplexoDetalhe.exibeAltura = (false);
     itemOrcamentoComplexoDetalhe.exibeQuantidadePortas = (false);
     itemOrcamentoComplexoDetalhe.exibeQuantidadeJanelas = (false);
     itemOrcamentoComplexoDetalhe.exibeQuantidadeInterruptores = (false);
     break;
     default:
     break
     }
     }*/
    
    func rechamaNotificacoes(_ notificaoOrcamentoMudou: NotificaOrcamentoMudou, resultadoCalculo: ResultadoCalculo?) -> BooleanLiteralType {
        
        for itemOrcamento in itensOrcamento! {
            
            if (itemOrcamento is ItemOrcamentoSimples && !(itemOrcamento is ItemOrcamentoTrinca)) {
                notificaoOrcamentoMudou.novoItemPrincipal(itemOrcamento)
            }
        }
        
        for itemOrcamento in itensOrcamento! {
            
            if itemOrcamento is ItemOrcamentoComplexo {
                notificaoOrcamentoMudou.novoItemPrincipal(itemOrcamento);
            }
            else if(itemOrcamento is  ItemOrcamentoComplexoDetalhe) {
                notificaoOrcamentoMudou.novoSubitem(nil, subitem: itemOrcamento);
                
                let itemOrcamentoComplexoDetalhe = itemOrcamento as! ItemOrcamentoComplexoDetalhe
                
                let locaisPintura  = [ LocalPintura.Paredes, LocalPintura.Teto, LocalPintura.Janelas, LocalPintura.Portas ]
                
                for localPintura in locaisPintura {
                    
                    let configuracaoTinta = itemOrcamentoComplexoDetalhe.configuracaoTinta(localPintura);
                    
                    if configuracaoTinta != nil {
                        notificaoOrcamentoMudou.novaConfiguracaoTinta(itemOrcamentoComplexoDetalhe, configuracaoTinta: configuracaoTinta);
                    }
                }
                
                notificaoOrcamentoMudou.fimConfiguracaoTinta(itemOrcamentoComplexoDetalhe);
            }
        }
        
        for itemOrcamento in itensOrcamento! {
            
            if itemOrcamento is ItemOrcamentoTrinca {
                notificaoOrcamentoMudou.novoItemPrincipal(itemOrcamento)
            }
            else if itemOrcamento is  ItemOrcamentoTrincaDetalhe {
                
                notificaoOrcamentoMudou.novoSubitem(nil, subitem: itemOrcamento)
                
                //let itemOrcamentoComplexoDetalhe = itemOrcamento as! ItemOrcamentoTrincaDetalhe
                
            }
        }
        
        let itemOrcamentoConclusao = ItemOrcamentoConclusao();

        if resultadoCalculo != nil {
            itemOrcamentoConclusao.dias = (resultadoCalculo!.diasTotal);
            itemOrcamentoConclusao.valorCalculado = (resultadoCalculo!.valorTotal);
            itemOrcamentoConclusao.valorAVista = (resultadoCalculo!.valorTotal * 0.95);
        }
        
        notificaoOrcamentoMudou.novoItemPrincipal(itemOrcamentoConclusao);
        
        return true;
    }
    
    /*func diasServico() -> Int {
        
        if resultadoCalculo == nil {
            resultadoCalculo = calculaOrcamento()
        }
        
        return resultadoCalculo == nil ? -1 : resultadoCalculo!.diasTotal
    }

     var resultadoCalculo: ResultadoCalculo? = nil

     do {

     try resultadoCalculo = calculaOrcamento();
     }
     catch /*(Exception ex)*/ {

     //Registro.registraExcecao("Erro calculando o orçamento", ex);

     if mNotificadorMudanca != nil {
     mNotificadorMudanca!.notificaErro("Erro durante o processamento.", mensagemTecnica: ""/*ex.getMessage()*/);
     }

     return false;
     }

    func getValor() -> Float {

        if resultadoCalculo == nil {
            resultadoCalculo = calculaOrcamento();
        }
        
        return resultadoCalculo == nil ? 0.0 : resultadoCalculo!.valorTotal
    }*/

    func atualizaResultadoCalculo(_ orcamentoGerado: OrcamentoGerado) -> ResultadoCalculo? {

        resultadoCalculo = ResultadoCalculo();

        resultadoCalculo!.diasTotal = Int(orcamentoGerado.dias_servico!)!;
        resultadoCalculo!.valorTotal = orcamentoGerado.valor_orcamento_total!

        for itemOrcamento in itensOrcamento! {

            if (!(itemOrcamento is ItemOrcamentoComplexoDetalhe)) {
                continue;
            }

            let itemOrcamentoComplexoDetalhe = itemOrcamento as! ItemOrcamentoComplexoDetalhe
            
            Registro.registraDebug("atualizaResultadoCalculo: buscando item calculado: " + itemOrcamento.texto()!)

            for item in orcamentoGerado.orcamento_item! {

                // Acho o item calculado do itemOrcamento
                if (item.indice != nil && item.indice == itemOrcamento.indice) || (item.indice == nil && item.descricao == itemOrcamento.texto()) {
                                        
                    Registro.registraDebug("atualizaResultadoCalculo: encontrado: [\(item.descricao!)], valor: \(item.valor_ambiente)")

                    itemOrcamento.valorCalculado = item.valor_ambiente!

                    let locaisPintura = [ LocalPintura.Paredes, LocalPintura.Portas, LocalPintura.Janelas, LocalPintura.Teto ]

                    for localPintura in locaisPintura {

                        let configuracaoTinta = itemOrcamentoComplexoDetalhe.configuracaoTinta(localPintura);

                        if configuracaoTinta == nil {
                            continue;
                        }

                        for orcamentoItemPintura in item.item_pintura! {

                            if orcamentoItemPintura.tipo_registro == configuracaoTinta!.localPintura.rawValue {

                                configuracaoTinta?.valorCalculado = orcamentoItemPintura.item_pintura_valor!
                            }

                        }

                    }

                    break;
                }
            }

        }
        
        adicionaValorAgregadoOrcamento("tinta_franquia_nome_total", valor: orcamentoGerado.tinta_franquia_nome_total)
        adicionaValorAgregadoOrcamento("tinta_franquia_litros_total", valor: orcamentoGerado.tinta_franquia_litros_total)
        adicionaValorAgregadoOrcamento("tinta_cliente_nome_total", valor: orcamentoGerado.tinta_cliente_nome_total)
        adicionaValorAgregadoOrcamento("tinta_cliente_litros_total", valor: orcamentoGerado.tinta_cliente_litros_total)
        adicionaValorAgregadoOrcamento("tinta_franquia_consolidado", valor: orcamentoGerado.tinta_franquia_consolidado)
        adicionaValorAgregadoOrcamento("tinta_cliente_consolidado", valor: orcamentoGerado.tinta_cliente_consolidado)

        return resultadoCalculo;
    }
    
    func adicionaValorAgregadoOrcamento(_ chave: String, valor: Array<AnyObject>?) {
        
        if valores_agregados == nil {
            valores_agregados = [String:AnyObject]()
        }
        
        valores_agregados![chave] = valor as AnyObject?
    }

    func buscaItemOrcamentoPorIndice(_ indice: Int) -> ItemOrcamento? {

        for  itemOrcamento in itensOrcamento! {

            if(itemOrcamento.indice == indice){
                return itemOrcamento;
            }
        }

        return nil;
    }
    
    func existeAmbienteComNome(_ nome: String?) -> Bool {
    
        for item in listaAmbientes! {
    
            if (item.textoAmbiente() == nome) {
                return true;
            }
        }
    
        return false;
    }

    func mudouNomeAmbiente(_ itemCopia: ItemOrcamentoComplexoDetalhe, novoNome: String ) -> Void {

        Registro.registraDebug("mudouNomeAmbiente: Mudando nome ambiente de \(itemCopia.texto()) para \(novoNome)");

        if novoNome.characters.count == 0 {
            if mNotificadorMudanca != nil {
                mNotificadorMudanca?.notificaErro("Nome de ambiente inválido", mensagemTecnica: nil)
            }
            return
        }
        else if existeAmbienteComNome(novoNome) {

            if mNotificadorMudanca != nil {
                mNotificadorMudanca?.notificaErro("Nome de ambiente já em uso", mensagemTecnica: nil)
            }
            return
        }

        let itemOrcamentoAtualizar = buscaItemOrcamentoPorIndice(itemCopia.indice) as! ItemOrcamentoComplexoDetalhe;

        //if (BuildConfig.DEBUG && itemOrcamentoAtualizar == null) {
        //    throw new NoSuchElementException();
        //}

        if itemCopia.itemOrcamentoPai == nil {
            mudaNomeAmbiente(itemCopia.textoAlternativo, id_texto: itemCopia.idTexto, sequencia: itemCopia.sequencia, novoNome: novoNome)
        }
        else {
            mudaNomeAmbiente(itemCopia, itemOrcamentoPai: itemCopia.itemOrcamentoPai!, novoNome: novoNome)
        }
        
        // Atualiza o nome no objeto do orçamento e nos locais de pintura
        itemOrcamentoAtualizar.texto(novoNome);

        let locaisPintura = [ LocalPintura.Paredes, LocalPintura.Teto, LocalPintura.Janelas, LocalPintura.Portas ]

        for localPintura in locaisPintura {

            let configuracaoTinta = itemOrcamentoAtualizar.configuracaoTinta(localPintura);

            if ( configuracaoTinta == nil ) {
                continue;
            }

            configuracaoTinta?.nomeAmbiente = (novoNome);
        }

        if (mNotificadorMudanca != nil) {
            mNotificadorMudanca!.mudouNomeAmbiente(itemOrcamentoAtualizar);
        }

        // A mudança pode ter feito que seja necessário atualizar as sequências
        atualizaSequenciaItemComplexoDetalhe(itemCopia.tipoDetalheComplexo, itemOrcamentoPai: itemCopia.itemOrcamentoPai);
    }


}

    /*func calculaOrcamento() -> ResultadoCalculo? {

        var diasTotal = 0;
        var totalPrice: Float = 0.0;
        var percentNewAmbiente: Float = 0.0, percentLocalDesocupado: Float = 0.0;
        
        resultadoCalculo = ResultadoCalculo();
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        let tipoPintura = recuperaTipoPintura();
        
        let itemPrimeiraPintura = recuperaPrimeiraPintura(),
            itemImovelDesocupado = recuperaImovelDesocupado()
        
        if itemPrimeiraPintura == nil || itemImovelDesocupado == nil {
            return nil
        }
        
        let primeiraPintura = itemPrimeiraPintura!,
            imovelOcupado = !itemImovelDesocupado!;
        
        //assert primeiraPintura != nil;
        //assert imovelOcupado != nil;
        
        ////IMOVEL NOVO
        if (primeiraPintura) {
            percentNewAmbiente += 0.0;
        } else {
            percentNewAmbiente += 10.0;
        }
        
        ///LUGAR DESOCUPADO
        if (!imovelOcupado) {
            percentLocalDesocupado += -10;
        } else {
            percentLocalDesocupado += 0;
        }
        
        let itemOrcamentoTrinca:ItemOrcamentoTrinca? = buscaItemOrcamentoPorIndice(indiceTrincaRaiz) as? ItemOrcamentoTrinca;
        
        let numero_trincas: Int = itemOrcamentoTrinca == nil ? 0 : itemOrcamentoTrinca!.quantidade
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        var precoAmbiente: Float = 0.0
        var totalMtrs: Float = 0.0
        
        var totalJanelas = 0;
        var totalPortas = 0;
        
        var pintaraAlgumaPorta = false
        var pintaraAlgumaJanela = false
        
        for itemOrcamento in itensOrcamento! {
            
            if (!(itemOrcamento is ItemOrcamentoComplexoDetalhe)) {
                continue;
            }
            
            var valorTintaJanela: Float = 0.0
            var valorTintaPortas: Float = 0.0
            
            var valorJanelaBase: Float = 0.0
            var valorJanelaTotal: Float = 0.0
            
            var valorPortasBase: Float = 0.0
            var valorPortasTotal: Float = 0.0

            var valorAmbienteParede: Float = 0.0, valorAmbienteTeto: Float = 0.0
            
            
            let itemAmbiente = itemOrcamento as! ItemOrcamentoComplexoDetalhe
            
            let janelas = itemAmbiente.quantidadeJanelas,
            portas = itemAmbiente.quantidadePortas;
            
            ////JANELAS / PORTAS
            totalJanelas += janelas == nil ? 0 : Int(janelas!)!
            totalPortas += portas == nil ? 0 : Int(portas!)!
            
            let acabamentosJanelas = "";
            
            var percentTamanhoImovel: Float = 0.0
            var percentTipoAmbiente: Float = 0.0
            var valorMassaCorrida: Float = 0.0
            var valorTrinca: Float = 0.0
            
            let acabamentosAmbiente = "";
            let acabamentosParede = "";
            let acabamentosTeto = "";
            //let        acabamentosJanelas = "";
            let acabamentosPortas = "";
            
            //Massa Corrida
            let massa_corrida = "";
            
            ////************* -------------- ****************////
            ////************* Metro Quadrado ****************////
            ////************* -------------- ****************////
            let scomprimento = itemAmbiente.comprimento,
            slargura = itemAmbiente.largura,
            saltura = itemAmbiente.altura;
            
            let comprimento: Float = scomprimento == nil ? 0.0 : Float(scomprimento!)!;
            let largura: Float = slargura == nil ? 0.0 : Float(slargura!)!;
            let altura: Float = saltura == nil ? 0.0 : Float(saltura!)!;
            
            var m2Ambientee: Float = 0.0, m2Teto: Float = 0.0 /*, m2Ambientee: Float = 0.0*/, m2AmbienteETeto: Float = 0.0
            
            //Log.i("this.massa_corrida = " + this.massa_corrida);
            
            if ( itemAmbiente.tipoDetalheComplexo == TipoDetalheComplexo.ParedeAvulsa) {
                
                m2AmbienteETeto = largura * altura;
            }
            else {
                
                if (tipoPintura == TipoPintura.ParedesETeto) {
                    
                    m2Teto = (largura * comprimento);
                    m2Ambientee = ((comprimento * 2) + (largura * 2)) * altura;
                    
                    m2AmbienteETeto = (m2Ambientee + m2Teto);
                    
                } else if (tipoPintura == TipoPintura.SomenteParedes) {
                    
                    m2Ambientee = (largura * altura);
                    m2AmbienteETeto = m2Ambientee; //largura * altura
                } else if (tipoPintura == TipoPintura.SomenteTeto) {
                    m2AmbienteETeto = largura * comprimento;
                    
                }
            }
            
            //console.log('Paredes: '+$m2Ambientee, 'Teto: '+$m2Teto, 'Metros2: '+$m2AmbienteETeto, 'Altura: '+$altura);
            totalMtrs += m2AmbienteETeto;
            
            ////************* -------------- ****************////
            ////************* PREÇO AMBIENTE ****************////
            ////************* -------------- ****************////
            precoAmbiente = getPrecoBaseAmbiente(m2AmbienteETeto);
            //console.log(this.nome+' - Preço: '+$precoAmbiente)
            
            
            ////************* -------------- ****************////
            ////************* NEW AMBIENTE   ****************////
            ////************* -------------- ****************////
            var calcPercent = precoAmbiente * percentNewAmbiente / 100.0;
            precoAmbiente = precoAmbiente + calcPercent;
            //console.log('Percent: '+calcPercent, 'Preço / ambiente: '+$precoAmbiente)
            
            ////************* -------------- ****************////
            ////************* LOCAL DESOCUPADO   ****************////
            ////************* -------------- ****************////
            calcPercent = precoAmbiente * percentLocalDesocupado / 100;
            precoAmbiente = precoAmbiente + calcPercent;
            //console.log('Percent: '+calcPercent, 'Preço / Local Desocupado: '+$precoAmbiente)
            
            
            ////************* -------------- ****************////
            ////************* TAMANHO IMÓVEL ****************////
            ////************* -------------- ****************////
            /*if (m2AmbienteETeto < 70) {
                percentTamanhoImovel += 10;
            }
            else{
                percentTamanhoImovel += 0;
            }
            
            calcPercent = precoAmbiente * percentTamanhoImovel / 100;
            precoAmbiente = precoAmbiente + calcPercent;*/
            //console.log('Percent: '+calcPercent, 'Preço / Tamanho Imóvel: '+$precoAmbiente)
            
            
            ////************* -------------- ****************////
            ////************* TIPO AMBIENTE  ****************////
            ////************* -------------- ****************////
            
            if ( itemAmbiente.tipoDetalheComplexo == TipoDetalheComplexo.ParedeAvulsa) {
                percentTipoAmbiente += 10;
            }
            else {
                
                if (tipoPintura == TipoPintura.ParedesETeto){
                    percentTipoAmbiente += 0;
                }
                if (tipoPintura == TipoPintura.SomenteParedes) {
                    percentTipoAmbiente += 10;
                }
                if (tipoPintura == TipoPintura.SomenteTeto) {
                    percentTipoAmbiente += 10;
                }
            }
            
            calcPercent = precoAmbiente * percentTipoAmbiente / 100;
            
            precoAmbiente = precoAmbiente + calcPercent;
            //console.log('percentTipoAmbiente:' + percentTipoAmbiente +' Percent: '+calcPercent, ' Preço / Tipo Imóvel: '+$precoAmbiente)
            
            
            ////************* -------------- ****************////
            ////************* MASSA CORRIDA  ****************////
            ////************* -------------- ****************////
            if (itemAmbiente.necessitaMassaCorrida != nil && itemAmbiente.necessitaMassaCorrida!) {
                valorMassaCorrida = getPrecoBaseMassaCorrida(m2AmbienteETeto);
            }
            
            precoAmbiente = precoAmbiente + valorMassaCorrida;
            //console.log('Massa Corrida: '+valorMassaCorrida, 'Preço / Massa Corrida: '+$precoAmbiente)
            
            
            ////************* -------------- ****************////
            ////************* IS TRINCAS  ****************////
            ////************* -------------- ****************////
            
            if (numero_trincas > 0) {
                
                valorTrinca = getPrecoTrincas(itensOrcamento!, nome: itemAmbiente.idTexto);
                //console.log('TRINCAS: ', valorTrinca)
            }
            
            precoAmbiente += valorTrinca;
            
            ////////-- call obj function ambientes -- //////////
            
            let numeroJanelas = janelas == nil ? 0 : Int(janelas!)!,
            numeroPortas = portas == nil ? 0 : Int(portas!)!;
            
            // Daniel: não copiei todo_ código somente o que achei necessário
            if (tipoPintura == TipoPintura.ParedesETeto) {
                //ambientes.paredesTeto(i, this);
                
                let configuracaoTintaJanelas = itemAmbiente.configuracaoTintaJanelas,
                configuracaoTintaPortas = itemAmbiente.configuracaoTintaPortas,
                configuracaoTintaParedes = itemAmbiente.configuracaoTintaParedes,
                configuracaoTintaTeto = itemAmbiente.configuracaoTintaTeto
                ;
                
                let valorJanelaItem = handleValidaFornecerTintasJanelas(configuracaoTintaJanelas, quantidadeJanelas: numeroJanelas),
                valorPortasItem = handleValidaFornecerTintasPortas(configuracaoTintaPortas, quantidadePortas: numeroPortas),
                valorAmbienteItem = handleGetValueAmbiente(configuracaoTintaParedes, areaM2: m2Ambientee),
                valorAmbienteTetoItem = handleGetValueAmbiente(configuracaoTintaTeto, areaM2: m2Teto);
                
                valorJanelaTotal += valorJanelaItem;
                valorPortasTotal += valorPortasItem;
                valorAmbienteParede += valorAmbienteItem;
                valorAmbienteTeto += valorAmbienteTetoItem;
                
                // TODO: unificar
                if (configuracaoTintaJanelas != nil) {
                    
                    if (!configuracaoTintaJanelas!.naoPintara) {
                        pintaraAlgumaJanela = true;
                    }
                    
                    configuracaoTintaJanelas!.valorCalculado = (valorJanelaItem);
                }
                
                if (configuracaoTintaPortas != nil) {
                    
                    if (!configuracaoTintaPortas!.naoPintara) {
                        pintaraAlgumaPorta = true;
                    }
                    
                    configuracaoTintaPortas!.valorCalculado = (valorPortasItem);
                }
                
                if(configuracaoTintaParedes != nil) {
                    configuracaoTintaParedes?.valorCalculado = (valorAmbienteItem);
                }
                
                if(configuracaoTintaTeto != nil) {
                    configuracaoTintaTeto?.valorCalculado = (valorAmbienteTetoItem);
                }
                
                //resultadoCalculo.mapValorPorItem.setValue(resultadoCalculo.montaChave(itemAmbiente.getIndice(), "janelas"), valorJanelaItem);
                //resultadoCalculo.mapValorPorItem.setValue(resultadoCalculo.montaChave(itemAmbiente.getIndice(), "portas"), valorPortasItem);
                //resultadoCalculo.mapValorPorItem.setValue(resultadoCalculo.montaChave(itemAmbiente.getIndice(), "paredes"), valorAmbienteItem);
                //resultadoCalculo.mapValorPorItem.setValue(resultadoCalculo.montaChave(itemAmbiente.getIndice(), "teto"), valorAmbienteTetoItem);
                
                
            }
            
            if (tipoPintura == TipoPintura.SomenteParedes) {
                //ambientes.paredes(i, this);
                
                let configuracaoTintaJanelas = itemAmbiente.configuracaoTintaJanelas,
                configuracaoTintaPortas = itemAmbiente.configuracaoTintaPortas,
                configuracaoTintaParedes = itemAmbiente.configuracaoTintaParedes
                ;
                
                let valorJanelaItem = handleValidaFornecerTintasJanelas(configuracaoTintaJanelas, quantidadeJanelas: numeroJanelas),
                valorPortasItem = handleValidaFornecerTintasPortas(configuracaoTintaPortas, quantidadePortas: numeroPortas),
                valorAmbienteParedeItem = handleGetValueAmbiente(configuracaoTintaParedes, areaM2: m2AmbienteETeto);
                
                valorJanelaTotal += valorJanelaItem;
                valorPortasTotal += valorPortasItem;
                
                //percentTamanhoImovel += 10.0f;
                
                valorAmbienteParede += valorAmbienteParedeItem;
                
                // TODO: unificar
                if (configuracaoTintaJanelas != nil) {
                    
                    if (!configuracaoTintaJanelas!.naoPintara){
                        pintaraAlgumaJanela = true;
                    }
                    
                    configuracaoTintaJanelas?.valorCalculado = (valorJanelaItem);
                }
                
                if (configuracaoTintaPortas != nil) {
                    
                    if (!configuracaoTintaPortas!.naoPintara) {
                        pintaraAlgumaPorta = true;
                    }
                    
                    configuracaoTintaPortas?.valorCalculado = (valorPortasItem);
                }
                
                if(configuracaoTintaParedes != nil) {
                    configuracaoTintaParedes?.valorCalculado = (valorAmbienteParedeItem);
                }
                
                //resultadoCalculo.mapValorPorItem.setValue(resultadoCalculo.montaChave(itemAmbiente.getIndice(), "janelas"), valorJanelaItem);
                //resultadoCalculo.mapValorPorItem.setValue(resultadoCalculo.montaChave(itemAmbiente.getIndice(), "portas"), valorPortasItem);
                //resultadoCalculo.mapValorPorItem.setValue(resultadoCalculo.montaChave(itemAmbiente.getIndice(), "paredes"), valorAmbienteParedeItem);
            }
            
            if (tipoPintura == TipoPintura.SomenteTeto) {
                //ambientes.teto(i, this);
                
                //percentTamanhoImovel += 10.0f;
                
                let configuracaoTintaTeto = itemAmbiente.configuracaoTintaTeto;
                
                let valorAmbienteTetoItem = handleGetValueAmbiente(configuracaoTintaTeto, areaM2: m2AmbienteETeto);
                
                valorAmbienteTeto += valorAmbienteTetoItem;
                
                //resultadoCalculo.mapValorPorItem.setValue(resultadoCalculo.montaChave(itemAmbiente.getIndice(), "teto"), valorAmbienteTetoItem);
                
                if(configuracaoTintaTeto != nil) {
                    configuracaoTintaTeto?.valorCalculado = (valorAmbienteTetoItem);
                }
            }
            
            itemOrcamento.valorCalculado = (precoAmbiente);
            
            let allTotal = precoAmbiente + valorPortasTotal + valorJanelaTotal + valorAmbienteTeto + valorAmbienteParede;
            //console.log(allTotal, $precoAmbiente,'PORTAS: '+valorPortasTotal,'JANELA: '+valorJanelaTotal,valorAmbienteTeto, $totalPrice);
            
            totalPrice += allTotal
        }
        
        // Valor das trincas
        
        /*for (ItemOrcamento itemOrcamento : itensOrcamento) {
         
         if (!(itemOrcamento is ItemOrcamentoTrincaDetalhe))
         continue;
         
         ItemOrcamentoTrincaDetalhe itemOrcamentoTrincaDetalhe = (ItemOrcamentoTrincaDetalhe)itemOrcamento;
         
         float valorTrinca = getPrecoTrinca(Float.valueOf(itemOrcamentoTrincaDetalhe.getTamanhoTrinca()));
         
         precoAmbiente += valorTrinca;
         }*/
        
        
        
        diasTotal += setDiasUteis(totalMtrs, portas: totalPortas, janelas: totalJanelas, isPortas: pintaraAlgumaPorta, isOcupado: imovelOcupado, isJanelas: pintaraAlgumaJanela);
        
        ////////////////////////////////////////////////////////////////////////////////////////////
        
        resultadoCalculo!.diasTotal = diasTotal;
        resultadoCalculo!.valorTotal = totalPrice;
        
        return resultadoCalculo;
        
    }
    
    func adicionaValorAgregadoOrcamento(chave: String, valor: Array<AnyObject>?) {
        
        if valores_agregados == nil {
            valores_agregados = [String:AnyObject]()
        }
        
        valores_agregados![chave] = valor
    }
    
    func recuperaTipoPintura() -> TipoPintura {
        
        let itemOrcamento = buscaItemOrcamentoPorIndice(indiceSelecaoTipoPintura);
        
        if (eSelecaoTipoPintura(itemOrcamento!)) {
            
            let item =  itemOrcamento as! ItemOrcamentoSimples
            
            if(item.itemSelecionado == nil) {
                return TipoPintura.Nenhum;
            }
            
            return TipoPintura(rawValue: item.itemSelecionado!)!;
        }
        
        
        return TipoPintura.Nenhum;
    }
    
    func recuperaPrimeiraPintura() -> Bool? {
        
        let itemOrcamento = buscaItemOrcamentoPorIndice(indiceSelecaoPrimeiraPintura);
        
        if (eSelecaoPrimeiraPintura(itemOrcamento!)) {
            
            let item = itemOrcamento as! ItemOrcamentoSimples
            
            if item.itemSelecionado != nil {
                return Bool(item.itemSelecionado == "true")
            }
        }
        
        return nil;
    }
    
    func recuperaImovelDesocupado() -> Bool? {
        
        let itemOrcamento = buscaItemOrcamentoPorIndice(indiceSelecaoImovelDesocupado);
        
        if (eSelecaoImovelDesocupado(itemOrcamento!)) {
            
            let item = itemOrcamento as! ItemOrcamentoSimples;
            
            if item.itemSelecionado != nil {
                return Bool(item.itemSelecionado == "true");
            }
        }

        return nil;
    }


    
}
*/
