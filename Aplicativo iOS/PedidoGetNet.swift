//
//  PedidoGetNet.swift
//  Pintura a Jato
//
//  Created by daniel on 24/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import ObjectMapper

class PedidoGetNet : Mappable {
    
    var transactionID: String?
    var originalTransactionID:String?
    var merchantTrackID: String?
    var descriptionResponse:String?
    var responseCode: String?
    var eci: String?
    var auth: String?
    var ref: String?
    var postdate: String?
    var amount: String?
    var currencycode: String?
    var instType: String?
    var instNum: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        transactionID <- map["transactionID"]
        originalTransactionID <- map["originalTransactionID"]
        merchantTrackID <- map["merchantTrackID"]
        descriptionResponse <- map["descriptionResponse"]
        responseCode <- map["responseCode"]
        eci <- map["eci"]
        auth <- map["auth"]
        ref <- map["ref"]
        postdate <- map["postdate"]
        amount <- map["amount"]
        currencycode <- map["currencycode"]
        instType <- map["instType"]
        instNum <- map["instNum"]
        
    }
}
