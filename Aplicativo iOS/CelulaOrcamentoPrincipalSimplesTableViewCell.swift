//
//  CelulaOrcamentoPrincipalSimplesTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 18/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

typealias interacaoSimples = (_ item: ItemOrcamentoSimples?) -> Void

import UIKit
class CelulaOrcamentoPrincipalSimplesTableViewCell: UITableViewCell {
    @IBOutlet weak var indice: UILabel!
    @IBOutlet weak var descricao: UILabel!
    @IBOutlet weak var texto1: UILabel!
    @IBOutlet weak var texto2: UILabel!
    @IBOutlet weak var texto3: UILabel!
    @IBOutlet weak var botao1: UIButton!
    @IBOutlet weak var botao2: UIButton!
    @IBOutlet weak var botao3: UIButton!
    @IBOutlet weak var botao_ajuda: UIButton!
    
    var itemOrcamento: ItemOrcamentoSimples?
    var interacao: interacaoSimples?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onBotaoAjuda(_ sender: AnyObject) {
        
        if itemOrcamento?.idTextoAjuda == nil {
            return;
        }
        
        let mensagem = self.obtemString(itemOrcamento?.idTextoAjuda);
        
        exibeAlerta(mensagem, textoBotao: "Fechar");
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var view = self.superview
        
        while view != nil && !(view is UITableView) {
            view = view?.superview
        }
        
        view?.endEditing(true)
    }
    
    
    func defineItemOrcamento(_ itemOrcamento: ItemOrcamentoSimples) {
        
        self.itemOrcamento = itemOrcamento
        let listaBotoes = [ botao1, botao2, botao3 ]
        var indice = 0
        
        for botao in itemOrcamento.botoes! {
            
            if botao.selecao == itemOrcamento.itemSelecionado {
                listaBotoes[indice]?.isSelected = true
                break
            }
            
            indice += 1
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func onClique(_ sender: AnyObject) {
        
        let botaox = sender as! UIButton
        let novo_estado = !botaox.isSelected
        var selecao : String?
        
        botaox.isSelected = novo_estado
        
        if botaox.tag == 1 {
            selecao = itemOrcamento?.botoes![0].selecao
            botao2.isSelected = !novo_estado
            botao3.isSelected = !novo_estado
        }
        else if botaox.tag == 2 {
            botao1.isSelected = !novo_estado
            selecao = itemOrcamento?.botoes![1].selecao
            botao3.isSelected = !novo_estado
        }
        else {
            botao1.isSelected = !novo_estado
            botao2.isSelected = !novo_estado
            selecao = itemOrcamento?.botoes![2].selecao
        }
        
        itemOrcamento?.itemSelecionado = selecao
        
        interacao?(itemOrcamento)
    }
    
    func exibeAlerta(_ mensagem: String, textoBotao: String) {
        
        let alert = UIAlertController.init(title:AvisoProcessamento.Titulo, message:mensagem, preferredStyle:UIAlertControllerStyle.alert);
        
        let defaultAction = UIAlertAction.init(title:textoBotao, style:UIAlertActionStyle.default,
                                               handler: { (action: UIAlertAction) -> Void in
                                                
        })
        
        alert.addAction(defaultAction)
        
        window?.rootViewController?.present(alert, animated:true, completion:nil)
    }
}
