//
//  OrcamentoEscolhaMassaCorridaPopup.swift
//  Pintura a Jato
//
//  Created by daniel on 19/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class OrcamentoEscolhaMassaCorridaPopup : UIView {
    
    @IBOutlet weak var label_titulo: UILabel!
    @IBOutlet weak var botao_sim: UIButton!
    @IBOutlet weak var botao_nao: UIButton!
    @IBOutlet weak var botao_fechar: UIButton!
    @IBOutlet weak var viewInterna: UIView!
    @IBOutlet weak var viewAreaUmidaSeca: UIView!
    @IBOutlet weak var botao_areas_umidas: UIButton!
    @IBOutlet weak var botao_areas_secas: UIButton!
    
    @IBOutlet weak var contraintHeightViewInterna: NSLayoutConstraint!
    
    
    var itemOrcamento: ItemOrcamentoComplexoDetalhe?
    
    func defineItemOrcamento(_ itemOrcamento: ItemOrcamentoComplexoDetalhe?) {
        
        self.itemOrcamento = itemOrcamento;
    
        if itemOrcamento?.necessitaMassaCorrida != nil {
            let necessitaMassaCorrida = itemOrcamento!.necessitaMassaCorrida!
            
            botao_nao.isSelected = !necessitaMassaCorrida
            botao_sim.isSelected = necessitaMassaCorrida
        }
        
    }
    
    override func didMoveToWindow() {
        //let verde = UIColor(red: 134.0 / 255.0, green: 206.0 / 255.0, blue: 87.0 / 255.0, alpha: 1.0)
        botao_fechar.setImage(UIImage(icon: "icon-check", backgroundColor: UIColor.clear, iconColor: UIColor.white, iconScale: 1.0, andSize: CGSize(width: 30, height: 30)), for: UIControlState())
        label_titulo.text = "Necessita serviço de massa corrida para o \(itemOrcamento!.texto()!) ?  "
    }
    
    @IBAction func onSim(_ sender: AnyObject) {
        
        botao_sim.isSelected = true
        botao_nao.isSelected = false
        viewAreaUmidaSeca.isHidden = false
        desvabilitaBotoesAreaUmicaSeca()
        
        itemOrcamento?.necessitaMassaCorrida = true
    }

    @IBAction func onNao(_ sender: AnyObject) {
        
        botao_sim.isSelected = false
        botao_nao.isSelected = true
        viewAreaUmidaSeca.isHidden = true
        desvabilitaBotoesAreaUmicaSeca()
        
        itemOrcamento?.necessitaMassaCorrida = false
    }
    
    @IBAction func onAreasSecas(_ sender: AnyObject) {
        
        botao_areas_secas.isSelected = true
        botao_areas_umidas.isSelected = false
    }
    
    @IBAction func onAreasUmidas(_ sender: AnyObject) {
        
        botao_areas_umidas.isSelected = true
        botao_areas_secas.isSelected = false
    }
    
    
    @IBAction func onFechar(_ sender: AnyObject) {
        
        if !botao_nao.isSelected && !botao_sim.isSelected {
            exibeAlerta("Por favor selecione se necessita ou não o serviço de massa corrida" , textoBotao: "Fechar")
        }
        else {
            self.removeFromSuperview()
        }
    }
    
    func desvabilitaBotoesAreaUmicaSeca () {
        
        botao_areas_secas.isSelected = false
        botao_areas_umidas.isSelected = false
    
    }
    
    func exibeAlerta(_ mensagem: String, textoBotao: String) {
        
        let alert = UIAlertController.init(title:AvisoProcessamento.Titulo, message:mensagem, preferredStyle:UIAlertControllerStyle.alert);
        
        let defaultAction = UIAlertAction.init(title:textoBotao, style:UIAlertActionStyle.default,
                                               handler: { (action: UIAlertAction) -> Void in
                                                
        })
        
        alert.addAction(defaultAction)
        
        window?.rootViewController?.present(alert, animated:true, completion:nil)
    }
}
