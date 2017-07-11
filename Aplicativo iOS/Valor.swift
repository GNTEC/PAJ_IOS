//
//  Valor.swift
//  Pintura a Jato
//
//  Created by daniel on 06/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class Valor {
    
    static func floatParaMoedaString(_ valor: Float) -> String {
        
        //return String(format:"%.2f", valor)
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle =  NumberFormatter.Style.currency
        numberFormatter.currencySymbol = "R$ "
        numberFormatter.currencyDecimalSeparator = ","
        numberFormatter.currencyGroupingSeparator = "."
        return numberFormatter.string(from: NSNumber(value: valor as Float))!;
    }
    
    static func floatParaStringValor(_ valor: Float) -> String {

        return String(format:"%.2f", valor)
    }
}
