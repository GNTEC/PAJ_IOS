//
//  LojaResumoCompraViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit
class LojaResumoCompraViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var botaoAdicionar: UIButton!
    @IBOutlet weak var imagem_carrinho: UIImageView!
    @IBOutlet weak var imagem_produto: UIImageView!
    @IBOutlet weak var imagem_quantidade: UIImageView!
    @IBOutlet weak var imagem_valor_unitario: UIImageView!
    @IBOutlet weak var imagem_valor_total: UIImageView!
    @IBOutlet weak var imagem_valor_total2: UIImageView!
    @IBOutlet weak var imagem_valor_total3: UIImageView!
    @IBOutlet weak var label_valor: UILabel!
    
    var listaProdutos : [Produto]?
    var listaProdutosCalculo: [Produto]?
    
    var calculo: CalculoPedido?
    
    func defineProdutosSelecionados(_ listaProdutos: [Produto]?) {
        self.listaProdutos = listaProdutos
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        botaoAdicionar!.setImage(self.iconeBotao("thumbs-up", cor: UIColor.white, corFundo: UIColor.clear), for: UIControlState())
        self.imagem_carrinho.image = self.iconeQuadrado("shopping-cart", cor: UIColor.white, corFundo: UIColor.clear, tamanho: 30.0)
        let imagemUSD = self.iconeListaPequeno("usd", cor: self.corCinzaBullet(), corFundo: UIColor.white)
        self.imagem_valor_total.image = imagemUSD
        self.imagem_valor_total2.image = imagemUSD
        self.imagem_valor_total3.image = imagemUSD
        self.imagem_valor_unitario.image = imagemUSD
        self.imagem_quantidade.image = self.iconeListaPequeno("ellipsis-horizontal", cor: self.corCinzaBullet(), corFundo: UIColor.white)
        //self.imagem_produto.image = UIImage.imageWithIonicIcon("\u{f4d6}", backgroundColor: UIColor.whiteColor(), iconColor: self.corCinzaBullet(), iconScale: 1.0, andSize: CGSizeMake(24, 24))
        
        self.imagem_produto.image = UIImage.init(named: "lata_cinza_pequena")
        
        /*var valor : Float = 0.0
        
        for produto in listaProdutos! {
        
            let valor_float = Float(produto.valor!)!
            
            valor += valor_float * Float(produto.quantidade)
        }*/
        
        let api = PinturaAJatoApi()
        
        let parametros = geraJsonPedido(listaProdutos)
        
        api.loja(self.navigationController!.view, tipo: "calcular", parametros: parametros!, sucesso: { (objeto:CalculoPedido?, resultado:Resultado?) -> Bool in

            self.listaProdutosCalculo = objeto?.produtos
            
            self.label_valor.text = "R$ " + Valor.floatParaMoedaString(objeto!.valor_total!)
            
            self.tableview.reloadData()
            
            self.calculo = objeto
            
            return true
            })
        
    }
    
    
    func geraJsonPedido(_ produtos: [Produto]?) -> Dictionary<String, AnyObject>? {
        
        var raiz = Dictionary<String, AnyObject>();

        raiz["id_franquia"] = "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject?
        raiz["id_sessao"] = PinturaAJatoApi.obtemIdSessao() as AnyObject?
        
        var jsonArray = Array<Dictionary<String, AnyObject>>()
        
        for produto in produtos! {
                    
            var jsonObject = Dictionary<String, AnyObject>();
                    
            jsonObject["id"] = produto.id as AnyObject?
            jsonObject["quantidade"] = produto.quantidade as AnyObject?
                    
            jsonArray.append(jsonObject)
        }
                
        raiz["produtos"] = jsonArray as AnyObject?
        
        return raiz;
    }
    
    @IBAction func onConfirmar(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "SegueLojaCarrinhoParaFormaPagamento", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueLojaCarrinhoParaFormaPagamento" {
            
            let vc = segue.destination as! LojaPagamentoCompraViewController
            
            vc.defineContexto(listaProdutosCalculo, calculo: self.calculo)
        }
    }
    
    // MARK: - UITableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listaProdutosCalculo == nil {
            return 0
        }
        
        return listaProdutosCalculo!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String
        var cell: CelulaLojaResumoCompraTableViewCell?
        cellIdentifier = "SimpleTableCell"
        cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CelulaLojaResumoCompraTableViewCell)
        
        let dados = listaProdutosCalculo![indexPath.item]
        let valor_float = Float(dados.valor_unitario!)!
        
        cell?.activity_imagem_produto.startAnimating()
        cell?.imagemProduto.image = nil
        Imagem.carregaImagemUrlAssincrona(PinturaAJatoApi().obtemUrlFotoProduto(dados.imagem!), sucesso: { (imagem) in
            
            cell?.activity_imagem_produto.stopAnimating()
            if imagem == nil {
                return
            }
            
            cell?.imagemProduto.image = imagem
            
        }, falha: { (url) in })
        cell!.qtdProduto.text = "\(dados.quantidade)"
        cell!.valorUnitario.text = Valor.floatParaMoedaString(valor_float)
        cell!.valorTotal.text = Valor.floatParaMoedaString(dados.valor_total!)
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
