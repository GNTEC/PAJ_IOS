//
//  FinanceiroListaViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 06/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class FinanceiroListaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var titulo_lista: UILabel!
    var listaItens: [Recebimento]?
    var contexto: ContextoFinanceiro?
    var selecionado: Recebimento?
    
    func defineContexto(_ contexto: ContextoFinanceiro?) {
        self.contexto = contexto
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contexto != nil {
            
            self.navigationItem.title = "Financeiro"
            
            titulo_lista.text = contexto?.tipoRecebimento == TipoRecebimento.recebido ? "Recebido" : contexto?.tipoRecebimento == TipoRecebimento.aReceber ? "A receber" : "Cancelados";
            
            ///////////////////////////////////////////////////////////////////
            
            let api = PinturaAJatoApi()
            let tipo = contexto?.tipoRecebimento == TipoRecebimento.recebido ? "recebido" : contexto?.tipoRecebimento == TipoRecebimento.aReceber ? "receber" : "cancelado";
            let parametros: [String:AnyObject] = [
                "id_franquia" : String.init(format:"%d", (PinturaAJatoApi.obtemFranqueado()?.id_franquia)!) as AnyObject,
                "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
            ]
            
            api.financeiro(self.navigationController!.view, tipo:tipo, parametros:parametros, sucesso: { (objeto: [Recebimento]?, tipo: String?, resultado: Bool) -> Bool in
                
                self.listaItens = objeto
                
                return true
            })
        }
        
    }
    // MARK: - UITableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listaItens == nil {
            return 0
        }
        
        return listaItens!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String
        var cell: CelulaFinanceiroListaTableViewCell?
        
        cellIdentifier = "SimpleTableCell"
        
        cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CelulaFinanceiroListaTableViewCell
        
        let dados: Recebimento = listaItens![indexPath.item]
        
        cell!.labelMes.text = dados.periodo
        cell!.labelValor.text = Valor.floatParaMoedaString(dados.total!)
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selecionado = listaItens![indexPath.item]

        self.performSegue(withIdentifier: "SegueFinanceiroListaParaDetalhe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueFinanceiroListaParaDetalhe" {
            
            contexto?.recebimento = selecionado
            
            let vc = segue.destination as! FinanceiroDetalheViewController
            
            vc.defineContexto(contexto)
        }
    }
}
