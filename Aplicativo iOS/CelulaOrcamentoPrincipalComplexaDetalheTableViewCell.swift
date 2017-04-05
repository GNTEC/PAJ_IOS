//
//  CelulaOrcamentoPrincipalComplexaDetalheTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 18/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

typealias interacaoComplexaDetalhe = (_ item:ItemOrcamentoComplexoDetalhe?, _ acao: OpcoesSelecaoComplexa) -> Void;
typealias interacaoMudouNomeAmbiente = (_ item:ItemOrcamentoComplexoDetalhe?, _ novoNome: String?) -> Void;

import UIKit
class CelulaOrcamentoPrincipalComplexaDetalheTableViewCell: UITableViewCell, UITextFieldDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var nome_item: UILabel!
    @IBOutlet weak var edit_altura: UITextField!
    @IBOutlet weak var edit_largura: UITextField!
    @IBOutlet weak var edit_comprimento: UITextField!
    @IBOutlet weak var edit_quantidade_portas: UITextField!
    @IBOutlet weak var edit_quantidade_janelas: UITextField!
    @IBOutlet weak var edit_quantidade_interruptores: UITextField!
    
    @IBOutlet weak var botao_duplicar: UIButton!
    @IBOutlet weak var botao_cor: UIButton!
    @IBOutlet weak var botao_parede_avulsa: UIButton!
    @IBOutlet weak var botao_adicionar: UIButton!
    @IBOutlet weak var botao_excluir: UIButton!
    @IBOutlet weak var botao_teto_avulso: UIButton!
    @IBOutlet weak var botao_ambiente_completo: UIButton!
    
    @IBOutlet weak var constraint_altura_altura: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_largura: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_comprimento: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_portas: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_janelas: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_interruptores: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_painel_dados: NSLayoutConstraint!
    
    @IBOutlet weak var constraint_altura_botao_parede_avulsa: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_botao_teto_avulso: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_botao_ambiente_completo: NSLayoutConstraint!
    
    @IBOutlet weak var label_altura: UILabel!
    @IBOutlet weak var label_largura: UILabel!
    @IBOutlet weak var label_comprimento: UILabel!
    @IBOutlet weak var label_portas: UILabel!
    @IBOutlet weak var label_janelas: UILabel!
    @IBOutlet weak var label_interruptores: UILabel!
    
    var itemOrcamento: ItemOrcamentoComplexoDetalhe?
    var interacao: interacaoComplexaDetalhe?
    var interacaoNomeAmbiente: interacaoMudouNomeAmbiente?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let controles = [ edit_altura, edit_largura, edit_comprimento, edit_quantidade_portas, edit_quantidade_janelas, edit_quantidade_interruptores];
        
        for controle in controles {
            controle?.addTarget(self, action: #selector(textoMudou), for: UIControlEvents.editingChanged)
        }
        
        botao_parede_avulsa.titleLabel?.text = "Parede\nAvulsa"
        
        adicionaIconeTextoBotao(botao_duplicar, icone: FAIcon.FAIconCopy)
        adicionaIconeTextoBotao(botao_cor, icone: FAIcon.FAIconTint)
        adicionaIconeTextoBotao(botao_parede_avulsa, icone: FAIcon.FAIconPlusSquareO, linhas: 3)
        adicionaIconeTextoBotao(botao_teto_avulso, icone: FAIcon.FAIconPlusSquareO, linhas: 3)
        adicionaIconeTextoBotao(botao_ambiente_completo, icone: FAIcon.FAIconPlusSquareO, linhas: 3)
        adicionaIconeTextoBotao(botao_adicionar, icone: FAIcon.FAIconPlus)
        adicionaIconeTextoBotao(botao_excluir, icone: FAIcon.FAIconRemove)
        
        edit_altura.delegate = self
    }
    
    /*func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let texto = Mask.ajustaNumeroMascara(string, inicio: range.location, antes: 0, contagem: range.length)
        
        textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: texto)
        
        return true
    }*/
    
    
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
    
    func defineItemOrcamento(_ itemOrcamento: ItemOrcamentoComplexoDetalhe) {
        
        self.itemOrcamento = itemOrcamento
        
        edit_altura.text = itemOrcamento.altura
        edit_largura.text = itemOrcamento.largura
        edit_comprimento.text = itemOrcamento.comprimento
        edit_quantidade_portas.text = itemOrcamento.quantidadePortas
        edit_quantidade_janelas.text = itemOrcamento.quantidadeJanelas
        edit_quantidade_interruptores.text = itemOrcamento.quantidadeInterruptores
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func onDuplicar(_ sender: AnyObject) {
        
        self.interacao?(itemOrcamento, OpcoesSelecaoComplexa.duplicar);
    }
    
    @IBAction func onAdicionar(_ sender: AnyObject) {
        
        let itemOrcamentoComplexoDetalhe = itemOrcamento as ItemOrcamentoComplexoDetalhe?
        
        switch itemOrcamentoComplexoDetalhe!.tipoDetalheComplexo {

        case .Ambiente:
            self.interacao?(itemOrcamento, OpcoesSelecaoComplexa.adicionar);
            break
        case .ParedeAvulsa:
            self.interacao?(itemOrcamento, OpcoesSelecaoComplexa.paredeAvulsa);
            break
        case .TetoAvulso:
            self.interacao?(itemOrcamento, OpcoesSelecaoComplexa.tetoAvulso);
            break
        case .AmbienteCompleto:
            self.interacao?(itemOrcamento, OpcoesSelecaoComplexa.adicionarAmbienteCompleto);
            break
        }
    }
    
    @IBAction func onExcluir(_ sender: AnyObject) {
        
        self.interacao?(itemOrcamento, OpcoesSelecaoComplexa.excluir);
    }
    
    @IBAction func onSelecionarCor(_ sender: AnyObject) {
        
        self.interacao?(itemOrcamento, OpcoesSelecaoComplexa.selecionarCor);
    }
    
    @IBAction func onParedeAvulsa(_ sender: AnyObject) {
        
        self.interacao?(itemOrcamento, OpcoesSelecaoComplexa.paredeAvulsa);
    }

    @IBAction func onTetoAvulso(_ sender: AnyObject) {
        
        self.interacao?(itemOrcamento, OpcoesSelecaoComplexa.tetoAvulso);
    }

    @IBAction func onAmbienteCompleto(_ sender: AnyObject) {
        
        self.interacao?(itemOrcamento, OpcoesSelecaoComplexa.ambienteCompleto);
    }
    
    func textoMudou(_ sender: AnyObject) {
        
        if sender as! NSObject == self.edit_altura {
            
            edit_altura.text = Mask.ajustaNumeroMascara(edit_altura.text!, inicio: 0, antes: 0, contagem: 0)
            
            itemOrcamento?.altura = edit_altura.text
        }
        else if sender as! NSObject == self.edit_largura {

            edit_largura.text = Mask.ajustaNumeroMascara(edit_largura.text!, inicio: 0, antes: 0, contagem: 0)

            itemOrcamento?.largura = edit_largura.text
        }
        else if sender as! NSObject == self.edit_comprimento {
            
            edit_comprimento.text = Mask.ajustaNumeroMascara(edit_comprimento.text!, inicio: 0, antes: 0, contagem: 0)

            itemOrcamento?.comprimento = edit_comprimento.text
        }
        else if sender as! NSObject == self.edit_quantidade_portas {
            itemOrcamento?.quantidadePortas = edit_quantidade_portas.text
        }
        else if sender as! NSObject == self.edit_quantidade_janelas {
            itemOrcamento?.quantidadeJanelas = edit_quantidade_janelas.text
        }
        else if sender as! NSObject == self.edit_quantidade_interruptores {
            itemOrcamento?.quantidadeInterruptores = edit_quantidade_interruptores.text
        }
    }
    
    @IBAction func onMudarNomeAmbiente(_ sender: AnyObject) {
        
        let alert = UIAlertView(title: "Nome do ambiente", message: nil, delegate: self, cancelButtonTitle: "Fechar")
        
        alert.addButton(withTitle: "Alterar")
        
        alert.alertViewStyle = .plainTextInput
        
        let textField = alert.textField(at: 0)
        textField?.text = itemOrcamento?.texto()
        
        alert.show()
        
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {

        if buttonIndex != 1 {
            return
        }
        
        let textField = alertView.textField(at: 0)
     
        self.interacaoNomeAmbiente?(itemOrcamento, textField?.text)
    }
    
}
