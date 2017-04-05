//
//  TermosServicoExibirDocumentoViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class TermosServicoExibirDocumentoViewController : UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var contexto: ContextoTermosExibir?
    
    func defineContexto(_ contexto: ContextoTermosExibir?) {
        self.contexto = contexto
    }
    
    override func viewDidLoad() {
        
        if contexto != nil {
            
            let aUrl = URL.init(string: (contexto?.url)!);
            
            let request = NSMutableURLRequest.init(url:aUrl!, cachePolicy:NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval:60.0)
            
            webView.loadRequest(request as URLRequest)
        }
        else {
            AvisoProcessamento.mensagemSucessoGenerico(self, mensagem: "Houve um problema ao acessar o recurso. Tente novamente mais tarde", destino: { () -> Void in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
}
