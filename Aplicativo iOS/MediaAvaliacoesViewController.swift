//
//  MediaAvaliacoesViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 05/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit
class MediaAvaliacoesViewController: UIViewController {
    @IBOutlet weak var imagem_media_brasil1: UIImageView!
    @IBOutlet weak var imagem_media_brasil2: UIImageView!
    @IBOutlet weak var imagem_media_brasil3: UIImageView!
    @IBOutlet weak var imagem_media_brasil4: UIImageView!
    @IBOutlet weak var imagem_media_brasil5: UIImageView!
    @IBOutlet weak var imagem_media_regiao1: UIImageView!
    @IBOutlet weak var imagem_media_regiao2: UIImageView!
    @IBOutlet weak var imagem_media_regiao3: UIImageView!
    @IBOutlet weak var imagem_media_regiao4: UIImageView!
    @IBOutlet weak var imagem_media_regiao5: UIImageView!
    @IBOutlet weak var imagem_media1: UIImageView!
    @IBOutlet weak var imagem_media2: UIImageView!
    @IBOutlet weak var imagem_media3: UIImageView!
    @IBOutlet weak var imagem_media4: UIImageView!
    @IBOutlet weak var imagem_media5: UIImageView!

    var imagemBucketNormal: UIImage!
    var imagemBucketNormalDesativado: UIImage!

    var icones_brasil: [UIImageView]?
    var icones_regiao: [UIImageView]?
    var icones_media: [UIImageView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagemBucketNormal = UIImage (named: "lata_colorida_media")
        imagemBucketNormalDesativado = UIImage(named: "lata_cinza_media")
        
        self.imagem_media1.image = imagemBucketNormalDesativado!
        self.imagem_media2.image = imagemBucketNormalDesativado!
        self.imagem_media3.image = imagemBucketNormalDesativado!
        self.imagem_media4.image = imagemBucketNormalDesativado!
        self.imagem_media5.image = imagemBucketNormalDesativado!
        self.imagem_media_brasil1.image = imagemBucketNormalDesativado!
        self.imagem_media_brasil2.image = imagemBucketNormalDesativado!
        self.imagem_media_brasil3.image = imagemBucketNormalDesativado!
        self.imagem_media_brasil4.image = imagemBucketNormalDesativado!
        self.imagem_media_brasil5.image = imagemBucketNormalDesativado!
        self.imagem_media_regiao1.image = imagemBucketNormalDesativado!
        self.imagem_media_regiao2.image = imagemBucketNormalDesativado!
        self.imagem_media_regiao3.image = imagemBucketNormalDesativado!
        self.imagem_media_regiao4.image = imagemBucketNormalDesativado!
        self.imagem_media_regiao5.image = imagemBucketNormalDesativado!
        
        icones_brasil = [imagem_media_brasil1, imagem_media_brasil2, imagem_media_brasil3, imagem_media_brasil4, imagem_media_brasil5]
        icones_regiao = [imagem_media_regiao1, imagem_media_regiao2, imagem_media_regiao3, imagem_media_regiao4, imagem_media_regiao5]
        icones_media = [imagem_media1, imagem_media2, imagem_media3, imagem_media4, imagem_media5]
        
        ////////////////////////////////////////////////////////////////////////
        
        executa("nacional")
    }
    
    func executa(_ tipo: String) {
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_franquia" : String.init(format: "%d", (PinturaAJatoApi.obtemFranqueado()?.id_franquia)!) as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]

        api.avaliacao(self.navigationController!.view, tipo: tipo, parametros: parametros, sucesso:  { (avaliacao:Avaliacao?, tipo:String, resultado: Bool) -> Bool in
            
            if tipo == "nacional" {
                
                self.ajustaIcones(avaliacao!.media, icones: self.icones_brasil!)
                
                self.executa("regional")
            }
            else if tipo == "regional" {
                
                self.ajustaIcones(avaliacao!.media, icones: self.icones_regiao!)
                
                self.executa("franquia")
            }
            else if tipo == "franquia" {
                
                self.ajustaIcones(avaliacao!.media, icones: self.icones_media!)
            }
            
            return true
        })
        
    }
    
    func ajustaIcones(_ media: Int, icones: [UIImageView]) {
        
        var contador = 1
        
        for imageView:UIImageView in icones {
            
            imageView.image = ( media >= contador ? imagemBucketNormal : imagemBucketNormalDesativado)
            
            contador += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
