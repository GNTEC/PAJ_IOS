//
//  CelulaComplexaOrcamentoConfirmacaoPinturaTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

typealias notificaAjustarTamanho = (_ configuracaoTinta: ConfiguracaoTinta?, _ altura: CGFloat) -> Void

class CelulaComplexaOrcamentoConfirmacaoPinturaTableViewCell : UITableViewCell {
    @IBOutlet weak var label_tipo_pintura: UILabel!
    @IBOutlet weak var label_cor_tinta: UILabel!
    @IBOutlet weak var label_tipo_tinta: UILabel!
    @IBOutlet weak var label_acabamento_tinta: UILabel!
    @IBOutlet weak var label_valor: UILabel!
    @IBOutlet weak var imagem_check_fornece_tintas: UIImageView!
    @IBOutlet weak var view_fornece_tintas: UIView!
    @IBOutlet weak var view_nao_pintara: UIView!
    
    @IBOutlet weak var botao_mais_menos: UIButton!
    @IBOutlet weak var imagem_check_nao_pintara: UIImageView!
    
    @IBOutlet weak var constraint_altura_valor: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_fornece_tintas: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_nao_pintarei: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_painel: NSLayoutConstraint!
    
    var altura_painel : CGFloat = 0.0
    var notificador_tamanho: notificaAjustarTamanho?
    
    var configuracaoTinta : ConfiguracaoTinta?
    
    var views_painel : [UIView]?
    
    override func awakeFromNib() {
        
        altura_painel = constraint_altura_painel.constant
        
        views_painel = [label_tipo_tinta, label_cor_tinta, label_acabamento_tinta, label_valor, view_nao_pintara, view_fornece_tintas]
    }
    
    @IBAction func onInformacaoFornecereiAsTintas(_ sender: AnyObject) {
        
        let mensagem = configuracaoTinta!.clienteForneceTintas ? obtemString("mensagem_tinta_premium") : obtemString("mensagem_nao_somos_revendedores_tinta");
        
        exibeAlerta(mensagem,  textoBotao: "Ok");
        
    }
    func ajustaVisibilidade() {
        
        constraint_altura_painel.constant = botao_mais_menos.isSelected ? label_cor_tinta.frame.origin.y + 9.0 : altura_painel
        
        configuracaoTinta?.celulaExpandida = !botao_mais_menos.isSelected
        
        for view in views_painel! {
            view.isHidden = botao_mais_menos.isSelected
        }
        
        if notificador_tamanho != nil {
            notificador_tamanho!(configuracaoTinta, constraint_altura_painel.constant)
        }
    }
    
    @IBAction func onSelecionouMaisMenos(_ sender: AnyObject) {
        
        botao_mais_menos.isSelected = !botao_mais_menos.isSelected
        
        self.ajustaVisibilidade()
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
