//
//  OrcamentoItemPintura.swift
//  teste_rede
//
//  Created by daniel on 25/08/16.
//  Copyright © 2016 teste. All rights reserved.
//

import Foundation
import ObjectMapper

class OrcamentoItemPintura : Mappable {
    
    var id: Int
    var id_orcamento_item_pintura: Int
    var id_orcamento_item: Int
    var nao_pintar: Int
    var fornecer_tintas: Int

    var resposta: String?
    var tipo_registro: String?
    var cor: String?
    var acabamento: String?
    var tipo_tinta: String?
    
    var item_pintura_valor: Float?
    
    required init?(map: Map) {
        
        id = 0
        id_orcamento_item = 0
        id_orcamento_item_pintura = 0
        nao_pintar = 0
        fornecer_tintas = 0
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        id_orcamento_item <- map["id_orcamento_item"]
        id_orcamento_item_pintura <- map["id_orcamento_item_pintura"]
        nao_pintar <- map["nao_pintar"]
        fornecer_tintas <- map["fornecer_tintas"]
        
        resposta <- map["resposta"]
        tipo_registro <- map["tipo_registro"]
        
        cor <- map["cor"]
        acabamento <- map["acabamento"]
        tipo_tinta <- map["tipo_tinta"]
        
        item_pintura_valor <- map["item_pintura_valor"]
    }
}
