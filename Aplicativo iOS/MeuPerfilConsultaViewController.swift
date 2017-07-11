//
//  MeuPerfilConsultaViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 06/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

import UIKit
class MeuPerfilConsultaViewController : UIViewController {
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var botao_gravar: UIButton!
    @IBOutlet weak var nome_franqueado: UITextField!
    @IBOutlet weak var razao_social_franqueado: UITextField!
    @IBOutlet weak var nome_fantasia_franqueado: UITextField!
    @IBOutlet weak var cnpj_franqueado: UITextField!
    
    @IBOutlet weak var endereco_fiscal: UITextField!
    @IBOutlet weak var numero_fiscal: UITextField!
    @IBOutlet weak var complemento_fiscal: UITextField!
    @IBOutlet weak var cidade_fiscal: UITextField!
    @IBOutlet weak var estado_fiscal: UITextField!
    @IBOutlet weak var cep_fiscal: UITextField!
    @IBOutlet weak var telefone1_fiscal: UITextField!
    @IBOutlet weak var telefone2_fiscal: UITextField!
    
    @IBOutlet weak var endereco_entrega: UITextField!
    @IBOutlet weak var numero_entrega: UITextField!
    @IBOutlet weak var complemento_entrega: UITextField!
    @IBOutlet weak var cidade_entrega: UITextField!
    @IBOutlet weak var estado_entrega: UITextField!
    @IBOutlet weak var cep_entrega: UITextField!
    @IBOutlet weak var telefone1_entrega: UITextField!
    @IBOutlet weak var telefone2_entrega: UITextField!
    
    @IBOutlet weak var email_franqueado: UITextField!
    
    @IBOutlet weak var indicador_foto_carregando: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
        tap.numberOfTapsRequired = 1
        foto!.isUserInteractionEnabled = true
        foto!.addGestureRecognizer(tap)
        let size: CGSize = CGSize(width: 30, height: 30)
        let image = UIImage.init(icon:"icon-check", backgroundColor: UIColor.clear, iconColor: UIColor.white, iconScale: 1.0, andSize: size)
        botao_gravar!.setImage(image, for: UIControlState())
        self.foto.layer.cornerRadius = foto.frame.size.width / 2
        self.foto.clipsToBounds = true
        self.foto.layer.borderWidth = 3.0
        self.foto.layer.borderColor = UIColor.gray.cgColor
        
        ////////////////////////////////////////////////////////////////////////
        
        let franqueado: Franqueado = PinturaAJatoApi.obtemFranqueado()!
        
        nome_franqueado.text = franqueado.nome! + franqueado.sobrenome!
        
        razao_social_franqueado.text = franqueado.razaoSocial
        nome_fantasia_franqueado.text = franqueado.nomeFantasia
        cnpj_franqueado.text = franqueado.cnpj
        
        endereco_fiscal.text = franqueado.endereco_fiscal?.logradouro
        numero_fiscal.text = franqueado.endereco_fiscal?.numero
        complemento_fiscal.text = franqueado.endereco_fiscal?.complemento
        cidade_fiscal.text = franqueado.endereco_fiscal?.cidade
        estado_fiscal.text = franqueado.endereco_fiscal?.uf
        cep_fiscal.text = franqueado.endereco_fiscal?.cep
        telefone1_fiscal.text = franqueado.telefone1
        telefone2_fiscal.text = franqueado.telefone2

        endereco_entrega.text = franqueado.endereco_entrega?.logradouro
        numero_entrega.text = franqueado.endereco_entrega?.numero
        complemento_entrega.text = franqueado.endereco_entrega?.complemento
        cidade_entrega.text = franqueado.endereco_entrega?.cidade
        estado_entrega.text = franqueado.endereco_entrega?.uf
        cep_entrega.text = franqueado.endereco_entrega?.cep
        telefone1_entrega.text = franqueado.telefone1
        telefone2_entrega.text = franqueado.telefone2

        email_franqueado.text = franqueado.email
        
        let api = PinturaAJatoApi()

        if franqueado.foto != nil {
            Imagem.carregaImagemUrlAssincrona(api.obtemUrlFotoUsuario(franqueado.foto!), sucesso: { (imagem:UIImage?) -> Void in
                
                if imagem == nil {
                    return
                }
                
                self.foto!.image = imagem
                self.indicador_foto_carregando.stopAnimating()
            }, falha: { (url) in })
        }
        else {
            self.indicador_foto_carregando.stopAnimating()
        }
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var camera: Camera?
    
    func processaImagem(_ imagemOriginal:UIImage?) {
        
        let imagem_pequena = Imagem.ajustaTamanhoImagem(imagemOriginal!, scaledToSize: CGSize(width: 300, height: 200))
        
        self.foto?.image = imagem_pequena
        
        let api = PinturaAJatoApi()
        let franqueado = PinturaAJatoApi.obtemFranqueado()
        
        let parametros: [String:AnyObject] = [
            "id_franquia" : String(format: "%d", franqueado!.id_franquia) as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
            "id_usuario" : String(format: "%d", franqueado!.id) as AnyObject,
            "formato": "jpeg" as AnyObject
        ]
        
        api.inserirFotoUsuario(self.navigationController!.view, parametros:parametros, foto: imagem_pequena, sucesso: { (resultado: Bool, mensagem: String?) -> Bool in
            
                return true
            })
    }
    
    func onTap() {
        let alert = UIAlertController(title: "Foto do Perfil", message: "Foto de rosto do franqueado de frente", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Galeria de Fotos", style: .default, handler: {(action: UIAlertAction) -> Void in
            
            self.camera = Camera.selecionaFotoGaleria(self, sucesso: { (imagem) in
                self.processaImagem(imagem)
            })
            
            if self.camera == nil {
                AvisoProcessamento.mensagemErroGenerico("Galeria não disponível")
            }
            
        })
        alert.addAction(action1)
        
        let action2 = UIAlertAction(title: "Câmera", style: .default, handler: {(action: UIAlertAction) -> Void in
            
            self.camera = Camera.disparaCapturaFoto(self, sucesso: { (imagem) in
                self.processaImagem(imagem)
            })
            
            if self.camera == nil {
                AvisoProcessamento.mensagemErroGenerico("Câmera não disponível")
            }
        })
        alert.addAction(action2)
        
        let action3 = UIAlertAction(title: "Cancelar", style: .cancel, handler: {(action: UIAlertAction) -> Void in
        })
        alert.addAction(action3)
        
        self.present(alert, animated: true, completion: {() -> Void in
        })
    }
    
    @IBAction func onConfirmar(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
