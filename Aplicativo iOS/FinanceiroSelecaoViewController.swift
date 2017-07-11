//
//  FinanceiroSelecaoViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 06/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class FinanceiroSelecaoViewController : UIViewController {
    
    var tipoRecebimento: TipoRecebimento?
    
    @IBAction func onSelecao(_ sender: AnyObject) {
        
        let botao = sender as! UIView
        
        switch botao.tag {
        case 1:
            tipoRecebimento = TipoRecebimento.recebido
            break
        case 2:
            tipoRecebimento = TipoRecebimento.aReceber
            break
        case 3:
            tipoRecebimento = TipoRecebimento.cancelados
            break
        default:
            break
        }
        
        self.performSegue(withIdentifier: "SegueSelecaoParaLista", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        //button.tintColor = [UIColor whiteColor];
        self.navigationItem.backBarButtonItem = button
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueSelecaoParaLista" {
            
            let contexto = ContextoFinanceiro()
            
            contexto.tipoRecebimento = self.tipoRecebimento
            
            let vc = segue.destination as! FinanceiroListaViewController;
            
            vc.defineContexto(contexto)
            
        }
    }
}
