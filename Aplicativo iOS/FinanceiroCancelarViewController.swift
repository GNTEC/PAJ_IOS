//
//  FinanceiroCancelarViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 28/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation


class FinanceiroCancelarViewController: UIViewController {
    @IBOutlet weak var imagem_motivo: UIImageView!
    @IBOutlet weak var imagem_carrinho: UIImageView!
    @IBOutlet weak var botao_check: UIButton!
    @IBOutlet weak var label_valor: UILabel!
    @IBOutlet weak var text_motivo_cancelamento: UITextField!
    
    var contexto: ContextoFinanceiro?
    var pedido: PedidoGetNet?
    
    func defineContexto(_ contexto: ContextoFinanceiro) {
        self.contexto = contexto
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imagem_motivo.image = self.iconeBotao("commenting", cor: self.corCinzaBullet(), corFundo: self.corCinzaFundoBullet())
        self.imagem_carrinho.image = self.iconeBotao("shopping-cart", cor: UIColor.white, corFundo: UIColor.clear)
        botao_check.setImage(self.iconeBotao("check", cor: UIColor.white, corFundo: UIColor.clear), for: UIControlState())
        
        ////////////////////////////////////////////////////////////////////////
        
        title = String(format: "Pedido #%06d", contexto!.id_orcamento)
        
        ////////////////////////////////////////////////////////////////////////
        
        label_valor.text = Valor.floatParaMoedaString(contexto!.valorPagamento)
        
        ////////////////////////////////////////////////////////////////////////
        
        let api = PinturaAJatoApi()
        
        let parametros : [String:AnyObject] = [
            "id_orcamento" : contexto!.id_orcamento as AnyObject,
            "id_pedido" : contexto!.id_pedido as AnyObject,
            "id_franquia" : PinturaAJatoApi.obtemFranqueado()!.id_franquia as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.buscarPedidoPorId(self.navigationController!.view, parametros:  parametros, sucesso: { (objeto:CartaoPagamentoSaida?, resultado: Bool) -> Bool in
            self.pedido = objeto?.pedido
            return true
        });
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onConfirmar(_ sender: AnyObject) {
        
        if text_motivo_cancelamento.text == nil || text_motivo_cancelamento.text!.isEmpty {
            
            AvisoProcessamento.mensagemErroGenerico("Indique o motivo do cancelamento")
            return
        }
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_franquia" : "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
            "id_orcamento" : "\(contexto!.id_orcamento)" as AnyObject,
            "id_pedido" : "\(contexto!.id_pedido)" as AnyObject,
            "motivo" : text_motivo_cancelamento.text! as AnyObject
        ]
        
        api.getNet(self.navigationController!.view, tipo: "cancelamento", parametros: parametros) { (objeto, resultado) -> Bool in
            
            AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: "Cancelamento efetuado!", destino: { () -> Void in
                if self.contexto!.voltarHistorico {
                    
                    var vc : UIViewController?
                    
                    for vc_pilha in self.navigationController!.viewControllers {
                        
                        if vc_pilha is HistoricoTableViewController {
                            vc = vc_pilha
                            break
                        }
                    }
                    
                    if vc != nil {
                        self.navigationController!.popToViewController(vc!, animated: true)
                    }
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
            return true
        }
        
    }
}
