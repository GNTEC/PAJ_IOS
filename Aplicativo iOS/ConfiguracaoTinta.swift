//
//  ConfiguracaoTinta.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ConfiguracaoTinta {
    
    var cor: CorTinta
    var tipo: TipoTinta
    var acabamento: AcabamentoTinta
    var clienteForneceTintas: Bool
    var naoPintara: Bool
    
    // Usado na confirmacao
    var valorCalculado: Float
    // Usado no checklist
    var checklistAprovado: Bool?
    var id: Int
    
    var nomeItem: String?
    var nomeAmbiente: String?
    var localPintura: LocalPintura
    
    var celulaExpandida = false
    
    init(localPintura: LocalPintura) {
        
        self.localPintura = localPintura;
        
        cor = CorTinta.Nenhum
        tipo = TipoTinta.Nenhum
        acabamento = AcabamentoTinta.Nenhum
        clienteForneceTintas = false
        naoPintara = false
        
        valorCalculado = 0.0
        checklistAprovado = false
        id = 0
    }
    
    func descricaoCorSelecionada() -> String? {
        switch (cor) {
        case CorTinta.Branco:
            return "literal_cor_branco"
        case CorTinta.Concreto:
            return "literal_cor_concreto"
        case CorTinta.Gelo:
            return "literal_cor_gelo"
        case CorTinta.Marfim:
            return "literal_cor_marfim"
        case CorTinta.Nenhum:
            return "literal_cor_nenhum"
        case CorTinta.Palha:
            return "literal_cor_palha"
        case CorTinta.Verniz:
            return "literal_cor_verniz"
        case CorTinta.Platina:
            return "literal_cor_platina"
        }
        
        //return "texto_vazio"
    }
    
    func descricaoTipoTintaSelecionada() -> String? {
        switch (tipo) {
        case TipoTinta.Acrilica:
            return "literal_tipo_acrilica"
        case TipoTinta.Nenhum:
            return "literal_tipo_nenhum"
        case TipoTinta.PVA:
            return "literal_tipo_pva"
        case TipoTinta.EsmalteBaseAgua:
            return "literal_tipo_esmalte_base_agua"
        case TipoTinta.EsmalteSintetico:
            return "literal_tipo_esmalte_sintetico"
        case TipoTinta.Incolor:
            return "literal_tipo_incolor"
        }
        
        //return "texto_vazio"
    }
    
    func descricaoAcabamentoSelecionado() -> String? {
        
        switch (acabamento) {
        case  AcabamentoTinta.Brilhante:
            return "literal_acabamento_brilhante"
        case AcabamentoTinta.Fosco:
            return "literal_acabamento_fosco"
        case AcabamentoTinta.Semibrilho:
            return "literal_acabamento_semibrilho"
        case AcabamentoTinta.Acetinado:
            return "literal_acabamento_acetinado"
        case AcabamentoTinta.Nenhum:
            return "literal_acabamento_nenhum"
        }
        
        //return "texto_vazio"
    }

    func valido(_ indice: Int, listaErros: inout Array<ItemErroOrcamento>) -> Bool {
        
        let contagem = listaErros.count
        
        if(naoPintara) {
            return true;
        }
        
        if(clienteForneceTintas) {
            return true;
        }
        
        var mensagem: String? = nil
        
        if(cor == CorTinta.Nenhum) {
            mensagem = "Cor"
        }
        if(tipo == TipoTinta.Nenhum) {
            if mensagem == nil {
                mensagem = "Tipo tinta"
            }
            else {
                mensagem! += ", Tipo tinta"
            }
        }
        if(acabamento == AcabamentoTinta.Nenhum) {
            if mensagem == nil {
                mensagem = "Acabamento"
            }
            else {
                mensagem! += ", Acabamento"
            }
        }
        
        if mensagem != nil {
            listaErros.append(ItemErroOrcamento(indice: indice, descricao: "\(nomeItem!) : \(mensagem!)", ambiente: self.nomeAmbiente, tipoErroOrcamento: .naoSelecionado));
        }
        
        return listaErros.count == contagem;
    }
    
    func copiaDados(_ configuracaoTintaCopiar: ConfiguracaoTinta?) {
        
        if(configuracaoTintaCopiar == nil) {
            return;
        }
        
        self.cor = (configuracaoTintaCopiar!.cor);
        self.tipo = (configuracaoTintaCopiar!.tipo);
        self.acabamento = (configuracaoTintaCopiar!.acabamento);
        self.clienteForneceTintas = (configuracaoTintaCopiar!.clienteForneceTintas);
        self.naoPintara = (configuracaoTintaCopiar!.naoPintara);
        self.localPintura = (configuracaoTintaCopiar!.localPintura);
        self.nomeItem = (configuracaoTintaCopiar!.nomeItem);
        self.nomeAmbiente = (configuracaoTintaCopiar!.nomeAmbiente);
    }
    
    func exibeNaoPintara() -> Bool {
        return localPintura == .Portas || localPintura == .Janelas
    }
}
