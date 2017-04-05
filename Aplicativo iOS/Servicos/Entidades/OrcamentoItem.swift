//
//  OrcamentoItem.swift
//  teste_rede
//
//  Created by daniel on 25/08/16.
//  Copyright © 2016 teste. All rights reserved.
//

import Foundation
import ObjectMapper

class OrcamentoItem : Mappable {

    var id: Int
    var id_orcamento_item: Int
    
    var tipo_registro: String?
    var descricao: String?
    
    var largura: String?
    var altura: String?
    var comprimento: String?
    var portas: Int
    var janelas: Int
    var interruptores: Int
    var massa_corrida: Int?
    
    // Para bater o cálculo com o item enviado
    var indice: Int?
    
    var valor_ambiente: Float?
    
    // item do checklist
    var resposta: String?
    
    var item_pintura: [OrcamentoItemPintura]?
    
    required init?(_ map: Map) {
        
        id = 0
        id_orcamento_item = 0
        interruptores = 0
        janelas = 0
        portas = 0
    }
    
    func mapping(_ map: Map) {
        id <- map["id"]
        id_orcamento_item <- map["id_orcamento_item"]
        item_pintura <- map["item_pintura"]

        descricao <- map["descricao"]
        tipo_registro <- map["tipo_registro"]
        
        largura <- map["largura"]
        altura <- map["altura"]
        comprimento <- map["comprimento"]
        portas <- map["portas"]
        janelas <- map["janelas"]
        interruptores <- map["interruptores"]
        massa_corrida <- map["massa_corrida"]
        if massa_corrida == nil {
            var texto : String?
            
            texto <- map["massa_corrida"]
            
            if texto != nil {
                massa_corrida = Int(texto!)
            }
        }
        valor_ambiente <- map["valor_ambiente"]
        indice <- map["indice"]
    }
}
