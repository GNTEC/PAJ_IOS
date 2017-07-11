//
//  GenericoSelecionarData.swift
//  Pintura a Jato
//
//  Created by daniel on 03/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

typealias destinoCancelouDelegate = () -> Void
typealias destinoSelecionouDelegate = (_ data: Date) -> Void

class GenericoSelecionarData: UIView {
    
    @IBOutlet weak var date_picker: UIDatePicker!
    @IBOutlet weak var fundo: UIView!
    
    var destinoCancelou: destinoCancelouDelegate?
    var destinoSelecionou: destinoSelecionouDelegate?
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     - (void)drawRect:(CGRect)rect {
     // Drawing code
     }
     */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        destinoCancelou = nil
        destinoSelecionou = nil
    }
        
    override func didMoveToWindow() {
        self.date_picker.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    }
    
    @IBAction func onSelecionouData(_ sender: AnyObject) {
        
        destinoSelecionou!(self.date_picker.date)
    }
    
    @IBAction func onCancelar(_ sender: AnyObject) {
        destinoCancelou!()
    }
    
    func defineDestinoCancelou(_ destinoCancelou: @escaping destinoCancelouDelegate, Selecionou destinoSelecionou: @escaping destinoSelecionouDelegate) {
        self.destinoCancelou = destinoCancelou
        self.destinoSelecionou = destinoSelecionou
    }
}
