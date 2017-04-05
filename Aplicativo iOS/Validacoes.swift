//
//  Validacoes.swift
//  Pintura a Jato
//
//  Created by daniel on 14/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class Validacoes {
    
    
    static func isTelefone(_ telefone: String?) -> Bool {
        //TODO: colocar regex: "\\((10)|([1-9][1-9])\\)\\s9?[6-9][0-9]{3}-[0-9]{4}"
        return true
    }
    
    static func isCPF(_ CPF: String) -> Bool {
    
    // considera-se erro CPF's formados por uma sequencia de numeros iguais
        if (CPF == "00000000000" || CPF == "11111111111" || CPF == "22222222222" || CPF == "33333333333" || CPF == "44444444444" || CPF == "55555555555" || CPF == "66666666666" || CPF == "77777777777" || CPF == "88888888888" || CPF == "99999999999" || (CPF.characters.count != 11)) {
            return(false);
        }
    
        var dig10: Character, dig11: Character;
        var sm: UInt32, i: Int, r: UInt32, num: UInt32, peso: UInt32;
    
    // "try" - protege o codigo para eventuais erros de conversao de tipo (int)
    //try {
    // Calculo do 1o. Digito Verificador
        sm = 0;
        peso = 10;
        for (i=0; i<9; i+=1) {
    
            // converte o i-esimo caractere do CPF em um numero:
            // por exemplo, transforma o caractere '0' no inteiro 0
            // (48 eh a posicao de '0' na tabela ASCII)
            let c = CPF[CPF.characters.index(CPF.startIndex, offsetBy: i)...CPF.characters.index(CPF.startIndex, offsetBy: i+1)]
                
            num = c.unicodeScalars.first!.value - 48
            sm = sm + (num * peso);
            peso = peso - 1;
        }
    
        r = 11 - (sm % 11);
        if ((r == 10) || (r == 11)) {
            dig10 = "0";
        }
        else {
            dig10 = Character(UnicodeScalar(r + 48)!); // converte no respectivo caractere numerico
        }
    
        // Calculo do 2o. Digito Verificador
        sm = 0;
        peso = 11;
        for(i=0; i<10; i+=1) {
    
            let c = CPF[CPF.characters.index(CPF.startIndex, offsetBy: i)...CPF.characters.index(CPF.startIndex, offsetBy: i+1)]

            num = c.unicodeScalars.first!.value - 48
    
            sm = sm + (num * peso);
    
            peso = peso - 1;
    
        }
    
    
        r = 11 - (sm % 11);
    
        if ((r == 10) || (r == 11)) {
            dig11 = "0";
        }
        else {
            dig11 = Character(UnicodeScalar(r + 48)!);
        }
    
    
        // Verifica se os digitos calculados conferem com os digitos informados.
        let dig10C = CPF[CPF.characters.index(CPF.startIndex, offsetBy: 9)], dig11C = CPF[CPF.characters.index(CPF.startIndex, offsetBy: 10)]
    
        if ((dig10 == dig10C) && (dig11 == dig11C)) {
            return(true);
        }
        else {
            return(false);
        }
    
    //} catch (InputMismatchException erro) {
    //Registro.registraExcecao(TAG, "Erro validação CPF", erro);
    
    //return(false);
    //}
    }
}
