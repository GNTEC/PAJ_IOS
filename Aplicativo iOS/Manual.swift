//
//  Manual.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class Manual : Mappable {
    
    var id: Int
    var id_franquia: Int
    var id_tipo_manual: Int
    var status: Int

    var descricao: String?
    var url: String?
    var atualizacao: String?
    
    required init?(map: Map) {
        id = 0
        id_franquia = 0
        id_tipo_manual = 0
        status = 0
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        id_franquia <- map["id_franquia"]
        id_tipo_manual <- map["id_tipo_manual"]
        status <- map["status"]
        
        descricao <- map["descricao"]
        url <- map["url"]
        atualizacao <- map["atualizacao"]
        
    }
}
