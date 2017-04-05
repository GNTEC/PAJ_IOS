//
//  InicioViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//
import UIKit

class InicioViewController : UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
        self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.tapCenterView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     #pragma mark - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func onHistorico(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Historico", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        //[self presentViewController:controller animated:TRUE completion:nil];
        self.navigationController!.pushViewController(controller!, animated: true)
    }
    
    @IBAction func onAgenda(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Agenda", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        //[self presentViewController:controller animated:TRUE completion:nil];
        self.navigationController!.pushViewController(controller!, animated: true)
    }
    
    @IBAction func onFinanceiro(_ sender: AnyObject) {
        if InicioViewController.avaliaAcessoPermitido() {
            let storyboard = UIStoryboard(name: "Financeiro", bundle: nil)
            let controller = storyboard.instantiateInitialViewController()
            //[self presentViewController:controller animated:TRUE completion:nil];
            self.navigationController!.pushViewController(controller!, animated: true)
        }
    }
    
    @IBAction func onMediaAvaliacoes(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Historico", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MediaAvaliacoesViewController")
        //[self presentViewController:controller animated:TRUE completion:nil];
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func onOrcamento(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Orcamento", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        //[self presentViewController:controller animated:TRUE completion:nil];
        self.navigationController!.pushViewController(controller!, animated: true)
    }
    
    @IBAction func onClientes(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Historico", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ClientesListaViewController")
        //[self presentViewController:controller animated:TRUE completion:nil];
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    static let PERFIL_ADMINISTRADOR = 1;
    static let PERFIL_USUARIO = 2;
    static let PERFIL_CLIENTE = 3;
    
    static func avaliaAcessoPermitido() -> Bool {
        
        let perfil = PinturaAJatoApi.obtemFranqueado()!.perfil!
        
        if perfil > PERFIL_ADMINISTRADOR {
            AvisoProcessamento.mensagemErroGenerico("Opção não disponível")
            return false
        }
        
        return true
    }
}
