//
//  OrcamentoEscolhaTintaPopup.swift
//  Pintura a Jato
//
//  Created by daniel on 18/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import UIKit

class PadraoConfiguracaoCorTinta
{
    init(tipoTintas: [TipoTinta], acabamentoTintas: [AcabamentoTinta]) {
        self.tipoTintas = tipoTintas;
        self.acabamentoTintas = acabamentoTintas;
    }
    
    var tipoTintas: [TipoTinta]
    var acabamentoTintas: [AcabamentoTinta]
    
    func contemTipoTinta(_ tipoTintaBuscada: TipoTinta) -> Bool {
    
        for tipoTinta in tipoTintas {
            
            if(tipoTinta == tipoTintaBuscada) {
                return true;
            }
        }
    
        return false;
    }
    
    func contemAcabamento(_ acabamentoTintaBuscado: AcabamentoTinta) -> Bool {
    
        for acabamentoTinta in acabamentoTintas {
            
            if(acabamentoTinta == acabamentoTintaBuscado){
                return true;
            }
        }
    
        return false;
    }
}

class OrcamentoEscolhaTintaPopup: UIView {
    @IBOutlet weak var botao_fechar: UIButton!
    @IBOutlet weak var botao_check_cliente_fornece: UIButton!
    @IBOutlet weak var botao_check_nao_pintarei: UIButton!
    @IBOutlet weak var botao_verniz: UIButton!
    @IBOutlet weak var botao_branco: UIButton!
    @IBOutlet weak var botao_gelo: UIButton!
    @IBOutlet weak var botao_marfim: UIButton!
    @IBOutlet weak var botao_palha: UIButton!
    @IBOutlet weak var botao_concreto: UIButton!
    @IBOutlet weak var botao_platina: UIButton!
    
    @IBOutlet weak var botao_pva: UIButton!
    @IBOutlet weak var botao_acrilica: UIButton!
    @IBOutlet weak var botao_incolor: UIButton!
    @IBOutlet weak var botao_esmalte_base_agua: UIButton!
    @IBOutlet weak var botao_esmalte_sintetico: UIButton!
    
    @IBOutlet weak var botao_brilhante: UIButton!
    @IBOutlet weak var botao_fosco: UIButton!
    @IBOutlet weak var botao_semi_brilho: UIButton!
    @IBOutlet weak var botao_acetinado: UIButton!
    
    @IBOutlet weak var constraint_largura_verniz: NSLayoutConstraint!
    @IBOutlet weak var constraint_largura_branco: NSLayoutConstraint!
    @IBOutlet weak var constraint_largura_gelo: NSLayoutConstraint!
    @IBOutlet weak var constraint_largura_marfim: NSLayoutConstraint!
    @IBOutlet weak var constraint_largura_palha: NSLayoutConstraint!
    @IBOutlet weak var constraint_largura_concreto: NSLayoutConstraint!
    @IBOutlet weak var constraint_largura_platina: NSLayoutConstraint!
    
    @IBOutlet weak var constraint_largura_pva: NSLayoutConstraint!
    @IBOutlet weak var constraint_largura_acrilica: NSLayoutConstraint!
    @IBOutlet weak var constraint_largura_incolor: NSLayoutConstraint!
    @IBOutlet weak var constraint_largura_esmalte_agua: NSLayoutConstraint!
    @IBOutlet weak var constraint_largura_esmalte_sintetico: NSLayoutConstraint!
    
    @IBOutlet weak var constraint_largura_brilhante: NSLayoutConstraint!
    @IBOutlet weak var constraint_largura_fosco: NSLayoutConstraint!
    @IBOutlet weak var constraint_largura_semibrilho: NSLayoutConstraint!
    @IBOutlet weak var constraint_largura_acetinado: NSLayoutConstraint!
    
    @IBOutlet weak var constraint_altura_fornecerei_tintas: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_nao_pintarei: NSLayoutConstraint!
    
    @IBOutlet weak var constraint_altura_verniz: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_pva: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_brilhante: NSLayoutConstraint!
    
    @IBOutlet weak var painel_fornece_tintas: UIView!
    @IBOutlet weak var label_titulo: UILabel!
    @IBOutlet weak var label_nao_pintarei: UILabel!
    
    @IBOutlet weak var painel_botoes: UIView!
    var imagemCheckFechar: UIImage!
    var imagemCheckMarcado: UIImage!
    var imagemCheckDesmarcado: UIImage!
    var largura_botao : CGFloat = 0.0
    var largura_botao_tipo : CGFloat = 0.0
    
    static let padroesTipoTinta1 = [ TipoTinta.Acrilica ]
    static let padroesTipoTinta2 = [ TipoTinta.Incolor ]
    static let padroesTipoTinta3 = [ TipoTinta.EsmalteBaseAgua, TipoTinta.EsmalteSintetico ]
    
    static let padroesAcabamentoTinta1 = [ AcabamentoTinta.Brilhante, AcabamentoTinta.Fosco, AcabamentoTinta.Semibrilho ]
    static let padroesAcabamentoTinta2 = [ AcabamentoTinta.Fosco, AcabamentoTinta.Semibrilho ]
    static let padroesAcabamentoTinta3 = [ AcabamentoTinta.Fosco ]
    static let padroesAcabamentoTinta4 = [ AcabamentoTinta.Brilhante ]
    static let padroesAcabamentoTinta5 = [ AcabamentoTinta.Brilhante, AcabamentoTinta.Acetinado ]
    
    static let padrao1 = PadraoConfiguracaoCorTinta(tipoTintas: padroesTipoTinta1, acabamentoTintas: padroesAcabamentoTinta1)
    static let padrao2 = PadraoConfiguracaoCorTinta(tipoTintas: padroesTipoTinta1, acabamentoTintas: padroesAcabamentoTinta2)
    static let padrao3 = PadraoConfiguracaoCorTinta(tipoTintas: padroesTipoTinta1, acabamentoTintas: padroesAcabamentoTinta3)
    static let padrao4 = PadraoConfiguracaoCorTinta(tipoTintas: padroesTipoTinta2, acabamentoTintas: padroesAcabamentoTinta4)
    static let padrao5 = PadraoConfiguracaoCorTinta(tipoTintas: padroesTipoTinta3, acabamentoTintas: padroesAcabamentoTinta5)
    static let padrao6 = PadraoConfiguracaoCorTinta(tipoTintas: padroesTipoTinta3, acabamentoTintas: padroesAcabamentoTinta4)
    
    static var mapaCorPadraoParedesTeto =  Dictionary<CorTinta, PadraoConfiguracaoCorTinta>()
    static var mapaCorPadraoPortasJanelas = Dictionary<CorTinta, PadraoConfiguracaoCorTinta>()

    var configuracaoTinta: ConfiguracaoTinta?
    
    var botoesCorTinta: [UIButton]?
    var itensCorTinta: [CorTinta]?
    var constraintsCorTinta: [NSLayoutConstraint]?

    var botoesTipoTinta: [UIButton]?
    var itensTipoTinta: [TipoTinta]?
    var constraintsTipoTinta: [NSLayoutConstraint]?
    
    var botoesAcabamentoTinta: [UIButton]?
    var itensAcabamentoTinta: [AcabamentoTinta]?
    var constraintsAcabamentoTinta: [NSLayoutConstraint]?
    
    var iniciado = false
    
    @IBAction func onSelecionouTinta(_ sender: AnyObject) {
        
        let botaoClicado = sender as! UIButton
        
        var indice = 0
        
        for botao in botoesCorTinta! {
            
            botao.isHighlighted = botao == botaoClicado
            
            if botao.isHighlighted {
                
                botao.adicionaBorda()
                
                let item = itensCorTinta![indice]
                
                configuracaoTinta?.cor = item
                
                ajustaVisibilidadeSelecaoTipoTinta(item, tipo: configuracaoTinta!.tipo)
                ajustaVisibilidadeSelecaoAcabamentoTinta(item, tipo: configuracaoTinta!.tipo, acabamento: configuracaoTinta!.acabamento)
                
                if item == CorTinta.Verniz {
                    exibeAlerta("O verniz só será aplicado em superfícies de madeira \"crua\" sem pintura ou massa ou já pintadas com verniz anteriormente (repintura).", textoBotao: "Ok");
                }
            }
            else {
                botao.removeBorda()
            }
            
            indice += 1
        }
    }
    
    @IBAction func onSelecionouTipoTinta(_ sender: AnyObject) {
        
        let botaoClicado = sender as! UIButton
        
        var indice = 0
        
        for botao in botoesTipoTinta! {
            
            botao.isHighlighted = botao == botaoClicado
            
            if botao.isHighlighted {
                
                botao.adicionaBorda()
                
                let item = itensTipoTinta![indice]
                
                configuracaoTinta?.tipo = item
                
                ajustaVisibilidadeSelecaoAcabamentoTinta(configuracaoTinta!.cor, tipo: item, acabamento: configuracaoTinta!.acabamento)
            }
            else {
                botao.removeBorda()
            }

            
            indice += 1
        }
    }
    
    @IBAction func onSelecionouAcabamento(_ sender: AnyObject) {
        
        let botaoClicado = sender as! UIButton
        
        var indice = 0
        
        for botao in botoesAcabamentoTinta! {
            
            botao.isHighlighted = botao == botaoClicado
            
            if botao.isHighlighted {
                
                botao.adicionaBorda()

                let item = itensAcabamentoTinta![indice]
                
                configuracaoTinta?.acabamento = item
            }
            else {
                botao.removeBorda()
            }

            
            indice += 1
        }
    }
    
    func ajustaVisibilidadeSelecaoTipoTinta(_ corTintaSelecionada: CorTinta, tipo: TipoTinta) {
        
        var indice = 0
        let corSelecionada = corTintaSelecionada != CorTinta.Nenhum;
        
        var mapa: Dictionary<CorTinta, PadraoConfiguracaoCorTinta>?
        
        if configuracaoTinta?.localPintura == LocalPintura.Janelas || configuracaoTinta?.localPintura == LocalPintura.Portas {
            mapa = OrcamentoEscolhaTintaPopup.mapaCorPadraoPortasJanelas
        }
        else if configuracaoTinta?.localPintura == LocalPintura.Paredes || configuracaoTinta?.localPintura == LocalPintura.Teto {
            mapa = OrcamentoEscolhaTintaPopup.mapaCorPadraoParedesTeto
        }
        
        for botao in botoesTipoTinta! {
            
            var visivel = false
            let tipoTinta = itensTipoTinta![indice]
            
            ///////////////////////////////////////////////////////////////////////////////////////
            
            // Se possui uma cor selecionada, usa o padrão dela
            if corSelecionada {
                let padrao = mapa![corTintaSelecionada]
                
                visivel = padrao!.contemTipoTinta(tipoTinta)
            }
            else {
                // Se não possui, busca todas as possibilidades para o tipo de tina
                for padrao in mapa!.values {
                    
                    visivel = padrao.contemTipoTinta(tipoTinta);
                    
                    if (visivel) {
                        break;
                    }
                }
            }
            
            ///////////////////////////////////////////////////////////////////////////////////////
            
            // Esconde o botão
            constraintsTipoTinta![indice].constant = visivel ? largura_botao_tipo : 0.0
            
            // Marca a seleção se houver
            botao.seleciona(tipo ==  itensTipoTinta![botao.tag] && visivel);
            
            indice += 1
        }
    }
    
    func ajustaVisibilidadeSelecaoAcabamentoTinta(_ corTintaSelecionada: CorTinta, tipo: TipoTinta, acabamento: AcabamentoTinta) {
        
        var indice = 0
        let corSelecionada = corTintaSelecionada != CorTinta.Nenhum;
        
        var mapa: Dictionary<CorTinta, PadraoConfiguracaoCorTinta>?
        
        if configuracaoTinta?.localPintura == LocalPintura.Janelas || configuracaoTinta?.localPintura == LocalPintura.Portas {
            mapa = OrcamentoEscolhaTintaPopup.mapaCorPadraoPortasJanelas
        }
        else if configuracaoTinta?.localPintura == LocalPintura.Paredes || configuracaoTinta?.localPintura == LocalPintura.Teto {
            mapa = OrcamentoEscolhaTintaPopup.mapaCorPadraoParedesTeto
        }
        
        for botao in botoesAcabamentoTinta! {
            
            var visivel = false
            let acabamentoTinta = itensAcabamentoTinta![indice]
            
            ///////////////////////////////////////////////////////////////////////////////////////
            
            // Se possui uma cor selecionada, usa o padrão dela
            if corSelecionada {
                let padrao = mapa![corTintaSelecionada]
                
                visivel = padrao!.contemAcabamento(acabamentoTinta)
            }
            else {
                // Se não possui, busca todas as possibilidades para o tipo de tina
                for padrao in mapa!.values {
                    
                    visivel = padrao.contemAcabamento(acabamentoTinta);
                    
                    if (visivel) {
                        break;
                    }
                }
            }
            
            ///////////////////////////////////////////////////////////////////////////////////////
            
            // Esconde o botão
            constraintsAcabamentoTinta![indice].constant = visivel ? largura_botao : 0.0
            
            // Marca a seleção se houver
            botao.seleciona(acabamento == itensAcabamentoTinta![botao.tag] && visivel);
            
            indice += 1
        }
    }
    
    func exibeAlerta(_ mensagem: String, textoBotao: String) {
        
        let alert = UIAlertController.init(title:AvisoProcessamento.Titulo, message:mensagem, preferredStyle:UIAlertControllerStyle.alert);
        
        let defaultAction = UIAlertAction.init(title:textoBotao, style:UIAlertActionStyle.default,
                                               handler: { (action: UIAlertAction) -> Void in
                                                
        })
        
        alert.addAction(defaultAction)
        
        window?.rootViewController?.present(alert, animated:true, completion:nil)
    }
    
    func bloqueioNavegacao(_ ativo: Bool, itens: [UIView], listaListaBotoes: [[UIButton]?]) {
        
        for item in itens {
            
            item.alpha = ativo ? 1.0 : 0.5
        }
        
        for listaBotoes in listaListaBotoes {
            
            for botao in listaBotoes! {
                botao.isEnabled = ativo
            }
        }
    }
    
    override func didMoveToWindow() {
        
        if iniciado {
            return
        }
        
        iniciado = true
        
        if OrcamentoEscolhaTintaPopup.mapaCorPadraoParedesTeto.count == 0 || OrcamentoEscolhaTintaPopup.mapaCorPadraoPortasJanelas.count == 0 {
            OrcamentoEscolhaTintaPopup.criaPadroes()
        }
        
        botao_fechar.setImage(UIImage(icon: "icon-check", backgroundColor: UIColor.clear, iconColor: UIColor.white, iconScale: 1.0, andSize: CGSize(width: 30, height: 30)), for: UIControlState())
        
        imagemCheckMarcado = UIImage(icon: "icon-check", backgroundColor: UIColor.white, iconColor: Cores.corCinzaBullet(), iconScale: 1.0, andSize: CGSize(width: 24, height: 24))
        imagemCheckDesmarcado = UIImage(icon: "icon-check-empty", backgroundColor: UIColor.white, iconColor: Cores.corCinzaBullet(), iconScale: 1.0, andSize: CGSize(width: 24, height: 24))
        
        botao_check_cliente_fornece.setImage(imagemCheckDesmarcado, for: UIControlState())
        botao_check_cliente_fornece.setImage(imagemCheckMarcado, for: .selected)

        botao_check_nao_pintarei.setImage(imagemCheckDesmarcado, for: UIControlState())
        botao_check_nao_pintarei.setImage(imagemCheckMarcado, for: .selected)
        
        botao_esmalte_base_agua.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        botao_esmalte_base_agua.titleLabel!.numberOfLines = 2

        botao_esmalte_sintetico.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        botao_esmalte_sintetico.titleLabel!.numberOfLines = 3
        
        ////////////////////////////////////////////////////////////////////////
        
        // Titulo
        
        label_titulo.text = String(format:obtemString("titulo_popup_orcamento_escolha_tinta"), configuracaoTinta!.nomeItem!, configuracaoTinta!.nomeAmbiente!)
        
        let exibeNaoPintaraPortaOuJanela = configuracaoTinta?.localPintura == LocalPintura.Portas || configuracaoTinta?.localPintura == LocalPintura.Janelas;
        
        if exibeNaoPintaraPortaOuJanela {
            
            label_nao_pintarei.text = String(format: obtemString("mascara_nao_pintarei"), configuracaoTinta?.localPintura == LocalPintura.Portas ? "as portas" : "as janelas")
        }
        else {
            constraint_altura_nao_pintarei.constant = 0.0
        }
        
        ////////////////////////////////////////////////////////////////////////
        
        constraintsAcabamentoTinta = [constraint_largura_brilhante, constraint_largura_fosco, constraint_largura_semibrilho, constraint_largura_acetinado]
        botoesAcabamentoTinta = [botao_brilhante, botao_fosco, botao_semi_brilho, botao_acetinado]
        itensAcabamentoTinta = [ AcabamentoTinta.Brilhante, AcabamentoTinta.Fosco, AcabamentoTinta.Semibrilho, AcabamentoTinta.Acetinado]
        
        constraintsTipoTinta = [constraint_largura_pva, constraint_largura_acrilica, constraint_largura_incolor, constraint_largura_esmalte_agua, constraint_largura_esmalte_sintetico]
        botoesTipoTinta = [botao_pva, botao_acrilica, botao_incolor, botao_esmalte_base_agua, botao_esmalte_sintetico];
        itensTipoTinta = [ TipoTinta.PVA, TipoTinta.Acrilica, TipoTinta.Incolor, TipoTinta.EsmalteBaseAgua, TipoTinta.EsmalteSintetico];

        constraintsCorTinta = [ constraint_largura_verniz, constraint_largura_branco, constraint_largura_gelo, constraint_largura_marfim, constraint_largura_palha, constraint_largura_concreto, constraint_largura_platina]
        botoesCorTinta = [ botao_verniz, botao_branco, botao_gelo, botao_marfim, botao_palha, botao_concreto, botao_platina ]
        itensCorTinta = [ CorTinta.Verniz, CorTinta.Branco, CorTinta.Gelo, CorTinta.Marfim, CorTinta.Palha, CorTinta.Concreto, CorTinta.Platina ]

        // Seleciona a cor da tinta
        
        painel_botoes.layoutIfNeeded()
        
        var indice = 0
        let largura_painel = painel_botoes.frame.width - (/*botao_verniz.frame.origin.x*/ 20.0 * 2.0)
        
        largura_botao = largura_painel / 5.0
        largura_botao = largura_botao > 64.0 ? 64.0 : largura_botao
        
        largura_botao_tipo = largura_painel / 2.0
        largura_botao_tipo = largura_botao_tipo > 64.0 ? 64.0 : largura_botao_tipo
        
        if largura_botao != 64.0 {
            
            let diferenca = 64.0 - largura_botao
            
            constraint_altura_verniz.constant -= diferenca * 2
            constraint_altura_pva.constant -= diferenca * 2
            constraint_altura_brilhante.constant -= diferenca * 2
        }
        
        for corTinta in itensCorTinta! {
            
            let botao = botoesCorTinta![indice]
            let constraint = constraintsCorTinta![indice]
            var visivel = false
            
            if configuracaoTinta?.localPintura == LocalPintura.Janelas || configuracaoTinta?.localPintura == LocalPintura.Portas {
                visivel = OrcamentoEscolhaTintaPopup.mapaCorPadraoPortasJanelas.index(forKey: corTinta) != nil
            }
            else if configuracaoTinta?.localPintura == LocalPintura.Paredes || configuracaoTinta?.localPintura == LocalPintura.Teto {
                visivel = OrcamentoEscolhaTintaPopup.mapaCorPadraoParedesTeto.index(forKey: corTinta) != nil
            }
            
            constraint.constant = visivel ? largura_botao : 0.0
            
            botao.seleciona((configuracaoTinta?.cor == corTinta) && visivel)
            
            indice += 1
        }
        
        // Seleciona o tipo da tinta
        ajustaVisibilidadeSelecaoTipoTinta(configuracaoTinta!.cor,  tipo: configuracaoTinta!.tipo);
        
        // Seleciona o acabamento da tinta
        
        ajustaVisibilidadeSelecaoAcabamentoTinta(configuracaoTinta!.cor, tipo: configuracaoTinta!.tipo, acabamento: configuracaoTinta!.acabamento);

        ////////////////////////////////////////////////////////////////////////////////////////////
        
        // Ajustes da navegação
        
        if exibeNaoPintaraPortaOuJanela && configuracaoTinta!.naoPintara {
            ajustaVisibilidade(true, ativo:configuracaoTinta!.naoPintara);
        }
        else {
            ajustaVisibilidade(false, ativo:configuracaoTinta!.clienteForneceTintas);
        }
    }
    
    static func criaPadroes() {
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        
        mapaCorPadraoParedesTeto[CorTinta.Branco] = padrao1
        mapaCorPadraoParedesTeto[CorTinta.Gelo] = padrao2
        mapaCorPadraoParedesTeto[CorTinta.Marfim] = padrao2
        mapaCorPadraoParedesTeto[CorTinta.Palha] = padrao2
        mapaCorPadraoParedesTeto[CorTinta.Concreto] = padrao3
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        mapaCorPadraoPortasJanelas[CorTinta.Verniz] = padrao4
        mapaCorPadraoPortasJanelas[CorTinta.Branco] = padrao5
        mapaCorPadraoPortasJanelas[CorTinta.Gelo] = padrao6
        mapaCorPadraoPortasJanelas[CorTinta.Platina] = padrao6
        
        
    }
    
    @IBAction func onCheck(_ sender: AnyObject) {
        
        let botao = sender as! UIButton
        
        botao.isSelected = !botao.isSelected
        
        if botao === botao_check_nao_pintarei {

            ajustaVisibilidade(true, ativo: botao.isSelected)
            
            configuracaoTinta?.naoPintara = botao.isSelected
        }
        else if botao === botao_check_cliente_fornece {

            ajustaVisibilidade(false, ativo: botao.isSelected)
            
            configuracaoTinta?.clienteForneceTintas = botao.isSelected
        }
    }
    
    func ajustaVisibilidade(_ naoPintarei:Bool, ativo: Bool) {
        
        if naoPintarei {
            bloqueioNavegacao(!ativo, itens: [painel_botoes, painel_fornece_tintas], listaListaBotoes: [
                botoesCorTinta, botoesTipoTinta, botoesAcabamentoTinta, [botao_check_cliente_fornece]
                ])
            
            botao_check_nao_pintarei.isSelected = ativo
        }
        else {
            bloqueioNavegacao(!ativo, itens: [painel_botoes], listaListaBotoes: [
                botoesCorTinta, botoesTipoTinta, botoesAcabamentoTinta
                ])
            
            botao_check_cliente_fornece.isSelected = ativo
        }
    }
    
    /*func corCinzaFundoBullet() -> UIColor {
        return UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1.0)
    }
    
    func corCinzaBullet() -> UIColor {
        return UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.0)
    }*/
    
    @IBAction func onFechar(_ sender: AnyObject) {
        
        if configuracaoTinta!.clienteForneceTintas {
            
            exibeAlerta(obtemString("mensagem_tinta_premium"), textoBotao: "Ok")
        }
        
        self.removeFromSuperview()
    }
}
