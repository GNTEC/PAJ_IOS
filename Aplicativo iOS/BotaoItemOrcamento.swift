//
//  BotaoItemOrcamento.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class BotaoItemOrcamento {
    
    let imagem_selecionado: String?
    let imagem_nao_selecionado: String?
    
    let idTexto: String?
    let selecao: String?
    let idTextoSelecao: String?
    
    init(imagemH: String?, imagemA: String?, idTexto: String?, idTextoResposta: String?, textoSelecao: String?) {
        
        imagem_selecionado = imagemH
        imagem_nao_selecionado = imagemA
        self.idTexto = idTexto
        self.idTextoSelecao = idTextoResposta
        self.selecao = textoSelecao
        
    }
}