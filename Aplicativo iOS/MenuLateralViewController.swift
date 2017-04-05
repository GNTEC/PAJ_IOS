//
//  MenuLateralViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit

class MenuLateralViewController: UIViewController {
    @IBOutlet weak var imagem_perfil: UIImageView!
    @IBOutlet weak var imagem_treinamento: UIImageView!
    @IBOutlet weak var imagem_pagamento: UIImageView!
    @IBOutlet weak var imagem_loja: UIImageView!
    @IBOutlet weak var imagem_agenda: UIImageView!
    @IBOutlet weak var imagem_historico: UIImageView!
    @IBOutlet weak var imagem_avaliacoes: UIImageView!
    @IBOutlet weak var imagem_financeiro: UIImageView!
    @IBOutlet weak var imagem_orcamento: UIImageView!
    @IBOutlet weak var imagem_termos: UIImageView!
    @IBOutlet weak var imagem_sair: UIImageView!
    @IBOutlet weak var imagem_fulano: UIImageView!
    @IBOutlet weak var texto_ola_drawer: UILabel!
    @IBOutlet weak var imagem_clientes: UIImageView!
    
    @IBOutlet weak var indicador_processamento_imagem: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        let size: CGSize = CGSize(width: 24, height: 24)
        let background_color = UIColor.white
        let icon_color = UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.0)
        self.imagem_perfil.image = UIImage(icon:"icon-user", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_clientes.image = UIImage(icon:"icon-user", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_treinamento.image = UIImage(icon:"icon-book", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_pagamento.image = UIImage(icon:"icon-credit-card", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_loja.image = UIImage(icon:"icon-shopping-cart", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_agenda.image = UIImage(icon:"icon-calendar", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_historico.image = UIImage(icon:"icon-history", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_avaliacoes.image = UIImage(icon:"icon-star", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_financeiro.image = UIImage(icon:"icon-dollar", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_orcamento.image = UIImage(icon:"icon-list-alt", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_termos.image = UIImage(icon:"icon-legal", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_sair.image = UIImage(icon:"icon-signout", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_fulano.layer.cornerRadius = imagem_fulano.frame.size.width / 2
        self.imagem_fulano.clipsToBounds = true
        self.imagem_fulano.layer.borderWidth = 3.0
        self.imagem_fulano.layer.borderColor = UIColor.gray.cgColor

        ////////////////////////////////////////////////////////////////////////
        
        let franqueado: Franqueado = PinturaAJatoApi.obtemFranqueado()!
        
        let api = PinturaAJatoApi()
        
        if franqueado.foto != nil {
            
            Imagem.carregaImagemUrlAssincrona(api.obtemUrlFotoUsuario(franqueado.foto!), sucesso: { (imagem:UIImage?) -> Void in
                
                if imagem == nil {
                    return
                }
                
                self.imagem_fulano!.image = imagem
                self.indicador_processamento_imagem.stopAnimating()
            }, falha: { (url) in })
        }
        
        self.texto_ola_drawer.text = String(format:"Olá, %@", franqueado.nome!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTreinamentoManual(_ sender: AnyObject) {
        self.mm_drawerController.toggle(MMDrawerSide.left, animated: false, completion: { _ in })
        let storyboard = UIStoryboard(name: "ManuaisTreinamento", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        //[self presentViewController:controller animated:TRUE completion:nil];
        self.navigationController!.pushViewController(controller!, animated: true)
    }
    
    @IBAction func onMeioPagamento(_ sender: AnyObject) {
        
        if InicioViewController.avaliaAcessoPermitido() {

            self.mm_drawerController.toggle(MMDrawerSide.left, animated: false, completion: { _ in })
            let storyboard = UIStoryboard(name: "MeioDePagamento", bundle: nil)
            let controller = storyboard.instantiateInitialViewController()
            //[self presentViewController:controller animated:TRUE completion:nil];
            self.navigationController!.pushViewController(controller!, animated: true)
        }
    }
    @IBAction func onLoja(_ sender: AnyObject) {
        
        if InicioViewController.avaliaAcessoPermitido() {
            
            self.mm_drawerController.toggle(MMDrawerSide.left, animated: false, completion: { _ in })
            let storyboard = UIStoryboard(name: "Loja", bundle: nil)
            let controller = storyboard.instantiateInitialViewController()
            //[self presentViewController:controller animated:TRUE completion:nil];
            self.navigationController!.pushViewController(controller!, animated: true)
        }
    }
    
    @IBAction func onFinanceiro(_ sender: AnyObject) {
        
        if InicioViewController.avaliaAcessoPermitido() {
            
            self.mm_drawerController.toggle(MMDrawerSide.left, animated: false, completion: { _ in })
            let storyboard = UIStoryboard(name: "Financeiro", bundle: nil)
            let controller = storyboard.instantiateInitialViewController()
            //[self presentViewController:controller animated:TRUE completion:nil];
            self.navigationController!.pushViewController(controller!, animated: true)
        }
    }
    
    @IBAction func onOrcamento(_ sender: AnyObject) {
        self.mm_drawerController.toggle(MMDrawerSide.left, animated: false, completion: { _ in })
        let storyboard = UIStoryboard(name: "Orcamento", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        //[self presentViewController:controller animated:TRUE completion:nil];
        self.navigationController!.pushViewController(controller!, animated: true)
    }
    
    @IBAction func onMediaAvaliacoes(_ sender: AnyObject) {
        self.mm_drawerController.toggle(MMDrawerSide.left, animated: false, completion: { _ in })
        let storyboard = UIStoryboard(name: "Historico", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MediaAvaliacoesViewController")
        //[self presentViewController:controller animated:TRUE completion:nil];
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func onHistorico(_ sender: AnyObject) {
        self.mm_drawerController.toggle(MMDrawerSide.left, animated: false, completion: { _ in })
        let storyboard = UIStoryboard(name: "Historico", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        //[self presentViewController:controller animated:TRUE completion:nil];
        self.navigationController!.pushViewController(controller!, animated: true)
    }
    
    @IBAction func onTermosServico(_ sender: AnyObject) {
        self.mm_drawerController.toggle(MMDrawerSide.left, animated: false, completion: { _ in })
        let storyboard = UIStoryboard(name: "Termos", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        //[self presentViewController:controller animated:TRUE completion:nil];
        self.navigationController!.pushViewController(controller!, animated: true)
    }
    
    @IBAction func onClientes(_ sender: AnyObject) {
        self.mm_drawerController.toggle(MMDrawerSide.left, animated: false, completion: { _ in })
        let storyboard = UIStoryboard(name: "Historico", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ClientesListaViewController")
        //[self presentViewController:controller animated:TRUE completion:nil];
        self.navigationController!.pushViewController(controller, animated: true)
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "SegueMenuSair" {
            PinturaAJatoApi.defineFranqueado(nil)
            PinturaAJatoApi.defineSessao(nil)
        }
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        self.mm_drawerController.toggle(MMDrawerSide.left, animated: false, completion: { _ in })
    }
}
