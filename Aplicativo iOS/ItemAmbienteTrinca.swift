    //
//  ItemAmbienteTrinca.swift
//  Pintura a Jato
//
//  Created by daniel on 06/12/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ItemAmbienteTrinca {
    
    var id_texto: String?
    var sequencia: Int
    
    var id_texto_pai: String?
    var sequencia_pai: Int?

    var textoAlternativo: String?
    var textoAlternativoPai: String?
    
    init (textoAlternativo: String?) {
        self.textoAlternativo = textoAlternativo
        self.sequencia = 0
    }
    
    init (textoAlternativo: String?, id_texto: String?, sequencia: Int?) {
        
        if textoAlternativo != nil {
            self.textoAlternativo = textoAlternativo
            self.sequencia = 0
        }
        else {
            self.sequencia = sequencia!;
            self.id_texto = id_texto;
        }
    }
    
    init(textoAlternativo: String?, id_texto: String?, sequencia: Int? , textoAlternativoPai: String?, id_texto_pai: String?, sequencia_pai: Int?) {

        if textoAlternativo != nil {
            self.textoAlternativo = textoAlternativo
            self.sequencia = 0
        }
        else {
            self.sequencia = sequencia!;
            self.id_texto = id_texto;
        }

        if textoAlternativoPai != nil {
            self.textoAlternativoPai = textoAlternativoPai
            self.sequencia_pai = 0
        }
        else {
            self.sequencia_pai = sequencia_pai;
            self.id_texto_pai = id_texto_pai;
        }

    }
    
    func texto() -> String? {
        
        var chave: String?
        
        if (id_texto_pai == nil || sequencia_pai == nil) {

            chave = textoAmbiente()
        }
        else {
            
            chave = String(format: "%@ (%@)", textoAmbiente()!, textoAmbientePai()!);
        }
        
        return chave;
    }
    
    
    func textoAmbiente() -> String? {
        
        if textoAlternativo != nil {
            return textoAlternativo
        }
        
        return String(format: NSLocalizedString(id_texto!, comment: ""), sequencia)
    }
    
    func textoAmbientePai() -> String? {
        
        if textoAlternativoPai != nil {
            return textoAlternativoPai
        }

        if id_texto_pai == nil || sequencia_pai == nil {
            return nil
        }
        
        return String(format: NSLocalizedString(id_texto_pai!, comment: ""), sequencia_pai!)
    }
    
    func equals(_ itemAmbienteTrinca: ItemAmbienteTrinca) -> Bool {
        
        //if ( !(itemAmbienteTrinca is ItemAmbienteTrinca) ) {
        //    return false;
        //}

        //ItemAmbienteTrinca itemAmbienteTrinca = (ItemAmbienteTrinca)o;
        
        // Se tem texto alternativo e forem iguais
        var ambienteIgual = itemAmbienteTrinca.textoAlternativo != nil && itemAmbienteTrinca.textoAlternativo == self.textoAlternativo
        
        // Se não é igual pelo texto alternativo, pode ser igual pelos id_texto e sequência
        if !ambienteIgual {
            
            ambienteIgual = itemAmbienteTrinca.id_texto == self.id_texto && itemAmbienteTrinca.sequencia == self.sequencia && itemAmbienteTrinca.textoAlternativo == nil && self.textoAlternativo == nil
        }
        
        ////////////////////////////////////////////////////////////////////////////////////////////
        
        // Se tem texto alternativo e forem iguais
        
        var ambientePaiIgual: Bool = (itemAmbienteTrinca.textoAlternativoPai != nil && itemAmbienteTrinca.textoAlternativoPai == self.textoAlternativoPai)
        
        // Se não forem iguais pelo texto alternativo, podem ser pelos id_texto e sequência.
        // Mas só vale se ambos os texto alternativos do pai forem nulos
        if (!ambientePaiIgual && itemAmbienteTrinca.textoAlternativoPai == nil && self.textoAlternativoPai == nil) {

            if ( self.id_texto_pai == nil && self.sequencia_pai == nil && itemAmbienteTrinca.id_texto_pai == nil && itemAmbienteTrinca.sequencia_pai == nil ) {
                ambientePaiIgual = true;
            }
            else if ( (self.id_texto_pai == nil && self.sequencia_pai == nil) || (itemAmbienteTrinca.id_texto_pai == nil && itemAmbienteTrinca.sequencia_pai == nil) ) {
                ambientePaiIgual = false;
            }
            else {
                ambientePaiIgual =  self.id_texto_pai == itemAmbienteTrinca.id_texto_pai && self.sequencia_pai == itemAmbienteTrinca.sequencia_pai;
            }
        }
        
        return ambienteIgual && ambientePaiIgual;

    }
    
    func defineNovoNome(_ novoNome: String?) {
    
        self.textoAlternativo = novoNome;
    }
    
    func defineNovoNomePai(_ novoNomePai: String?) {
    
        self.textoAlternativoPai = novoNomePai;
    }
    
    func itemAmbientePai() -> ItemAmbienteTrinca? {
    
        if  textoAlternativoPai == nil && id_texto_pai == nil && sequencia_pai == nil {
            return nil
        }
    
        return ItemAmbienteTrinca(textoAlternativo: textoAlternativoPai, id_texto: id_texto_pai, sequencia: sequencia_pai!);
    }

}
