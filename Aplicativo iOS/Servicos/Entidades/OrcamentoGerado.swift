//
//  OrcamentoGerado.swift
//  teste_rede
//
//  Created by daniel on 25/08/16.
//  Copyright © 2016 teste. All rights reserved.
//

import Foundation
import ObjectMapper

class OrcamentoGerado: Mappable {
    
    var id: Int
    var id_franquia: Int
    var id_cliente: Int
    var avaliacao: Int
    var descricao: String?
    var pergunta_1: String?
    var pergunta_2: String?
    var pergunta_3: String?
    var pergunta_4: String?
    var pergunta_5: String?
    var pergunta_6: String?
    var tipo_pintura: String?
    var atualizacao: String?
    var status: String?
    
    var forma_de_pagamento: String?
    var meio_de_pagamento: String?
    
    var dias_servico: String?
    var numero_parcelas: String?
    
    var valor: String?
    var valor_bruto: String?
    
    var orcamento_item: [OrcamentoItem]?
    var orcamento_trinca: [OrcamentoTrinca]?
    
    var valor_orcamento_total: Float?
    
    var tinta_franquia_nome_total: Array<AnyObject>?
    var tinta_franquia_litros_total: Array<AnyObject>?
    var tinta_cliente_nome_total: Array<AnyObject>?
    var tinta_cliente_litros_total: Array<AnyObject>?
    var tinta_franquia_consolidado: Array<AnyObject>?
    var tinta_cliente_consolidado: Array<AnyObject>?
    
    // Resposta do checklist
    var trincas: String?
    
    required init?(_ map: Map) {
        
        id = 0
        id_cliente = 0
        id_franquia = 0
        avaliacao = 0
    }
    
    func mapping(_ map: Map) {
        
        /*let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
            // transform value from String? to Int?
            if value == nil {
                return 0
            }
            return Int(value!)
            }, toJSON: { (value: Int?) -> String? in
                // transform value from Int? to String?
                if let value = value {
                    return String(value)
                }
                return nil
        })*/
        
        var id_string : String?
        
        id_string <- map["id"]
        
        if id_string == nil {
            id <- map["id"]
        }
        else {
            id = Int(id_string!)!
        }
        
        //id <- (map["id"], transform)
        id_franquia <- map["id_franquia"]
        id_cliente <- map["id_cliente"]
        descricao <- map["descricao"]
        pergunta_1 <- map["pergunta_1"]
        pergunta_2 <- map["pergunta_2"]
        pergunta_3 <- map["pergunta_3"]
        pergunta_4 <- map["pergunta_4"]
        pergunta_5 <- map["pergunta_5"]
        pergunta_6 <- map["pergunta_6"]
        tipo_pintura <- map["tipo_pintura"]
        valor <- map["valor"]
        valor_orcamento_total <- map["valor_orcamento_total"]
        status <- map["status"]
        
        if status == nil {
            var status_int : Int?
            
            status_int <- map["status"]
            
            if status_int != nil {
                status = "\(status_int!)"
            }
        }
        
        valor_bruto <- map["valor_bruto"]
        
        atualizacao <- map["atualizacao"]
        avaliacao <- map["avaliacao"]
        
        forma_de_pagamento <- map["forma_de_pagamento"]
        meio_de_pagamento <- map["meio_de_pagamento"]
        dias_servico <- map["dias_servico"]
        
        if dias_servico == nil {
            var dias_servico_int : Int?
            
            dias_servico_int <- map["dias_servico"]
            
            if dias_servico_int != nil {
                dias_servico = "\(dias_servico_int!)"
            }
        }
        
        numero_parcelas <- map["numero_parcelas"]
        
        orcamento_item <- map["orcamento_item"];
        orcamento_trinca <- map["orcamento_trinca"];
        
        tinta_franquia_nome_total <- map["tinta_franquia_nome_total"]
        tinta_franquia_litros_total <- map["tinta_franquia_litros_total"]
        tinta_cliente_nome_total <- map["tinta_cliente_nome_total"]
        tinta_cliente_litros_total <- map["tinta_cliente_litros_total"]
        tinta_franquia_consolidado <- map["tinta_franquia_consolidado"]
        tinta_cliente_consolidado <- map["tinta_cliente_consolidado"]
    }
}
