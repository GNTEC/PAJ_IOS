//
//  Mask.swift
//  Pintura a Jato
//
//  Created by daniel on 29/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class Mask {
    
    static let caractereSeparadorMilhar = "."
    static let caractereDecimal = ","
    static let pontoFloat = "."
    
    static func ajustaNumeroMascara(_ s2: String, inicio: Int, antes: Int, contagem: Int) -> String {
        
        let str = Mask.removeMascaraValor(s2, caractereSeparadorMilhar: caractereSeparadorMilhar);
        var mascara = "";
        
        /*if (isUpdating) {
            old = str;
            isUpdating = false;
            return;
        }*/
        
        //let i = 0;
        
        var textoFloat = str.replacingOccurrences(of: caractereDecimal, with: "");
        
        if(textoFloat.characters.count > 1) {
            
            if(textoFloat.characters.count == 2) {
                
                let indice = textoFloat.characters.index(textoFloat.startIndex, offsetBy: 1);
                
                textoFloat = textoFloat.substring(to: indice) + pontoFloat + textoFloat.substring(from: indice);
            }
            else {
                let indice = textoFloat.characters.index(textoFloat.endIndex, offsetBy: -2)
                textoFloat = textoFloat.substring(to: indice) + pontoFloat + textoFloat.substring(from: indice);
            }
            
            //float valor = Float.parseFloat(textoFloat);
            //mascara = String.format("%.02f", valor).replace(".", caractereDecimal);
            mascara = textoFloat;
        }
        else {
            mascara = textoFloat;
        }
        
        // remove os zeros à direita, mas deixa um
        //while (mascara.length() > 1 && mascara.endsWith("0") ) {
        //  mascara = mascara.substring(0, mascara.length() - 1);
        //}
        
        //isUpdating = true;
        //ediTxt.setText(mascara);
        //ediTxt.setSelection(mascara.length());
        
        return mascara
    }
    
    static func removeMascaraValor(_ s: String, caractereSeparadorMilhar: String) -> String {
    
        return s.replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "/", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: caractereSeparadorMilhar, with: "");
    }
}
