//
//  DatasDisponiveisSaida.swift
//  Pintura a Jato
//
//  Created by daniel on 18/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class DatasDisponiveisSaida : Mappable {
    
    var resultado: Resultado?
    var datas: [String]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        
        resultado <- map["resultado"]
        datas <- map["datas"]
    }
}
