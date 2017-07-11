//
//  LojaProdutosViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit
class LojaProdutosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var botaoAdicionar: UIButton!
    
    var listaProdutos: [Produto]?
    var listaProdutosSelecionados: [Produto]?
    
    var imagemMaisVerde: UIImage!
    var imagemMenosVermelha: UIImage!
    var imagemContinuar: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //listaProdutos = [["img_fita", "Fita Crepe Scotch", "img_mais", "img_menos", "R$ 9.990,00", "img_confirmar", "2", 1, "Blue 3M 4x50cm"], ["img_papel", "Papel", "img_mais", "img_menos", "R$ 200,00", "img_confirmar", "5", 2, "Blue 3M 4x50cm"], ["img_tinta", "Tinta", "img_mais", "img_menos", "R$ 1.120,00", "img_confirmar", "10", 3, "Blue 3M 4x50cm"]]
        imagemMaisVerde = self.iconeQuadrado("plus", cor: UIColor.white, corFundo: self.corVerdeCheck(), tamanho: 36)
        imagemMenosVermelha = self.iconeQuadrado("minus", cor: UIColor.white, corFundo: self.corVermelhoRemove(), tamanho: 36)
        botaoAdicionar!.setImage(self.iconeBotao("signin", cor: UIColor.white, corFundo: self.corLaranja()), for: UIControlState())
        
        let api  = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_franquia" : String.init(format:"%d", PinturaAJatoApi.obtemFranqueado()!.id_franquia) as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.buscarProdutos(self.navigationController!.view, parametros:parametros, sucesso: { (objeto:[Produto]?, resultado:Bool) -> Bool in
            
            self.listaProdutos = objeto
            self.tableview.reloadData()
            
            return true
        })
    }
    
    
    @IBAction func onFinalizarCompra(_ sender: AnyObject) {
        
        var selecionado = false
        
        for produto in listaProdutos! {
            
            if produto.quantidade > 0 {
                selecionado = true
            }
        }
        
        if !selecionado {
            AvisoProcessamento.mensagemErroGenerico("Nenhum produto foi selecionado")
            return
        }
        
        listaProdutosSelecionados = [Produto]()
        
        for produto in listaProdutos! {
            
            if produto.quantidade > 0 {
                listaProdutosSelecionados?.append(produto)
            }
        }
        
        self.performSegue(withIdentifier: "SegueLojaProdutosParaCarrinho", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueLojaProdutosParaCarrinho" {
            
            let vc = segue.destination as! LojaResumoCompraViewController
            
            vc.defineProdutosSelecionados(listaProdutosSelecionados)
            
        }
    }
    
    // MARK: - UITableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listaProdutos == nil {
            return 0
        }
        
        return listaProdutos!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String
        var cell: CelulaLojaProdutosTableViewCell?
        cellIdentifier = "SimpleTableCell"
        cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CelulaLojaProdutosTableViewCell)
        
        let dados = listaProdutos![indexPath.item]
        
        let api = PinturaAJatoApi()
        cell!.activity_imagem_produto.startAnimating()
        cell!.imagemProduto.image = nil
        Imagem.carregaImagemUrlAssincrona(api.obtemUrlFotoProduto(dados.imagem!), sucesso: { (imagem) in
            
            cell!.activity_imagem_produto.stopAnimating()
            
            if imagem == nil {
                return
            }
            
            cell!.imagemProduto.image = imagem

        }, falha: { (url) in })
        
        cell!.descricaoProduto.text = dados.nome
        cell!.botao_mais.setImage(imagemMaisVerde, for: UIControlState())
        cell!.botao_menos.setImage(imagemMenosVermelha, for: UIControlState())
        cell!.valorUnitario.text = dados.valor
        
        //let imagem = UIImage(named: dados.imagem)
        //cell!.botaoConfirmar.imageView!.image = imagem
        
        cell!.botaoConfirmar.layer.borderColor = UIColor.darkGray.cgColor
        cell!.botaoConfirmar.layer.borderWidth = 1.0
        cell!.label_quantidade.layer.borderColor = UIColor.darkGray.cgColor
        cell!.label_quantidade.layer.borderWidth = 1.0
        cell!.valorUnitario.layer.borderColor = UIColor.darkGray.cgColor
        cell!.valorUnitario.layer.borderWidth = 1.0
        //cell!.descricaoQuantidade.text = dados[6]  as? String
        cell!.descricaoProduto2.text = dados.descricao
        
        cell!.produto = dados
        
        cell!.backgroundColor = indexPath.item % 2 == 0 ? corZebradoPar() : corZebradoImpar()
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
