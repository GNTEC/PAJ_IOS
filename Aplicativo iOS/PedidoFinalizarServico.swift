//
//  PedidoFinalizarServico.swift
//  Pintura a Jato
//
//  Created by daniel on 17/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import UIKit

typealias destinoFinalizaServico = (_ modalView: UIView, _ hora: Date?, _ finalizarServico: Bool) -> Void

class PedidoFinalizarServico: UIView {
    
    @IBOutlet weak var botao_check: UIButton!
    @IBOutlet weak var date_picker: UIDatePicker!
    @IBOutlet weak var painel_finalizar_servico: UIView!
    
    var _destino : destinoFinalizaServico?
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     - (void)drawRect:(CGRect)rect {
     // Drawing code
     }
     */
    @IBOutlet weak var fundo: UIView!
    
    override func didMoveToWindow() {
        self.date_picker.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        botao_check.setImage(UIImage(icon: "icon-check-empty", backgroundColor: UIColor.white, iconColor: self.corCinzaBullet(), iconScale: 1.0, andSize: CGSize(width: 24, height: 24)), for: UIControlState())
        botao_check.setImage(UIImage(icon: "icon-check", backgroundColor: UIColor.white, iconColor: self.corCinzaBullet(), iconScale: 1.0, andSize: CGSize(width: 24, height: 24)), for: .selected)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onFundo))
        fundo.isUserInteractionEnabled = true
        fundo.addGestureRecognizer(gesture)
    }
    
    func onFundo(_ sender: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
    
    func defineDestino(_ pdestino: @escaping destinoFinalizaServico) {
        self._destino = pdestino
    }
    
    func exibeFinalizarServico(_ exibe: Bool) {
        
        painel_finalizar_servico.isHidden = !exibe
    }
    
    @IBAction func onOK(_ sender: AnyObject) {
        _destino!(self, date_picker.date, botao_check.isSelected)
    }
    
    @IBAction func onCheck(_ sender: AnyObject) {
        let botao = sender as! UIButton
        botao.isSelected = !botao.isSelected
    }
    
    func corCinzaFundoBullet() -> UIColor {
        return UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1.0)
    }
    
    func corCinzaBullet() -> UIColor {
        return UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.0)
    }
}
