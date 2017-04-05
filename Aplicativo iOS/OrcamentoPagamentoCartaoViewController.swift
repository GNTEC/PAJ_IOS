//
//  OrcamentoPagamentoCartaoViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 15/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

import UIKit
class OrcamentoPagamentoCartaoViewController: UIViewController {
    @IBOutlet weak var botao_continuar: UIButton!
    @IBOutlet weak var imagem_cifrao: UIImageView!
    @IBOutlet weak var imagem_nome: UIImageView!
    @IBOutlet weak var imagem_cartao: UIImageView!
    @IBOutlet weak var imagem_validade: UIImageView!
    @IBOutlet weak var imagem_cvv: UIImageView!
    @IBOutlet weak var label_valor_pagamento: UILabel!
    @IBOutlet weak var label_descricao_forma_pagamento: UILabel!
    @IBOutlet weak var edit_nome_cliente: UITextField!
    @IBOutlet weak var edit_numero_cartao: VSTextField!
    @IBOutlet weak var edit_validade: VSTextField!
    @IBOutlet weak var edit_cvv: UITextField!
    
    var contexto: ContextoAgendaCalendario?
    
    func defineContexto(_ contexto: ContextoAgendaCalendario?) {
        self.contexto = contexto
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imagem_nome.image = self.iconeBotao("user", cor: self.corCinzaBullet(), corFundo: self.corCinzaFundoBullet())
        self.imagem_cartao.image = self.iconeBotao("credit-card", cor: self.corCinzaBullet(), corFundo: self.corCinzaFundoBullet())
        self.imagem_validade.image = self.iconeBotao("calendar", cor: self.corCinzaBullet(), corFundo: self.corCinzaFundoBullet())
        self.imagem_cvv.image = self.iconeBotao("lock", cor: self.corCinzaBullet(), corFundo: self.corCinzaFundoBullet())
        self.imagem_cifrao.image = self.iconeBotao("usd", cor: UIColor.white, corFundo: self.corLaranja())
        botao_continuar.setImage(self.iconeBotao("check", cor: UIColor.white, corFundo: self.corLaranja()), for: UIControlState())
        
        var chave_texto: String? = nil
        
        switch(contexto!.tipoPagamento!) {
        case TipoPagamento.AVista:
            chave_texto = "literal_descricao_forma_pagamento_a_vista"
            contexto!.valorDebito = contexto!.valorPagamento * 0.95
            break
        case TipoPagamento.Parcelado:
            chave_texto = "literal_descricao_forma_pagamento_parcelado_\(contexto!.parcelas!)x"
            contexto!.valorDebito = contexto!.valorPagamento
            break
        case TipoPagamento.ComEntrada:
            chave_texto = "literal_descricao_forma_pagamento_com_entrada"
            contexto!.valorDebito = contexto!.valorPagamento * 0.15
            break
        default:
            contexto!.valorDebito = contexto!.valorPagamento
            break
        }
        
        label_descricao_forma_pagamento.text = obtemString(chave_texto!)
        label_valor_pagamento.text = Valor.floatParaMoedaString(contexto!.valorDebito)
        
        ////////////////////////////////////////////////////////////////////////
        
        edit_numero_cartao.setFormatting("####-####-####-####", replacementChar: "#")
        edit_validade.setFormatting("##/##", replacementChar: "#")
        
#if DEBUG
            
            edit_cvv.text = ("321");
            //pagamentoCartaoCreditoEntrada.setNomeCliente("FULANO DE TAL");
            edit_numero_cartao.text = ("5453010000083303");
            
            //edit_cvv.text = ("456");
            edit_nome_cliente.text = ("FULANO DE TAL");
            //edit_numero_cartao.text = ("4012001038166662");
            edit_validade.text = ("04/17");
#endif
        
        self.title = "Valor"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onContinuar(_ sender: AnyObject) {
        
        var mensagem: String? = nil
        
        if edit_cvv.text!.isEmpty {
            mensagem = "Campo CVV não pode ser vazio"
        }
        else if edit_cvv.text!.characters.count != 3 {
            mensagem = "Campo CVV deve conter 3 números"
        }
        
        var confere = false
        
        do {
            
            let patternValidade = try NSRegularExpression(pattern:"\\d{4}", options: NSRegularExpression.Options.caseInsensitive)
            
            let resultado = patternValidade.matches(in: edit_validade.text!, options: NSRegularExpression.MatchingOptions.anchored, range: NSMakeRange(0, edit_validade.text!.characters.count))
            
            confere = resultado.count != 0
        }
        catch {
            
        }
        
        if confere == false {
            mensagem = "Campo validade deve ser mm/aa"
        }
        
        if edit_validade.text!.isEmpty {
            mensagem = "Campo validade não pode ser vazio"
        }
        
        if edit_numero_cartao.text!.isEmpty {
            mensagem = "Campo número do cartão não pode ser vazio"
        }
        else if edit_numero_cartao.text!.characters.count != 16 {
            mensagem = "Campo número do cartão deve conter 16 números"
        }

        
        if edit_nome_cliente.text!.isEmpty {
            mensagem = "Campo nome não pode ser vazio"
        }

        if mensagem != nil {
            AvisoProcessamento.mensagemErroGenerico(mensagem)
            return
        }
        
        prossegueConfirmacaoFinal()
    }
    
    func prossegueConfirmacaoFinal() {
        
        contexto!.cartao = edit_numero_cartao.text?.replacingOccurrences(of: "-", with: "")
        contexto!.cvv = edit_cvv.text
        let indice = edit_validade.text!.characters.index(edit_validade.text!.startIndex, offsetBy: 2)
        contexto!.mes = edit_validade.text!.substring(to: indice)
        contexto!.ano = edit_validade.text!.substring(from: indice)

        //contexto!.ano = edit_validade.text!.substring(from: <#T##String.CharacterView corresponding to `indice`##String.CharacterView#>.index(indice, offsetBy: 1))
        contexto!.nome = edit_nome_cliente.text
        contexto!.descricao = "Pgto do orçamento \(contexto!.id_orcamento)"
        
        self.performSegue(withIdentifier: "SeguePagamentoCartaoParaFinalizar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SeguePagamentoCartaoParaFinalizar" {
            
            let vc = segue.destination as! OrcamentoFinalizarViewController
            
            vc.defineContexto(contexto)
        }
    }
}

/*
 
 //let subAlert = UIAlertView(title: "", message: "Pagamento recebido!", delegate: self, cancelButtonTitle: "Ir para Agendamento")
 //subAlert.show()

 //if(buttonIndex == 1) {
 let storyboard = UIStoryboard(name: "Agenda", bundle: nil)
 let controller = storyboard.instantiateInitialViewController()
 //[self presentViewController:controller animated:TRUE completion:nil];
 self.navigationController!.pushViewController(controller!, animated: true)
 // }
 func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
 }
 
 
 */
