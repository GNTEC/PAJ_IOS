//
//  LoginSaida.swift
//  teste_rede
//
//  Created by daniel on 23/08/16.
//  Copyright © 2016 teste. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginSaida : Mappable {
    
    var resultado: Resultado?
    var franqueado: Franqueado?
    var sessao: Sessao?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        resultado    <- map["resultado"]
        franqueado   <- map["franqueado"]
        sessao       <- map["sessao"]
    }
    
}
