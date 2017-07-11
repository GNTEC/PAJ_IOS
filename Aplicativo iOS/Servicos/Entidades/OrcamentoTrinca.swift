//
//  OrcamentoTrinca.swift
//  teste_rede
//
//  Created by daniel on 25/08/16.
//  Copyright © 2016 teste. All rights reserved.
//

import Foundation
import ObjectMapper

class OrcamentoTrinca : Mappable {
    
    var id: Int
    var tamanho: Int
    var tipo_registro: String?
    var ambiente: String?
    var ambiente_pai: String?
    
    required init?(map: Map) {
        
        id = 0
        tamanho = 0
    }
    
    func mapping(map: Map) {
        id <- map["id"]

        var tamanho_string: String?
        
        tamanho_string <- map["tamanho"]
        
        if tamanho_string != nil {
            let tamanho_float = Float(tamanho_string!)!
            
            tamanho = Int(tamanho_float)
        }
        else {
            tamanho <- map["tamanho"]
        }
        
        tipo_registro <- map["tipo_registro"]
        ambiente <- map["ambiente"]
        ambiente_pai <- map["ambiente_pai"]
    }
}
