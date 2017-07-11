//
//  CelulaConclusaoOrcamentoConfirmacaoTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class CelulaConclusaoOrcamentoConfirmacaoTableViewCell : UITableViewCell, UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var edit_forma_pagamento: UITextField!
    @IBOutlet weak var edit_meio_pagamento: UITextField!
    @IBOutlet weak var botao_confirmar: UIButton!
    @IBOutlet weak var label_prazo_execucao: UILabel!
    @IBOutlet weak var label_valor_servico: UILabel!
    @IBOutlet weak var label_valor_servico_a_vista: UILabel!
    @IBOutlet weak var botao_concordo_termos: UIButton!
    @IBOutlet weak var painel_novo_orcamento: UIView!
    @IBOutlet weak var painel_refazer_orcamento: UIView!
    @IBOutlet weak var constraint_altura_painel_novo_orcamento: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_painel_refazer_orcamento: NSLayoutConstraint!
    @IBOutlet weak var label_valor_anterior: UILabel!
    @IBOutlet weak var label_valor_ja_pago: UILabel!
    @IBOutlet weak var label_valor_novo: UILabel!
    @IBOutlet weak var label_valor_diferenca: UILabel!
    @IBOutlet weak var label_valor_diferenca_a_vista: UILabel!
    @IBOutlet weak var label_prazo_execucao_refazer: UILabel!
    
    let tipos_formas_pagamento = [ TipoPagamento.AVista, TipoPagamento.ComEntrada, TipoPagamento.Parcelado, TipoPagamento.Parcelado];
    let formas_pagamento = [ "À vista" , "15% agora + 85% no início do serviço", "Parcelado em 2x", "Parcelado em 3x"];
    //let formas_pagamento_refazer = [ "À vista" , "Parcelado em 2x", "Parcelado em 3x"];
    let tipos_meios_pagamento = [ TipoMeioPagamento.CartaoCredito, TipoMeioPagamento.Dinheiro, TipoMeioPagamento.CartaoCreditoMaquina]
    let meios_pagamento = [ "Cartão de Crédito", "Dinheiro", "Cartão c/Máquina"];
    
    var fonte_atual: [String]?
    
    //var tipo_forma_pagamento = TipoPagamento.AVista
    //var tipo_meio_pagamento = TipoMeioPagamento.CartaoCredito
    //var parcelas = 1
    var escolhaPagamento: EscolhaPagamento?
    
    var pickerFormaPagamento: UIPickerView?
    var pickerMeioPagamento: UIPickerView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        init_comum()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        init_comum()
    }
    
    func init_comum() {
        
        
    }
    
    @IBAction func onCheck(_ sender: AnyObject) {
        
        let botao = sender as! UIButton;
        
        botao.isSelected = !botao.isSelected
        
        escolhaPagamento?.leuOTermo = botao.isSelected
    }
    
    var destino: (() -> Void)?
    
    func defineDestinoConfirmar(_ destino: @escaping () -> Void) {
        self.destino = destino
    }
    
    @IBAction func onBotaoConfirmar(_ sender: AnyObject) {
        destino?()
    }
    
    // MARK: - Text field delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == edit_forma_pagamento {
            fonte_atual = formas_pagamento
            
        }
        else if textField == edit_meio_pagamento {
            fonte_atual = meios_pagamento
            pickerMeioPagamento?.isHidden = false
        }
        
        if textField.text == "" {
            textField.text = fonte_atual![0]
        }
    }
    // MARK: - Picker View Data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if fonte_atual == nil {
            return 0
        }
        
        return fonte_atual!.count
    }
    // MARK:- Picker View Delegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerFormaPagamento {
            let texto = fonte_atual![row]
            
            edit_forma_pagamento.text = texto
            escolhaPagamento?.formaPagamento = tipos_formas_pagamento[row]
            
            if texto.contains("2x") {
                escolhaPagamento?.parcelas = 2
            }
            else if texto.contains("3x") {
                escolhaPagamento?.parcelas = 3
            }
            else {
                escolhaPagamento?.parcelas = 1
            }
            
            
            
        }
        else if pickerView == pickerMeioPagamento {
            edit_meio_pagamento.text = fonte_atual![row]
            escolhaPagamento?.meioPagamento = tipos_meios_pagamento[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fonte_atual![row]
    }
    
    func defineEscolhaPagamento(_ escolhaPagamento: EscolhaPagamento?) {
        self.escolhaPagamento = escolhaPagamento
    }
    
    func exibePainel(_ novo:Bool) {
        
        if novo {
            self.constraint_altura_painel_refazer_orcamento.constant = 0.0
        }
        else {
            self.constraint_altura_painel_novo_orcamento.constant = 0.0
        }
    }
    
    func adicionaPickerMeioPagamento(_ view: UIView) {
        
        if pickerMeioPagamento != nil {
            return
        }
        
        pickerMeioPagamento = UIPickerView()
        pickerMeioPagamento!.dataSource = self
        pickerMeioPagamento!.delegate = self
        pickerMeioPagamento!.showsSelectionIndicator = true
        let doneButton = UIBarButtonItem(title: "Fechar", style: .done, target: self, action: #selector(self.concluido_meio(_:)))
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: view.frame.size.height - pickerMeioPagamento!.frame.size.height - 50, width: 320, height: 50))
        toolBar.barStyle = .blackOpaque
        let toolbarItems = [doneButton]
        toolBar.items = toolbarItems
        edit_meio_pagamento.delegate = self
        edit_meio_pagamento.inputView = pickerMeioPagamento!
        edit_meio_pagamento.inputAccessoryView = toolBar
        
        edit_meio_pagamento.text = meios_pagamento[0]
    }
    
    func concluido_forma(_ sender: AnyObject) {
        
        //pickerFormaPagamento!.hidden = true
        edit_forma_pagamento.resignFirstResponder()
    }
    func concluido_meio(_ sender: AnyObject) {
        
        //pickerFormaPagamento!.hidden = true
        edit_meio_pagamento.resignFirstResponder()
    }
    
    func adicionaPickerFormaPagamento(_ view: UIView) {
        
        if pickerFormaPagamento != nil {
            return
        }
        
        pickerFormaPagamento = UIPickerView()
        pickerFormaPagamento!.dataSource = self
        pickerFormaPagamento!.delegate = self
        pickerFormaPagamento!.showsSelectionIndicator = true
        let doneButton = UIBarButtonItem(title: "Fechar", style: .done, target: self, action: #selector(self.concluido_forma(_:)))
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: view.frame.size.height - pickerFormaPagamento!.frame.size.height - 50, width: 320, height: 50))
        toolBar.barStyle = .blackOpaque
        let toolbarItems = [doneButton]
        toolBar.items = toolbarItems
        edit_forma_pagamento.delegate = self
        edit_forma_pagamento.inputView = pickerFormaPagamento!
        edit_forma_pagamento.inputAccessoryView = toolBar
        
        edit_forma_pagamento.text = formas_pagamento[0]

    }
}
