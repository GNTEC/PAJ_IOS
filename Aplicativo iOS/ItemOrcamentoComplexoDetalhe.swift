//
//  ItemOrcamentoComplexoDetalhe.swift
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
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
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


class ItemOrcamentoComplexoDetalhe : ItemOrcamento {
    
    var tipoDetalheComplexo: TipoDetalheComplexo
    
    // Usado no checklist
    var checklistAprovado: Bool?
    var id: Int
    
    // Ambiente
    var altura: String?
    var largura: String?
    var comprimento: String?
    var quantidadePortas: String?
    var quantidadeJanelas: String?
    var quantidadeInterruptores: String?
    
    // Complexa
    var exibeAltura: Bool
    var exibeComprimento: Bool
    var exibeQuantidadePortas: Bool
    var exibeQuantidadeJanelas: Bool
    var exibeQuantidadeInterruptores: Bool
    var exibeBotaoExcluir: Bool
    var exibeBotaoParedeAvulsa: Bool
    var exibeBotaoTetoAvulso: Bool
    var exibeBotaoAmbienteCompleto: Bool
    
    var configuracaoTintaPortas: ConfiguracaoTinta?
    var configuracaoTintaParedes: ConfiguracaoTinta?
    var configuracaoTintaJanelas: ConfiguracaoTinta?
    var configuracaoTintaTeto: ConfiguracaoTinta?
    var configuracaoMassaCorrida: Bool
    
    var necessitaMassaCorrida: Bool?
    var itemOrcamentoPai: ItemOrcamentoComplexoDetalhe?
    
    let LIMITE_ALTURA: Float = 4.0
    
    override init() {
        tipoDetalheComplexo = TipoDetalheComplexo.Ambiente
        id = 0
        exibeAltura = true
        exibeComprimento = true
        exibeQuantidadePortas = true
        exibeQuantidadeJanelas = true
        exibeQuantidadeInterruptores = true
        exibeBotaoExcluir = true
        exibeBotaoParedeAvulsa = true
        configuracaoMassaCorrida = false
        exibeBotaoTetoAvulso = false
        exibeBotaoAmbienteCompleto = false
        super.init()
        tipo = TipoItem.complexoDetalhe
        necessitaMassaCorrida = nil
    }
    
    func atualizaNomeAmbienteOuSequencia(/*String nomeAmbiente,*/ _ novaSequencia: Int ) {
    
        /*if nomeAmbiente != nil {
            self.textoAlternativo = nomeAmbiente
         }
         else {*/
            self.sequencia = novaSequencia
        /*}*/
    
        let locaisPintura = [ LocalPintura.Paredes, LocalPintura.Teto, LocalPintura.Janelas, LocalPintura.Portas ]
    
        for localPintura in locaisPintura {
    
            let configuracaoTinta = self.configuracaoTinta(localPintura);
    
            if ( configuracaoTinta == nil ) {
                continue;
            }
    
            configuracaoTinta!.nomeAmbiente = texto()
        }
    }
    
    init(novoIndice: Int, novaSequencia: Int, idNomeItem: String?, itemOrcamentoCopiar: ItemOrcamentoComplexoDetalhe) {

        tipoDetalheComplexo = TipoDetalheComplexo.Ambiente
        id = 0
        exibeAltura = true
        exibeComprimento = true
        exibeQuantidadePortas = true
        exibeQuantidadeJanelas = true
        exibeQuantidadeInterruptores = true
        exibeBotaoExcluir = true
        exibeBotaoParedeAvulsa = true
        exibeBotaoTetoAvulso = false
        exibeBotaoAmbienteCompleto = false
        configuracaoMassaCorrida = false
        
        super.init(novoIndice: novoIndice, novaSequencia: novaSequencia, idNovoTexto: idNomeItem, itemOrcamentoCopiar: itemOrcamentoCopiar);
        
        self.altura = (itemOrcamentoCopiar.altura);
        self.largura = (itemOrcamentoCopiar.largura);
        self.comprimento = (itemOrcamentoCopiar.comprimento);
        self.quantidadePortas = (itemOrcamentoCopiar.quantidadePortas);
        self.quantidadeJanelas = (itemOrcamentoCopiar.quantidadeJanelas);
        self.quantidadeInterruptores = (itemOrcamentoCopiar.quantidadeInterruptores);
        
        self.exibeAltura = itemOrcamentoCopiar.exibeAltura;
        self.exibeComprimento = itemOrcamentoCopiar.exibeComprimento;
        self.exibeQuantidadePortas = itemOrcamentoCopiar.exibeQuantidadePortas;
        self.exibeQuantidadeJanelas = itemOrcamentoCopiar.exibeQuantidadeJanelas;
        self.exibeQuantidadeInterruptores = itemOrcamentoCopiar.exibeQuantidadeInterruptores;
        self.exibeBotaoExcluir = itemOrcamentoCopiar.exibeBotaoExcluir;
        self.exibeBotaoParedeAvulsa = itemOrcamentoCopiar.exibeBotaoParedeAvulsa;
        self.exibeBotaoTetoAvulso = itemOrcamentoCopiar.exibeBotaoTetoAvulso;
        self.exibeBotaoAmbienteCompleto = itemOrcamentoCopiar.exibeBotaoAmbienteCompleto;
        
        if(itemOrcamentoCopiar.configuracaoTintaJanelas != nil) {
            self.configuracaoTintaJanelas = ConfiguracaoTinta(localPintura: itemOrcamentoCopiar.configuracaoTintaJanelas!.localPintura);
            self.configuracaoTintaJanelas!.copiaDados(itemOrcamentoCopiar.configuracaoTintaJanelas);
            self.configuracaoTintaJanelas?.nomeAmbiente = self.texto()
        }
        if(itemOrcamentoCopiar.configuracaoTintaPortas != nil) {
            self.configuracaoTintaPortas = ConfiguracaoTinta(localPintura: itemOrcamentoCopiar.configuracaoTintaPortas!.localPintura);
            self.configuracaoTintaPortas!.copiaDados(itemOrcamentoCopiar.configuracaoTintaPortas);
            self.configuracaoTintaPortas?.nomeAmbiente = self.texto()
        }
        if(itemOrcamentoCopiar.configuracaoTintaTeto != nil) {
            self.configuracaoTintaTeto = ConfiguracaoTinta(localPintura: itemOrcamentoCopiar.configuracaoTintaTeto!.localPintura);
            self.configuracaoTintaTeto!.copiaDados(itemOrcamentoCopiar.configuracaoTintaTeto);
            self.configuracaoTintaTeto?.nomeAmbiente = self.texto()
        }
        if(itemOrcamentoCopiar.configuracaoTintaParedes != nil) {
            self.configuracaoTintaParedes = ConfiguracaoTinta(localPintura: itemOrcamentoCopiar.configuracaoTintaParedes!.localPintura);
            self.configuracaoTintaParedes!.copiaDados(itemOrcamentoCopiar.configuracaoTintaParedes);
            self.configuracaoTintaParedes?.nomeAmbiente = self.texto()
        }
        
        self.necessitaMassaCorrida = itemOrcamentoCopiar.necessitaMassaCorrida;
        self.configuracaoMassaCorrida = itemOrcamentoCopiar.configuracaoMassaCorrida;
    }
    
    func configuracaoTinta(_ localPintura: LocalPintura) ->  ConfiguracaoTinta? {
        
        switch (localPintura) {
        case LocalPintura.Janelas:
            return configuracaoTintaJanelas;
        case LocalPintura.Paredes:
            return configuracaoTintaParedes;
        case LocalPintura.Portas:
            return configuracaoTintaPortas;
        case LocalPintura.Teto:
            return configuracaoTintaTeto;
        default:
            return nil
        }
    }
    
    func setConfiguracaoTinta(_ configuracaoTinta: ConfiguracaoTinta?) {
    
        if configuracaoTinta == nil {
            return;
        }
    
        setConfiguracaoTinta((configuracaoTinta?.localPintura)!, configuracaoTinta: configuracaoTinta);
    
    }
    
    func setConfiguracaoTinta(_ localPintura: LocalPintura, configuracaoTinta: ConfiguracaoTinta?) {
        
        switch (localPintura) {
        case LocalPintura.Janelas:
            configuracaoTintaJanelas = configuracaoTinta;
            break;
        case LocalPintura.Paredes:
            configuracaoTintaParedes = configuracaoTinta;
            break;
        case LocalPintura.Portas:
            configuracaoTintaPortas = configuracaoTinta;
            break;
        case LocalPintura.Teto:
            configuracaoTintaTeto = configuracaoTinta;
            break;
        default:
            break
        }
        
    }
    
    func adicionaConfiguracaoTinta(_ localPintura: LocalPintura) {
    
        let configuracaoTinta = ConfiguracaoTinta(localPintura: localPintura);
    
        adicionaConfiguracaoTinta(localPintura, configuracaoTinta: configuracaoTinta);
    
    }
    
    func adicionaConfiguracaoTinta(_ localPintura: LocalPintura, configuracaoTinta: ConfiguracaoTinta) {
    
        //String nomeItem = null;
        configuracaoTinta.nomeAmbiente = texto()
        configuracaoTinta.localPintura = (localPintura);
    
        switch (localPintura) {
        case LocalPintura.Janelas:
            configuracaoTinta.nomeItem = ("Janelas");
            configuracaoTintaJanelas = configuracaoTinta;
            break;
        case LocalPintura.Paredes:
            configuracaoTinta.nomeItem = ("Paredes");
            configuracaoTintaParedes = configuracaoTinta;
            break;
        case LocalPintura.Portas:
            configuracaoTinta.nomeItem = ("Portas");
            configuracaoTintaPortas = configuracaoTinta;
            break;
        case LocalPintura.Teto:
            configuracaoTinta.nomeItem = ("Teto");
            configuracaoTintaTeto = configuracaoTinta;
            break;
        default:
            break
        }
    }
    
    override func valido(_ listaErros: inout Array<ItemErroOrcamento>) -> Bool {
        
        let contagem = listaErros.count
        
        
        if(exibeAltura && (altura == nil || altura!.isEmpty) ) {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Altura", ambiente:self.texto(), tipoErroOrcamento: .naoPreenchido));
        }
        else if(exibeAltura && Float(altura!)! > LIMITE_ALTURA) {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: String(format:"Altura não pode ser superior a %.2f metros", LIMITE_ALTURA), ambiente:self.texto(), tipoErroOrcamento: .invalido));
        }
        else if(exibeAltura && Float(altura!)! <= 0.0) {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Altura deve ser maior que zero", ambiente:self.texto(), tipoErroOrcamento: .invalido));
        }
        
        if(largura == nil || largura!.isEmpty) {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Largura", ambiente:self.texto(), tipoErroOrcamento: .naoPreenchido));
        }
        else if(Float(largura!) <= 0.0) {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Largura deve ser maior que zero", ambiente:self.texto(), tipoErroOrcamento: .invalido));
        }
        
        if(exibeComprimento && (comprimento == nil || comprimento!.isEmpty) ) {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Comprimento", ambiente:self.texto(), tipoErroOrcamento: .naoPreenchido));
        }
        else if(exibeComprimento && Float(comprimento!) <= 0.0) {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Comprimento deve ser maior que zero", ambiente:self.texto(), tipoErroOrcamento: .invalido));
        }
        
        if(exibeQuantidadePortas && (self.quantidadePortas == nil || self.quantidadePortas!.isEmpty) ) {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Quantidade de portas", ambiente:self.texto(), tipoErroOrcamento: .naoPreenchido));
        }
        if(exibeQuantidadeJanelas && (self.quantidadeJanelas == nil || self.quantidadeJanelas!.isEmpty) ) {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Quantidade de janelas", ambiente:self.texto(), tipoErroOrcamento: .naoPreenchido));
        }
        if(exibeQuantidadeInterruptores && (quantidadeInterruptores == nil || quantidadeInterruptores!.isEmpty) ) {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Quantidade de interruptores/tomadas", ambiente:self.texto(), tipoErroOrcamento: .naoPreenchido));
        }
        if(configuracaoMassaCorrida && necessitaMassaCorrida == nil) {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Opção de massa corrida", ambiente:self.texto(), tipoErroOrcamento: .naoSelecionado));
        }
        
        let itensConfiguracaoTinta : [ConfiguracaoTinta?] =  [ configuracaoTintaTeto, configuracaoTintaParedes ]
        
        for configuracaoTinta in itensConfiguracaoTinta {
            
            if(configuracaoTinta != nil) {
                configuracaoTinta!.valido(indice, listaErros: &listaErros);
            }
        }
        
        let stringQuantidadeJanelas = self.quantidadeJanelas,
            stringQuantidadePortas = self.quantidadePortas;
        
        let quantidadeJanelas = (stringQuantidadeJanelas == nil || stringQuantidadeJanelas!.isEmpty) ? 0 : Int(stringQuantidadeJanelas!),
            quantidadePortas = (stringQuantidadePortas == nil || stringQuantidadePortas!.isEmpty) ? 0 : Int(stringQuantidadePortas!);
        
        if(quantidadePortas > 0) {
            
            if(configuracaoTintaPortas == nil) {
                listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Cor da(s) porta(s)", ambiente:self.texto(), tipoErroOrcamento: .naoSelecionado));
            }
            else {
                configuracaoTintaPortas!.valido(indice, listaErros: &listaErros);
            }
        }
        
        if(quantidadeJanelas > 0) {
            
            if (configuracaoTintaJanelas == nil) {
                listaErros.append(ItemErroOrcamento(indice: indice, descricao: "Cor da(s) janelas(s)", ambiente:self.texto(), tipoErroOrcamento: .naoSelecionado));
            }
            else {
                configuracaoTintaJanelas!.valido(indice, listaErros: &listaErros);
            }
        }
        
        return listaErros.count == contagem;
    }
    
    func atualizaNomeAmbienteOuSequencia(_ nomeAmbiente: String?, novaSequencia: Int ) {
    
        if (nomeAmbiente != nil) {
            textoAlternativo = nomeAmbiente
        }
        else {
            sequencia = (novaSequencia);
        }
    
        let locaisPintura = [ LocalPintura.Paredes, LocalPintura.Teto, LocalPintura.Janelas, LocalPintura.Portas ]
    
        for localPintura in locaisPintura {
    
            let configuracaoTinta = self.configuracaoTinta(localPintura);
    
            if configuracaoTinta == nil {
                continue;
            }
    
            configuracaoTinta?.nomeAmbiente = texto()
        }
    }
    

}
