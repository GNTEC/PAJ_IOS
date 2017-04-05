//
//  LoginViewController.swift
//  Pintura à Jato
//
//  Created by daniel on 26/08/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    
    @IBOutlet weak var imagem_email: FAImageView!
    @IBOutlet weak var imagem_senha: FAImageView!
    @IBOutlet weak var botao_prosseguir: UIButton!
    @IBOutlet weak var text_email: UITextField!
    @IBOutlet weak var text_senha: UITextField!
    @IBOutlet weak var botao_check_lembrar_email: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let size: CGSize = CGSize(width: 30, height: 30)

        let background_color = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1.0)
        let icon_color = UIColor.white
        
        self.imagem_email.image = UIImage(icon:"icon-envelope", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_senha.image = UIImage(icon:"icon-lock", backgroundColor: background_color, iconColor: icon_color, iconScale: 1.0, andSize: size)
        //let background_color_blue = UIColor(red: 0.3125, green: 0.75, blue: 0.9375, alpha: 1.0)
        let image = UIImage(icon:"icon-signin", backgroundColor: UIColor.clear, iconColor: icon_color, iconScale: 1.0, andSize: size)
        botao_prosseguir.setImage(image!, for: UIControlState())
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Fazer Login"
        
#if DEBUG
        text_email.text = "robsonmedeiros@uol.com.br"
        text_senha.text = "1"
#endif
        
        ////////////////////////////////////////////////////////////////////////
        
        let imagemCheckMarcado = self.iconeListaPequeno("check", cor: self.corCinzaBullet(), corFundo: UIColor.clear)
        let imagemCheckDesmarcado = self.iconeListaPequeno("unchecked", cor: self.corCinzaBullet(), corFundo: UIColor.clear)
        
        botao_check_lembrar_email.setImage(imagemCheckDesmarcado, for: UIControlState())
        botao_check_lembrar_email.setImage(imagemCheckMarcado, for: UIControlState.selected)
        
        ////////////////////////////////////////////////////////////////////////
        
        let defaults = UserDefaults.standard
        
        let lembrar_email = defaults.bool(forKey: "lembrar_email")
        
        botao_check_lembrar_email.isSelected = lembrar_email
        
        if lembrar_email {
            
            let email = defaults.string(forKey: "email")
            
            text_email.text = email
        }
    }
    
    @IBAction func onCheckLembrarEmail(_ sender: AnyObject) {
        let botao = sender as! UIButton
        botao.isSelected = !botao.isSelected
    }
    
    @IBAction func onConfirmar(_ sender: UIButton) {
        
        let parameters: [String : AnyObject] = [
            "email": text_email.text! as AnyObject,
            "password" : text_senha.text! as AnyObject
        ]
        
        let api = PinturaAJatoApi()
        
        api.validarUsuario(self.navigationController!.view, parametros: parameters) { (objeto, sessao, resultado) -> Bool in
            
            DispatchQueue.main.async(execute: { 

                PinturaAJatoApi.defineFranqueado(objeto)
                PinturaAJatoApi.defineSessao(sessao)
                
                ////////////////////////////////////////////////////////////////////////
                
                let defaults = UserDefaults.standard
                
                let lembrar_email = self.botao_check_lembrar_email.isSelected
                
                defaults.set(lembrar_email, forKey: "lembrar_email")
                
                if lembrar_email {
                    defaults.set(self.text_email.text, forKey: "email")
                }
                else {
                    defaults.removeObject(forKey: "email")
                }
                
                defaults.synchronize()
                
                ////////////////////////////////////////////////////////////////////////
                
                self.performSegue(withIdentifier: "SegueProssegueInicio", sender: self)

            })
            
            return true
        }
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
