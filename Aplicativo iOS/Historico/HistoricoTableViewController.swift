//
//  HistoricoTableViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 28/08/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
// The output below is limited by 4 KB.
// Upgrade your plan to remove this limitation.

class HistoricoTableViewController : UITableViewController {
    
    var itensHistorico = [OrcamentoDetalhe]()
    var imagemBucket: UIImage!
    var imagemBucketDesativado: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        //itensHistorico = [["25/JAN", "#098716", "R$ 1.320,50", 0], ["20/JAN", "#015976", "R$ 1.720,90", 4], ["16/JAN", "#064198", "R$ 1.480,20", 5], ["11/JAN", "#098716", "R$ 2.300,50", 3]]
        
        //imagemBucket = UIImage.imageWithIonicIcon("\u{f4d6}", backgroundColor: self.corCinzaFundoBullet(), iconColor: self.corLaranja(), iconScale: 1.0, andSize: CGSizeMake(20, 20))
        //imagemBucketDesativado = UIImage.imageWithIonicIcon("\u{f4d6}", backgroundColor: self.corCinzaFundoBullet(), iconColor: self.corCinzaBullet(), iconScale: 1.0, andSize: CGSizeMake(20, 20))
        
        imagemBucket = UIImage (named: "lata_colorida_pequena");
        imagemBucketDesativado = UIImage (named: "lata_cinza_pequena");
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let api = PinturaAJatoApi()
        
        let parametros: [String : AnyObject] = [
            "id_franquia": String(format:"%d",(PinturaAJatoApi.obtemFranqueado()?.id_franquia)!) as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
            "tipo_solicitacao" : "1" as AnyObject
        ]
        
        api.buscarOrcamentosCompletosPorFranquia(self.navigationController!.view, parametros: parametros) { (objeto, resultado) -> Bool in
            
            self.itensHistorico = objeto!
            
            self.tableView.reloadData()
            
            return true
        }
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
        return itensHistorico.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CelulaItemHistoricoTableViewCell", for: indexPath) as! CelulaItemHistoricoTableViewCell
        
        let dados = itensHistorico[indexPath.item]
        
        cell.contentView.backgroundColor = indexPath.item % 2 == 0 ? corZebradoPar() : corZebradoImpar();
        
        cell.data.text = dados.dataExibicao
        cell.numero.text = String.init(format:"%@#%06d", statusIdentificador(dados.status), dados.id)
        cell.valor.text = dados.valor
        
        let baldes = dados.avaliacao
        
        let exibeAvaliacao = dados.status == 3 || dados.status == 4;
        
        if !exibeAvaliacao {
            cell.imagem_bucket1.isHidden = true
            cell.imagem_bucket2.isHidden = true
            cell.imagem_bucket3.isHidden = true
            cell.imagem_bucket4.isHidden = true
            cell.imagem_bucket5.isHidden = true
        }
        else {
            cell.imagem_bucket1.isHidden = false
            cell.imagem_bucket2.isHidden = false
            cell.imagem_bucket3.isHidden = false
            cell.imagem_bucket4.isHidden = false
            cell.imagem_bucket5.isHidden = false
        
            cell.imagem_bucket1.image = (baldes > 0) ? imagemBucket : imagemBucketDesativado
            cell.imagem_bucket2.image = (baldes > 1) ? imagemBucket : imagemBucketDesativado
            cell.imagem_bucket3.image = (baldes > 2) ? imagemBucket : imagemBucketDesativado
            cell.imagem_bucket4.image = (baldes > 3) ? imagemBucket : imagemBucketDesativado
            cell.imagem_bucket5.image = (baldes > 4) ? imagemBucket : imagemBucketDesativado
        }
        
        return cell
    }
    
    func statusIdentificador(_ status: Int) -> String {
        
        if status == 1 {
            return "O";
        }
        else if (status == 2) {
            return "A";
        }
        else if (status == 3) {
            return "E";
        }
        else if (status == 4) {
            return "F"
        }
        else if (status == 5) {
            return "C";
        }
        else if (status == 6) {
            return "P";
        }
        
        return "";
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dados = itensHistorico[indexPath.item]
        
        if dados.status == 0 {
            AvisoProcessamento.mensagemErroGenerico("Não foi possível recuperar o item")
            return
        }
        
        var vc: UIViewController?
        let storyboard = UIStoryboard(name: "Orcamento", bundle: nil)
        
        if dados.status == 2 {
            
            let cvc = storyboard.instantiateViewController(withIdentifier: "OrcamentoChecklistViewController") as! OrcamentoChecklistViewController
            let contexto_orcamento = ContextoOrcamento()
            
            contexto_orcamento.id_orcamento = dados.id
            
            cvc.defineContexto(contexto_orcamento)
            
            vc = cvc
        }
        else {
            let pvc = storyboard.instantiateViewController(withIdentifier: "PedidoPrincipalViewController") as! PedidoPrincipalViewController
            let contexto_pedido = ContextoPedido()
            
            contexto_pedido.id_orcamento = dados.id
            
            pvc.defineContexto(contexto_pedido)
            
            vc = pvc
        }
        
        self.navigationController!.pushViewController(vc!, animated: true)
    }
}
