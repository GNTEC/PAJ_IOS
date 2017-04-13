//
//  OrcamentoPrincipalViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 18/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit
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


public enum OpcoesSelecaoTrinca {
    case duplicar
    case adicionar
    case excluir
}

public enum OpcoesSelecaoComplexa {
    case duplicar
    case selecionarCor
    case paredeAvulsa
    case adicionar
    case excluir
    case tetoAvulso
    case ambienteCompleto
    case adicionarAmbienteCompleto
}

class OrcamentoPrincipalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NotificaOrcamentoMudou {
    //@IBOutlet weak var botao_continuar: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var itensOrcamento = [AnyObject]()
    var modalView = [UIView!]()
    
    var orcamento: Orcamento?
    var contexto: ContextoOrcamento?
    var contadorZebrado: Int = 0
    var persisteAoSair = true
    
    let ALTURA_VIEW_NAO_VISIVEL : CGFloat = 0.0
    let ALTURA_VIEW_DADOS : CGFloat  = 53.0
    let ALTURA_PAINEL_DADOS : CGFloat = 460.0
    
    let ALTURA_BOTAO_DUPLICAR : CGFloat = 48.0
    let ALTURA_BOTAO_COR : CGFloat = 48.0
    let ALTURA_BOTAO_PAREDE_AVULSA: CGFloat = 72.0
    let ALTURA_BOTAO_TETO_AVULSO : CGFloat = 72.0
    let ALTURA_BOTAO_AMBIENTE_COMPLETO : CGFloat = 72.0
    let ALTURA_BOTAO_ADICIONAR : CGFloat = 48.0
    let ALTURA_BOTAO_EXCLUIR : CGFloat = 48.0

    let ALTURA_MAXIMA_CELULA_DETALHE_COMPLEXO : CGFloat = 470.0
    // tamanho máximo sem ocultar nenhum campo do painel com as medidas (altura, largura, etc)
    let ALTURA_MAXIMA_PAINEL_MEDIDAS : CGFloat = 460.0
    // mesma coisa para os botões
    let ALTURA_MAXIMA_PAINEL_BOTOES : CGFloat = 408.0

    func defineContexto(_ contexto: ContextoOrcamento?) {
        self.contexto = contexto
    }
    
    /*override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            persisteOrcamentoParcial()
        }
    }*/
    
    /*func persisteOrcamentoParcial() {
        
        if !persisteAoSair {
            return
        }
        
        atualizaOrcamentoComCopias()
        
        let jsonOrcamento = orcamento?.gerarConteudoApiInsercao(PinturaAJatoApi.obtemFranqueado()!.id_franquia)
        
        if jsonOrcamento != nil {
            //do {
                
                //let json = try NSJSONSerialization.dataWithJSONObject(jsonOrcamento!, options: NSJSONWritingOptions.PrettyPrinted)
                let chave = String(format: "orcamento_%d", contexto!.id_cliente)
                
                let defaults = NSUserDefaults.standardUserDefaults()
                    
                defaults.setObject(jsonOrcamento, forKey: chave)
                defaults.synchronize()
                
            //}
            //catch {
            //    AvisoProcessamento.mensagemErroGenerico("Falha persistindo orçamento parcial")
            //}
        }
    }*/
    
    func atualizaOrcamentoComCopias() {
        
        // TODO avaliar a necessidade aqui no swift
        
        // Os itens nos fragmentos são cópias, atualiza o orçamento com os dados digitados

        /*FragmentManager fragmentManager = getSupportFragmentManager();
         
         for (Fragment fragment:
         fragmentManager.getFragments()) {
         
         if(fragment instanceof OrcamentoPrincipalCelulaComplexaDetalhe) {
         
         OrcamentoPrincipalCelulaComplexaDetalhe fragmentOrcamento = (OrcamentoPrincipalCelulaComplexaDetalhe)fragment;
         
         ItemOrcamento itemOrcamento = orcamento!.buscaItemOrcamentoPorIndice(fragmentOrcamento.getIndiceItemOrcamento());
         
         itemOrcamento.copiaDados(fragmentOrcamento.getItemOrcamento());
         }
         else if (fragment instanceof OrcamentoPrincipalCelulaTrincaDetalhe) {
         
         OrcamentoPrincipalCelulaTrincaDetalhe fragmentOrcamento = (OrcamentoPrincipalCelulaTrincaDetalhe)fragment;
         
         ItemOrcamento itemOrcamento = orcamento!.buscaItemOrcamentoPorIndice(fragmentOrcamento.getIndiceItemOrcamento());
         
         itemOrcamento.copiaDados(fragmentOrcamento.getItemOrcamento());
         
         }
         }*/
    }
    
    func onInteracaoCelulas(_ item: ItemOrcamentoSimples) {
        
        if orcamento!.eSelecaoTipoPintura(item) {
            
            let tipoPintura = TipoPintura(rawValue: item.itemSelecionado!)
            
            orcamento!.selecionaPintura(tipoPintura!)
        }
        
        orcamento!.selecionouOpcaoSimples(item)
    }
    
    func onInteracaoCelulas(_ item: ItemOrcamentoTrinca) {
        
        let possuiTrinca = item.itemSelecionado == ("true");
            
        orcamento!.selecionouPossuiTrinca(possuiTrinca);
        
    }
    
    func onInteracaoCelulas(_ opcao: OpcoesSelecaoTrinca, item: ItemOrcamentoTrincaDetalhe) {
        
        switch (opcao) {
        case OpcoesSelecaoTrinca.duplicar:
            orcamento!.duplicarItemOrcamento(item);
            break;
        case OpcoesSelecaoTrinca.excluir:
            orcamento!.excluirSubitemOrcamento(item);
            break;
        case OpcoesSelecaoTrinca.adicionar:
            orcamento!.novoDetalheTrinca(item);
            break;
        }
    }
    
    func onInteracaoCelulas(_ opcao: OpcoesSelecaoComplexa, itemOrcamento: ItemOrcamentoComplexoDetalhe) {
        
        switch (opcao) {
        case OpcoesSelecaoComplexa.selecionarCor:
            DispatchQueue.main.async(execute: {
                    self.orcamento!.selecionaCores(itemOrcamento);
                });
            break;
        case OpcoesSelecaoComplexa.adicionar:
            orcamento!.novoDetalheComplexo(itemOrcamento, tipoDetalheComplexo: TipoDetalheComplexo.Ambiente);
            break;
        case OpcoesSelecaoComplexa.paredeAvulsa:
            orcamento!.novoDetalheComplexo(itemOrcamento, tipoDetalheComplexo: TipoDetalheComplexo.ParedeAvulsa);
            break;
        case OpcoesSelecaoComplexa.duplicar:
            orcamento!.duplicarItemOrcamento(itemOrcamento);
            break;
        case OpcoesSelecaoComplexa.excluir:
            orcamento!.excluirSubitemOrcamento(itemOrcamento);
            break;
        case OpcoesSelecaoComplexa.tetoAvulso:
            orcamento!.novoDetalheComplexo(itemOrcamento, tipoDetalheComplexo: .TetoAvulso)
            break;
        case OpcoesSelecaoComplexa.ambienteCompleto:
            orcamento!.novoDetalheComplexo(itemOrcamento, tipoDetalheComplexo: .AmbienteCompleto)
            break;
        case OpcoesSelecaoComplexa.adicionarAmbienteCompleto:
            orcamento!.novoDetalheComplexo(itemOrcamento, tipoDetalheComplexo: .AmbienteCompleto)
            break;
        }
        
    }
    
    
    @IBAction func onEscolheCor(_ sender: AnyObject) {

    }
    
    @IBAction func onAjuda(_ sender: AnyObject) {
        let alert = UIAlertController(title: "O que deseja fazer ?", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Ligar para o SAC", style: .default, handler: {(action: UIAlertAction) -> Void in
        })
        alert.addAction(action1)
        let action2 = UIAlertAction(title: "FAQ - Perguntas e Respostas", style: .default, handler: {(action: UIAlertAction) -> Void in
        })
        alert.addAction(action2)
//        let action3 = UIAlertAction(title: "Receber uma Ligação", style: .Default, handler: {(action: UIAlertAction) -> Void in
//            let subAlert = UIAlertView(title: "", message: "Entraremos em contato o mais rápido possível", delegate: nil, cancelButtonTitle: "Ok")
//            subAlert.show()
//        })
//        alert.addAction(action3)
        let action4 = UIAlertAction(title: "Cancelar", style: .cancel, handler: {(action: UIAlertAction) -> Void in
        })
        alert.addAction(action4)
        self.present(alert, animated: true, completion: {() -> Void in
        })
    }
    
    let ID_ORCAMENTO_INVALIDO: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // refazendo orçamento ?
        var id_orcamento : Int = ID_ORCAMENTO_INVALIDO
        
        if contexto?.id_orcamento_inicial != nil {
            id_orcamento = contexto!.id_orcamento_inicial!
        }
        else if contexto?.id_orcamento_editar != nil {
            id_orcamento = contexto!.id_orcamento_editar!
        }
        
        let novoOrcamento = id_orcamento == ID_ORCAMENTO_INVALIDO
        
        if novoOrcamento {
            
            Registro.registraAcessoTela("Principal", atributos: [ "orcamento":"novo" as AnyObject])

            // Verifica se existe um orçamento armazenado para este cliente...
            //let defaults = NSUserDefaults.standardUserDefaults()
            
            //let chave = String(format: "orcamento_%d", contexto!.id_cliente);
            
            //let dados = defaults.objectForKey(chave) as! Dictionary<String, AnyObject>?
            
            contexto!.id_orcamento_inicial = nil;
            contexto!.id_orcamento_editar = nil;
            
            //if(dados == nil) {
                // Não tem nada armazenado....
                orcamento = Orcamento.criaNovoOrcamento(self);
                orcamento!.adicionaOrcamentoInicial();
                orcamento!.id_cliente = (contexto!.id_cliente);
                
                itensOrcamento.append(ItemOrcamentoConclusao())
            /*}
            else {
                
                //Registro.registraDebug("Orçamento:JSON:L", dados);
                
                //final Gson gson = new Gson();
                
                let orcamentoGerado = OrcamentoGerado(JSON: dados!)
                
                ////////////////////////////////////////////////////////////////////////////////////////

                NSUserDefaults.standardUserDefaults().removeObjectForKey(chave)

                ////////////////////////////////////////////////////////////////////////////////////////

                orcamento = Orcamento.recriaOrcamentoGerado(orcamentoGerado!, notificaOrcamentoMudou: self, parcial: true);
                orcamento?.id_cliente = contexto!.id_cliente
                
                ////////////////////////////////////////////////////////////////////////////////////////

                
                orcamento?.rechamaNotificacoes(self, resultadoCalculo: nil);
                
            }*/
        }
        else {
            
            Registro.registraAcessoTela("Principal", atributos: [ "orcamento":"refazer" as AnyObject , "id_orcamento": "\(id_orcamento)" as AnyObject])

            let api = PinturaAJatoApi()
            
            let parametros: [String:AnyObject] = [
                "id_orcamento": "\(id_orcamento)" as AnyObject,
                "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
            ]
            
            api.buscarOrcamentoPorId(self.navigationController!.view, parametros: parametros, sucesso: { (objeto, falha) -> Bool in
                
                self.orcamento = Orcamento.recriaOrcamentoGerado(objeto!.orcamento!, notificaOrcamentoMudou: self, parcial: false)
                self.orcamento!.id_cliente = self.contexto!.id_cliente
                
                if self.contexto?.id_orcamento_editar != nil {
                    self.orcamento!.id = self.contexto!.id_orcamento_editar!
                }
                
                self.orcamento?.rechamaNotificacoes(self, resultadoCalculo: nil)
                
                self.tableView.reloadData()
                
                return true
            })

        }
        
        // Qualquer coisa a partir deste ponto deve considerar a chamada assíncrona da carga do
        // orçamento
        
        title = "Orçamento"
        
        //botao_continuar.setImage(UIImage(icon: "icon-check", backgroundColor: self.corLaranja(), iconColor: UIColor.whiteColor(), iconScale: 1.0, andSize: CGSizeMake(32, 32)), forState: .Normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itensOrcamento.count
    }
    
    
    func obtemTipoCelula(_ tipo: TipoItem) -> String? {
        
        var id_celula: String? = nil
        
        switch tipo {
        case TipoItem.complexo:
            id_celula = "CelulaOrcamentoPrincipalComplexaTableViewCell"
            break
        case TipoItem.complexoDetalhe:
            id_celula = "CelulaOrcamentoPrincipalComplexaDetalheTableViewCell"
            break
        case TipoItem.conclusao:
            id_celula = "CelulaOrcamentoPrincipalConclusaoTableViewCell"
            break
        case TipoItem.simples:
            id_celula = "CelulaOrcamentoPrincipalSimplesTableViewCell"
            break
        case TipoItem.trinca:
            id_celula = "CelulaOrcamentoPrincipalTrincaTableViewCell"
            break
        case TipoItem.trincaDetalhe:
            id_celula = "CelulaOrcamentoPrincipalTrincaDetalheTableViewCell"
            break
        }
        
        return id_celula
    }
    
    func corZebradoAtual() -> UIColor {
        return  (contadorZebrado % 2 == 0) ? corZebradoPar() : corZebradoImpar();
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dados = itensOrcamento[indexPath.item]
        var cell: UITableViewCell
        
        if dados is ItemOrcamento {
        
            let itemOrcamento = dados as! ItemOrcamento
            
            contadorZebrado = 0
            
            for indice in 0...indexPath.item {
                
                let item = itensOrcamento[indice] as! ItemOrcamento
                
                if (item.tipo != TipoItem.complexoDetalhe && item.tipo != TipoItem.complexo && item.tipo != TipoItem.trincaDetalhe) {
                    contadorZebrado += 1
                }
            }
            
            let corFundo = corZebradoAtual();
        
            let id_celula = obtemTipoCelula(itemOrcamento.tipo)
            
            cell = tableView.dequeueReusableCell(withIdentifier: id_celula!, for: indexPath)
            
            switch itemOrcamento.tipo {
            case TipoItem.simples:
                let itemSimples = itemOrcamento as! ItemOrcamentoSimples
                
                let cell_o = (cell as! CelulaOrcamentoPrincipalSimplesTableViewCell)
                
                let imagem1 = itemSimples.botoes![0].imagem_nao_selecionado!
                let imagem2 = itemSimples.botoes![1].imagem_nao_selecionado!
                let imagem3 = itemSimples.botoes?.count > 2 ? itemSimples.botoes![2].imagem_nao_selecionado : nil
                let imagemSelecionada1 = itemSimples.botoes![0].imagem_selecionado!
                let imagemSelecionada2 = itemSimples.botoes![1].imagem_selecionado!
                let imagemSelecionada3 = itemSimples.botoes?.count > 2 ? itemSimples.botoes![2].imagem_selecionado : nil
                cell_o.botao1.setImage(UIImage(named: imagem1)!, for: UIControlState())
                cell_o.botao1.setImage(UIImage(named: imagemSelecionada1)!, for: .selected)
                cell_o.botao2.setImage(UIImage(named: imagem2)!, for: UIControlState())
                cell_o.botao2.setImage(UIImage(named: imagemSelecionada2)!, for: .selected)
                if !(imagem3 == nil) {
                    cell_o.botao3.setImage(UIImage(named: imagem3!)!, for: UIControlState())
                    cell_o.botao3.setImage(UIImage(named: imagemSelecionada3!)!, for: .selected)
                }
                else {
                    cell_o.botao3.setImage(nil, for: UIControlState())
                    cell_o.botao3.setImage(nil, for: .selected)
                    cell_o.botao3.setTitle("", for: UIControlState())
                    cell_o.botao3.setTitle("", for: .selected)
                }
                cell_o.texto1.text = self.obtemString(itemSimples.botoes![0].idTexto)
                cell_o.texto2.text = self.obtemString(itemSimples.botoes![1].idTexto)
                cell_o.texto3.text = itemSimples.botoes?.count > 2 ? self.obtemString(itemSimples.botoes![2].idTexto) : nil
                cell_o.indice.text = "\(itemSimples.sequencia)"
                cell_o.descricao.text = itemSimples.texto()
                cell_o.defineItemOrcamento(itemSimples)
                
                cell_o.interacao = { (item: ItemOrcamentoSimples?) -> Void in
                    self.onInteracaoCelulas(item!)
                }
                
                cell_o.backgroundColor = corFundo
                break;
                
            case TipoItem.complexo:
                
                let itemComplexo = itemOrcamento as! ItemOrcamentoComplexo
                let cell_t = (cell as! CelulaOrcamentoPrincipalComplexaTableViewCell)
                cell_t.label_indice.text = itemComplexo.exibeSequencia ? "\(itemComplexo.sequencia)" : nil;
                cell_t.label_nome_item.text = itemComplexo.texto()?.replacingOccurrences(of: "\n", with: " ")
                cell_t.backgroundColor = corFundo
                break
                
            case TipoItem.complexoDetalhe:
                
                let itemComplexoDetalhe = itemOrcamento as! ItemOrcamentoComplexoDetalhe
                let cell_cd = (cell as! CelulaOrcamentoPrincipalComplexaDetalheTableViewCell)
                cell_cd.defineItemOrcamento(itemComplexoDetalhe)

                cell_cd.nome_item.text  = itemComplexoDetalhe.texto()
                
                
                cell_cd.edit_altura.isHidden = !itemComplexoDetalhe.exibeAltura
                cell_cd.label_altura.isHidden = !itemComplexoDetalhe.exibeAltura
                cell_cd.constraint_altura_altura.constant = itemComplexoDetalhe.exibeAltura ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL
                
                cell_cd.edit_comprimento.isHidden = !itemComplexoDetalhe.exibeComprimento
                cell_cd.label_comprimento.isHidden = !itemComplexoDetalhe.exibeComprimento
                cell_cd.constraint_altura_comprimento.constant = itemComplexoDetalhe.exibeComprimento ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL
                
                cell_cd.edit_quantidade_portas.isHidden = !itemComplexoDetalhe.exibeQuantidadePortas
                cell_cd.label_portas.isHidden = !itemComplexoDetalhe.exibeQuantidadePortas
                cell_cd.constraint_altura_portas.constant = itemComplexoDetalhe.exibeQuantidadePortas ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL
                
                cell_cd.edit_quantidade_janelas.isHidden = !itemComplexoDetalhe.exibeQuantidadeJanelas
                cell_cd.label_janelas.isHidden = !itemComplexoDetalhe.exibeQuantidadeJanelas
                cell_cd.constraint_altura_janelas.constant = itemComplexoDetalhe.exibeQuantidadeJanelas ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL
                
                cell_cd.edit_quantidade_interruptores.isHidden = !itemComplexoDetalhe.exibeQuantidadeInterruptores
                cell_cd.label_interruptores.isHidden = !itemComplexoDetalhe.exibeQuantidadeInterruptores
                cell_cd.constraint_altura_interruptores.constant = itemComplexoDetalhe.exibeQuantidadeInterruptores ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL
                
                cell_cd.edit_obs.isHidden = !itemComplexoDetalhe.exibeObs
                cell_cd.label_obs.isHidden = !itemComplexoDetalhe.exibeObs
                cell_cd.constraint_altura_obs.constant = itemComplexoDetalhe.exibeObs ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL
                
                cell_cd.constraint_altura_painel_dados.constant = ALTURA_PAINEL_DADOS - (!itemComplexoDetalhe.exibeAltura ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL) - (!itemComplexoDetalhe.exibeComprimento ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL) - (!itemComplexoDetalhe.exibeQuantidadePortas ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL) - (!itemComplexoDetalhe.exibeQuantidadeJanelas ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL) - (!itemComplexoDetalhe.exibeQuantidadeInterruptores ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL) - (!itemComplexoDetalhe.exibeObs ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL)

                cell_cd.botao_excluir.isHidden = !itemComplexoDetalhe.exibeBotaoExcluir
                
                cell_cd.botao_teto_avulso.isHidden = !itemComplexoDetalhe.exibeBotaoTetoAvulso
                cell_cd.constraint_altura_botao_teto_avulso.constant = itemComplexoDetalhe.exibeBotaoTetoAvulso ? ALTURA_BOTAO_TETO_AVULSO : 0.0;

                cell_cd.botao_ambiente_completo.isHidden = !itemComplexoDetalhe.exibeBotaoAmbienteCompleto
                cell_cd.constraint_altura_botao_ambiente_completo.constant = itemComplexoDetalhe.exibeBotaoAmbienteCompleto ? ALTURA_BOTAO_AMBIENTE_COMPLETO : 0.0;

                cell_cd.botao_parede_avulsa.isHidden = !itemComplexoDetalhe.exibeBotaoParedeAvulsa
                cell_cd.constraint_altura_botao_parede_avulsa.constant = itemComplexoDetalhe.exibeBotaoParedeAvulsa ? ALTURA_BOTAO_PAREDE_AVULSA : 0.0

                cell_cd.interacao = { (item: ItemOrcamentoComplexoDetalhe?, acao: OpcoesSelecaoComplexa) -> Void in
                    self.onInteracaoCelulas(acao, itemOrcamento: item!)
                }
                cell_cd.interacaoNomeAmbiente = { (item:ItemOrcamentoComplexoDetalhe?, novoNome: String?) -> Void in
                    self.orcamento?.mudouNomeAmbiente(item!, novoNome: novoNome!)
                }
                cell_cd.backgroundColor = UIColor.clear

                break
                
            case TipoItem.trinca:
                
                let itemTrinca =  itemOrcamento as! ItemOrcamentoTrinca
                let cell_t = (cell as! CelulaOrcamentoPrincipalTrincaTableViewCell)
                cell_t.descricao.text = itemOrcamento.texto()
                cell_t.indice.text = itemOrcamento.exibeSequencia ? "\(itemOrcamento.sequencia)" : nil;
                cell_t.defineItemOrcamento(itemTrinca)
                cell_t.interacao = { (item: ItemOrcamentoTrinca?) -> Void in
                    self.onInteracaoCelulas(item!)
                }
                cell_t.backgroundColor = corFundo

                break
                
            case TipoItem.trincaDetalhe:
                
                let itemTrincaDetalhe = itemOrcamento as! ItemOrcamentoTrincaDetalhe
                let cell_td = (cell as! CelulaOrcamentoPrincipalTrincaDetalheTableViewCell)
                cell_td.label_nome_item.text = itemOrcamento.texto()
                cell_td.adicionaPickerAmbiente(self.view)
                cell_td.defineItemOrcamento(itemTrincaDetalhe)

                cell_td.interacao = { (item: ItemOrcamentoTrincaDetalhe?, acao: OpcoesSelecaoTrinca) -> Void in
                    self.onInteracaoCelulas(acao, item: item!)
                }
                cell_td.backgroundColor = corFundo

                break
            case TipoItem.conclusao:
                let cell_c = (cell as! CelulaOrcamentoPrincipalConclusaoTableViewCell)
                let size: CGSize = CGSize(width: 30, height: 30)
                let image = UIImage(icon:"icon-check", backgroundColor: UIColor.clear, iconColor: UIColor.white, iconScale: 1.0, andSize: size)
                cell_c.botao_continuar.setImage(image, for: UIControlState())
                cell_c.botao_continuar.addTarget(self, action: #selector(self.onContinuar(_:)), for: .touchUpInside)
                break
            }
        }
        else {
            cell = UITableViewCell()
        }
        
        return cell
    }
    
    // remove todos os fragments de trinca detalhe
    func removeItemDetalhe(_ itemOrcamentoRemover: ItemOrcamento) {
    
        let index = itensOrcamento.index { (item: AnyObject) -> Bool in
            
            if item is ItemOrcamentoTrincaDetalhe {

                let itemTrincaDetalhe = item as! ItemOrcamentoTrincaDetalhe
                
                if(itemTrincaDetalhe.indice == itemOrcamentoRemover.indice) {
                    return true
                }
                
            }
            else if(item is ItemOrcamentoComplexoDetalhe) {
                
                let itemCelulaComplexa = item as! ItemOrcamentoComplexoDetalhe
                
                if itemCelulaComplexa.indice == itemOrcamentoRemover.indice {
                    return true;
                }
            }
            
            return false
        }

        itensOrcamento.remove(at: index!)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dados = itensOrcamento[indexPath.item]
        
        if dados is ItemOrcamento {
        
            let itemOrcamento = dados as! ItemOrcamento
            
            switch itemOrcamento.tipo  {
            case TipoItem.simples:
                return 130.0
            case TipoItem.complexo:
                return 44.0
            case TipoItem.complexoDetalhe:
                let itemComplexoDetalhe = itemOrcamento as! ItemOrcamentoComplexoDetalhe
                
                let altura_altura = (!itemComplexoDetalhe.exibeAltura ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL)
                let altura_comprimento = (!itemComplexoDetalhe.exibeComprimento ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL)
                let altura_portas =  (!itemComplexoDetalhe.exibeQuantidadePortas ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL)
                let altura_janelas = (!itemComplexoDetalhe.exibeQuantidadeJanelas ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL)
                let altura_interruptores =  (!itemComplexoDetalhe.exibeQuantidadeInterruptores ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL)
                let altura_obs = (!itemComplexoDetalhe.exibeObs ? ALTURA_VIEW_DADOS : ALTURA_VIEW_NAO_VISIVEL)
                
                var altura_botoes : CGFloat = ALTURA_BOTAO_DUPLICAR + ALTURA_BOTAO_COR + ALTURA_BOTAO_ADICIONAR;
                
                altura_botoes += itemComplexoDetalhe.exibeBotaoTetoAvulso ? ALTURA_BOTAO_TETO_AVULSO : 0.0
                altura_botoes += itemComplexoDetalhe.exibeBotaoAmbienteCompleto ? ALTURA_BOTAO_AMBIENTE_COMPLETO :0.0
                altura_botoes += itemComplexoDetalhe.exibeBotaoExcluir ? ALTURA_BOTAO_EXCLUIR : 0.0
                altura_botoes += itemComplexoDetalhe.exibeBotaoParedeAvulsa ? ALTURA_BOTAO_PAREDE_AVULSA : 0.0

                // Calcula a altura, como se o painel das medidas fosse o maior
                var altura = ALTURA_MAXIMA_CELULA_DETALHE_COMPLEXO - altura_altura - altura_comprimento - altura_portas - altura_janelas - altura_interruptores

                // Se a altura do painel de medidas for menor que a do painel de botões, define a do painel de botões como a altura
                if altura < (altura_botoes + (ALTURA_MAXIMA_CELULA_DETALHE_COMPLEXO - ALTURA_MAXIMA_PAINEL_MEDIDAS)) {
                    altura = (altura_botoes + (ALTURA_MAXIMA_CELULA_DETALHE_COMPLEXO - ALTURA_MAXIMA_PAINEL_MEDIDAS))
                }
                
                return altura

            case TipoItem.trinca:
                return 132.0
            case TipoItem.trincaDetalhe:
                return 190.0
            case TipoItem.conclusao:
                return 100.0
            }
        }

        return 44.0
    }
    
    func moveConclusaoParaFim() {
        
        let index = itensOrcamento.index(where: { (item:AnyObject) -> Bool in
            return item is ItemOrcamentoConclusao
        })
        
        if index != nil && index != itensOrcamento.endIndex {
            
            let item = itensOrcamento.remove(at: index!)
            itensOrcamento.append(item)
        }
    }
    
    @IBAction func onContinuar(_ sender: AnyObject) {
        //let indice = self.navigationController!.viewControllers.count - 3
        //let vc = self.navigationController!.viewControllers[indice]
        //self.navigationController!.popToViewController(vc, animated: true)!
        
        atualizaOrcamentoComCopias()
        
        orcamento?.validaNotificaOrcamentoValido()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueOrcamentoPrincipalParaConfirmacao" {
            
            let vc = segue.destination as! OrcamentoConfirmacaoViewController
            
            vc.defineContexto(self.contexto)
        }
    }
    
    func buscaPosicaoItemComPai(_ tipoDetalheComplexo: TipoDetalheComplexo, indiceItemOrcamentoPai: Int?) -> Int? {
        
        var velhoIndice = itensOrcamento.index { (item:AnyObject) -> Bool in
            
            if !(item is ItemOrcamentoComplexoDetalhe) {
                return false
            }
            
            let itemOrcamentoComplexoDetalhe = item as! ItemOrcamentoComplexoDetalhe
            
            if itemOrcamentoComplexoDetalhe.indice == indiceItemOrcamentoPai {
                return true
            }
            
            return false
        }
        
        var novoIndice = velhoIndice?.advanced(by: 1)
        
        while novoIndice < itensOrcamento.count {
            
            let novoItem = itensOrcamento[novoIndice!]
            
            if novoItem is ItemOrcamentoComplexoDetalhe {
                
                let itemOrcamentoComplexoDetalhe = novoItem as! ItemOrcamentoComplexoDetalhe
                
                // Item é um outro ambiente, adiciona antes dele
                if itemOrcamentoComplexoDetalhe.tipoDetalheComplexo != tipoDetalheComplexo {
                    return novoIndice
                }
            }
            else {
                
                // Item não é ambiente nem avulso, velho indice é o pai, adiciona depois dele
                return novoIndice
            }
            
            velhoIndice = novoIndice
            novoIndice = novoIndice?.advanced(by: 1)
        }
        
        return novoIndice
    }
    
    func buscaPosicaoNovoItem(_ tipo: TipoItem) -> Int? {
        
        if tipo == TipoItem.complexoDetalhe {
            
            let indiceRaiz = itensOrcamento.index(where: { (item:AnyObject) -> Bool in
                
                return item is ItemOrcamentoComplexo;
            })
            
            var indiceDetalhes = itensOrcamento.index(where: { (item:AnyObject) -> Bool in
                return item is ItemOrcamentoComplexoDetalhe
            })
            
            // Não tem nenhum detalhe, retorna o raiz (se houver)
            if indiceDetalhes == nil {
                return indiceRaiz?.advanced(by: 1)
            }

            // Busca o último raiz
            var proximo = indiceDetalhes!.advanced(by: 1)
            
            while proximo < itensOrcamento.count {
                
                let item = itensOrcamento[proximo]
                
                if !(item is ItemOrcamentoComplexoDetalhe) {
                    return indiceDetalhes!.advanced(by: 1)
                }
                
                indiceDetalhes = proximo
                proximo = indiceDetalhes!.advanced(by: 1)
            }
            
            return indiceDetalhes?.advanced(by: 1)
        }
        else if tipo == TipoItem.trincaDetalhe {
            
            let indiceRaiz = itensOrcamento.index(where: { (item:AnyObject) -> Bool in
                
                return item is ItemOrcamentoTrinca;
            })
            
            var indiceDetalhes = itensOrcamento.index(where: { (item:AnyObject) -> Bool in
                return item is ItemOrcamentoTrincaDetalhe
            })
            
            // Não tem nenhum detalhe, retorna o raiz (se houver)
            if indiceDetalhes == nil {
                return indiceRaiz?.advanced(by: 1)
            }
            
            // Busca o último raiz
            var proximo = indiceDetalhes!.advanced(by: 1)
            
            while proximo < itensOrcamento.count {
                
                let item = itensOrcamento[proximo]
                
                if !(item is ItemOrcamentoTrincaDetalhe) {
                    return indiceDetalhes?.advanced(by: 1)
                }
                
                indiceDetalhes = proximo
                proximo = indiceDetalhes!.advanced(by: 1)
            }
            
            return indiceDetalhes?.advanced(by: 1)
        }
        
        return nil
    }
    
    func novoItemPrincipal(_ itemPrincipal: ItemOrcamento?) -> Void {
        
        var mudou = true
        
        switch itemPrincipal!.tipo {
        case TipoItem.simples:
            itensOrcamento.append(itemPrincipal!)
            break
        case TipoItem.complexo:
            itensOrcamento.append(itemPrincipal!)
            break
        case TipoItem.trinca:
            itensOrcamento.append(itemPrincipal!)
            break
        case TipoItem.conclusao:
            itensOrcamento.append(itemPrincipal!)
            break
        default:
            mudou = false
            break
        }
        
        if mudou {
            moveConclusaoParaFim()
            tableView.reloadData()
        }
        
    }
    
    func mudouItemPrincipal(_ itemPrincipal: ItemOrcamento?) -> Void {
        
        // Houve a mudança do tipo de pintura (Teto, Paredes e Paredes e Teto)
        if itemPrincipal?.tipo == TipoItem.complexo {
            
            // Move a conclusão para o  fim
            moveConclusaoParaFim()
            
            // Reflete a descrição da célula
            // TODO avaliar se é necessário a tabela toda
            tableView.reloadData()
        }
        
    }
    func novoSubitem(_ itemPrincipal: ItemOrcamento?, subitem: ItemOrcamento?) -> Void {
        
        if subitem?.tipo == TipoItem.complexoDetalhe || subitem?.tipo == TipoItem.trincaDetalhe {
            
            var itemOrcamentoPai: ItemOrcamento? = nil
            
            // Verifica se está adicionando uma Parede Avulsa. Se for possui um item pai
            if subitem is ItemOrcamentoComplexoDetalhe {
                
                let itemOrcamentoComplexoDetalhe = subitem as! ItemOrcamentoComplexoDetalhe
                
                if itemOrcamentoComplexoDetalhe.tipoDetalheComplexo == .ParedeAvulsa || itemOrcamentoComplexoDetalhe.tipoDetalheComplexo == .TetoAvulso {
                    itemOrcamentoPai = itemOrcamentoComplexoDetalhe.itemOrcamentoPai
                }
            }
            
            if itemOrcamentoPai == nil {
            
                let index = buscaPosicaoNovoItem(subitem!.tipo)
            
                itensOrcamento.insert(subitem!, at: index!)
            }
            else if itemOrcamentoPai != nil && subitem is ItemOrcamentoComplexoDetalhe {

                let itemOrcamentoComplexoDetalhe = subitem as! ItemOrcamentoComplexoDetalhe

                // Tem um item pai, neste caso temos que adicionar depois do item pai ou depois da última parede avulsa depois do pai
                let index = buscaPosicaoItemComPai(itemOrcamentoComplexoDetalhe.tipoDetalheComplexo, indiceItemOrcamentoPai:  itemOrcamentoPai?.indice)
                
                itensOrcamento.insert(subitem!, at: index!)
            }
            
            tableView.reloadData()
        }
    }
    func removeSubitem(_ subitem: ItemOrcamento?) -> Void {
        
        if subitem?.tipo == TipoItem.complexoDetalhe || subitem?.tipo == TipoItem.trincaDetalhe {
            removeItemDetalhe(subitem!)
            
            tableView.reloadData()
        }
    }
    func selecionaCor(_ itemOrcamentoDetalhe: ItemOrcamento?, configuracaoTinta: ConfiguracaoTinta?) -> Bool {
        
        self.view.endEditing(true)
        
        let view_popup = (Bundle.main.loadNibNamed("OrcamentoEscolhaTintaPopup", owner: self, options: nil)?[0] as! UIView)
        
        view_popup.center = self.navigationController!.view.center
        let a_frame = self.navigationController!.view.frame
        /*a_frame.origin.x += 10;
         a_frame.origin.y += 10;
         a_frame.size.height -= 20;
         a_frame.size.width -= 20;*/
        view_popup.frame = a_frame
        
        let popup = view_popup as! OrcamentoEscolhaTintaPopup
        
        popup.configuracaoTinta = configuracaoTinta!
        
        self.navigationController!.view.addSubview(view_popup)
        
        self.modalView.append(view_popup)
        
        return true
    }
    
    func mudouOrcamentoValido(_ valido: Bool, listaErros: [ItemErroOrcamento]?) -> Void {
        
        if(!valido) {
            
            var mensagem = ""
            var agrupandoNaoPreenchido = false, agrupandoNaoSelecionado = false
            var ambiente: String? = nil
            
            for erro in listaErros! {
                
                if ambiente == nil || !(ambiente == erro.ambiente) {
                    ambiente = erro.ambiente
                    mensagem += "\n" + ambiente! + "\n";
                    agrupandoNaoPreenchido = false;
                    agrupandoNaoSelecionado = false;
                }
                
                if erro.tipoErroOrcamento == TipoErroOrcamento.invalido {
                    mensagem += erro.descricao! + "\n"
                    agrupandoNaoPreenchido = false;
                    agrupandoNaoSelecionado = false;
                }
                else if erro.tipoErroOrcamento == TipoErroOrcamento.naoPreenchido {
                    
                    if(!agrupandoNaoPreenchido) {
                        mensagem += "\nNão preenchido(s):\n"
                        agrupandoNaoPreenchido = true;
                    }
                    
                    mensagem += erro.descricao! + "\n"
                    
                    agrupandoNaoSelecionado = false;
                }
                else if erro.tipoErroOrcamento == TipoErroOrcamento.naoSelecionado {
                    
                    if(!agrupandoNaoSelecionado) {
                        mensagem += "\nNão selecionado(s):\n"
                        agrupandoNaoSelecionado = true;
                    }
                    
                    mensagem += erro.descricao! + "\n"
                    
                    agrupandoNaoPreenchido = false;
                }
            }
            
            let alert = UIAlertController(title: "Erros no orçamento", message: mensagem, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                // nada por enquanto
            }))
            
            self.present(alert, animated: true, completion: { 
                // nada
            })
            
        }
        else {
            
            persisteAoSair = false
            
            self.performSegue(withIdentifier: "SegueOrcamentoPrincipalParaConfirmacao", sender: self)
        }
        
    }
    func novaConfiguracaoTinta(_ itemOrcamentoComplexoDetalhe: ItemOrcamentoComplexoDetalhe?, configuracaoTinta: ConfiguracaoTinta?) -> Void {
        // não deve ser usado neste fluxo
    }
    func selecionaMassaCorrida(_ itemOrcamento: ItemOrcamentoComplexoDetalhe?) -> Void {
        
        let view_popup = (Bundle.main.loadNibNamed("OrcamentoEscolhaMassaCorridaPopup", owner: self, options: nil)?[0] as! UIView)
        
        view_popup.center = self.navigationController!.view.center
        let a_frame = self.navigationController!.view.frame
        /*a_frame.origin.x += 10;
         a_frame.origin.y += 10;
         a_frame.size.height -= 20;
         a_frame.size.width -= 20;*/
        view_popup.frame = a_frame
        
        let popup = view_popup as! OrcamentoEscolhaMassaCorridaPopup
        
        popup.defineItemOrcamento(itemOrcamento)
        
        self.navigationController!.view.addSubview(view_popup)
        
        self.modalView.append(view_popup)

    }
    func fimConfiguracaoTinta(_ itemOrcamentoComplexoDetalhe: ItemOrcamentoComplexoDetalhe?) -> Void {
    }
    func notificaErro(_ mensagem: String?, mensagemTecnica: String?) -> Void {
        AvisoProcessamento.mensagemErroGenerico(mensagem, mensagemTecnica: mensagemTecnica)
    }
    func listaAmbienteMudou(_ novoNome: String?, textoAlternativo: String?, id_texto: String?, sequencia: Int, listaAmbientes: [ItemAmbienteTrinca]?) -> Void {

        if(itensOrcamento.count == 0) {
            return;
        }

        var i = 0

        for item in itensOrcamento {
            
            if(!(item is ItemOrcamentoTrincaDetalhe)) {
                continue;
            }
            
            let itemTrincaDetalhe = item as! ItemOrcamentoTrincaDetalhe

            itemTrincaDetalhe.novaListaAmbientes(listaAmbientes, novoNome: novoNome, nomeAntigo: textoAlternativo, id_texto: id_texto, sequencia: sequencia);
            
            let itemVelho = ItemAmbienteTrinca(textoAlternativo: textoAlternativo, id_texto: id_texto, sequencia: sequencia)

            if itemTrincaDetalhe.itemAmbiente!.equals(itemVelho) {

                let indexPath = IndexPath.init(item: i, section: 0)

                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)

            }

            i += 1
        }
        
    }
    
    func mudouSequenciaDetalheComplexo(_ itemOrcamentoDetalheAjustar: ItemOrcamentoComplexoDetalhe, novaSequencia: Int, antigaSequencia: Int) {

        var i = 0
        
        for item in itensOrcamento {
            
            if item is ItemOrcamentoComplexoDetalhe {
                
                let itemOrcamentoDetalhe = item as! ItemOrcamentoComplexoDetalhe
                
                if itemOrcamentoDetalhe.sequencia == novaSequencia {
                    
                    let indexPath = IndexPath.init(item: i, section: 0)
                    
                    self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    
                    break
                }
            }
            
            i += 1
        }
    }
    
    func mudouSequenciaTrincaDetalhe(_ itemOrcamentoTrincaDetalhe: ItemOrcamentoTrincaDetalhe, novaSequencia: Int, antigaSequencia: Int) {
        
        var i = 0;
        
        for item in itensOrcamento {
            
            if item is ItemOrcamentoTrincaDetalhe {
                
                let itemOrcamentoDetalhe = item as! ItemOrcamentoTrincaDetalhe
                
                if (itemOrcamentoDetalhe.sequencia == antigaSequencia) {
                    
                    let indexPath = IndexPath.init(item: i, section: 0)
                    
                    self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    
                    break;
                }
            }
            
            i += 1;
            
        }
    }

    func mudouNomeAmbiente(_ itemOrcamentoAtualizado: ItemOrcamentoComplexoDetalhe) {

        var i = 0;

        for item in itensOrcamento {

            if item is ItemOrcamentoComplexoDetalhe {

                let itemOrcamentoDetalhe = item as! ItemOrcamentoComplexoDetalhe

                if (itemOrcamentoDetalhe.indice == itemOrcamentoAtualizado.indice) {

                    itemOrcamentoDetalhe.atualizaNomeAmbienteOuSequencia(itemOrcamentoAtualizado.texto(), novaSequencia: 0)

                    let indexPath = IndexPath.init(item: i, section: 0)

                    self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)

                    break;
                }
            }

            i += 1;

        }

    }
}
