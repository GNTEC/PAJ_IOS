//
//  Ponto.swift
//  Pintura a Jato
//
//  Created by daniel on 16/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class Ponto : Mappable {
    
    var id: Int
    var id_franquia: Int
    var id_orcamento: Int
    var inicio: String?
    var descricao: String?
    var data_servico: String?
    var longitude: String?
    var latitude: String?
    var precisao: String?
    var atualizacao: String?
    
    required init?(_ map: Map) {
        id = 0
        id_franquia = 0
        id_orcamento = 0
    }
    
    func mapping(_ map: Map) {
    
        id <- map["id"]
        id_franquia <- map["id_franquia"]
        id_orcamento <- map["id_orcamento"]
        inicio <- map["inicio"]
        descricao <- map["descricao"]
        data_servico <- map["data_servico"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        precisao <- map["precisao"]
        atualizacao <- map["atualizacao"]

    }
}
