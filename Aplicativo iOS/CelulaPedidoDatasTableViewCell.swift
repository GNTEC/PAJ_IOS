//
//  CelulaPedidoDatasTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 17/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import UIKit

typealias notificaPedidoDatas = (_ inicio: Bool, _ finalizarServico: Bool, _ hora_informada: String?) -> Void;

class CelulaPedidoDatasTableViewCell: UITableViewCell {
    @IBOutlet weak var imagem_calendario: UIImageView!
    @IBOutlet weak var indice_item: UILabel!
    @IBOutlet weak var imagem_inicio: UIImageView!
    @IBOutlet weak var texto_inicio: UILabel!
    @IBOutlet weak var imagem_fim: UIImageView!
    @IBOutlet weak var texto_fim: UILabel!
    
    var notificador : notificaPedidoDatas?
    
    var finalizarServico: Bool?
    var hora: Date?
    var permiteMarcarPonto = true
    weak var viewParaPopup: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap_imagem_fim = UITapGestureRecognizer(target: self, action: #selector(self.exibeAvisoFinalizar))
        let tap_texto_fim = UITapGestureRecognizer(target: self, action: #selector(self.exibeAvisoFinalizar))
        let tap_imagem_inicio = UITapGestureRecognizer(target:self, action: #selector(self.exibeAvisoInicio))
        let tap_texto_inicio = UITapGestureRecognizer(target:self, action: #selector(self.exibeAvisoInicio))
        
        tap_imagem_fim.numberOfTapsRequired = 1
        tap_texto_fim.numberOfTapsRequired = 1
        tap_texto_inicio.numberOfTapsRequired = 1
        tap_imagem_inicio.numberOfTapsRequired = 1

        texto_fim.isUserInteractionEnabled = true
        texto_fim.addGestureRecognizer(tap_texto_fim)
        imagem_fim.isUserInteractionEnabled = true
        imagem_fim.addGestureRecognizer(tap_imagem_fim)
        
        texto_inicio.isUserInteractionEnabled = true
        texto_inicio.addGestureRecognizer(tap_texto_inicio)
        imagem_inicio.isUserInteractionEnabled = true
        imagem_inicio.addGestureRecognizer(tap_imagem_inicio)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        /*if buttonIndex == 1 {
            let vc = self.getViewController()
            vc.navigationController!.popViewControllerAnimated(true)!
        }
        else*/ if buttonIndex == 1 {
            self.notificador?(false, self.finalizarServico!, Data.dateParaHHMM(self.hora!));
        }
    }
    
    func exibeAvisoInicio() {
        
        if !permiteMarcarPonto {
            return
        }
        
        criaExibeAviso({ (modalView: UIView, hora: Date?, finalizarServico:Bool) -> Void in
            
            modalView.removeFromSuperview()

            self.hora = hora
            
            self.notificador?(true, false, Data.dateParaHHMM(hora!))
            
        }, exibeFinalizarServico: false)
    }
    
    func exibeAvisoFinalizar() {
        
        if !permiteMarcarPonto {
            return
        }
        
        criaExibeAviso({(modalView: UIView, hora: Date?, finalizarServico:Bool) -> Void in
            
            modalView.removeFromSuperview()
            
            self.hora = hora
            self.finalizarServico = finalizarServico
            
            if finalizarServico {
                let alert = UIAlertView(title: "", message: "A finalização do serviço deixará disponíveis eventuais dias restantes desse serviço para a sua agenda", delegate: self, cancelButtonTitle: "Voltar")
                alert.addButton(withTitle: "Confirmar")
            
                alert.show()
            }
            else {
                self.notificador?(false, finalizarServico, Data.dateParaHHMM(hora!))
            }
            
        }, exibeFinalizarServico: true)

    }
    
    func criaExibeAviso(_ pdestino: @escaping destinoFinalizaServico, exibeFinalizarServico:Bool) {
        
        let modalView = (Bundle.main.loadNibNamed("PedidoFinalizarServico", owner: self, options: nil)?[0] as! PedidoFinalizarServico)
        
        var vc: UIViewController?
        
        if viewParaPopup == nil {
            vc = self.getViewController()
        }
        else {
            vc = viewParaPopup
        }
        
        modalView.center = vc!.navigationController!.view.center
        let a_frame = vc!.navigationController!.view.frame
        modalView.frame = a_frame
        
        /*modalView.center = vc!.view.center
        let a_frame = vc!.view.frame
        modalView.frame = a_frame*/
        
        modalView.defineDestino(pdestino)
        modalView.exibeFinalizarServico(exibeFinalizarServico)
        
        vc!.navigationController!.view.addSubview(modalView)
        
    }
    
    func getViewController() -> UIViewController {
        var vc = self.next
        while !(vc is UIViewController) && vc != nil {
            vc = vc!.next!
        }
        return vc as! UIViewController
    }
}
