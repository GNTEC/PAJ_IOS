//
//  OrcamentoCadastroCompletoViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 14/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class OrcamentoCadastroCompletoViewController : UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var label_nome: UITextField!
    @IBOutlet weak var label_email: UITextField!
    @IBOutlet weak var label_telefone: UITextField!
    @IBOutlet weak var edit_celular: VSTextField!
    @IBOutlet weak var edit_cpf: VSTextField!
    @IBOutlet weak var edit_rg: UITextField!
    @IBOutlet weak var label_logradouro: UITextField!
    @IBOutlet weak var edit_numero: UITextField!
    @IBOutlet weak var edit_complemento: UITextField!
    @IBOutlet weak var label_cidade: UITextField!
    @IBOutlet weak var label_bairo: UITextField!
    @IBOutlet weak var label_uf: UITextField!
    @IBOutlet weak var label_cep: UITextField!
    @IBOutlet weak var botao_continuar: UIButton!
    
    var contexto: ContextoOrcamento?
    var contexto_agendamento: ContextoAgendaCalendario?
    var cliente: Cliente?
    
    func defineContexto(_ contexto: ContextoOrcamento?) {
        self.contexto = contexto
    }
    
    @IBAction func onContinuar(_ sender: AnyObject) {
        
        let celular = edit_celular.text
        let cpf = edit_cpf.text
        
        var mensagem: String = ""
        
        if celular?.characters.count > 0 {
            if !Validacoes.isTelefone(celular) {
                mensagem += "Celular digitado incorretamente"
            }
        }
        
        if (cpf?.characters.count > 0) {
            
            let cpfa = cpf!.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "-", with: "")
            
            if !Validacoes.isCPF(cpfa) {
                mensagem += "CPF incorreto";
            }
            
        } else {
            mensagem += "O campo CPF é obrigatório";
        }

        
        if mensagem.characters.count > 0 {
            
            AvisoProcessamento.mensagemErroGenerico(mensagem)
            return
        }
        
        ////////////////////////////////////////////////////////////////////////
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id" : "\(cliente!.id)" as AnyObject,
            "id_franquia": "\(cliente!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
            "id_usuario": "\(cliente!.id_usuario)" as AnyObject,
            "id_endereco": "\(cliente!.id_endereco)" as AnyObject,
            "nome": cliente!.nome! as AnyObject,
            "email": cliente!.email! as AnyObject,
            "telefone": cliente!.telefone! as AnyObject,
            "celular": celular! as AnyObject,
            "cpf": cpf! as AnyObject,
            "rg": edit_rg.text! as AnyObject,
            "logradouro": cliente!.logradouro! as AnyObject,
            "numero": edit_numero.text! as AnyObject,
            "complemento": edit_complemento.text! as AnyObject,
            "bairro": cliente!.bairro! as AnyObject,
            "cidade": cliente!.cidade! as AnyObject,
            "uf": cliente!.uf! as AnyObject,
            "cep": cliente!.cep! as AnyObject
        ]
        
        api.editarClienteCadastroCompletoPorId(self.navigationController!.view, parametros: parametros, sucesso: { (objeto: Resultado?) -> Bool in
            self.prossegueParaAgendamento();
            return true
        })
        
    }
        
    func prossegueParaAgendamento() {
        
        contexto_agendamento = ContextoAgendaCalendario()
        
        contexto_agendamento!.modoSelecaoDataAtualFutura = true
        contexto_agendamento!.diasServico = (contexto?.diasServico)!
        contexto_agendamento!.valorPagamento = (contexto?.valorPagamento)!
        contexto_agendamento!.tipoPagamento = contexto?.tipoPagamento
        contexto_agendamento?.tipoMeioPagamento = contexto?.tipoMeioPagamento
        contexto_agendamento?.parcelas = contexto?.parcelas
        contexto_agendamento!.id_cliente = contexto?.id_cliente
        contexto_agendamento?.id_orcamento_inicial = contexto?.id_orcamento_inicial
        
        let storyboard = UIStoryboard(name: "Agenda", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "AgendaCalendarioViewController") as! AgendaCalendarioViewController
        
        vc.defineContexto(contexto_agendamento!)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        
        botao_continuar.setImage(self.iconeBotao("signin", cor: UIColor.white, corFundo: UIColor.clear), for: UIControlState())

        let api = PinturaAJatoApi()
        
        let parametros: [String: AnyObject] = [
            "id" : "\(contexto!.id_cliente)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        edit_celular.setFormatting("(##)#####-####", replacementChar: "#")
        edit_cpf.setFormatting("###.###.###-##", replacementChar: "#")
        
        api.buscarClienteCadastroCompletoPorId(self.navigationController!.view, parametros: parametros, sucesso: { (objeto: Cliente?, resultado: Bool) -> Bool in
        
            self.label_nome.text = objeto?.nome
            self.label_email.text = objeto?.email
            self.label_telefone.text = objeto?.telefone
            self.edit_celular.text = objeto?.celular
            self.edit_cpf.text = objeto?.cpf
            self.edit_rg.text = objeto?.rg
            self.label_logradouro.text = objeto?.logradouro
            self.edit_numero.text = objeto?.numero
            self.edit_complemento.text = objeto?.complemento
            self.label_bairo.text = objeto?.bairro
            self.label_cidade.text = objeto?.cidade
            self.label_uf.text = objeto?.uf
            self.label_cep.text = objeto?.cep
        
            self.cliente = objeto
            
            return true
        })
        
        let tapGestureRecognizer : UIGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(tapReceived))
        tapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    func tapReceived(_ tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
