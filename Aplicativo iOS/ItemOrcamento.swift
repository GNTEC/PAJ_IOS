//
//  ItemOrcamento.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ItemOrcamento {
    
    // Comum a todos
    var indice: Int
    var sequencia: Int
    var idTexto: String?
    var idTextoAjuda: String?
    var tipo: TipoItem
    
    var textoAlternativo: String?
    
    var exibeSequencia: Bool
    var exibeTexto: Bool
    var valorCalculado: Float
    var valorAVista: Float
    
    init() {
        indice = 0
        sequencia = 0
        exibeSequencia = true
        exibeTexto = true
        tipo = TipoItem.simples
        valorCalculado = 0.0
        valorAVista = 0.0
    }
    
    init(novoIndice: Int, novaSequencia: Int, idNovoTexto: String?, itemOrcamentoCopiar: ItemOrcamento) {
    
        self.exibeSequencia = itemOrcamentoCopiar.exibeSequencia;
        self.exibeTexto = itemOrcamentoCopiar.exibeTexto;
    
        self.indice = novoIndice;
        self.sequencia = novaSequencia;
        self.idTexto = idNovoTexto;
        self.tipo = itemOrcamentoCopiar.tipo
        self.textoAlternativo = itemOrcamentoCopiar.textoAlternativo
        
        valorCalculado = 0.0
        valorAVista = 0.0
    }
    
    func texto() -> String? {
        
        if textoAlternativo != nil {
            return textoAlternativo
        }
        
        if idTexto == nil {
            return "<idTexto> inválido"
        }
        
        let mascara = NSLocalizedString(idTexto!, comment: "")
        
        return String(format:mascara, sequencia)
    }
    
    func texto(_ novoTexto: String?) {
        self.textoAlternativo = novoTexto
    }
    
    func valido(_ listaErros: inout Array<ItemErroOrcamento>) -> Bool {
        return false
    }
    
    func usaSequencia() -> Bool {
        return textoAlternativo == nil;
    }
}
