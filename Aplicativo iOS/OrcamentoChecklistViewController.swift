//
//  OrcamentoChecklistViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 17/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import UIKit

class OrcamentoChecklistViewController: UITableViewController, NotificaOrcamentoMudou {

    @IBOutlet weak var label_valor_total: UILabel!
    @IBOutlet weak var label_data_pedido: UILabel!

    var itensChecklist: [AnyObject]? = [AnyObject]()
    var imageCheckVerde: UIImage!
    var imageRemoveVermelho: UIImage!
    var imageCheckCinza: UIImage!
    var imageRemoveCinza: UIImage!
    //var imagemBucket: UIImage!
    //var imagemBucketDesativado: UIImage!
    
    var imagemCheckMarcado: UIImage!
    var imagemCheckDesmarcado: UIImage!
    var contexto: ContextoOrcamento?
    var contexto_pedido: ContextoPedido?
    var contexto_novo_orcamento: ContextoOrcamento?
    var orcamento: Orcamento?
    var contadorZebrado: Int = 0
    
    func defineContexto(_ contexto: ContextoOrcamento?) {
        self.contexto = contexto
    }
    
    func aprovarCheckist() {
        
        let franqueado = PinturaAJatoApi.obtemFranqueado()
        
        let jsonObject = self.orcamento!.gerarConteudoApiChecklist(franqueado!.id_franquia)
        
        if jsonObject == nil {
            AvisoProcessamento.mensagemErroGenerico("Falha gerando o orçamento. Entre em contato com o suporte.")
            return
        }
        
        let api = PinturaAJatoApi()
        
        api.incluirCheckList(self.view, parametros: jsonObject!, sucesso: { (resultado: Resultado?) -> Bool in
          
            AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: resultado?.mensagem, destino: { 
                self.prossegueExecucao()
            })
            return true
        })
    }
    
    func prossegueExecucao() {
        
        self.contexto_pedido = ContextoPedido()
        
        self.contexto_pedido!.id_orcamento = contexto!.id_orcamento
        
        self.performSegue(withIdentifier: "SegueOrcamentoChecklistParaPedido", sender: self)
    }
    
    
    func prossegueReprovarOrcamento(_ id_pedido: Int, motivo: String?) {
        
        /*let contexto_financeiro = ContextoFinanceiro()
        
        contexto_financeiro.id_orcamento = contexto!.id_orcamento
        contexto_financeiro.id_pedido = orcamento!.id_pedido
        contexto_financeiro.valorPagamento = contexto!.valorPagamento!
        contexto_financeiro.voltarHistorico = true
        
        let storyboard = UIStoryboard(name: "Financeiro", bundle: nil)
        
        let vc = storyboard.instantiateViewControllerWithIdentifier("FinanceiroCancelarViewController") as! FinanceiroCancelarViewController
        
        vc.defineContexto(contexto_financeiro)
        
        self.navigationController?.pushViewController(vc, animated: true)*/
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_franquia" : "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
            "id_orcamento": "\(contexto!.id_orcamento)" as AnyObject,
            "id_pedido" : "\(id_pedido)" as AnyObject,
            //"motivo" : motivo == nil ? "" : motivo
            "motivo" : motivo as AnyObject
        ]
        
        api.getNet(self.navigationController!.view, tipo: "cancelamento", parametros: parametros) { (objeto, resultado) -> Bool in
         
            AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: resultado?.mensagem, destino: {
                self.navigationController!.popViewController(animated: true)
            })
            
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCheckVerde = self.iconeQuadrado("ok", cor: UIColor.white, corFundo: self.corVerdeCheck(), tamanho: 32)
        imageRemoveVermelho = self.iconeQuadrado("remove", cor: UIColor.white, corFundo: self.corVermelhoRemove(), tamanho: 32)
        imageCheckCinza = self.iconeQuadrado("ok", cor: UIColor.white, corFundo: self.corCinzaFundoBullet(), tamanho: 32)
        imageRemoveCinza = self.iconeQuadrado("remove", cor: UIColor.white, corFundo: self.corCinzaFundoBullet(), tamanho: 32)
        
        imagemCheckMarcado = self.iconeListaPequeno("check", cor: self.corCinzaBullet(), corFundo: UIColor.clear)
        imagemCheckDesmarcado = self.iconeListaPequeno("unchecked", cor: self.corCinzaBullet(), corFundo: UIColor.clear)


        self.navigationController!.setNavigationBarHidden(false, animated: true)
        
        ////////////////////////////////////////////////////////////////////////
        
        title = String(format:"Checklist #%06d", contexto!.id_orcamento)
        
        Registro.registraInformacao(.idOrcamento, valor: Int32(contexto!.id_orcamento))
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_orcamento" : "\(contexto!.id_orcamento)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.buscarOrcamentoPorId(self.navigationController!.view, parametros: parametros, sucesso: { (objeto:OrcamentoConsultaSaida?, falha:Bool) -> Bool in
            
            let orcamento = objeto!.orcamento!
            
            self.contexto?.id_cliente = orcamento.id_cliente
        
            self.orcamento = Orcamento.recriaOrcamentoGerado(orcamento, notificaOrcamentoMudou: self, parcial: false)
            
            if self.orcamento == nil {
            
                AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: "Houve um problema ao processar este item. Tente novamente mais tarde.", destino: { 
                    self.navigationController?.popViewController(animated: true)
                })
                
                return false
            }
            
            self.itensChecklist?.append(objeto!.cliente!)
            
            let dataDate = Data.dataJsonStringParaDate(orcamento.atualizacao)
            
            self.contexto!.valorPagamento = Float(orcamento.valor!)
            self.label_data_pedido.text = "Data do pedido: \(Data.dateParaStringDiaMes(dataDate!))"
            self.label_valor_total.text = "Valor Total: R$ \(Valor.floatParaMoedaString(Float(orcamento.valor!)!))"
            
            let resultadoCalculo = ResultadoCalculo()
            
            if orcamento.dias_servico != nil {
                resultadoCalculo.diasTotal = Int(orcamento.dias_servico!)!
            }
            resultadoCalculo.valorTotal = Float(orcamento.valor!)!
            
            self.orcamento?.rechamaNotificacoes(self, resultadoCalculo: resultadoCalculo)
            
            self.tableView.reloadData()
            
            return true
        } )
        
        //let botao = self.tableView.tableFooterView?.subviews.first as! UIButton
        
        //botao.targetForAction(#selector(onConfirmar), withSender: self)
        //botao.actionsForTarget(self, forControlEvent: UIControlEvents.TouchUpInside)
    }
    
    func onConfirmar(_ sender: AnyObject) {
        
            let alert = UIAlertController(title: "O que deseja fazer ?", message: nil, preferredStyle: .actionSheet)
            let action1 = UIAlertAction(title: "Aprovar Check-list", style: .default, handler: {(action: UIAlertAction) -> Void in
                self.aprovarCheckist()
            })
            alert.addAction(action1)
            let action2 = UIAlertAction(title: "Refazer Orçamento", style: .default, handler: {(action: UIAlertAction) -> Void in
                self.criaEntradaComTitulo("Descreva o motivo pelo qual você está refazendo o orçamento:", Destino: {(texto: String?) -> Void in
                    
                    self.prossegueRefazerOrcamento();
                })
            })
            alert.addAction(action2)
            let action3 = UIAlertAction(title: "Criar Novo Orçamento", style: .default, handler: {(action: UIAlertAction) -> Void in
                self.criaEntradaComTitulo("Descreva o motivo pelo qual você está criando um novo orçamento:", Destino: {(texto: String?) -> Void in
                    
                    self.prossegueNovoOrcamento()
                })
            })
            alert.addAction(action3)
            let action4 = UIAlertAction(title: "Reprovar", style: .default, handler: {(action: UIAlertAction) -> Void in
                self.criaEntradaComTitulo("Descreva o motivo da reprovação:", Destino: {(texto: String?) -> Void in
                    self.prossegueReprovarOrcamento(self.contexto!.id_orcamento, motivo: texto)
                })
            })
            alert.addAction(action4)
            let action5 = UIAlertAction(title: "Cancelar", style: .cancel, handler: {(action: UIAlertAction) -> Void in
                // Nada somente fechar
            })
            alert.addAction(action5)
            self.present(alert, animated: true, completion: {() -> Void in
            })
    }
    
    func prossegueRefazerOrcamento() {
        
        self.performSegue(withIdentifier: "SegueOrcamentoChecklistParaPrincipal", sender: self)
    }
    
    func prossegueNovoOrcamento() {

        self.contexto_novo_orcamento = ContextoOrcamento()
        self.contexto_novo_orcamento?.id_cliente = self.contexto!.id_cliente

        Orcamento.limpaOrcamento()
        
        self.performSegue(withIdentifier: "SegueOrcamentoChecklistParaPrincipalNovo", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueOrcamentoChecklistParaPedido" {
            
            let vc = segue.destination as! PedidoPrincipalViewController
            
            vc.defineContexto(self.contexto_pedido)
        }
        else if segue.identifier == "SegueOrcamentoChecklistParaPrincipal" {
            
            let vc = segue.destination as! OrcamentoPrincipalViewController
            
            self.contexto?.id_orcamento_inicial = self.contexto?.id_orcamento
            
            vc.defineContexto(self.contexto)
        }
        else if segue.identifier == "SegueOrcamentoChecklistParaPrincipalNovo" {
            
            let vc = segue.destination as! OrcamentoPrincipalViewController
            
            vc.defineContexto(self.contexto_novo_orcamento)
        }
    }

    func criaEntradaComTitulo(_ titulo: String, Destino pdestino: @escaping destino) {
        
        let modalView = (Bundle.main.loadNibNamed("GenericoEntradaTexto", owner: self, options: nil)?[0] as! GenericoEntradaTexto)
        //var vc = self.getViewController()
        modalView.center = self.view.center
        let a_frame = self.view.frame
        modalView.frame = a_frame
        modalView.defineTitulo(titulo)
        modalView.defineDestino(pdestino)
        self.navigationController!.view.addSubview(modalView)
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
        
        if itensChecklist == nil {
            return 0
        }
        
        return itensChecklist!.count
    }
    
    func obtemTipoCelula(_ tipo: TipoItem) -> String? {
        
        var id_celula: String? = nil
        
        switch tipo {
        case TipoItem.complexo:
            id_celula = "CelulaOrcamentoChecklistComplexaTableViewCell"
            break
        case TipoItem.complexoDetalhe:
            id_celula = "CelulaOrcamentoChecklistComplexaAmbienteTableViewCell"
            break
        case TipoItem.conclusao:
            id_celula = "CelulaOrcamentoChecklistConclusaoTableViewCell"
            break
        case TipoItem.simples:
            id_celula = "CelulaOrcamentoChecklistSimplesTableViewCell"
            break
        case TipoItem.trinca:
            id_celula = "CelulaOrcamentoChecklistTrincaTableViewCell"
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
        
        let dados = itensChecklist![indexPath.item]
        var cell: UITableViewCell? = nil
        
        if dados is ItemOrcamento {
            
            let itemOrcamento = dados as! ItemOrcamento
            
            let id_celula = obtemTipoCelula(itemOrcamento.tipo)
            
            if (itemOrcamento.tipo != TipoItem.complexoDetalhe && itemOrcamento.tipo != TipoItem.complexo) {
                contadorZebrado += 1;
            }
            
            let corFundo = corZebradoAtual();
            
            cell = tableView.dequeueReusableCell(withIdentifier: id_celula!, for: indexPath)
            
            cell!.backgroundColor = corFundo
            
            switch itemOrcamento.tipo {
                
            case TipoItem.simples:
                
                let itemOrcamentoSimples = itemOrcamento as! ItemOrcamentoSimples
                let cell_s = (cell as! CelulaOrcamentoChecklistSimplesTableViewCell)
                cell_s.texto.text = obtemString(itemOrcamentoSimples.textoSelecao())
                cell_s.numero.text = "\(itemOrcamento.sequencia)"
                
                cell_s.botao_sim.isHidden = !itemOrcamentoSimples.exibeBotoesCheckList
                cell_s.botao_nao.isHidden = !itemOrcamentoSimples.exibeBotoesCheckList

                cell_s.botao_sim.setImage(imageCheckVerde, for: .selected)
                cell_s.botao_sim.setImage(imageCheckCinza, for: UIControlState())
                cell_s.botao_nao.setImage(imageRemoveVermelho, for: .selected)
                cell_s.botao_nao.setImage(imageRemoveCinza, for: UIControlState())
                
                cell_s.itemOrcamento = itemOrcamentoSimples
                
                break
                
            case TipoItem.complexo:
                
                let itemOrcamentoComplexo = itemOrcamento as! ItemOrcamentoComplexo
                let cell_c = (cell as! CelulaOrcamentoChecklistComplexaTableViewCell)
                cell_c.texto.text = obtemString(itemOrcamentoComplexo.idTexto).replacingOccurrences(of: "\n", with: " ")
                //cell_c.numero.text = "\(itemOrcamentoComplexo.sequencia)"
                //cell_c.texto2.text = itemOrcamentoComplexo.
                break
                
            case TipoItem.complexoDetalhe:

                let itemOrcamentoAmbiente = itemOrcamento as! ItemOrcamentoComplexoDetalhe
                let cell_c = (cell as! CelulaOrcamentoChecklistComplexaAmbienteTableViewCell)
                
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

                cell_c.botao_sim.setImage(imageCheckVerde, for: .selected)
                cell_c.botao_sim.setImage(imageCheckCinza, for: UIControlState())
                cell_c.botao_nao.setImage(imageRemoveVermelho, for: .selected)
                cell_c.botao_nao.setImage(imageRemoveCinza, for: UIControlState())
                
                cell_c.itemOrcamento = itemOrcamentoAmbiente

                break
            case TipoItem.trinca:
                
                let itemOrcamentoTrinca = dados as! ItemOrcamentoTrinca
                let cell_s2 = (cell as! CelulaOrcamentoChecklistTrincaTableViewCell)
                cell_s2.texto.text = obtemString(itemOrcamentoTrinca.idTexto)
                cell_s2.numero.text = "\(itemOrcamentoTrinca.sequencia)"
                cell_s2.sim_ou_nao.text = itemOrcamentoTrinca.quantidade == 0 ? "Não" : "Sim"
                cell_s2.quantidade.text = "\(itemOrcamentoTrinca.quantidade)"
                
                cell_s2.botao_sim.setImage(imageCheckVerde, for: .selected)
                cell_s2.botao_sim.setImage(imageCheckCinza, for: UIControlState())
                cell_s2.botao_nao.setImage(imageRemoveVermelho, for: .selected)
                cell_s2.botao_nao.setImage(imageRemoveCinza, for: UIControlState())
                
                cell_s2.itemOrcamento = itemOrcamentoTrinca
                break
            case TipoItem.conclusao:

                let cell_c = (cell as! CelulaOrcamentoChecklistConclusaoTableViewCell)
                let size: CGSize = CGSize(width: 30, height: 30)
                let image = UIImage(icon:"icon-check", backgroundColor: UIColor.clear, iconColor: UIColor.white, iconScale: 1.0, andSize: size)
                cell_c.botao_continuar.setImage(image, for: UIControlState())
                cell_c.botao_continuar.addTarget(self, action: #selector(self.onConfirmar), for: .touchUpInside)
                break
            default:
                break
            }
        }
        else if dados is ConfiguracaoTinta {

            let configuracaoTinta = dados as! ConfiguracaoTinta
            
            cell = tableView.dequeueReusableCell(withIdentifier: "CelulaOrcamentoChecklistComplexaPinturaTableViewCell", for: indexPath)
            
            let cell_c = cell as! CelulaOrcamentoChecklistComplexaPinturaTableViewCell

            cell_c.label_pintura.text = "Pintura de " + configuracaoTinta.nomeItem!
            cell_c.label_cor.text = configuracaoTinta.cor.rawValue
            cell_c.label_tipo.text = configuracaoTinta.tipo.rawValue
            cell_c.label_acabamento.text = configuracaoTinta.acabamento.rawValue
            cell_c.imagem_fornece_tintas.image = configuracaoTinta.clienteForneceTintas ? self.imagemCheckMarcado : self.imagemCheckDesmarcado
            cell_c.imagem_nao_pintara.image = configuracaoTinta.naoPintara ? self.imagemCheckMarcado : self.imagemCheckDesmarcado
            
            cell_c.constraint_altura_painel_fornece_tintas.constant = configuracaoTinta.naoPintara ? 0.0 : 32.0
            cell_c.constraint_altura_painel_nao_pintara.constant = configuracaoTinta.exibeNaoPintara() ? 32.0 : 0.0
            
            cell_c.botao_sim.setImage(imageCheckVerde, for: .selected)
            cell_c.botao_sim.setImage(imageCheckCinza, for: UIControlState())
            cell_c.botao_nao.setImage(imageRemoveVermelho, for: .selected)
            cell_c.botao_nao.setImage(imageRemoveCinza, for: UIControlState())
            
            cell_c.configuracaoTinta = configuracaoTinta
         
            cell_c.backgroundColor = self.corZebradoAtual()
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
            
            cell!.backgroundColor = self.corZebradoAtual()
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dados = itensChecklist![indexPath.item]
        
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
        else if dados is Cliente {
            return 348.0
        }
        
        return 21.0
    }
    
    func novoItemPrincipal(_ itemPrincipal: ItemOrcamento?) -> Void {
        itensChecklist!.append(itemPrincipal!)
        
        if itemPrincipal is ItemOrcamentoSimples {
            let itemSimples = itemPrincipal as! ItemOrcamentoSimples
            itemSimples.checkListAprovado = true
        }
        else if itemPrincipal is ItemOrcamentoComplexoDetalhe {
            let itemComplexoDetalhe = itemPrincipal as! ItemOrcamentoComplexoDetalhe
            itemComplexoDetalhe.checklistAprovado = true
        }
        else if itemPrincipal is ItemOrcamentoTrinca {
            let itemTrinca = itemPrincipal as! ItemOrcamentoTrinca
            itemTrinca.checkListAprovado = true
        }
    }
    func mudouItemPrincipal(_ itemPrincipal: ItemOrcamento?) -> Void {
        
    }
    func novoSubitem(_ itemPrincipal: ItemOrcamento?, subitem: ItemOrcamento?) -> Void {
        
        if subitem?.tipo != .trincaDetalhe {
            itensChecklist!.append(subitem!)
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
        
        configuracaoTinta?.checklistAprovado = true
        
        itensChecklist?.append(configuracaoTinta!)
    }
    func selecionaMassaCorrida(_ itemOrcamento: ItemOrcamentoComplexoDetalhe?) -> Void {
        
    }
    func fimConfiguracaoTinta(_ itemOrcamentoComplexoDetalhe: ItemOrcamentoComplexoDetalhe?) -> Void {
        itensChecklist?.append("" as AnyObject)
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
