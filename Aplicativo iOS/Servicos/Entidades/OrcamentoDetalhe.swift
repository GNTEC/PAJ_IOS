//
//  OrcamentoGerado.swift
//  teste_rede
//
//  Created by daniel on 25/08/16.
//  Copyright © 2016 teste. All rights reserved.
//

import Foundation
import ObjectMapper

class OrcamentoDetalhe : Mappable {
    
    var id: Int
    var id_franquia: Int
    var id_cliente: Int
    var nome: String?
    var descricao: String?
    var pergunta_1: String?
    var pergunta_2: String?
    var pergunta_3: String?
    var pergunta_4: String?
    var pergunta_5: String?
    var pergunta_6: String?
    var dataExibicao: String?
    var valor: String?
    var status: Int
    var atualizacao: String?
    var avaliacao: Int
    
    required init?(map: Map) {
   
        id = 0;
        id_cliente = 0;
        id_franquia = 0
        avaliacao = 0
        status = 0
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        id_franquia <- map["id_franquia"]
        id_cliente <- map["id_cliente"]
        nome <- map["nome"]
        descricao <- map["descricao"]
        pergunta_1 <- map["pergunta_1"]
        pergunta_2 <- map["pergunta_2"]
        pergunta_3 <- map["pergunta_3"]
        pergunta_4 <- map["pergunta_4"]
        pergunta_5 <- map["pergunta_5"]
        pergunta_6 <- map["pergunta_6"]
        dataExibicao <- map["dataExibicao"]
        valor <- map["valor"]
        status <- map["status"]
        atualizacao <- map["atualizacao"]
        avaliacao <- map["avaliacao"]
    }
    
}
