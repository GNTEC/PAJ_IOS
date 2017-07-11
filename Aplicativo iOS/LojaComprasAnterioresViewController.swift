//
//  LojaComprasAnterioresViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit
class LojaComprasAnterioresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableview: UITableView!
    
    var listaPedidos : [PedidoLoja]?
    var selecionado: PedidoLoja?

    override func viewDidLoad() {

        super.viewDidLoad()
        
        let api = PinturaAJatoApi();
        
        let parametros : [String:AnyObject] = [
            "id_franquia" : "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ];

        api.lojaBuscarPorFranquia(self.navigationController!.view, parametros: parametros) { (objeto, resultado) -> Bool in
            
            self.listaPedidos = objeto
            
            self.tableview.reloadData()
            
            return true
        }
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        

    }
    // MARK: - UITableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listaPedidos == nil {
            return 0
        }
        
        return listaPedidos!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String
        var cell: CelulaLojaComprasAnterioresTableViewCell?
        cellIdentifier = "SimpleTableCell"
        cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CelulaLojaComprasAnterioresTableViewCell)
        
        let dados: PedidoLoja = listaPedidos![indexPath.item]
        
        cell!.data.text = dados.data_pedido
        cell!.pedido.text = String(format: "#%06d", dados.id)
        cell!.valor.text = Valor.floatParaMoedaString(dados.valor)
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selecionado = listaPedidos![indexPath.item]
        
        self.performSegue(withIdentifier: "SegueLojaPedidoParaDetalhe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueLojaPedidoParaDetalhe" {
            
            let vc = segue.destination as! LojaDetalhePedidoViewController
            
            vc.definePedido(selecionado)
        }
    }
}
