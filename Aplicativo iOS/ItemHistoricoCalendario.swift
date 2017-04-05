//
//  ItemHistoricoCalendario.swift
//  Pintura a Jato
//
//  Created by daniel on 03/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class ItemHistoricoCalendario : Mappable {
    
    var id: Int
    var id_franquia: Int
    var id_orcamento: Int
    var descricao: String?
    var data_agenda: String?
    var periodo_agenda: String?
    var periodo_inicial: String?
    var periodo_final: String?
    var tipo: Int
    var sequencia: Int
    var status: String?
    var atualizacao: String?
    
    init() {
        id = 0
        id_franquia = 0
        id_orcamento = 0
        tipo = 0
        sequencia = 0        
    }
    
    required init?(_ map: Map) {
        id = 0
        id_franquia = 0
        id_orcamento = 0
        tipo = 0
        sequencia = 0
    }
    
    func mapping(_ map: Map) {
        id    <- map["id"]
        id_franquia    <- map["id_franquia"]
        id_orcamento    <- map["id_orcamento"]
        descricao    <- map["descricao"]
        data_agenda    <- map["data_agenda"]
        periodo_agenda    <- map["periodo_agenda"]
        periodo_inicial    <- map["periodo_inicial"]
        periodo_final    <- map["periodo_final"]
        tipo    <- map["tipo"]
        sequencia    <- map["sequencia"]
        status    <- map["status"]
        atualizacao    <- map["atualizacao"]
    }
    
    func tipoDataCalendario() -> TipoDataCalendario {
    
        //TODO: verificar como recuperar do valor
        switch (tipo) {
        case 1:
            return TipoDataCalendario.diaInicioTrabalho;
        case 2:
            return TipoDataCalendario.diaBloqueadoFranqueado;
        case 3:
            return TipoDataCalendario.diaContinuacaoFinalizacao;
        default:
            return TipoDataCalendario.nenhum;
        }
    }
    
    func data() -> Date? {
        return Data.dataJsonStringComTParaDate(data_agenda)
    }
    
    func setData(_ novaData: String?) {
        data_agenda = novaData
    }
    
    func inicio() -> String {
        if periodo_inicial == nil || periodo_inicial!.characters.count < 5 {
            return ""
        }
        
        return periodo_inicial!.substring(to: periodo_inicial!.characters.index(periodo_inicial!.startIndex, offsetBy: 5))
    }
    
    func fim() -> String {
        if periodo_final == nil || periodo_final!.characters.count < 5 {
            return ""
        }
        
        return periodo_final!.substring(to: periodo_final!.characters.index(periodo_final!.startIndex, offsetBy: 5))
    }
}
