//
//  FinanceiroDetalheViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 06/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class FinanceiroDetalheViewController : UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titulo_detalhe: UILabel!
    var listaItensDetalhe: [RecebimentoDetalhe]?
    var contexto: ContextoFinanceiro?
    var selecionado: RecebimentoDetalhe?
    
    func defineContexto(_ contexto: ContextoFinanceiro?) {
        self.contexto = contexto
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //listaReceberDetalhe = [["20/MAR", "#792567", "R$ 519,00", 1], ["02/MAR", "#158634", "R$ 200,28", 2]]
        
        if contexto != nil {
            
            self.navigationItem.title = "Financeiro"
            
            titulo_detalhe.text = contexto?.tipoRecebimento == TipoRecebimento.recebido ? "Recebido" : contexto?.tipoRecebimento == TipoRecebimento.aReceber ? "A receber" : "Cancelados";
            
            ///////////////////////////////////////////////////////////////////
            
            let api = PinturaAJatoApi()
            
            let tipo = contexto?.tipoRecebimento == TipoRecebimento.recebido ? "recebido" : contexto?.tipoRecebimento == TipoRecebimento.aReceber ? "receber" : "cancelado";
            
            let parametros: [String:AnyObject] = [
                "id_franquia" : String.init(format:"%d", (PinturaAJatoApi.obtemFranqueado()?.id_franquia)!) as AnyObject,
                "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
                "mes" : (contexto?.recebimento?.mes)! as AnyObject,
                "ano" : (contexto?.recebimento?.ano)! as AnyObject
            ]
            
            api.financeiroDetalhe(self.navigationController!.view, tipo:tipo, parametros:parametros, sucesso: { (objeto: [RecebimentoDetalhe]?, tipo: String?, resultado: Bool) -> Bool in
                
                self.listaItensDetalhe = objeto
                
                return true
            })

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UITableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listaItensDetalhe == nil {
            return 0
        }
        
        return listaItensDetalhe!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String
        var cell: CelulaFinanceiroDetalheTableViewCell?
        
        cellIdentifier = "CelulaFinanceiroDetalheTableViewCell"
        
        cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CelulaFinanceiroDetalheTableViewCell)
        
        let dados: RecebimentoDetalhe = listaItensDetalhe![indexPath.item]
        
        cell!.mes.text = dados.periodo
        cell!.pedido.text = dados.pedido
        cell!.valor.text = Valor.floatParaMoedaString(dados.total!)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selecionado = listaItensDetalhe![indexPath.item]
        
        self.performSegue(withIdentifier: "SegueFinanceiroDetalheParaPedido", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueFinanceiroDetalheParaPedido" {
            
            //contexto?.recebimento = selecionado
            
            //let vc = segue.destinationViewController as! FinanceiroDetalheViewController
            
            //vc.defineContexto(contexto)
        }
    }
}
