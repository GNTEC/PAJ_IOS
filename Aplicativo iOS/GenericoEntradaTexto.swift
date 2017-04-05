//
//  GenericoEntradaTexto.swift
//  Pintura a Jato
//
//  Created by daniel on 17/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

import UIKit
typealias destino = (_ texto: String?) -> Void

class GenericoEntradaTexto: UIView {
    var _destino : destino?
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var texto: UITextView!
    
    func defineTitulo(_ titulo: String) {
        self.titulo.text = titulo
    }
    
    @IBAction func onOk(_ sender: AnyObject) {
        self.removeFromSuperview()
        _destino!(self.texto.text)
    }
    
    func defineDestino(_ pdestino: destino?) {
        self._destino = pdestino
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
