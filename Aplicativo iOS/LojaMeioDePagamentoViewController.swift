//
//  LojaMeioDePagamentoViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import UIKit

class LojaMeioDePagamentoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var botaoAdicionar: UIButton!
    
    var listaCartoes :[Cartao]?
    var selecionado: Cartao?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        botaoAdicionar!.setImage(self.iconeBotao("plus", cor: UIColor.white, corFundo: self.corLaranja()), for: UIControlState())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        consultaListaCartoes()
    }
    
    func consultaListaCartoes() {
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
    }
    
    // MARK: - UITableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listaCartoes == nil {
            return 0
        }
        
        return listaCartoes!.count
    }
    
    func efetivaRemover(_ cartao: Cartao?) {
        
        let mensagem = "Remover o cartão \(cartao!.nome!) final \(cartao!.numero!.substring(from: cartao!.numero!.characters.index(cartao!.numero!.endIndex, offsetBy: -4))) ?"
        
        let alert = UIAlertController.init(title:AvisoProcessamento.Titulo, message:mensagem, preferredStyle:UIAlertControllerStyle.alert);
        
        let actionCancelar = UIAlertAction.init(title:"Não", style:UIAlertActionStyle.default,
                                               handler: { (action: UIAlertAction) -> Void in
                                                
        })
        alert.addAction(actionCancelar)

        let actionRemover = UIAlertAction.init(title:"Sim", style:UIAlertActionStyle.destructive,
                                               handler:
            { (action: UIAlertAction) -> Void in
                             
                let api = PinturaAJatoApi()
                                                
                let parametros: [String:AnyObject] = [
                    "id" :  "\(cartao!.id!)" as AnyObject,
                    "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
                ]
                
                api.excluirCartao(self.navigationController!.view, parametros: parametros, sucesso: { (resultado: Resultado?) -> Bool in
                    
                    self.consultaListaCartoes()
                    
                    return true
                })
                
        })
        alert.addAction(actionRemover)
        
        self.present(alert, animated:true, completion:nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String
        var cell: CelulaLojaMeioDePagamentoCartaoTableViewCell?
        
        cellIdentifier = "SimpleTableCell"
        cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CelulaLojaMeioDePagamentoCartaoTableViewCell)
        
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
        
        cell!.imagemBandeira.image = self.iconeListaPequeno(icone_bandeira, cor: cor, corFundo: UIColor.white)
        cell!.nomeBandeira.text = dados.nome
        cell!.numCartao.text = dados.numero!.substring(from: dados.numero!.characters.index(dados.numero!.endIndex, offsetBy: -4))
        cell!.imagemEditar.image = self.iconeListaPequeno("remove", cor: self.corCinzaFundoBullet(), corFundo: UIColor.clear)
        cell!.efetivaRemover = efetivaRemover
        cell!.cartao = dados
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selecionado = listaCartoes![indexPath.item]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
