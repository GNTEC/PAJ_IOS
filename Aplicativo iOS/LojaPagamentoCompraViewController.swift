//
//  LojaPagamentoCompraViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit
class LojaPagamentoCompraViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var botaoAdicionar: UIButton!
    @IBOutlet weak var imagem_carrinho: UIImageView!
    @IBOutlet weak var label_valor: UILabel!
    
    var listaCartoes :[Cartao]?
    var selecionado: Cartao?
    
    var listaProdutos: [Produto]?
    var calculo: CalculoPedido?
    
    var pedido: PedidoLoja?
    
    func defineContexto(_ listaProdutos: [Produto]?, calculo: CalculoPedido?) {
        self.listaProdutos = listaProdutos
        self.calculo = calculo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagem_carrinho.image = self.iconeListaPequeno("shopping-cart", cor: UIColor.white, corFundo: self.corLaranja())
        
        let api = PinturaAJatoApi()
        
        let parametros:[String:AnyObject] = [
            "id_franquia" : String.init(format:"%d", PinturaAJatoApi.obtemFranqueado()!.id_franquia) as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.buscarCartoesPorFranquia(self.navigationController!.view, parametros: parametros, sucesso: { (objeto: [Cartao]?, resultado: Bool) -> Bool in
            
            self.listaCartoes = objeto
            self.tableview.reloadData()
            
            return true
        })
        
        /*var valor : Float = 0.0
        
        for produto in listaProdutos! {
            
            let valor_float = Float(produto.valor_unitario!)!
            
            valor += valor_float * Float(produto.quantidade)
        }*/
        
        label_valor.text = "R$ " + Valor.floatParaMoedaString(calculo!.valor_total!)
        
    }
    
    func prossegueEfetivarPedido(_ calculoPedido: CalculoPedido,  cartaoDeCredito: Cartao?) {
    
        let jsonObject = geraConteudoJsonEfetivarPedido(calculoPedido.produtos, id_cartao: cartaoDeCredito!.id, valor_total: calculoPedido.valor_total!, final_cartao: cartaoDeCredito!.numero);
    
        if ( jsonObject == nil ) {
            AvisoProcessamento.mensagemErroGenerico("Falha ao gerar a solicitação do pedido. Entre em contato com o suporte.");
            return;
        }
    
        ///////////////////////////////////////////////////////////////////////////////////////////
    
        let api = PinturaAJatoApi()
        
        api.lojaEfetivar(self.navigationController!.view, parametros: jsonObject!, sucesso:  { (objeto: PedidoLoja?, resultado: Resultado?) -> Bool in
            
            self.pedido = objeto
            
            self.performSegue(withIdentifier: "SegueCartaoParaConfirmacao", sender: self)
           
            return true;
        });
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "SegueCartaoParaConfirmacao" {
            
            let vc = segue.destination as! LojaComprovanteViewController
            
            vc.definePedido(self.pedido);
            
        }
    }
    
    func geraConteudoJsonEfetivarPedido(_ produtos: [Produto]? , id_cartao: String? , valor_total: Float, final_cartao: String?) -> Dictionary<String, AnyObject>? {
    
        var raiz = Dictionary<String, AnyObject>()
    
        raiz["id_cartao"] = id_cartao! as AnyObject?
        raiz["id_franquia"] =  PinturaAJatoApi.obtemFranqueado()!.id_franquia as AnyObject?
        raiz["id_sessao"] = PinturaAJatoApi.obtemIdSessao() as AnyObject?
        raiz["final_cartao"] = final_cartao! as AnyObject?
        raiz["valor_total"] = valor_total as AnyObject?
    
        var jsonArray = Array<Dictionary<String, AnyObject>>()
    
        for produto in produtos! {
    
            var jsonObject = Dictionary<String, AnyObject>()
    
            jsonObject["id"] = produto.id as AnyObject?
            jsonObject["quantidade"] = produto.quantidade as AnyObject?
            jsonObject["valor_unitario"] = produto.valor_unitario! as AnyObject?
            jsonObject["valor_total"] = produto.valor_total! as AnyObject?
    
            jsonArray.append(jsonObject)
            
        }
    
        raiz["produtos"] = jsonArray as AnyObject?
    
        return raiz;
    }
    
    // MARK: - UITableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listaCartoes == nil {
            return 0
        }
        
        return listaCartoes!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String
        var cell: CelulaLojaPagamentoCompraTableViewCell?
        cellIdentifier = "SimpleTableCell"
        cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CelulaLojaPagamentoCompraTableViewCell)
        
        let dados = listaCartoes![indexPath.item]
        var icone_bandeira: String?, cor : UIColor?
        
        if (dados.bandeira == "visa") {
            cor = self.corAzulVisa()
            icone_bandeira = "cc-visa"
        }
        else if dados.bandeira == "mastercard" || dados.bandeira == "master" {
            cor = self.corVermelhoMaster()
            icone_bandeira = "cc-mastercard"
        }
        else {
            cor = UIColor.black
            icone_bandeira = "barcode"
        }
        
        cell!.imagemCartao.image = self.iconeListaPequeno(icone_bandeira, cor: cor, corFundo: UIColor.clear)
        cell!.nomeCartao.text = dados.nome
        cell!.numCartao.text = dados.numero?.substring(from: dados.numero!.characters.index(dados.numero!.endIndex, offsetBy: -4))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selecionado = listaCartoes![indexPath.item]
        let endereco:Endereco = PinturaAJatoApi.obtemFranqueado()!.endereco_entrega!
        
        let mensagem = String.init(format:"O pedido será enviado para o endereço cadastrado em seu perfil:\n%@, %@\n Bairro %@ - %@/%@\nCEP %@\n\nE será cobrado em seu Cartão de Crédito com final %@", endereco.logradouro!, endereco.numero!, endereco.bairro!, endereco.cidade!, endereco.uf!, endereco.cep!, self.selecionado!.numero!.substring(from: self.selecionado!.numero!.characters.index(self.selecionado!.numero!.endIndex, offsetBy: -4)))
        
        
        let alert = UIAlertView(title: "", message: mensagem, delegate: self, cancelButtonTitle: "Cancelar")
        
        alert.addButton(withTitle: "Confirmar")
        alert.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            self.prossegueEfetivarPedido(self.calculo!, cartaoDeCredito: selecionado);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
