//
//  OrcamentoConfirmacaoViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

enum OpcaoConfirmacao {
    case aprovar
    case salvar
    case enviarEmail
    case nenhuma
}

class EscolhaPagamento {
    var leuOTermo: Bool = false
    var formaPagamento: TipoPagamento = TipoPagamento.AVista
    var meioPagamento: TipoMeioPagamento = TipoMeioPagamento.CartaoCredito
    var parcelas: Int = 1
}

class OrcamentoConfirmacaoViewController : UITableViewController, NotificaOrcamentoMudou {
    var itensOrcamento = [AnyObject]()
    //var imagemCheckVerde: UIImage!
    //var imagemRemoveVermelho: UIImage!
    //var imagemCheckCinza: UIImage!
    //var imagemRemoveCinza: UIImage!
    //var imagemContinuar: UIImage!
    var imagemMais: UIImage!
    var imagemMenos: UIImage!
    var imagemCheckMarcado: UIImage!
    var imagemCheckDesmarcado: UIImage!
    
    var botao_editar_orcamento: UIBarButtonItem!

    
    var itemOrcamentoConclusao: ItemOrcamentoConclusao?
    var contadorZebrado: Int = 0
    var mOrcamento: Orcamento?
    
    var contexto: ContextoOrcamento?
    var contexto_agendamento: ContextoAgendaCalendario?
    
    var escolhaPagamento: EscolhaPagamento = EscolhaPagamento()
    
    var opcaoConfirmacao: OpcaoConfirmacao = OpcaoConfirmacao.nenhuma
    
    func defineContexto(_ contexto: ContextoOrcamento?) {
        self.contexto = contexto
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        //imagemContinuar = self.iconeBotao("signin", cor: UIColor.whiteColor(), corFundo: self.corLaranja())
        //imagemCheckVerde = self.iconeBotao("ok", cor: UIColor.whiteColor(), corFundo: self.corVerdeCheck())
        //imagemCheckCinza = self.iconeBotao("ok", cor: UIColor.whiteColor(), corFundo: self.corCinzaFundoBullet())
        //imagemRemoveVermelho = self.iconeBotao("remove", cor: UIColor.whiteColor(), corFundo: self.corVermelhoRemove())
        //imagemRemoveCinza = self.iconeBotao("remove", cor: UIColor.whiteColor(), corFundo: self.corCinzaFundoBullet())
        
        imagemMais = self.iconeBotao("plus", cor: self.corLaranja(), corFundo: self.corCinzaPainel())
        imagemMenos = self.iconeBotao("minus", cor: self.corLaranja(), corFundo: self.corCinzaPainel())

        imagemCheckMarcado = self.iconeListaPequeno("check", cor: self.corCinzaBullet(), corFundo: UIColor.clear)
        imagemCheckDesmarcado = self.iconeListaPequeno("unchecked", cor: self.corCinzaBullet(), corFundo: UIColor.clear)
        
        if (contexto != nil) {
            
            
            if contexto?.id_orcamento_inicial != nil {

                Registro.registraInformacao("id_orcamento_inicial", valor: contexto!.id_orcamento_inicial)
                
                let api = PinturaAJatoApi()
                
                let parametros: [String:AnyObject] = [
                    "id_orcamento" : "\(contexto!.id_orcamento_inicial!)" as AnyObject,
                    "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
                ]
                
                Registro.registraInformacao(.idOrcamento, valor: Int32(contexto!.id_orcamento_inicial!))
                
                api.buscarOrcamentoPorId(self.navigationController!.view, parametros: parametros, sucesso: { (objeto, falha) -> Bool in
                    
                    self.contexto?.valor_orcamento_inicial = Float(objeto?.orcamento?.valor_bruto == nil ? objeto!.orcamento!.valor! : objeto!.orcamento!.valor_bruto!)
                    self.contexto?.valor_pago_inicial = Float(objeto!.orcamento!.valor!)
                    
                    self.processaOrcamento()
                    
                    self.tableView.reloadData()
                    
                    return true
                })
                
            }
            else {
                processaOrcamento()
            }
            
        }
        
        // não é novo orçamento, nem está refazendo, é um orçamento salvo
        if (mOrcamento != nil && mOrcamento?.id != 0) && contexto?.id_orcamento_inicial == nil && contexto?.id_orcamento_editar == nil {
            
            botao_editar_orcamento = UIBarButtonItem(image: UIImage(named: "ic_mode_edit_white_24dp"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(prossegueEditarOrcamento))
            
            self.navigationItem.rightBarButtonItems = [botao_editar_orcamento]
        }

    }
    
    func prossegueEditarOrcamento(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
        self.performSegue(withIdentifier: "SegueOrcamentoConfirmacaoParaPrincipal", sender: self)
        
    }
    
    func processaOrcamento() {
        
        Registro.registraInformacao("id_cliente", valor: contexto!.id_cliente)

        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id": "\(contexto!.id_cliente)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ];

        self.mOrcamento = Orcamento.obtemOrcamento()
        
        api.buscarClienteCadastroCompletoPorId(self.navigationController!.view, parametros: parametros) { (objeto, resultado) -> Bool in

            DispatchQueue.main.async(execute: { 

                self.itensOrcamento.append(objeto!)
                
                let parametros_calculo = self.mOrcamento?.gerarConteudoApiInsercao(PinturaAJatoApi.obtemFranqueado()!.id_franquia)
                
                api.orcamentoCalculoApp(self.navigationController!.view, parametros: parametros_calculo!, sucesso: { (objeto, resultado) -> Bool in

                    self.contadorZebrado = -1
                    
                    if ( objeto == nil ) {
                        self.prossegueErroCalculo(nil);
                        return false
                    }
                    
                    if resultado?.erro == true {
                        
                        self.prossegueErroCalculo(resultado?.mensagem);
                        
                        return false
                    }
                    
                    let resultadoCalculo = self.mOrcamento?.atualizaResultadoCalculo(objeto!)
                    
                    self.mOrcamento!.rechamaNotificacoes(self, resultadoCalculo: resultadoCalculo)
                    
                    self.tableView.reloadData()

                    return true
                })
            })
            
            return true
        }
        
    }
    
    func prossegueErroCalculo(_ mensagem: String?) {
        
        var texto = mensagem
        
        Registro.registraErro("Erro durante o cálculo.");
        
        if texto == nil {
            texto = "Erro durante o cálculo. Entre em contato com o suporte";
        }
        
        DispatchQueue.main.async(execute: {
            AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: texto, destino:  { () -> Void in
                self.navigationController?.popViewController(animated: true);                
            })
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itensOrcamento.count
    }
    
    func obtemTipoCelula(_ tipo: TipoItem) -> String? {
        
        var id_celula: String? = nil
        
        switch tipo {
        case TipoItem.complexo:
            id_celula = "CelulaComplexaOrcamentoConfirmacaoTableViewCell"
            break
        case TipoItem.complexoDetalhe:
            id_celula = "CelulaComplexaOrcamentoConfirmacaoAmbienteTableViewCell"
            break
        case TipoItem.conclusao:
            id_celula = "CelulaConclusaoOrcamentoConfirmacaoTableViewCell"
            break
        case TipoItem.simples:
            id_celula = "CelulaSimplesOrcamentoConfirmacaoTableViewCell"
            break
        case TipoItem.trinca:
            id_celula = "CelulaTrincaOrcamentoConfirmacaoTableViewCell"
            break
        case TipoItem.trincaDetalhe:
            //id_celula = "CelulaSimplesOrcamentoConfirmacaoPinturaTableViewCell"
            break
        }
        
        return id_celula
    }
    
    func corZebradoAtual() -> UIColor {
        return  (contadorZebrado % 2 == 0) ? corZebradoPar() : corZebradoImpar();
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dados = itensOrcamento[indexPath.item]
        var cell: UITableViewCell
        
        if dados is ItemOrcamento {

            let itemOrcamento = dados as! ItemOrcamento
            
            if (itemOrcamento.tipo != TipoItem.complexoDetalhe && itemOrcamento.tipo != TipoItem.complexo) {
                contadorZebrado += 1;
            }
            
            let corFundo = corZebradoAtual();

            let id_celula = obtemTipoCelula(itemOrcamento.tipo)
            
            cell = tableView.dequeueReusableCell(withIdentifier: id_celula!, for: indexPath)
            
            cell.backgroundColor = corFundo
            
            switch itemOrcamento.tipo {
            case TipoItem.simples:
                let itemSimples = (dados as! ItemOrcamentoSimples)
                let cell_s = (cell as! CelulaSimplesOrcamentoConfirmacaoTableViewCell)
                cell_s.indice.text = String(format:"%d", itemSimples.sequencia)
                cell_s.descricao.text = obtemString(itemSimples.textoSelecao())
                break
            case TipoItem.complexo:
                let itemComplexo = (dados as! ItemOrcamentoComplexo)
                let cell_c = (cell as! CelulaComplexaOrcamentoConfirmacaoTableViewCell)

                cell_c.descricao.text = obtemString(itemComplexo.idTexto).replacingOccurrences(of: "\n", with: " ")
                break
            case TipoItem.complexoDetalhe:
                
                let itemComplexoDetalhe = (dados as! ItemOrcamentoComplexoDetalhe)
                var ajuste_painel : CGFloat = 0.0
                
                let cell_ambiente = (cell as! CelulaComplexaOrcamentoConfirmacaoAmbienteTableViewCell)

                cell_ambiente.label_ambiente.text = itemComplexoDetalhe.texto()
                
                if itemComplexoDetalhe.exibeAltura {
                    cell_ambiente.label_altura.text = String(format: obtemString("mascara_altura"),
                                                         itemComplexoDetalhe.altura!)
                }
                else {
                    cell_ambiente.label_altura.isHidden = true
                    ajuste_painel += cell_ambiente.constraint_altura_altura.constant
                    cell_ambiente.constraint_altura_altura.constant = 0.0
                }
                
                cell_ambiente.label_largura.text = String(format: obtemString("mascara_largura"), itemComplexoDetalhe.largura!)
                
                if itemComplexoDetalhe.exibeComprimento && itemComplexoDetalhe.comprimento != nil {
                    cell_ambiente.label_comprimento.text = String(format: obtemString("mascara_comprimento"), itemComplexoDetalhe.comprimento!)
                }
                else {
                    cell_ambiente.label_comprimento.isHidden = true
                    ajuste_painel += cell_ambiente.constraint_altura_comprimento.constant
                    cell_ambiente.constraint_altura_comprimento.constant = 0.0
                }
                
                cell_ambiente.label_valor.text = String(format: obtemString("mascara_valor"), Valor.floatParaMoedaString(itemComplexoDetalhe.valorCalculado))
                
                if itemComplexoDetalhe.necessitaMassaCorrida != nil {
                    cell_ambiente.label_massa.text = obtemString(itemComplexoDetalhe.necessitaMassaCorrida! ? "literal_necessita_massa_corrida" : "literal_nao_necessita_massa_corrida")
                }
                else {
                    cell_ambiente.label_massa.isHidden = true
                    ajuste_painel += cell_ambiente.constraint_altura_massa.constant
                    cell_ambiente.constraint_altura_massa.constant = 0.0
                }
                
                cell_ambiente.constraint_altura_painel.constant -= ajuste_painel
                
                break
            case TipoItem.trinca:
                let itemTrinca = (dados as! ItemOrcamentoTrinca)
                
                let cell_trinca = (cell as! CelulaTrincaOrcamentoConfirmacaoTableViewCell)
                
                cell_trinca.label_indice.text = "\(itemTrinca.sequencia)"
                cell_trinca.label_quantidade_trincas.text = "\(itemTrinca.quantidade)"
                cell_trinca.label_texto_existem_trincas.text = obtemString(itemTrinca.quantidade == 0 ? "literal_nao" : "literal_sim")
                
                break
            
            case TipoItem.conclusao:
                itemOrcamentoConclusao = (dados as! ItemOrcamentoConclusao)
                
                let cell_conclusao = (cell as! CelulaConclusaoOrcamentoConfirmacaoTableViewCell)
                
                cell_conclusao.botao_concordo_termos.setImage(UIImage(icon:"icon-check-empty", backgroundColor:corFundo, iconColor:self.corCinzaBullet(), iconScale:1.0, andSize:CGSize(width: 24, height: 24)), for:UIControlState())
                
                cell_conclusao.botao_concordo_termos.setImage(UIImage(icon:"icon-check", backgroundColor:corFundo, iconColor:self.corCinzaBullet(), iconScale:1.0, andSize:CGSize(width: 24, height: 24)), for:UIControlState.selected)
                cell_conclusao.botao_confirmar.setImage(iconeBotao("signin", cor: UIColor.white, corFundo: UIColor.clear), for: UIControlState())
                
                if contexto?.id_orcamento_inicial != nil {
                 
                    cell_conclusao.label_valor_anterior.text = String(format: obtemString("mascara_valor_pedido_anterior"), Valor.floatParaMoedaString(contexto!.valor_orcamento_inicial!))
                    cell_conclusao.label_valor_ja_pago.text = String(format:obtemString("mascara_valor_ja_pago"), Valor.floatParaMoedaString(contexto!.valor_pago_inicial!))
                    cell_conclusao.label_valor_novo.text = String(format:obtemString("mascara_valor_novo_pedido"), Valor.floatParaMoedaString(itemOrcamentoConclusao!.valorCalculado))
                    cell_conclusao.label_valor_diferenca.text = String(format:obtemString("mascara_diferenca_pagar"), Valor.floatParaMoedaString(itemOrcamentoConclusao!.valorCalculado - contexto!.valor_pago_inicial!))
                    cell_conclusao.label_valor_diferenca_a_vista.text = String(format:obtemString("mascara_diferenca_pagar_a_vista"), Valor.floatParaMoedaString((itemOrcamentoConclusao!.valorCalculado - contexto!.valor_pago_inicial!) * 0.95))
                    cell_conclusao.label_prazo_execucao_refazer.text = String(format:self.obtemString("mascara_prazo_execucao_servico"), itemOrcamentoConclusao!.dias)
                    
                    cell_conclusao.exibePainel(false)
                }
                else {
                    cell_conclusao.label_prazo_execucao.text = String(format:self.obtemString("mascara_prazo_execucao_servico"), itemOrcamentoConclusao!.dias)
                    cell_conclusao.label_valor_servico.text = String(format:obtemString("mascara_valor_servico"), Valor.floatParaMoedaString(itemOrcamentoConclusao!.valorCalculado))
                    cell_conclusao.label_valor_servico_a_vista.text = String(format:obtemString("mascara_valor_servico_a_vista"), Valor.floatParaMoedaString(itemOrcamentoConclusao!.valorAVista))
                    cell_conclusao.exibePainel(true)
                }
                
                cell_conclusao.adicionaPickerFormaPagamento(self.view)
                cell_conclusao.adicionaPickerMeioPagamento(self.view)
                cell_conclusao.defineEscolhaPagamento(self.escolhaPagamento)
                
                cell_conclusao.defineDestinoConfirmar({ 
                    self.onConfirmar()
                })
                break
            default:
                break
            }
        }
        else if dados is ConfiguracaoTinta {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "CelulaComplexaOrcamentoConfirmacaoPinturaTableViewCell", for: indexPath)
            
            let configuracaoTinta = dados as! ConfiguracaoTinta
            let ajuste = " "

            let cell_pintura = (cell as! CelulaComplexaOrcamentoConfirmacaoPinturaTableViewCell)
            cell_pintura.configuracaoTinta = configuracaoTinta
			if configuracaoTinta.localPintura == .Paredes {
				cell_pintura.label_tipo_pintura.text = "Tinta do Ambiente"
			}
			else if configuracaoTinta.localPintura == .Teto {
				cell_pintura.label_tipo_pintura.text = "Tinta do Teto"
			}
			else {
				cell_pintura.label_tipo_pintura.text = String(format: obtemString("mascara_pintura_ambiente"), configuracaoTinta.nomeItem!)
			}
            cell_pintura.label_valor.text = String(format: obtemString("mascara_valor"), Valor.floatParaMoedaString(configuracaoTinta.valorCalculado))
            cell_pintura.label_cor_tinta.text = ajuste + obtemString(configuracaoTinta.descricaoCorSelecionada()!) + ajuste
            cell_pintura.label_tipo_tinta.text = ajuste + obtemString(configuracaoTinta.descricaoTipoTintaSelecionada()!) + ajuste
            cell_pintura.label_acabamento_tinta.text = ajuste + obtemString(configuracaoTinta.descricaoAcabamentoSelecionado()!) + ajuste
            
            cell_pintura.botao_mais_menos.setImage(self.imagemMenos, for: UIControlState())
            cell_pintura.botao_mais_menos.setImage(self.imagemMais, for: UIControlState.selected)
            
            cell_pintura.botao_mais_menos.isSelected = !configuracaoTinta.celulaExpandida
            
            if cell_pintura.botao_mais_menos.isSelected {
                // 37 y do label cor, 9 altura da borda branca até a base
                cell_pintura.constraint_altura_painel.constant = 37.0 + 9.0
            }
            
            cell_pintura.imagem_check_nao_pintara.image = configuracaoTinta.naoPintara ? self.imagemCheckMarcado : self.imagemCheckDesmarcado
            cell_pintura.imagem_check_fornece_tintas.image = configuracaoTinta.clienteForneceTintas ? imagemCheckMarcado : self.imagemCheckDesmarcado
            
            cell_pintura.notificador_tamanho = ajustarTamanhoCelula

            cell_pintura.backgroundColor = corZebradoAtual()
        }
        else if dados is Cliente {
            
            let cliente = dados as! Cliente
            
            cell = tableView.dequeueReusableCell(withIdentifier: "CelulaPedidoClienteTableViewCell", for: indexPath)
            
            let cell_c = (cell as! CelulaPedidoClienteTableViewCell)
            cell_c.nome_cliente.text = cliente.nome
            cell_c.endereco.text = cliente.logradouro! + ", " + cliente.numero!
            cell_c.telefone.text = cliente.telefone
            cell_c.email.text = cliente.email
            cell_c.complemento.text = cliente.complemento
            
        }
        else {
            cell = UITableViewCell()
            cell.backgroundColor = corZebradoAtual()
        }
        
        return cell
    }
    
    func onConfirmar() {
        
        if !escolhaPagamento.leuOTermo {
            AvisoProcessamento.mensagemErroGenerico("É necessário aceitar os termos antes de continuar!");
            return
        }
        
        var pagamentoDinheiroMaquina = false, refazerPagamentoCartao = false
        var novoTipoPagamento = TipoPagamento.Nenhum
        var parcelas = 1
        
        pagamentoDinheiroMaquina = escolhaPagamento.meioPagamento == TipoMeioPagamento.CartaoCreditoMaquina || escolhaPagamento.meioPagamento == TipoMeioPagamento.Dinheiro
        
        if contexto?.id_orcamento_inicial != nil {
            
            refazerPagamentoCartao = !pagamentoDinheiroMaquina
            
            novoTipoPagamento = escolhaPagamento.formaPagamento
        }
        else {
            novoTipoPagamento = escolhaPagamento.formaPagamento
        }
        
        if novoTipoPagamento == TipoPagamento.Parcelado {
            parcelas = escolhaPagamento.parcelas
        }
        
        if pagamentoDinheiroMaquina && novoTipoPagamento != TipoPagamento.AVista {
            AvisoProcessamento.mensagemErroGenerico("Pagamento em dinheiro/máquina somente à vista")
            return
        }
        
        ////////////////////////////////////////////////////////////////////////
        
        let exibeOpcaoSalvar = mOrcamento?.id == 0 || contexto?.id_orcamento_editar != nil
        
        let alert = UIAlertController()
        
        alert.title = "O que deseja fazer ?"
        
        let refazerPagamentoDinheiroFinal = pagamentoDinheiroMaquina;
        let refazerTipoPagamentoFinal = novoTipoPagamento;
        let parcelasFinal = parcelas;
        
        alert.addAction(UIAlertAction(title: "Aprovar Orçamento", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            
            self.opcaoConfirmacao = OpcaoConfirmacao.aprovar
            
            if self.contexto?.id_orcamento_inicial == nil {
                self.prossegueCadastroCliente()
            }
            else {
                // refazendo orçamento
                /*if refazerPagamentoDinheiroFinal {
                    self.prosseguePagamentoDinheiro(self.mOrcamento!.getValor(), valorOriginal: self.contexto!.valor_orcamento_inicial!)
                }
                else {*/
                    self.prosseguePagamentoRefazer(refazerTipoPagamentoFinal, parcelas: parcelasFinal, diferenca: self.mOrcamento!.resultadoCalculo!.valorTotal - self.contexto!.valor_pago_inicial!, emDinheiro:refazerPagamentoDinheiroFinal)
                /*}*/
            }
        }))
        
        let emailHandler = { (action:UIAlertAction) in
            self.opcaoConfirmacao = OpcaoConfirmacao.enviarEmail
            
            if self.mOrcamento?.id == 0 || self.contexto?.id_orcamento_inicial != nil || self.contexto?.id_orcamento_editar != nil {
                self.persisteOrcamento()
            }
            else {
                self.prossegueEnvioEmail(self.mOrcamento!.id)
            }
        }
        
        if exibeOpcaoSalvar {
            alert.addAction(UIAlertAction(title: "Salvar Orçamento", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            
                self.opcaoConfirmacao = OpcaoConfirmacao.salvar
                self.persisteOrcamento()
            }))
            alert.addAction(UIAlertAction(title: "Enviar por email", style: UIAlertActionStyle.default, handler: emailHandler))
        }
        else {
            alert.addAction(UIAlertAction(title: "Enviar por email", style: UIAlertActionStyle.default, handler: emailHandler))
            alert.addAction(UIAlertAction(title: "Voltar", style: UIAlertActionStyle.cancel, handler: { (action:UIAlertAction) in
                
                //self.prossegueInicio()
            }))
            
        }
        
        self.navigationController?.present(alert, animated: true, completion: { 
            
        })
    }
    
    func persisteOrcamento() {
        
        let franqueado = PinturaAJatoApi.obtemFranqueado()
        
        var jsonObject = mOrcamento!.gerarConteudoApiInsercao(franqueado!.id_franquia)
        
        if jsonObject == nil {
            AvisoProcessamento.mensagemErroGenerico("Falha gerando o orçamento. Entre em contato com o suporte.")
            return
        }
        
        //do {
          
            //var tipoMeioPagamento: TipoMeioPagamento?
            //var tipoPagamento: TipoPagamento?
            //var numero_parcelas = 1
            
            jsonObject!["forma_de_pagamento"] = (escolhaPagamento.formaPagamento.rawValue)
            jsonObject!["meio_de_pagamento"] = (escolhaPagamento.meioPagamento.rawValue)
            jsonObject!["numero_parcelas"] = (escolhaPagamento.parcelas)
            jsonObject!["status_pagamento"] = "0"
            
        //}
        //catch {
            
       // }
        
        ////////////////////////////////////////////////////////////////////////
        
        let api = PinturaAJatoApi()
        
        let sucesso = { (objeto: OrcamentoGerado?, resultado: Bool) -> Bool in
            
            Orcamento.limpaOrcamento()
            
            if self.opcaoConfirmacao == OpcaoConfirmacao.aprovar {
                if self.contexto?.id_orcamento_inicial != nil {
                    self.prossegueRefazerOrcamento(self.contexto!.id_orcamento_inicial!, id_orcamento_novo: objeto!.id)
                }
            }
            else if self.opcaoConfirmacao == OpcaoConfirmacao.enviarEmail {
                self.prossegueEnvioEmail(objeto!.id)
            }
            else if self.opcaoConfirmacao == OpcaoConfirmacao.salvar {
                AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: String(format:"Orçamento #%06d gravado", objeto!.id), destino: {
                    self.prossegueInicio()
                })
            }
            
            return true
        };
        
        if self.contexto?.id_orcamento_editar != nil {
            
            jsonObject!["id_orcamento"] = self.contexto!.id_orcamento_editar!
            
            api.editarOrcamentoApp(self.navigationController!.view, parametros: jsonObject!, sucesso: sucesso )
        }
        else {
            
            api.incluirOrcamento(self.navigationController!.view, parametros: jsonObject!, sucesso: sucesso )
        }
    }
    
    func prossegueRefazerOrcamento(_ id_orcamento_inicial: Int, id_orcamento_novo: Int) {
        
        let api = PinturaAJatoApi()
        
        let parametros: [String: AnyObject] = [
            "id_orcamento_1" : "\(id_orcamento_inicial)" as AnyObject,
            "id_orcamento_2" : "\(id_orcamento_novo)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.orcamento(self.navigationController!.view, tipo:"refazer", parametros: parametros, sucesso: { (resultado: Resultado?) -> Bool in
            
            AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: "Novo orçamento gerado", destino: { 
                self.prossegueInicio()
            })
            
            return true
        })
        
    }
    
    func prossegueCadastroCliente() {
        
        contexto!.valorPagamento = itemOrcamentoConclusao?.valorCalculado
        contexto!.diasServico = itemOrcamentoConclusao?.dias
        contexto!.tipoPagamento = escolhaPagamento.formaPagamento
        contexto!.tipoMeioPagamento = escolhaPagamento.meioPagamento
        contexto!.parcelas = escolhaPagamento.parcelas
        
        self.performSegue(withIdentifier: "SegueConfirmacaoParaDadosCadastrais", sender: self)
        
    }
    
    func prosseguePagamentoDinheiro(_ valorNovo: Float, valorOriginal: Float) {
        
        let api = PinturaAJatoApi()
        
        let parametros: [String: AnyObject] = [
            "id_orcamento" : "\(contexto!.id_orcamento_inicial!)" as AnyObject,
            "valor": String(format: "%.2f", itemOrcamentoConclusao!.valorCalculado) as AnyObject,
            "id_franquia" : "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
            "id_cliente" : "\(contexto!.id_cliente)" as AnyObject,
            "descricao" : String(format: "Pgto. do orçamento: %d", contexto!.id_orcamento_inicial!) as AnyObject,
            "valor_parcelas" : "0.0" as AnyObject,
            "status_pagamento" : "1",
            "valor_bruto" : "\(valorNovo)",
            "valor_residual" : "0.0"
        ]
        
        api.pagamento(self.navigationController!.view, tipo: "dinheiro", parametros: parametros, sucesso: { (resultado: Resultado?) -> Bool in
             AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: "Pagamento registrado", destino: { 
                self.prossegueInicio()
             })
            return true
            })
        
    }
    
    func prossegueInicio() {
        
        var vc : UIViewController? = nil
        
        for vcvoltar in self.navigationController!.viewControllers {
            
            if vcvoltar is OrcamentoEscolhaViewController || vcvoltar is HistoricoTableViewController {
                vc = vcvoltar
                break
            }
        }
        
        // deve voltar a escolha
        if vc != nil {
            self.navigationController?.popToViewController(vc!, animated: true)
        }
        else {
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func prossegueEnvioEmail(_ id_orcamento: Int) {
        
        let api = PinturaAJatoApi()
        
        let parametros: [String: AnyObject] = [
            "id_franquia" : "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
            "id_orcamento" : "\(id_orcamento)" as AnyObject
        ]
        
        api.email(self.navigationController!.view, tipo: "orcamento", parametros: parametros, sucesso: { (objeto:Cliente?, resultado: Resultado?) -> Bool in
        
            AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: "E-mail enviado para " + objeto!.email! , destino: {
                self.prossegueInicio()
            })
            
            return false
        })
    }
    
    func prosseguePagamentoRefazer(_ tipoPagamento: TipoPagamento, parcelas: Int, diferenca: Float, emDinheiro: Bool) {
        
        let alert = UIAlertController()
        var mensagem: String?
        
        if diferenca <= 0.0 {
            
            if diferenca < 0.0 {
                mensagem = "O novo orçamento tem valor menor que o anterior. A diferença \(Valor.floatParaMoedaString(diferenca)) deverá ser estornada pelo sistema administrativo"
            }
            else {
                // Nada a fazer
                mensagem = "O novo orçamento tem o mesmo valor que o anterior. Nenhuma ação de pagamento é necessária.";
            }
            
            alert.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
                self.opcaoConfirmacao = OpcaoConfirmacao.aprovar
                self.persisteOrcamento()
            }))
        }
        
        if mensagem != nil {
            alert.message = mensagem
            self.present(alert, animated: true, completion: { 
                
            })
            return
        }
        
        ////////////////////////////////////////////////////////////////////////
        
        // Força criar um novo
        Orcamento.obtemOrcamento()!.id = 0

        if emDinheiro {
            
            contexto!.valorPagamento = diferenca
            contexto!.diasServico = itemOrcamentoConclusao!.dias
            contexto!.tipoPagamento = tipoPagamento
            contexto!.parcelas = parcelas
            contexto!.tipoMeioPagamento = TipoMeioPagamento.Dinheiro
            
            self.performSegue(withIdentifier: "SegueConfirmacaoParaDadosCadastrais", sender: self)
        }
        else {

            if contexto_agendamento == nil {
                contexto_agendamento = ContextoAgendaCalendario()
            }
            
            contexto_agendamento!.valorPagamento = diferenca
            contexto_agendamento!.diasServico = itemOrcamentoConclusao!.dias
            contexto_agendamento!.tipoPagamento = tipoPagamento
            contexto_agendamento!.parcelas = parcelas
            contexto_agendamento!.id_cliente = contexto!.id_cliente
            
            if contexto?.id_orcamento_inicial != nil {
                contexto_agendamento!.id_orcamento_inicial = contexto?.id_orcamento_inicial
            }
            if contexto?.id_orcamento_editar != nil {
                contexto_agendamento!.id_orcamento_editar = contexto?.id_orcamento_editar
            }

            contexto_agendamento!.tipoMeioPagamento = TipoMeioPagamento.CartaoCredito
            
            self.performSegue(withIdentifier: "SegueConfirmacaoParaPagamentoCartao", sender: self)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueConfirmacaoParaDadosCadastrais" {
            
            let vc = segue.destination as! OrcamentoCadastroCompletoViewController
            
            vc.defineContexto(contexto)
            
        }
        else if segue.identifier == "SegueConfirmacaoParaPagamentoCartao" {
            
            let vc = segue.destination as! OrcamentoPagamentoCartaoViewController
            
            vc.defineContexto(self.contexto_agendamento)
        }
        else if segue.identifier == "SegueOrcamentoConfirmacaoParaPrincipal" {
            
            let vc = segue.destination as! OrcamentoPrincipalViewController
            
            self.contexto?.id_orcamento_editar = mOrcamento?.id
            
            vc.defineContexto(self.contexto)
            
        }
    }
  
    func ajustarTamanhoCelula(_ configuracaoTinta: ConfiguracaoTinta?, altura: CGFloat) {
    
        /*var indice = 0
        
        for item in itensOrcamento {
            
            if item === configuracaoTinta {
                break
            }
            
            indice += 1
        }*/
    
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dados = itensOrcamento[indexPath.item]
        
        
        if dados is ItemOrcamento {

            let itemOrcamento = dados as! ItemOrcamento
            
            switch itemOrcamento.tipo {
            case TipoItem.simples:
                return 44.0
            case TipoItem.complexo:
                return 44.0
            case TipoItem.conclusao:
                var altura : CGFloat = 430.0
                // novo: 96
                // refazer: 142
                
                altura += 26.0
                altura -= contexto?.id_orcamento_inicial != nil ? 96.0 : 142.0
                
                return altura
            case TipoItem.complexoDetalhe:
                let itemComplexoDetalhe = itemOrcamento as! ItemOrcamentoComplexoDetalhe
                var altura : CGFloat = 254.0
                
                altura -= (!itemComplexoDetalhe.exibeAltura ? 21.0 : 0.0)
                altura -= (!itemComplexoDetalhe.exibeComprimento ? 21.0 : 0.0)
                altura -= (itemComplexoDetalhe.necessitaMassaCorrida == nil ? 21.0 : 0.0)
                
                return altura
            case TipoItem.trinca:
                return 80.0
            default:
                break
            }
        }
        else if dados is ConfiguracaoTinta {
            
            let configuracaoTinta = dados as! ConfiguracaoTinta
            var altura: CGFloat = 231.0
            
            if !configuracaoTinta.celulaExpandida {
                altura = 52.0
            }
            
            return altura
        }
        else if dados is Cliente {
            return 348.0
        }
    
        return 21.0
    }
    
    func novoItemPrincipal(_ itemPrincipal: ItemOrcamento?) -> Void {
        
        if itemPrincipal?.tipo != TipoItem.trincaDetalhe {
            itensOrcamento.append(itemPrincipal!)
        }
    }
    func mudouItemPrincipal(_ itemPrincipal: ItemOrcamento?) -> Void {
        
    }
    func novoSubitem(_ itemPrincipal: ItemOrcamento?, subitem: ItemOrcamento?) -> Void {
        if subitem?.tipo != TipoItem.trincaDetalhe {
            itensOrcamento.append(subitem!)
        }
    }
    func removeSubitem(_ subitem: ItemOrcamento?) -> Void {
        
    }
    func selecionaCor(_ itemOrcamentoDetalhe: ItemOrcamento?, configuracaoTinta: ConfiguracaoTinta?) -> Bool {
        return true
    }
    func mudouOrcamentoValido(_ valido: Bool, listaErros: [ItemErroOrcamento]?) -> Void {
        
    }
    func novaConfiguracaoTinta(_ itemOrcamentoComplexoDetalhe: ItemOrcamentoComplexoDetalhe?, configuracaoTinta: ConfiguracaoTinta?) -> Void {
        itensOrcamento.append(configuracaoTinta!)
    }
    func selecionaMassaCorrida(_ itemOrcamento: ItemOrcamentoComplexoDetalhe?) -> Void {
        
    }
    func fimConfiguracaoTinta(_ itemOrcamentoComplexoDetalhe: ItemOrcamentoComplexoDetalhe?) -> Void {
        itensOrcamento.append("" as AnyObject)
    }
    func notificaErro(_ mensagem: String?, mensagemTecnica: String?) -> Void {
        
    }
    func listaAmbienteMudou(_ novoNome: String?, textoAlternativo: String?, id_texto: String?, sequencia: Int, listaAmbientes: [ItemAmbienteTrinca]?) -> Void {

    }
    func mudouSequenciaDetalheComplexo(_ itemOrcamentoDetalheAjustar: ItemOrcamentoComplexoDetalhe, novaSequencia: Int, antigaSequencia: Int) {
        
    }
    func mudouSequenciaTrincaDetalhe(_ itemOrcamentoTrincaDetalhe: ItemOrcamentoTrincaDetalhe, novaSequencia: Int, antigaSequencia: Int) {
        
    }
    func mudouNomeAmbiente(_ itemOrcamentoAtualizado: ItemOrcamentoComplexoDetalhe) {

    }
}
