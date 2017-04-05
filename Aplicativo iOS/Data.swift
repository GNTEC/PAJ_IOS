//
//  Data.swift
//  Pintura a Jato
//
//  Created by daniel on 03/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class Data {
    
    static var formatterMMAAAA: DateFormatter? = nil
    static var formatterExtenso: DateFormatter? = nil
    static var formatterJsonStringComT: DateFormatter? = nil
    static var formatterJsonString: DateFormatter? = nil
    static var formatterDD_MM_AAAA: DateFormatter? = nil
    static var formatterDiaMes: DateFormatter? = nil
    static var formatterHHMM: DateFormatter? = nil
    static var formatterMesAno: DateFormatter? = nil
    
    static func dateParaStringMesAno(_ dataDate: Date) -> String {
        
        if(formatterMesAno == nil) {
            formatterMesAno = DateFormatter()
            formatterMesAno?.dateFormat = "MMM/yyyy";
        }
        
        return formatterMesAno!.string(from: dataDate);
    }
    
    static func dateParaJsonStringComT(_ dataDate: Date) -> String {
        
        if(formatterJsonStringComT == nil) {
            formatterJsonStringComT = DateFormatter()
            formatterJsonStringComT!.dateFormat = "yyyy-MM-dd'T'hh:mm:ss";
        }
        
        return formatterJsonStringComT!.string(from: dataDate);
    }
    
    static func dateStringDD_MM_AAAAParaDate(_ dataString: String?) -> Date? {
        
        if(formatterDD_MM_AAAA == nil) {
            formatterDD_MM_AAAA = DateFormatter()
            formatterDD_MM_AAAA!.dateFormat = "dd/MM/yyyy"
        }
        
        return formatterDD_MM_AAAA?.date(from: dataString!)
    }
    
    static func dateParaHHMM(_ dataDate: Date) -> String {
        if(formatterHHMM == nil) {
            formatterHHMM = DateFormatter()
            formatterHHMM?.dateFormat = "HH:mm";
        }
        
        return formatterHHMM!.string(from: dataDate);
        
    }
    
    static func dateParaStringDiaMes(_ dataDate: Date) -> String {
        if(formatterDiaMes == nil) {
            formatterDiaMes = DateFormatter()
            formatterDiaMes?.dateFormat = "dd/MMM";
        }
        
        return formatterDiaMes!.string(from: dataDate);
    }
    
    static func dataJsonStringParaDate(_ dataString: String?) -> Date? {
        
        if(formatterJsonString == nil) {
            formatterJsonString = DateFormatter()
            formatterJsonString!.dateFormat = "yyyy-MM-dd HH:mm:ss";
        }
        
        return formatterJsonString?.date(from: dataString!)
    }
    
    static func dataValidaDD_MM_AAAA(_ dataString: String?) -> Bool {
    
        if(formatterDD_MM_AAAA == nil) {
            formatterDD_MM_AAAA = DateFormatter()
            formatterDD_MM_AAAA!.dateFormat = "dd/MM/yyyy"
        }
        
        let data = formatterDD_MM_AAAA?.date(from: dataString!)
        
        return data != nil
    }
    
    static func dateParaStringDD_MM_AAAA(_ dataDate: Date?) -> String {
        
        if(formatterDD_MM_AAAA == nil) {
            formatterDD_MM_AAAA = DateFormatter()
            formatterDD_MM_AAAA!.dateFormat = "dd/MM/yyyy"
        }
        
        return formatterDD_MM_AAAA!.string(from: dataDate!)
    }
    
    static func dateParaDataStringMMAAAA(_ date: Date) -> String {
    
        if(formatterMMAAAA == nil) {
            formatterMMAAAA = DateFormatter()
            formatterMMAAAA?.dateFormat = "MMM\nYYYY";
        }
    
        return formatterMMAAAA!.string(from: date);
    }
    
    static func dateParaDataExtenso(_ date: Date) -> String {
        
        if(formatterExtenso == nil) {
            formatterExtenso = DateFormatter()
            formatterExtenso!.dateFormat = "'  'EEEE, dd 'de' MMMM 'de' yyyy"
        }
        
        return formatterExtenso!.string(from: date)
    }
    
    static func dataJsonStringComTParaDate(_ dataString: String?) -> Date? {
        
        if(formatterJsonStringComT == nil) {
            formatterJsonStringComT = DateFormatter()
            formatterJsonStringComT!.dateFormat = "yyyy-MM-dd'T'hh:mm:ss";
        }
        
        return formatterJsonStringComT?.date(from: dataString!)
    }
}
