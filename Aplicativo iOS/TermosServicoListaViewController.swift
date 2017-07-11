//
//  TermosServicoListaViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class TermosServicoListaViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var listaTermos: [AnyObject] = [
        ["Política de Privacidade", "https://www.pinturaajato.com/uploads/termos/politica_privacidade.pdf"] as AnyObject,
        ["Termos de Uso", "https://www.pinturaajato.com/uploads/termos/termos_uso.pdf"] as AnyObject
    ]

    var selecionado: [String]?
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String
        var cell: CelulaManualListaTableViewCell?
        
        cellIdentifier = "SimpleTableCell"
        
        cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CelulaManualListaTableViewCell)
        
        let dados: [String] = listaTermos[indexPath.item] as! [String]
        
        cell!.descricao.text = dados[0]
        
        var cor: UIColor?, corFundo: UIColor?
        var nome_icone:String?
        
        //if (dados.id_tipo_manual == 1) {
        //    cor = self.corAzulClaro()
        //    nome_icone = "book"
        //}
        //else if (dados.id_tipo_manual == 2) {
            cor = self.corLaranja()
            nome_icone = "legal"
        //}
        //else if (dados.id_tipo_manual == 3) {
        //    cor = self.corCinzaBullet()
        //    nome_icone = "facetime-video"
        //}
        
        if indexPath.item % 2 == 0 {
            corFundo = self.corZebradoPar()
            cell!.backgroundColor = self.corZebradoPar()
        }
        else {
            corFundo = self.corZebradoImpar()
            cell!.backgroundColor = self.corZebradoImpar()
        }
        cell!.imageView!.image = self.iconeLista(nome_icone, cor: cor, corFundo: corFundo)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        selecionado = (listaTermos[indexPath.row] as! [String])        

        self.performSegue(withIdentifier: "SegueTermosListaParaExibicao", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        return listaTermos.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueTermosListaParaExibicao" {
            
            let contexto = ContextoTermosExibir()
            
            contexto.url = selecionado![1]
            
            let vc = segue.destination as! TermosServicoExibirDocumentoViewController
            
            vc.defineContexto(contexto)
            
        }
    }
}
