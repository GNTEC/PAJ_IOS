//
//  LojaDetalhePedidoViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit

class LojaDetalhePedidoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var imagem_carrinho: UIImageView!
    @IBOutlet weak var imagem_calendario: UIImageView!
    @IBOutlet weak var valor_total: UILabel!
    @IBOutlet weak var label_data_compra: UILabel!
    
    var listaProdutos : [Produto]?
    var pedido: PedidoLoja?
    
    func definePedido(_ pedido: PedidoLoja?) {
        self.pedido = pedido
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagem_carrinho.image = self.iconeListaPequeno("shopping-cart", cor: UIColor.white, corFundo: self.corLaranja())
        self.imagem_calendario.image = self.iconeListaPequeno("calendar", cor: UIColor.white, corFundo: self.corLaranja())
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        let api = PinturaAJatoApi()

        let parametros : [String:AnyObject] = [
            "id_pedido" : "\(pedido!.id)" as AnyObject,
            "id_franquia": "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ];
        
        api.lojaBuscarDetalhe(self.navigationController!.view, parametros: parametros) { (objeto, resultado) -> Bool in
            
            self.valor_total.text = Valor.floatParaMoedaString(objeto!.pedido!.valor)
            self.label_data_compra.text = objeto?.pedido?.data_pedido
            
            self.listaProdutos = objeto!.produtos
            self.tableview.reloadData()
            
            return true
        }
        
    }
    // MARK: - UITableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listaProdutos == nil {
            return 0
        }
        
        return listaProdutos!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String
        var cell: CelulaLojaDetalhePedidoTableViewCell?
        cellIdentifier = "SimpleTableCell"
        cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!
            CelulaLojaDetalhePedidoTableViewCell)
        
        let dados = listaProdutos![indexPath.item]

        cell!.quantidade.text = "\(dados.quantidade)"
        cell!.valorUnitario.text = dados.valor_unitario != nil ? Valor.floatParaMoedaString(Float(dados.valor_unitario!)!) : ""
        cell!.valorTotal.text = Valor.floatParaMoedaString(dados.valor_total!)
        cell?.imagemProduto.image = nil
        Imagem.carregaImagemUrlAssincrona(PinturaAJatoApi().obtemUrlFotoProduto(dados.imagem!), sucesso: { (imagem) in
            
            if imagem == nil {
                return
            }
            
            cell?.imagemProduto.image = imagem
            
            }, falha: { (url) in })
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
