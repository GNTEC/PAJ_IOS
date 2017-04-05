//
//  PedidoPrincipalViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 17/09/16.
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


class ItemTabela {
    var inicio: Ponto?
    var fim: Ponto?
}

class ItemAntesDepois {
    var urlAntesPequena: String?
    var urlDepoisPequena: String?
    var urlAntesGrande: String?
    var urlDepoisGrande: String?
    var sequencia: Int = 0
    var exibe: Bool = true
    
    var imagemGrandeAntes: UIImage?
    var imagemGrandeDepois: UIImage?
}

class PedidoPrincipalViewController : UITableViewController, NotificaOrcamentoMudou {
    var itensPedido : [AnyObject]? = [AnyObject]()
    var imagemCalendario: UIImage!
    var imagemRelogio1: UIImage!
    var imagemRelogio2: UIImage!
    var imagemAviaoPapel: UIImage!
    var imageCheckVerde: UIImage!
    var imageRemoveVermelho: UIImage!
    var imageCheckCinza: UIImage!
    var imageRemoveCinza: UIImage!
    var imagemCheckMarcado: UIImage!
    var imagemCheckDesmarcado: UIImage!
    //var tapAntes: UITapGestureRecognizer!
    //var tapDepois: UITapGestureRecognizer!
    
    var pedidoFinalizado: Bool = false
    var pedidoCancelado: Bool = false
    var orcamento: Orcamento?
    var contadorZebrado: Int = 0
    var contexto: ContextoPedido?
    var contexto_detalhe_foto: ContextoPedidoDetalheFoto?
    
    let altura_item_cabecalho: CGFloat = 25.0
    
    @IBOutlet weak var painel_cabecalho: UIView!
    @IBOutlet weak var label_valor_total: UILabel!
    @IBOutlet weak var label_detalhe_pedido: UILabel!
    @IBOutlet weak var label_mensagem_inativo: UILabel!
    @IBOutlet weak var constraint_altura_cabecalho: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_painel_detalhe_servico: NSLayoutConstraint!
    @IBOutlet weak var constrain_altura_painel_pedido_inativo: NSLayoutConstraint!
    
    func defineContexto(_ contexto: ContextoPedido?) {
        self.contexto = contexto
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        //tapAntes = UITapGestureRecognizer(target: self, action: #selector(self.onTapAntes))
        //tapAntes.numberOfTapsRequired = 1
        //tapDepois = UITapGestureRecognizer(target: self, action: #selector(self.onTapDepois))
        //tapDepois.numberOfTapsRequired = 1
        
        let size: CGSize = CGSize(width: 20, height: 20)
        let background_color1 = self.corCinzaFundoBullet()
        let background_color2 = UIColor(red: 0.93, green: 0.93, blue: 0.952135, alpha: 1.0)
        let icon_color = UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.0)
        //let background_color_laranja = self.corLaranja()
        painel_cabecalho.backgroundColor = self.corLaranja()
        
        // laranja
        imageCheckVerde = self.iconeQuadrado("ok", cor: UIColor.white, corFundo: self.corVerdeCheck(), tamanho: 32)
        imageRemoveVermelho = self.iconeQuadrado("remove", cor: UIColor.white, corFundo: self.corVermelhoRemove(), tamanho: 32)
        imageCheckCinza = self.iconeQuadrado("ok", cor: UIColor.white, corFundo: self.corCinzaFundoBullet(), tamanho: 32)
        imageRemoveCinza = self.iconeQuadrado("remove", cor: UIColor.white, corFundo: self.corCinzaFundoBullet(), tamanho: 32)
        
        imagemCheckMarcado = self.iconeListaPequeno("check", cor: self.corCinzaBullet(), corFundo: UIColor.clear)
        imagemCheckDesmarcado = self.iconeListaPequeno("unchecked", cor: self.corCinzaBullet(), corFundo: UIColor.clear)
        
        imagemCalendario = UIImage(icon: "icon-calendar", backgroundColor: background_color1, iconColor: icon_color, iconScale: 1.0, andSize: size)
        imagemRelogio1 = UIImage(icon: "icon-time", backgroundColor: background_color1, iconColor: icon_color, iconScale: 1.0, andSize: size)
        imagemRelogio2 = UIImage(icon: "icon-time", backgroundColor: background_color2, iconColor: icon_color, iconScale: 1.0, andSize: size)
        
        //size.width = 30
        //size.height = 30
        //imagemAviaoPapel = UIImage(icon: "icon-paper-plane", backgroundColor: background_color_laranja, iconColor: UIColor.whiteColor(), iconScale: 1.0, andSize: size)
        
        ////////////////////////////////////////////////////////////////////////
        
        self.title = String(format: "Pedido #%06d", contexto!.id_orcamento)
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_orcamento" : "\(contexto!.id_orcamento)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        Registro.registraInformacao(.idOrcamento, valor: Int32(contexto!.id_orcamento))
        
        api.buscarPedido(self.navigationController!.view, parametros: parametros) { (objeto, resultado) -> Bool in
            
            let valorPedido = Float(objeto!.orcamento!.valor!)!
            let dias = objeto?.agenda != nil ? objeto?.agenda?.count : 0;
            let dataDate = dias == 0 ? nil : objeto!.agenda![0].data();
            
            let texto_inicio_servico = String(format: self.obtemString("mascara_inicio_servico"), dataDate == nil ? "" : Data.dateParaStringDiaMes(dataDate!))
            
            let texto_tempo_servico = String(format: self.obtemString("mascara_dias_servico"), dias!)
            
            self.label_detalhe_pedido.text = texto_inicio_servico + " - " + texto_tempo_servico
            
            self.label_valor_total.text = String(format: self.obtemString("mascara_valor_total"), Valor.floatParaMoedaString(valorPedido))
            
            ////////////////////////////////////////////////////////////////////
            
            self.pedidoFinalizado = objeto?.orcamento?.status == "4"
            self.pedidoCancelado = objeto?.orcamento?.status == "5"
            
            self.ajustaPaineis()
            
            //if !(self.pedidoFinalizado || self.pedidoCancelado) {
                self.processaDatas(objeto!.agenda, ponto: objeto!.ponto)
            //}
            
            ////////////////////////////////////////////////////////////////////

            self.itensPedido!.append(objeto!.cliente!)
            
            ////////////////////////////////////////////////////////////////////
            
            self.orcamento = Orcamento.recriaOrcamentoGerado(objeto!.orcamento!, notificaOrcamentoMudou: self, parcial: false)
            
            self.atualizaChecklist(self.orcamento, checklist: objeto!.checklist, orcamentoGerado: objeto!.orcamento)
            
            let resultadoCalculo = ResultadoCalculo()
            
            if objeto?.orcamento?.dias_servico != nil {
                resultadoCalculo.diasTotal = Int(objeto!.orcamento!.dias_servico!)!
            }
            resultadoCalculo.valorTotal = Float(objeto!.orcamento!.valor!)!
            
            self.orcamento?.rechamaNotificacoes(self, resultadoCalculo: resultadoCalculo)
            
            ////////////////////////////////////////////////////////////////////
            
            if !(self.contexto!.modoFinanceiro) {
                
                self.processaFotos(objeto?.foto)
                
                if !(self.pedidoCancelado || self.pedidoFinalizado) {
                    
                    let itemFoto = ItemAntesDepois()
                    
                    itemFoto.sequencia = self.contexto!.sequencia
                    
                    self.contexto?.sequencia += 1
                    
                    self.itensPedido!.append(itemFoto)
                }
            }
            
            self.tableView.reloadData()
            
            return true
        }
    }
    
    func processaFotos(_ fotos: [Foto]? ) {
    
        var listHashMap = Dictionary<Int, ItemAntesDepois?>()
        
        for foto in fotos! {
            
            var itemAntesDepois: ItemAntesDepois? = nil;
            
            let indice = listHashMap.index(forKey: foto.id_sequencia)
            
            if(indice != nil) {
                itemAntesDepois = listHashMap[foto.id_sequencia]!
            }
            else {
                itemAntesDepois = ItemAntesDepois();
                
                listHashMap[foto.id_sequencia] = itemAntesDepois
                itemAntesDepois!.sequencia = foto.id_sequencia
            }
            
            let api = PinturaAJatoApi()
            
            if(foto.antes_depois == "antes") {
                itemAntesDepois!.urlAntesPequena = api.obtemUrlFotoPedido(foto.nome_arquivop!)
                itemAntesDepois!.urlAntesGrande = api.obtemUrlFotoPedido(foto.nome_arquivog!)
            }
            else {
                itemAntesDepois!.urlDepoisPequena = api.obtemUrlFotoPedido(foto.nome_arquivop!)
                itemAntesDepois!.urlDepoisGrande = api.obtemUrlFotoPedido(foto.nome_arquivog!)
            }
            
            itemAntesDepois!.exibe = !(pedidoCancelado || pedidoFinalizado)
        }
    
    
        var maior_sequencia = 0;
        
        let ordenador = { (item_esquerda: (Int, ItemAntesDepois?), item_direita: (Int, ItemAntesDepois?)) -> Bool in
            return item_esquerda.0 < item_direita.0
        }
        
        let listaHashMapOrdenado = listHashMap.sorted(by: ordenador)
    
        for itemAntesDepois in listaHashMapOrdenado {
    
            //final String urlImagem = "https://www.pinturaajato.com/uploads/foto/";
    
    
            if (itemAntesDepois.1!.sequencia > maior_sequencia) {
                maior_sequencia = itemAntesDepois.1!.sequencia;
            }
    
            itensPedido?.append(itemAntesDepois.1!)
    
        }
    
        contexto!.sequencia = maior_sequencia == 0 ? 0 : maior_sequencia + 1;
    }
    
    
    func processaDatas(_ agenda: [ItemHistoricoCalendario]?, ponto: [Ponto]? ) {
        
        var sequencia = 1;
        
        if(agenda == nil || agenda!.count == 0) {
            
            #if DEBUG
                //let itemHistoricoCalendario = ItemHistoricoCalendario()
                
                //itemHistoricoCalendario.pe("00:00:01");
                //itemHistoricoCalendario.setPeriodo_final("23:59:59");
                
                //itemHistoricoCalendario.setSequencia(sequencia++);
            #endif
            
            return;
        }
        
        let ponto_ordenado = ponto!.sorted(by: { $0.data_servico < $1.data_servico })
        
        var tabelaList = Array<ItemTabela>()
        
        var itemTabela: ItemTabela? = nil;
        
        for itemPonto in ponto_ordenado {
            
            if(itemPonto.inicio == "0") {
                
                if(itemTabela == nil) {
                    itemTabela = ItemTabela();
                }
                
                itemTabela!.fim = itemPonto;
                
                tabelaList.append(itemTabela!);
                
                itemTabela = nil;
            }
            else {
                
                if(itemTabela == nil) {
                    itemTabela = ItemTabela();
                }
                
                itemTabela!.inicio = itemPonto;
                
            }
        }
        
        if(itemTabela != nil) {
            tabelaList.append(itemTabela!);
        }
        
        var indice = 0;
        
        for itemHistoricoCalendario in agenda! {
            
            if(tabelaList.count > indice) {
                
                let itemTabela1 = tabelaList[indice]
                
                // 2016-08-25 14:41:15
                
                if(itemTabela1.inicio != nil) {
                    
                    let data = Data.dataJsonStringParaDate(itemTabela1.inicio?.data_servico);
                    
                    itemHistoricoCalendario.periodo_inicial = Data.dateParaHHMM(data!);
                }
                
                if(itemTabela1.fim != nil) {
                    
                    let data = Data.dataJsonStringParaDate(itemTabela1.fim?.data_servico);
                    
                    itemHistoricoCalendario.periodo_final = Data.dateParaHHMM(data!)
                    
                }
            }
            
            indice += 1
            
            itemHistoricoCalendario.sequencia = sequencia
            
            sequencia += 1
            
            itensPedido?.append(itemHistoricoCalendario)
        }
        
    }
    
    func ajustaPaineis() {
    
        let exibe_painel_detalhe_servico = !(pedidoCancelado || pedidoFinalizado)
        let exibe_painel_pedido_inativo = (pedidoCancelado || pedidoFinalizado)
        
        label_detalhe_pedido.isHidden = !exibe_painel_detalhe_servico
        //var frame = self.tableView.tableHeaderView?.frame
        
        if !exibe_painel_detalhe_servico {
            //constraint_altura_cabecalho.constant -= constraint_altura_painel_detalhe_servico.constant
            //frame!.size.height -= constraint_altura_painel_detalhe_servico.constant
            constraint_altura_painel_detalhe_servico.constant = 0
        }
        if !exibe_painel_pedido_inativo {
            //constraint_altura_cabecalho.constant -= constrain_altura_painel_pedido_inativo.constant
            //frame!.size.height -= constraint_altura_painel_detalhe_servico.constant
            constrain_altura_painel_pedido_inativo.constant = 0
        }
        
        //self.tableView.tableHeaderView!.frame = frame!
        
        if exibe_painel_pedido_inativo {
            
            label_mensagem_inativo.text = pedidoCancelado ? "Pedido cancelado" : pedidoFinalizado ? "Pedido finalizado" :  "n/d"
            label_mensagem_inativo.isHidden = false
        }
        
        self.tableView.layoutIfNeeded()
    }
    
    func atualizaChecklist(_ orcamento: Orcamento?, checklist: OrcamentoGerado?, orcamentoGerado: OrcamentoGerado?) {
    
        orcamento!.atualizaChecklistPergunta(1, aprovado: checklist?.pergunta_1 == "true");
        orcamento!.atualizaChecklistPergunta(2, aprovado: checklist?.pergunta_2 == "true");
        orcamento!.atualizaChecklistPergunta(3, aprovado: checklist?.pergunta_3 == "true");
        orcamento!.atualizaChecklistPergunta(4, aprovado: checklist?.pergunta_4 == "true");
        orcamento!.atualizaChecklistPergunta(5, aprovado: checklist?.pergunta_5 == "true");
        orcamento!.atualizaChecklistPergunta(6, aprovado: checklist?.pergunta_6 == "true");

        if checklist?.trincas != nil {
            orcamento!.atualizaChecklistTrincas(checklist?.trincas == "true")
        }

        for orcamentoItem in checklist!.orcamento_item! {
    
            let itemOrcamento = orcamento!.buscaItemOrcamentoPorId(orcamentoItem.id_orcamento_item);
    
            if(itemOrcamento == nil) {
                continue;
            }
    
            if (itemOrcamento is ItemOrcamentoComplexoDetalhe) {
    
                let itemOrcamentoComplexoDetalhe = itemOrcamento as! ItemOrcamentoComplexoDetalhe
                
                itemOrcamentoComplexoDetalhe.checklistAprovado = orcamentoItem.resposta == "true"
    
                if(orcamentoItem.item_pintura != nil) {
    
                    for orcamentoItemPintura in orcamentoItem.item_pintura! {
    
                        var localPintura = LocalPintura.Nenhum;
    
                        ///////////////////////////////////////////////////////////////////////////
    
                        // busca no orçamento original a informação
    
                        for orcamentoOriginalItem in orcamentoGerado!.orcamento_item! {
    
                            if(orcamentoOriginalItem.id == orcamentoItem.id_orcamento_item) {
    
                                for orcamentoOriginalItemPintura in orcamentoOriginalItem.item_pintura! {
    
                                    if(orcamentoOriginalItemPintura.id == orcamentoItemPintura.id_orcamento_item_pintura) {
                                        localPintura = LocalPintura(rawValue: orcamentoOriginalItemPintura.tipo_registro!)!;
                                    }
                                }
                            }
                        }
    
                        ///////////////////////////////////////////////////////////////////////////
    
                        let configuracaoTinta = itemOrcamentoComplexoDetalhe.configuracaoTinta(localPintura);
    
                        configuracaoTinta?.checklistAprovado = orcamentoItemPintura.resposta == "true"
    
                    }
                }
            }
            /*else if(itemOrcamento is ItemOrcamentoTrincaDetalhe) {
    
                //ItemOrcamentoTrincaDetalhe itemOrcamentoTrincaDetalhe = (ItemOrcamentoTrincaDetalhe)itemOrcamento;
    
                let aprovado = orcamentoItem.resposta == "true"
    
                let itemOrcamento1 = orcamento!.buscaPrimeiroItemPorTipo(TipoItem.Trinca);
    
                if(itemOrcamento1 != nil) {
    
                    let itemOrcamentoTrinca = itemOrcamento1 as! ItemOrcamentoTrinca
    
                    itemOrcamentoTrinca.checkListAprovado = aprovado
                }
            }*/
        }
    }
    
    /*func onTapAntes() {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("PedidoFotosAntes")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func onTapDepois() {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("PedidoFotosDepois")
        self.navigationController!.pushViewController(vc, animated: true)
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if itensPedido == nil {
            return 0
        }
        
        return itensPedido!.count
    }
    
    func obtemTipoCelula(_ tipo: TipoItem) -> String? {
        
        var id_celula: String? = nil
        
        switch tipo {
        case TipoItem.complexo:
            id_celula = "CelulaPedidoComplexaTableViewCell"
            break
        case TipoItem.complexoDetalhe:
            id_celula = "CelulaPedidoComplexaAmbienteTableViewCell"
            break
        case TipoItem.conclusao:
            id_celula = "CelulaPedidoConclusaoTableViewCell"
            break
        case TipoItem.simples:
            id_celula = "CelulaPedidoSimplesTableViewCell"
            break
        case TipoItem.trinca:
            id_celula = "CelulaPedidoTrincaTableViewCell"
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
    
    func prossegueHistorico(_ inicio: Bool, finalizarServico: Bool, hora_informada: String?) {
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_franquia" : "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
            "id_orcamento" : "\(contexto!.id_orcamento)" as AnyObject,
            "inicio_servico" : inicio ? "1" as AnyObject : "0" as AnyObject,
            "latitude" : "0.0" as AnyObject,
            "longitude" : "0.0" as AnyObject,
            "precisao" : "0.0" as AnyObject,
            "finalizar_servico" : finalizarServico ? "1" as AnyObject : "0" as AnyObject,
            "hora_informada" : hora_informada! as AnyObject
        ]

        api.ponto(self.navigationController!.view, tipo: "registro", parametros: parametros, sucesso: { (resultado: Resultado?) -> Bool in
          
            AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: "Registrado!", destino: {
                
                var vc : UIViewController?
                
                for vc_busca in self.navigationController!.viewControllers {
                    
                    if vc_busca is HistoricoTableViewController {
                        vc = vc_busca
                        break
                    }
                }
                
                if vc == nil {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.navigationController?.popToViewController(vc!, animated: true)
                }
            })
            
            return true
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dados = itensPedido![indexPath.item]
        
        var cell : UITableViewCell?
        
        if dados is ItemOrcamento {
        
            let itemOrcamento = dados as! ItemOrcamento
            
            let id_celula = obtemTipoCelula(itemOrcamento.tipo)
            
            cell = tableView.dequeueReusableCell(withIdentifier: id_celula!, for: indexPath)
            
            if itemOrcamento.tipo != .complexoDetalhe && itemOrcamento.tipo != .complexo {
                contadorZebrado += 1
            }

            let corFundo = corZebradoAtual()
            
            cell!.backgroundColor = corFundo
            
            switch itemOrcamento.tipo {
                
            case TipoItem.simples:
                let itemOrcamentoSimples = itemOrcamento as! ItemOrcamentoSimples
                let cell_s = (cell as! CelulaPedidoSimplesTableViewCell)
                cell_s.texto.text = obtemString(itemOrcamentoSimples.textoSelecao())
                cell_s.numero.text = "\(itemOrcamento.sequencia)"
                
                cell_s.imagem_sim.isHidden = !itemOrcamentoSimples.exibeBotoesCheckList
                cell_s.imagem_nao.isHidden = !itemOrcamentoSimples.exibeBotoesCheckList
                
                cell_s.imagem_sim.image = itemOrcamentoSimples.checkListAprovado != nil && itemOrcamentoSimples.checkListAprovado! ? imageCheckVerde : imageCheckCinza
                cell_s.imagem_nao.image = itemOrcamentoSimples.checkListAprovado != nil && !itemOrcamentoSimples.checkListAprovado! ? imageRemoveVermelho : imageRemoveCinza

                break
                
            case TipoItem.complexo:
                let itemOrcamentoComplexo = itemOrcamento as! ItemOrcamentoComplexo
                let cell_c = (cell as! CelulaPedidoComplexaTableViewCell)
                cell_c.texto.text = obtemString(itemOrcamentoComplexo.idTexto).replacingOccurrences(of: "\n", with: " ")
                //cell_c.numero.text = "\(itemOrcamentoComplexo.sequencia)"
                //cell_c.texto2.text = itemOrcamentoComplexo.
                break
                    
            case TipoItem.complexoDetalhe:
                let itemOrcamentoAmbiente = itemOrcamento as! ItemOrcamentoComplexoDetalhe
                let cell_c = (cell as! CelulaPedidoComplexaAmbienteTableViewCell)
                
                cell_c.label_ambiente.text = itemOrcamentoAmbiente.texto() //obtemString(itemOrcamentoAmbiente.idTexto)
                
                if itemOrcamentoAmbiente.exibeAltura {
                    cell_c.label_altura.text = "Altura: \(itemOrcamentoAmbiente.altura!)m"
                }
                cell_c.constraint_altura_altura.constant = itemOrcamentoAmbiente.exibeAltura ? 21.0 : 0.0
                
                cell_c.label_largura.text = "Largura: \(itemOrcamentoAmbiente.largura!)m"
                
                if itemOrcamentoAmbiente.exibeComprimento {
                    cell_c.label_comprimento.text = "Comprimento: \(itemOrcamentoAmbiente.comprimento!)m"
                }
                cell_c.constraint_altura_comprimento.constant = itemOrcamentoAmbiente.exibeComprimento ? 21.0 : 0.0
                
                cell_c.label_massa.text = itemOrcamentoAmbiente.necessitaMassaCorrida == nil ? "" : ((itemOrcamentoAmbiente.necessitaMassaCorrida! ? "Com " : "Sem ") + "serviço de massa corrida")
                cell_c.constraint_altura_massa.constant = itemOrcamentoAmbiente.configuracaoMassaCorrida ? 21.0 : 0.0
                
                cell_c.imagem_sim.image = itemOrcamentoAmbiente.checklistAprovado != nil && itemOrcamentoAmbiente.checklistAprovado! ? imageCheckVerde : imageCheckCinza
                cell_c.imagem_nao.image = itemOrcamentoAmbiente.checklistAprovado != nil && !itemOrcamentoAmbiente.checklistAprovado! ? imageRemoveVermelho : imageRemoveCinza
                
                break
            case TipoItem.trinca:
                let itemOrcamentoTrinca = dados as! ItemOrcamentoTrinca
                let cell_s2 = (cell as! CelulaPedidoTrincaTableViewCell)
                cell_s2.texto.text = obtemString(itemOrcamentoTrinca.idTexto)
                cell_s2.numero.text = "\(itemOrcamentoTrinca.sequencia)"
                cell_s2.sim_ou_nao.text = itemOrcamentoTrinca.quantidade == 0 ? "Não" : "Sim"
                cell_s2.quantidade.text = "\(itemOrcamentoTrinca.quantidade)"
                
                cell_s2.imagem_sim.image = itemOrcamentoTrinca.checkListAprovado != nil && itemOrcamentoTrinca.checkListAprovado! ? imageCheckVerde : imageCheckCinza
                cell_s2.imagem_nao.image = itemOrcamentoTrinca.checkListAprovado != nil && !itemOrcamentoTrinca.checkListAprovado! ? imageRemoveVermelho : imageRemoveCinza
                
                break
            case TipoItem.conclusao:
                let cell_e = (cell as! CelulaPedidoConclusaoTableViewCell)
                
                cell_e.botao_continuar.setImage(imagemAviaoPapel, for: UIControlState())
                
                break
            default:
                break
            }

        }
        else if dados is ItemHistoricoCalendario {
            
            let itemCalendario = dados as! ItemHistoricoCalendario

            cell = tableView.dequeueReusableCell(withIdentifier: "CelulaPedidoDatasTableViewCell", for: indexPath)
            
            let cell_p = (cell as! CelulaPedidoDatasTableViewCell)
            cell_p.indice_item.text = "\(itemCalendario.sequencia)"
            cell_p.texto_inicio.text = itemCalendario.inicio()
            cell_p.texto_fim.text = itemCalendario.fim()
            cell_p.imagem_calendario.image = imagemCalendario
            cell_p.imagem_inicio.image = imagemRelogio2
            cell_p.imagem_fim.image = imagemRelogio1
            cell_p.notificador = self.prossegueHistorico
            cell_p.permiteMarcarPonto = !(self.pedidoCancelado || self.pedidoFinalizado)
            cell_p.viewParaPopup = self
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
        else if dados is ItemAntesDepois /*Foto*/ {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "CelulaPedidoFotosTableViewCell", for: indexPath)
            
            let cell_f = (cell as! CelulaPedidoFotosTableViewCell)
            
            //let antes = cell_f.viewWithTag(1)!
            //let depois = cell_f.viewWithTag(2)!
            //antes.userInteractionEnabled = true
            //antes.addGestureRecognizer(tapAntes)
            //depois.userInteractionEnabled = true
            //depois.addGestureRecognizer(tapDepois)
            
            cell_f.defineItemFoto(dados as? ItemAntesDepois)
            cell_f.definePermiteNovaFoto(!(pedidoFinalizado || pedidoCancelado))
            cell_f.viewController = self
            cell_f.conclusaoFoto = uploadFoto
            cell_f.conclusaoExibir = exibeDetalheFoto
            
            cell_f.backgroundColor = self.corZebradoAtual()
        }
        else if dados is ConfiguracaoTinta {
            
            let configuracaoTinta = dados as! ConfiguracaoTinta
            
            cell = tableView.dequeueReusableCell(withIdentifier: "CelulaPedidoComplexaPinturaTableViewCell", for: indexPath)

            let cell_c = cell as! CelulaPedidoComplexaPinturaTableViewCell
            
            cell_c.label_pintura.text = "Pintura de " + configuracaoTinta.nomeItem!
            cell_c.label_cor.text = configuracaoTinta.cor.rawValue
            cell_c.label_tipo.text = configuracaoTinta.tipo.rawValue
            cell_c.label_acabamento.text = configuracaoTinta.acabamento.rawValue
            
            cell_c.imagem_fornece_tintas.image = configuracaoTinta.clienteForneceTintas ? self.imagemCheckMarcado : self.imagemCheckDesmarcado
            cell_c.imagem_nao_pintara.image = configuracaoTinta.naoPintara ? self.imagemCheckMarcado : self.imagemCheckDesmarcado
            
            cell_c.constraint_altura_painel_fornece_tintas.constant = configuracaoTinta.naoPintara ? 0.0 : 32.0
            cell_c.constraint_altura_painel_nao_pintara.constant = configuracaoTinta.exibeNaoPintara() ? 32.0 : 0.0
            
            cell_c.imagem_sim.image = configuracaoTinta.checklistAprovado != nil && configuracaoTinta.checklistAprovado! ? imageCheckVerde : imageCheckCinza
            cell_c.imagem_nao.image = configuracaoTinta.checklistAprovado != nil && !configuracaoTinta.checklistAprovado! ? imageRemoveVermelho : imageRemoveCinza
            
            cell_c.backgroundColor = self.corZebradoAtual()
            
        }
        else {
            cell = UITableViewCell()
            cell!.backgroundColor = self.corZebradoAtual()
        }
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SeguePedidoParaDetalheFoto" {
            
            let vc = segue.destination as! PedidoDetalheFotoViewController
            
            vc.defineContexto(self.contexto_detalhe_foto)
        }
    }
    
    func exibeDetalheFoto(_ antes: Bool, url: String?, imagem: UIImage?) {
        
        self.contexto_detalhe_foto = ContextoPedidoDetalheFoto()
        self.contexto_detalhe_foto?.titulo = antes ? "Foto antes" : "Foto depois"
        self.contexto_detalhe_foto?.urlImagem = url
        self.contexto_detalhe_foto?.imagem = imagem
        
        self.performSegue(withIdentifier: "SeguePedidoParaDetalheFoto", sender: self)
        
    }
    
    func uploadFoto(_ imagem:UIImage?, antes: Bool, sequencia: Int) {
        
        let imagemPequena = Imagem.ajustaTamanhoImagem(imagem!, scaledToSize: CGSize.init(width: 300, height: 200))
        let imagemGrande = Imagem.ajustaTamanhoImagem(imagem!, scaledToSize: CGSize.init(width: 1024, height: 768))
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_orcamento" : "\(contexto!.id_orcamento)" as AnyObject,
            "id_sequencia" : "\(sequencia)" as AnyObject,
            "id_franquia" : "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
            "antes_depois" : antes ? "antes" as AnyObject : "depois" as AnyObject,
            "formato" : "jpeg" as AnyObject
        ]
        
        api.inserirFoto(self.navigationController!.view, parametros: parametros, foto_pequena: imagemPequena, foto_grande: imagemGrande, sucesso: { (resultado:Bool, mensagem: String?) -> Bool in
            
            if resultado == false {
                AvisoProcessamento.mensagemErroGenerico("Falha ao enviar a imagem. Tente novamente mais tarde")
            }
            
            let item = ItemAntesDepois()
            
            self.itensPedido?.append(item)
            self.contexto?.sequencia += 1
            item.sequencia = self.contexto!.sequencia
            
            self.tableView.reloadData()
            
            return true
        });

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dados = itensPedido![indexPath.item]
        
        if dados is ItemOrcamento {
            
            let itemOrcamento = dados as! ItemOrcamento
            
            if (itemOrcamento.tipo == TipoItem.simples) {
                
                let itemOrcamentoSimples = itemOrcamento as! ItemOrcamentoSimples
                
                if itemOrcamentoSimples.exibeBotoesCheckList {
                    return 76.0
                }
                else {
                    return 76.0 - 32.0
                }
            }
            else if (itemOrcamento.tipo == TipoItem.complexo) {
                return 32.0
            }
            else if (itemOrcamento.tipo == TipoItem.complexoDetalhe) {
                
                let itemOrcamentoComplexo = itemOrcamento as! ItemOrcamentoComplexoDetalhe
                var altura : CGFloat = 232.0
                
                if !itemOrcamentoComplexo.exibeAltura {
                    altura -= 21.0
                }
                if !itemOrcamentoComplexo.exibeComprimento {
                    altura -= 21.0
                }
                if !itemOrcamentoComplexo.configuracaoMassaCorrida {
                    altura -= 21.0
                }
                
                return altura
            }
            else if (itemOrcamento.tipo == TipoItem.trinca) {
                return 110.0
            }
            else if (itemOrcamento.tipo == TipoItem.conclusao) {
                return 100.0
            }

        }
        else if dados is ConfiguracaoTinta {
            
            let configuracaoTinta = dados as! ConfiguracaoTinta
            var altura : CGFloat = 212.0
            
            altura -= configuracaoTinta.naoPintara ? 32.0 : 0.0
            altura -= configuracaoTinta.exibeNaoPintara() ? 0.0 : 32.0

            return altura
        }
        else if dados is ItemHistoricoCalendario {
            return 44.0
        }
        else if dados is Cliente {
            return 348.0
        }
        else if dados is ItemAntesDepois /*Foto*/ {
            return 175.0
        }
        
        return 21.0
    }
    
    func novoItemPrincipal(_ itemPrincipal: ItemOrcamento?) -> Void {
        if itemPrincipal!.tipo != TipoItem.conclusao {
            itensPedido?.append(itemPrincipal!)
        }
        
    }
    func mudouItemPrincipal(_ itemPrincipal: ItemOrcamento?) -> Void {
        
    }
    func novoSubitem(_ itemPrincipal: ItemOrcamento?, subitem: ItemOrcamento?) -> Void {
        
        if contexto!.modoFinanceiro {
            
            if itemPrincipal!.tipo != TipoItem.conclusao {
                itensPedido?.append(subitem!)
            }
        }
        else {
            if subitem!.tipo != TipoItem.trincaDetalhe && subitem!.tipo != TipoItem.conclusao {
                itensPedido?.append(subitem!)
            }
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
        itensPedido?.append(configuracaoTinta!)
        
    }
    func selecionaMassaCorrida(_ itemOrcamento: ItemOrcamentoComplexoDetalhe?) -> Void {
        
    }
    func fimConfiguracaoTinta(_ itemOrcamentoComplexoDetalhe: ItemOrcamentoComplexoDetalhe?) -> Void {
        
        itensPedido?.append("fimConfiguracaoTinta" as AnyObject)
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
