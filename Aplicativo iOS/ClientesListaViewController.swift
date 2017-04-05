//
//  ClientesListaViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 06/11/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class ClientesListaViewController : UITableViewController {
    
    var itensCliente: [Cliente]?
    var itemDetalhe: Cliente?
    
    override func viewDidLoad() {
        self.title = "Clientes"
        
        consultaListaClientes()
    }
    
    func consultaListaClientes() {
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_franquia" : "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.buscarClientesPorFranquia(self.navigationController!.view, parametros: parametros, sucesso: { (objeto: ClientesBuscarSaida?, resultado: Resultado?) -> Bool in
            
            self.itensCliente = objeto?.clientes
            
            self.tableView.reloadData()
            
            return true;
            });
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if itensCliente == nil {
            return 0
        }
        
        return itensCliente!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CelulaClientesListaTableViewCell", for: indexPath) as! CelulaClientesListaTableViewCell
        
        let dados = itensCliente![indexPath.item]
        
        cell.contentView.backgroundColor = indexPath.item % 2 == 0 ? corZebradoPar() : corZebradoImpar();
        
        cell.nome.text = dados.nome
        cell.numero.text = String.init(format:"#%06d", dados.id)
        cell.telefone.text = dados.telefone1
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemDetalhe = itensCliente![indexPath.item]
        
        self.performSegue(withIdentifier: "SegueClientesListaParaDetalhe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueClientesListaParaDetalhe" && itemDetalhe != nil {
            
            let vc = segue.destination as! ClienteDetalheViewController
            
            vc.defineIdCliente(itemDetalhe!.id)
        }
    }
}
