//
//  AgendaEventoViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 05/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit

class AgendaEventoViewController: UIViewController {
    @IBOutlet weak var botao_check: UIButton!
    @IBOutlet weak var imagem_data_inicio: FAImageView!
    @IBOutlet weak var imagem_data_fim: FAImageView!
    @IBOutlet weak var imagem_motivo: FAImageView!
    @IBOutlet weak var edit_data_inicial: UITextField!
    @IBOutlet weak var edit_data_final: UITextField!
    @IBOutlet weak var edit_motivo: UITextField!
    
    var datePickerInicio = UIDatePicker()
    var datePickerFim = UIDatePicker()
    
    @IBAction func onAdicionar(_ sender: AnyObject) {
        //self.navigationController.popViewControllerAnimated(true)!
        var mensagem: String?
        
        if edit_motivo.text!.isEmpty {
            mensagem = "Motivo vazio"
        }

        if edit_data_final.text!.isEmpty {
            mensagem = "Data final vazia"
        }
        else if !Data.dataValidaDD_MM_AAAA(edit_data_final.text) {
            mensagem = "Data final inválida"
        }

        if edit_data_inicial.text!.isEmpty {
            mensagem = "Data inicial vazia"
        }
        else if !Data.dataValidaDD_MM_AAAA(edit_data_inicial.text) {
            mensagem = "Data inicial inválida"
        }
        
        if mensagem != nil {
            
            AvisoProcessamento.mensagemErroGenerico(mensagem)
            
            return
        }
        
        ////////////////////////////////////////////////////////////////////////
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "data_inicial" : edit_data_inicial.text! as AnyObject,
            "data_final" : edit_data_final.text! as AnyObject,
            "motivo" : edit_motivo.text! as AnyObject,
            "descricao" : "Bloqueado pelo Franqueado \(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
            "id_orcamento" : "0" as AnyObject,
            "id_equipe" : "1" as AnyObject,
            "tipo" : "\(TipoDataCalendario.diaBloqueadoFranqueado.rawValue)" as AnyObject,
            "status" : "\(TipoDataCalendario.diaBloqueadoFranqueado.rawValue)" as AnyObject,
            "id_franquia" : String.init(format:"%d", PinturaAJatoApi.obtemFranqueado()!.id_franquia) as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.incluirAgendaBloqueio(self.navigationController!.view, parametros: parametros, sucesso: { (objeto: Resultado?) -> Bool in
            
                AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: objeto?.mensagem, destino: {
                    if objeto?.erro == false {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
          return true
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let size: CGSize = CGSize(width: 30, height: 30)

        let image = UIImage.init(icon:"icon-check", backgroundColor: UIColor.clear, iconColor: UIColor.white, iconScale: 1.0, andSize: size)
        
        botao_check!.setImage(image, for: UIControlState())
        let background_color = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1.0)
        // cinza escuro
        let icon_color = UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.0)
        // cinza claro
        self.imagem_motivo.image = UIImage.init(icon: "icon-comment", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_data_inicio.image = UIImage.init(icon: "icon-calendar", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_data_fim.image = UIImage.init(icon: "icon-calendar", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
#if DEBUG
        //edit_data_inicial.text = "05/09/2016"
        //edit_data_final.text = "06/09/2016"
        edit_motivo.text = "Teste"
#endif
        
        datePickerInicio.datePickerMode = UIDatePickerMode.date
        datePickerFim.datePickerMode = UIDatePickerMode.date
        
        datePickerInicio.setDate(Date(), animated: false)
        datePickerFim.setDate(Date(), animated: false)
        
        datePickerInicio.addTarget(self, action: #selector(dataInicioSelecionada), for: UIControlEvents.valueChanged)
        datePickerFim.addTarget(self, action: #selector(dataFimSelecionada), for: UIControlEvents.valueChanged)
        
        datePickerInicio.addTarget(self, action: #selector(dataInicioSelecionada), for: UIControlEvents.editingDidBegin)
        datePickerFim.addTarget(self, action: #selector(dataFimSelecionada), for: UIControlEvents.editingDidBegin)
        
        edit_data_inicial.inputView = datePickerInicio
        edit_data_final.inputView = datePickerFim
        
    }
    
    func dataInicioSelecionada(_ sender: AnyObject) {
        
        edit_data_inicial.text = Data.dateParaStringDD_MM_AAAA(datePickerInicio.date)
    }
    
    func dataFimSelecionada(_ sender: AnyObject) {
        edit_data_final.text = Data.dateParaStringDD_MM_AAAA(datePickerFim.date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
