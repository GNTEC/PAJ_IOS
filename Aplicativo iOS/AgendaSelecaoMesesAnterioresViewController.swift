//
//  AgendaSelecaoMesesAnterioresViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 03/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class AgendaSelecaoMesesAnterioresViewController : UIViewController {
    var modalView: GenericoSelecionarData!
    var listaMeses: [Date]!
    
    @IBOutlet weak var botao_mes_anterior1: UIButton!
    @IBOutlet weak var botao_mes_anterior2: UIButton!
    @IBOutlet weak var botao_mes_anterior3: UIButton!
    @IBOutlet weak var botao_mes_anterior4: UIButton!
    @IBOutlet weak var botao_mes_anterior5: UIButton!
    @IBOutlet weak var botao_mes_anterior6: UIButton!
    @IBOutlet weak var botao_mes_anterior7: UIButton!
    @IBOutlet weak var botao_mes_anterior8: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let botoes: [UIButton?] = [botao_mes_anterior1,
                                   botao_mes_anterior2,
                                   botao_mes_anterior3,
                                   botao_mes_anterior4,
                                   botao_mes_anterior5,
                                   botao_mes_anterior6,
                                   botao_mes_anterior7,
                                   botao_mes_anterior8]

        var componente_data = DateComponents()
        componente_data.month = -botoes.count;
        
        let calendario = Calendar.current

        var data = (calendario as NSCalendar).date(byAdding: componente_data, to: Date(), options: NSCalendar.Options(rawValue: 0));
        
        componente_data.month = 1;
        listaMeses = Array<Date>()

        var indice = 0
        
        for botao in botoes {
            
            listaMeses.append(data!)
        
            let dataFormatada = Data.dateParaDataStringMMAAAA(data!);
            
            var insets = botao?.titleEdgeInsets;
            
            insets?.top += 20;
            
            botao?.tag = indice
            botao?.titleEdgeInsets = insets!;
            botao?.titleLabel?.textAlignment = NSTextAlignment.center;
            botao?.titleLabel?.textColor = corCinzaFundoBullet()
            botao?.titleLabel?.numberOfLines = 2;
            botao?.setTitle(dataFormatada.uppercased(), for: UIControlState())
            
            data = (calendario as NSCalendar).date(byAdding: componente_data, to: data!, options: NSCalendar.Options(rawValue: 0))
            
            indice += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var mesSelecionado: Date?
    
    func mudaParaCalendario(_ dataSelecionada: Date) {
        
        mesSelecionado = dataSelecionada
        
        self.performSegue(withIdentifier: "SeguePassadoParaCalendario", sender: self)
    }
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {

        if(segue.identifier == "SeguePassadoParaCalendario") {
        
            let contexto = ContextoAgendaCalendario()
            
            contexto.mesSelecionado = self.mesSelecionado
            
            let vc = segue.destination as! AgendaCalendarioViewController
            
            vc.defineContexto(contexto)
        }
     }
 
    
    
    @IBAction func onSelecionouMes(_ sender: AnyObject) {
        
        let botao = sender as! UIButton
        
        let dataSelecionada = self.listaMeses[botao.tag]
        
        mudaParaCalendario(dataSelecionada)
    }
    
    @IBAction func onMesesAnteriores(_ sender: AnyObject) {
        modalView = (Bundle.main.loadNibNamed("GenericoSelecionarData", owner: self, options: nil)?[0] as! GenericoSelecionarData)
        modalView.center = self.view.center
        
        let a_frame = self.view.frame
        modalView.frame = a_frame
        
        modalView!.defineDestinoCancelou({() -> Void in
            self.modalView!.removeFromSuperview()
            }, Selecionou: {(data: Date) -> Void in
                self.modalView!.removeFromSuperview()
                
                self.mudaParaCalendario(data)
        })
        self.navigationController!.view.addSubview(modalView!)
    }
}
