//
//  AgendaSelecaoTempoViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 04/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class AgendaSelecaoTempoViewController : UIViewController {
    
    var mesSelecionado: Date?
    
    @IBAction func onFuturo(_ sender: AnyObject) {
        
        var componentes = DateComponents()
        
        componentes.month = 1
        
        mudaParaCalendario((Calendar.current as NSCalendar).date(byAdding: componentes, to: Date(), options: NSCalendar.Options(rawValue: 0))!)
        
    }
    
    func mudaParaCalendario(_ dataSelecionada: Date) {
        
        mesSelecionado = dataSelecionada
        
        self.performSegue(withIdentifier: "SegueParaCalendario", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        
        if(segue.identifier == "SegueParaCalendario" && mesSelecionado != nil) {
            
            let contexto = ContextoAgendaCalendario()
            
            contexto.mesSelecionado = self.mesSelecionado
            
            let vc = segue.destination as! AgendaCalendarioViewController
            
            vc.defineContexto(contexto)
        }
    }
}
