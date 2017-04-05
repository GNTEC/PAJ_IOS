//
//  CelulaOrcamentoPrincipalTrincaDetalheTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 21/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

typealias interacaoTrincaDetalhe = (_ item:ItemOrcamentoTrincaDetalhe?, _ acao: OpcoesSelecaoTrinca) -> Void;

class CelulaOrcamentoPrincipalTrincaDetalheTableViewCell : UITableViewCell,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet weak var label_nome_item: UILabel!
    @IBOutlet weak var edit_tamanho_trinca: UITextField!
    @IBOutlet weak var edit_ambiente: UITextField!
    
    @IBOutlet weak var botao_duplicar: UIButton!
    @IBOutlet weak var botao_adicionar: UIButton!
    @IBOutlet weak var botao_excluir: UIButton!
    
    var itemOrcamento: ItemOrcamentoTrincaDetalhe?
    var interacao: interacaoTrincaDetalhe?
    
    var pickerAmbiente: UIPickerView?
    
    override func awakeFromNib() {

        let controles = [ edit_tamanho_trinca, edit_ambiente ];
        
        for controle in controles {
            controle?.addTarget(self, action: #selector(textoMudou), for: UIControlEvents.editingChanged)
        }
        
        adicionaIconeTextoBotao(botao_duplicar, icone: FAIcon.FAIconCopy)
        adicionaIconeTextoBotao(botao_adicionar, icone: FAIcon.FAIconPlus)
        adicionaIconeTextoBotao(botao_excluir, icone: FAIcon.FAIconRemove)
    }
    
    func adicionaIconeTextoBotao(_ botao: UIButton!, icone: FAIcon, linhas: Int = 2) {
        
        let texto_icone = String.fontAwesomeIconString(forEnum: icone)
        
        let atributo_awesome : [String:AnyObject] = [NSFontAttributeName: UIFont(awesomeFontOfSize:14.0)!]
        
        let textoIcone = NSMutableAttributedString(string: texto_icone!, attributes: atributo_awesome)
        let textoDuplicar = NSAttributedString(string: "\n" + botao.titleLabel!.text!)
        
        textoIcone.append(textoDuplicar)
        
        botao.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        botao.titleLabel!.numberOfLines = linhas
        botao.titleLabel!.textAlignment = NSTextAlignment.center
        
        botao.layer.borderWidth = 1.0
        botao.layer.borderColor = Cores.corCinzaBullet().cgColor
        
        botao.titleLabel!.textColor = Cores.corCinzaBullet()
        
        botao.setAttributedTitle(textoIcone, for: UIControlState())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var view = self.superview
        
        while view != nil && !(view is UITableView) {
            view = view?.superview
        }
        
        view?.endEditing(true)
    }
    
    func defineItemOrcamento(_ itemOrcamento: ItemOrcamentoTrincaDetalhe) {
        
        self.itemOrcamento = itemOrcamento
        
        edit_tamanho_trinca.text = itemOrcamento.tamanhoTrinca
        
        if itemOrcamento.itemAmbiente == nil {
            itemOrcamento.itemAmbiente = itemOrcamento.listaAmbientes?[0]
        }
        
        edit_ambiente.text = itemOrcamento.itemAmbiente?.texto()
    }
    
    
    @IBAction func onDuplicar(_ sender: AnyObject) {
        
        self.interacao?(itemOrcamento, OpcoesSelecaoTrinca.duplicar);
    }
    
    @IBAction func onAdicionar(_ sender: AnyObject) {
        
        self.interacao?(itemOrcamento, OpcoesSelecaoTrinca.adicionar);
    }
    
    @IBAction func onExcluir(_ sender: AnyObject) {
        
        self.interacao?(itemOrcamento, OpcoesSelecaoTrinca.excluir);
    }
    
    func textoMudou(_ sender: AnyObject) {
        
        if sender as! NSObject == self.edit_tamanho_trinca {
            itemOrcamento?.tamanhoTrinca = self.edit_tamanho_trinca.text
        }
        else if sender as! NSObject == self.edit_ambiente {
            itemOrcamento?.defineAmbientePorTexto(self.edit_ambiente.text)
        }
    }
    
    // MARK: - Text field delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        /*if textField.text == "" || textField.text == nil {
            textField.text = itemOrcamento?.listaAmbientes?[0]
        }*/
    }
    
    // MARK: - Picker View Data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if itemOrcamento == nil || itemOrcamento?.listaAmbientes == nil {
            return 0
        }
        
        return itemOrcamento!.listaAmbientes!.count
    }
    // MARK:- Picker View Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            edit_ambiente.text = itemOrcamento?.listaAmbientes?[row].texto()
            itemOrcamento?.itemAmbiente = itemOrcamento?.listaAmbientes?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemOrcamento?.listaAmbientes?[row].texto()
    }
    
    func adicionaPickerAmbiente(_ view: UIView) {
        
        if pickerAmbiente != nil {
            return
        }
        
        pickerAmbiente = UIPickerView()
        pickerAmbiente!.dataSource = self
        pickerAmbiente!.delegate = self
        pickerAmbiente!.showsSelectionIndicator = true
        let doneButton = UIBarButtonItem(title: "Fechar", style: .done, target: self, action: #selector(self.concluido_ambiente(_:)))
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: view.frame.size.height - pickerAmbiente!.frame.size.height - 50, width: 320, height: 50))
        toolBar.barStyle = .blackOpaque
        let toolbarItems = [doneButton]
        toolBar.items = toolbarItems
        edit_ambiente.delegate = self
        edit_ambiente.inputView = pickerAmbiente!
        edit_ambiente.inputAccessoryView = toolBar
        
        edit_ambiente.text = itemOrcamento?.listaAmbientes?[0].texto()
    }
    
    func concluido_ambiente(_ sender: AnyObject) {
        
        //pickerFormaPagamento!.hidden = true
        edit_ambiente.resignFirstResponder()
    }
}
