//
//  OrcamentoFinalizarViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 15/09/16.
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


enum PassosFinalizacao : String {
    case IncluirOrcamento
    case IncluirAgendamento
    case EfetivarPagamentoCartaoCredito
    case RefazerOrcamento
    case EfetivarPagamentoDinheiroMaquina
    case EfetivarPagamentoMaquina
}

class OrcamentoFinalizarViewController : UIViewController {
    
    @IBOutlet weak var label_nome: UITextField!
    @IBOutlet weak var label_email: UITextField!
    @IBOutlet weak var label_telefone: UITextField!
    @IBOutlet weak var label_celular: UITextField!
    @IBOutlet weak var label_logradouro: UITextField!
    @IBOutlet weak var label_numero: UITextField!
    @IBOutlet weak var label_complemento: UITextField!
    @IBOutlet weak var label_cidade: UITextField!
    @IBOutlet weak var label_bairro: UITextField!
    @IBOutlet weak var label_uf: UITextField!
    @IBOutlet weak var label_cep: UITextField!
    @IBOutlet weak var label_data_agendamento: UITextField!
    @IBOutlet weak var label_tempo_servico: UITextField!
    @IBOutlet weak var label_horario: UITextField!
    @IBOutlet weak var label_pagamento: UITextField!
    @IBOutlet weak var label_final_cartao: UITextField!
    @IBOutlet weak var label_valor_total: UITextField!
    @IBOutlet weak var label_valor_parcela: UITextField!
    @IBOutlet weak var botao_confirma_informacoes: UIButton!
    @IBOutlet weak var constraint_altura_label_horario: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_label_conteudo_horario: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_label_final_cartao: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_label_conteudo_final_cartao: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_label_valor_parcela: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_label_conteudo_valor_parcela: NSLayoutConstraint!
    @IBOutlet weak var constraint_espaco_label_final_cartao: NSLayoutConstraint!
    @IBOutlet weak var constraint_espaco_label_conteudo_final_cartao: NSLayoutConstraint!
    @IBOutlet weak var constraint_espaco_label_valor_parcela: NSLayoutConstraint!
    
    var passosFinalizacao: NSMutableArray?
    var imagemCheckMarcado: UIImage!
    var imagemCheckDesmarcado: UIImage!

    var contexto: ContextoAgendaCalendario?
    
    func defineContexto(_ contexto: ContextoAgendaCalendario?) {
        self.contexto = contexto
    }
    
    @IBAction func onConfirmar(_ sender: AnyObject) {
        
        if !botao_confirma_informacoes.isSelected {
            AvisoProcessamento.mensagemErroGenerico("É necessário marcar que confirma as informações")
            return
        }
        
        let orcamento = Orcamento.obtemOrcamento()
        
        // 3 situações:
        
        // 1 - vindo de um novo orçamento, deve: incluir orçamento, agendamento e efetivar pagamento
        // 2 - vindo de um orçamento salvo, deve: incluir agendamento e efetivar pagamento
        // 3 - vindo de refazer orçamento, deve: incluir o novo orçamento, refazer o novo pelo velho, e efetivar pagamento
        
        passosFinalizacao = NSMutableArray()
        
        if contexto?.id_orcamento_inicial != nil {
            
            // item 3 refazer
            passosFinalizacao?.add(PassosFinalizacao.IncluirOrcamento.rawValue)
            passosFinalizacao?.add(PassosFinalizacao.RefazerOrcamento.rawValue)
            
            if contexto?.tipoMeioPagamento == TipoMeioPagamento.CartaoCredito {
                passosFinalizacao?.add(PassosFinalizacao.EfetivarPagamentoCartaoCredito.rawValue)
            }
            else {
                passosFinalizacao?.add(PassosFinalizacao.EfetivarPagamentoDinheiroMaquina.rawValue)
            }
        }
        else {
            
            if (orcamento!.id == 0) {
                
                if orcamento!.id_cliente == 0 {
                    orcamento!.id_cliente = contexto!.id_cliente!
                }
                
                passosFinalizacao?.add(PassosFinalizacao.IncluirOrcamento.rawValue);
                passosFinalizacao?.add(PassosFinalizacao.IncluirAgendamento.rawValue);
                
                if(contexto?.tipoMeioPagamento == TipoMeioPagamento.CartaoCredito) {
                    passosFinalizacao?.add(PassosFinalizacao.EfetivarPagamentoCartaoCredito.rawValue);
                }
                else {
                    passosFinalizacao?.add(PassosFinalizacao.EfetivarPagamentoDinheiroMaquina.rawValue);
                }
                
            } else {
              
                // Efetivando um orçamento salvo....
                
                contexto!.id_orcamento = orcamento!.id
                
                if contexto?.id_orcamento_editar != nil {
                    passosFinalizacao?.add(PassosFinalizacao.IncluirOrcamento.rawValue)
                }
                
                ///////////////////////////////////////////////////////////////////////////////////////////
                
                passosFinalizacao?.add(PassosFinalizacao.IncluirAgendamento.rawValue);
                
                if (contexto!.tipoMeioPagamento == TipoMeioPagamento.CartaoCredito) {
                    passosFinalizacao!.add(PassosFinalizacao.EfetivarPagamentoCartaoCredito.rawValue);
                }
                else {
                    passosFinalizacao!.add(PassosFinalizacao.EfetivarPagamentoDinheiroMaquina.rawValue);
                }
            }
            
            ///////////////////////////////////////////////////////////////////////////////////////////
        }
        
        executaProximoPasso()
    }
    
    func executaProximoPasso() {
        
        let proximoPasso = PassosFinalizacao(rawValue:passosFinalizacao!.object(at: 0) as! String)
        passosFinalizacao!.removeObject(at: 0)
        
        if(proximoPasso == PassosFinalizacao.IncluirOrcamento) {
            persisteOrcamento();
        }
        else if(proximoPasso == PassosFinalizacao.IncluirAgendamento) {
            efetivaAgendamento();
        }
        else if(proximoPasso == PassosFinalizacao.EfetivarPagamentoCartaoCredito) {
            efetivaPagamento();
        }
        else if(proximoPasso == PassosFinalizacao.RefazerOrcamento) {
            refazOrcamento();
        }
        else if (proximoPasso == PassosFinalizacao.EfetivarPagamentoDinheiroMaquina) {
            efetivaPagamentoDinheiroMaquina();
        }
        else if (proximoPasso == PassosFinalizacao.EfetivarPagamentoMaquina) {
            efetivaPagamentoMaquina();
        }
    }
    
    func refazOrcamento() {
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_orcamento_1" : "\(contexto!.id_orcamento_inicial!)" as AnyObject,
            "id_orcamento_2" : "\(contexto!.id_orcamento)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.orcamento(self.navigationController!.view, tipo: "refazer", parametros: parametros) { (objeto) -> Bool in
            self.executaProximoPasso()
            
            return true
        }
    }
    
    func persisteOrcamento() -> Bool {
        
        let franqueado = PinturaAJatoApi.obtemFranqueado()
        
        var jsonObject = Orcamento.obtemOrcamento()?.gerarConteudoApiInsercao(franqueado!.id_franquia)
        
        if jsonObject == nil {
            
            AvisoProcessamento.mensagemErroGenerico("Falha gerando o orçamento. Entre em contato com o suporte.")
            
            return false
        }
        
        let api = PinturaAJatoApi()
        
        let sucesso = { (objeto: OrcamentoGerado?, resultado: Bool) -> Bool in
            
            self.contexto!.id_orcamento = objeto!.id
            
            self.executaProximoPasso()
            
            return true
        }
        
        if contexto?.id_orcamento_editar != nil {
            
            jsonObject!["id_orcamento"] = contexto!.id_orcamento_editar! as AnyObject?
            
            api.editarOrcamentoApp(self.navigationController!.view, parametros: jsonObject!, sucesso: sucesso)
        }
        else {
            api.incluirOrcamento(self.navigationController!.view, parametros: jsonObject!, sucesso: sucesso)
        }
        
        return true
    }
    
    func efetivaAgendamento() {
        
        // Não tem informação de agendamento, vai para o próximo passo
        if contexto?.data_inicial == nil {
            executaProximoPasso()
            return
        }
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_franquia" : "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
            "dias" : "\(contexto!.diasServico)" as AnyObject,
            "data_inicial" : contexto!.data_inicial! as AnyObject,
            "id_orcamento" : "\(contexto!.id_orcamento)" as AnyObject,
            "horario_inicio" : contexto!.horario_inicio! as AnyObject,
            "descricao" : "descricao" as AnyObject
        ]
        
        api.incluirAgendaOrcamento(self.navigationController!.view, parametros: parametros, sucesso: { (resultado: Resultado?) -> Bool in
            self.executaProximoPasso()
            return true
        })
    }
    
    func efetivaPagamento() {
        
        let api = PinturaAJatoApi()
        
        var parametros = [String:AnyObject]()
        parametros["id_franquia"] = "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject
        parametros["id_sessao"] = PinturaAJatoApi.obtemIdSessao() as AnyObject
        parametros["id_orcamento"] = "\(contexto!.id_orcamento)" as AnyObject
        parametros["id_cliente"] = "\(contexto!.id_cliente!)" as AnyObject
        parametros["valor"] = Valor.floatParaStringValor(contexto!.valorDebito) as AnyObject
        parametros["cartao"] = contexto!.cartao! as AnyObject
        parametros["cvv"] = contexto!.cvv! as AnyObject
        parametros["mes"] = contexto!.mes! as AnyObject
        parametros["ano"] = "20" + contexto!.ano! as AnyObject
        parametros["nome"] = contexto!.nome! as AnyObject
        parametros["tipo_pagamento"] = contexto!.tipoPagamento == TipoPagamento.AVista ? "SGL" as AnyObject : "ISS" as AnyObject
        parametros["parcelas"] = "\(contexto!.parcelas!)" as AnyObject
        parametros["descricao"] = contexto!.descricao! as AnyObject
        parametros["forma_de_pagamento"] = contexto!.tipoPagamento!.rawValue as AnyObject
        parametros["meio_de_pagamento"] = TipoMeioPagamento.CartaoCredito.rawValue as AnyObject
        parametros["numero_parcelas"] = "\(contexto!.parcelas!)" as AnyObject
        parametros["valor_parcelas"] = Valor.floatParaStringValor(contexto!.valorParcela) as AnyObject
        parametros["status_pagamento"] =  contexto!.tipoPagamento == TipoPagamento.ComEntrada ? "2" as AnyObject : "1" as AnyObject
        parametros["valor_bruto"] = Valor.floatParaStringValor(contexto!.valorPagamento) as AnyObject
        parametros["valor_residual"] = (contexto!.tipoPagamento == TipoPagamento.ComEntrada ? Valor.floatParaStringValor(contexto!.valorPagamento - contexto!.valorDebito) : "") as AnyObject
        parametros["dias_servico"] = "\(contexto!.diasServico)" as AnyObject
        
        api.getNet(self.navigationController!.view, tipo: "pagamento", parametros: parametros, sucesso: { (objeto: PedidoGetNet?, resultado: Resultado?) -> Bool in
            
            if resultado!.erro {
                
                AvisoProcessamento.mensagemErroGenerico(resultado?.mensagem)
                
                return false
            }
            else {
                
                if objeto!.descriptionResponse == "NOT APPROVED" {
                    
                    AvisoProcessamento.mensagemErroGenerico("Pagamento não aprovado.", mensagemTecnica: objeto?.descriptionResponse)
                    
                    return false
                }
                
                let id = self.contexto!.id_orcamento
                
                Orcamento.limpaOrcamento()
                
                AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: String(format: "Pedido #%06d incluído", id), destino: {
                    
                    self.prossegueHistorico()
                })
            }
            
            return true
        })
    }
    
    func efetivaPagamentoMaquina() {
        
        let api = PinturaAJatoApi()
        
        var parametros = [String:AnyObject]()
        parametros["id_franquia"] = "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject
        parametros["id_sessao"] = PinturaAJatoApi.obtemIdSessao() as AnyObject
        parametros["id_orcamento"] = "\(contexto!.id_orcamento)" as AnyObject
        parametros["id_cliente"] = "\(contexto!.id_cliente!)" as AnyObject
        parametros["valor"] = Valor.floatParaStringValor(contexto!.valorDebito) as AnyObject
        parametros["cartao"] = contexto!.cartao! as AnyObject
        parametros["cvv"] = contexto!.cvv! as AnyObject
        parametros["mes"] = contexto!.mes! as AnyObject
        parametros["ano"] = "20" + contexto!.ano! as AnyObject
        parametros["nome"] = contexto!.nome! as AnyObject
        parametros["tipo_pagamento"] = contexto!.tipoPagamento == TipoPagamento.AVista ? "SGL" as AnyObject : "ISS" as AnyObject
        parametros["parcelas"] = "\(contexto!.parcelas!)" as AnyObject
        parametros["descricao"] = contexto!.descricao! as AnyObject
        parametros["forma_de_pagamento"] = contexto!.tipoPagamento!.rawValue as AnyObject
        parametros["meio_de_pagamento"] = TipoMeioPagamento.CartaoCredito.rawValue as AnyObject
        parametros["numero_parcelas"] = "\(contexto!.parcelas!)" as AnyObject
        parametros["valor_parcelas"] = Valor.floatParaStringValor(contexto!.valorParcela) as AnyObject
        parametros["status_pagamento"] =  contexto!.tipoPagamento == TipoPagamento.ComEntrada ? "2" as AnyObject : "1" as AnyObject
        parametros["valor_bruto"] = Valor.floatParaStringValor(contexto!.valorPagamento) as AnyObject
        parametros["valor_residual"] = (contexto!.tipoPagamento == TipoPagamento.ComEntrada ? Valor.floatParaStringValor(contexto!.valorPagamento - contexto!.valorDebito) : "") as AnyObject
        parametros["dias_servico"] = "\(contexto!.diasServico)" as AnyObject
        
        api.getNet(self.navigationController!.view, tipo: "pagamento", parametros: parametros, sucesso: { (objeto: PedidoGetNet?, resultado: Resultado?) -> Bool in
            
            if resultado!.erro {
                
                AvisoProcessamento.mensagemErroGenerico(resultado?.mensagem)
                
                return false
            }
            else {
                
                if objeto!.descriptionResponse == "NOT APPROVED" {
                    
                    AvisoProcessamento.mensagemErroGenerico("Pagamento não aprovado.", mensagemTecnica: objeto?.descriptionResponse)
                    
                    return false
                }
                
                let id = self.contexto!.id_orcamento
                
                Orcamento.limpaOrcamento()
                
                AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: String(format: "Pedido #%06d incluído", id), destino: {
                    
                    self.prossegueHistorico()
                })
            }
            
            return true
        })
    }

    func efetivaPagamentoDinheiroMaquina() {
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_franquia" : "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
            "id_orcamento" : "\(contexto!.id_orcamento)" as AnyObject,
            "id_cliente" : "\(contexto!.id_cliente!)" as AnyObject,
            "valor" : Valor.floatParaStringValor(contexto!.valorPagamento) as AnyObject,
            "descricao" : "" as AnyObject,
            
            "forma_de_pagamento" : contexto!.tipoPagamento!.rawValue as AnyObject,
            "meio_de_pagamento" : TipoMeioPagamento.Dinheiro.rawValue as AnyObject,
            "numero_parcelas" : "1" as AnyObject,
            "valor_parcelas" : "0.0" as AnyObject,
            "status_pagamento" : "1" as AnyObject,
            "valor_bruto" : Valor.floatParaStringValor(contexto!.valorPagamento) as AnyObject,
            "valor_residual" : "0.0" as AnyObject,
            "dias_servico" : "\(contexto!.diasServico)" as AnyObject
        ]
        
        api.pagamento(self.navigationController!.view, tipo: "dinheiro", parametros: parametros, sucesso: { (resultado: Resultado?) -> Bool in
            
            let id = self.contexto!.id_orcamento

            Orcamento.limpaOrcamento()
            
            AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: String(format: "Pedido #%06d incluído", id), destino: {
                
                self.prossegueHistorico()
                
            })
            
            return true
        })
        
    }
    
    func prossegueHistorico() {
        
        var vc_inicio: UIViewController? = nil
        
        for vc in self.navigationController!.viewControllers {
            if vc is DrawerViewController {
                vc_inicio = vc
                break
            }
        }
     
        if vc_inicio == nil {
            return
        }
        
        let nvc = self.navigationController
        
        self.navigationController!.popToViewController(vc_inicio!, animated: false)
        
        let storyboard = UIStoryboard(name: "Historico", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        
        nvc!.pushViewController(controller!, animated: true)
    }
    
    @IBAction func onConfirmoInformacoes(_ sender: AnyObject) {
        
        let botao = sender as! UIButton
        
        botao.isSelected = !botao.isSelected
    }
    
    override func viewDidLoad() {
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id" : "\(contexto!.id_cliente!)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        contexto!.valorParcela = (contexto!.parcelas! > 1) ? (contexto!.valorDebito / (Float)(contexto!.parcelas!)) : 0.0;

        var detalhe = ""
        
        switch contexto!.tipoMeioPagamento! {
        case TipoMeioPagamento.CartaoCredito:
            detalhe += "Cartão de Crédito, ";
            break
        case TipoMeioPagamento.Dinheiro:
            detalhe += "Dinheiro, "
            break
        case TipoMeioPagamento.CartaoCreditoMaquina:
            detalhe += "Cartão de Crédito por máquina, "
            break
        }
        
        if contexto!.parcelas == 1 {
            detalhe += "à vista"
        }
        else {
            detalhe += "parcelado em \(contexto!.parcelas)x"
        }
        
        label_pagamento.text = detalhe
        label_final_cartao.text = contexto!.cartao?.substring(from: contexto!.cartao!.characters.index(contexto!.cartao!.endIndex, offsetBy: -4))
        label_valor_total.text = Valor.floatParaMoedaString(contexto!.valorPagamento)
        label_valor_parcela.text = Valor.floatParaStringValor(contexto!.valorParcela)
        
        imagemCheckMarcado = self.iconeListaPequeno("check", cor: self.corCinzaBullet(), corFundo: UIColor.clear)
        imagemCheckDesmarcado = self.iconeListaPequeno("unchecked", cor: self.corCinzaBullet(), corFundo: UIColor.clear)

        botao_confirma_informacoes.setImage(imagemCheckDesmarcado, for:UIControlState())
        botao_confirma_informacoes.setImage(imagemCheckMarcado, for:UIControlState.selected)
        
        label_data_agendamento.text = contexto?.data_inicial
        label_horario.text = contexto?.horario_inicio
        label_tempo_servico.text = "\(contexto!.diasServico) dia(s)"
        
        if contexto?.horario_inicio == nil {
            constraint_altura_label_horario.constant = 0
            constraint_altura_label_conteudo_horario.constant = 0
        }
        if contexto?.tipoMeioPagamento != TipoMeioPagamento.CartaoCredito {
            constraint_altura_label_final_cartao.constant = 0
            constraint_altura_label_conteudo_final_cartao.constant = 0
            constraint_espaco_label_final_cartao.constant = 0
            constraint_espaco_label_conteudo_final_cartao.constant = 0
        }
        if contexto?.valorParcela == 0.0 {
            constraint_altura_label_valor_parcela.constant = 0
            constraint_altura_label_conteudo_valor_parcela.constant = 0
            constraint_espaco_label_valor_parcela.constant = 0
        }
        
        api.buscarClienteCadastroCompletoPorId(self.navigationController!.view, parametros: parametros) { (objeto, resultado) -> Bool in
            
            self.label_nome.text = objeto?.nome
            self.label_email.text = objeto?.email
            self.label_telefone.text = objeto?.telefone
            self.label_celular.text = objeto?.celular
            self.label_logradouro.text = objeto?.logradouro
            self.label_numero.text = objeto?.numero
            self.label_complemento.text = objeto?.complemento
            self.label_cidade.text = objeto?.cidade
            self.label_bairro.text = objeto?.bairro
            self.label_uf.text = objeto?.uf
            self.label_cep.text = objeto?.cep
            
            // Recupera o agendamento do orçamento inicial
            if self.contexto!.id_orcamento_inicial != nil {
                
                let parametros_pedido : [String:AnyObject] = [
                    "id_orcamento" : "\(self.contexto!.id_orcamento_inicial!)" as AnyObject,
                    "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
                ]
                
                api.buscarPedido(self.navigationController!.view, parametros: parametros_pedido, sucesso: { (objeto:PedidoConsultaSaida?, resultado: Bool) -> Bool in
                    
                    if objeto?.agenda?.count > 0 {
                        
                        self.label_data_agendamento.text = Data.dateParaStringDD_MM_AAAA(objeto!.agenda![0].data())
                        self.label_tempo_servico.text = "\(objeto!.agenda!.count) dia(s)"
                        self.label_horario.text = objeto!.agenda![0].periodo_agenda
                    }
                    
                    return true
                })
            }
            
            return true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
