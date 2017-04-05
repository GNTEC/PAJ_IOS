//
//  AcessoViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit
class AcessoViewController: UIViewController {
    @IBOutlet weak var botao_facebook: UIButton!
    @IBOutlet weak var botao_cadastre: UIButton!
    @IBOutlet weak var botao_google: UIButton!
    @IBOutlet weak var botao_cadastrado: UIButton!
    
    var imagemFB: UIImage!
    var imagemGoogle: UIImage!
    var imagemUserPlus: UIImage!
    var imagemCadastrado: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button = UIBarButtonItem(title: "", style: self.navigationItem.backBarButtonItem!.style, target: nil, action: nil)
        //button.tintColor = [UIColor whiteColor];
        let azulFacebook = UIColor(red: 64.0 / 255.0, green: 102.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0)
        /*UIColor *vermelhoGoogle = [UIColor colorWithRed:211.0f/255.0f green:72.0f/255.0f blue:54.0f/255.0f alpha:1.0f];*/
        self.navigationItem.backBarButtonItem! = button
        imagemFB = UIImage(icon:"icon-facebook", backgroundColor: azulFacebook, iconColor: UIColor.white, iconScale: 1.0, andSize: CGSize(width: 30.0, height: 30.0))
        /*imagemGoogle = [UIImage imageWithIcon:@"icon-google-plus" backgroundColor:vermelhoGoogle iconColor:[UIColor whiteColor] iconScale:1.0f andSize:CGSizeMake(36.0f, 28.0f)];*/
        //UIImage *imagemFBOriginal = [UIImage imageNamed:@"facebook_icon"];
        let imagemGoogleOriginal = UIImage(named: "google_icon")!
        let imagemUserPlusOriginal = UIImage(named: "user-plus_icon")!
        let imagemCadastradoOriginal = UIImage(named: "ink_icon")!
        //imagemCadastrado = [UIImage imageNamed:@"1392-32"];
        let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
        UIGraphicsBeginImageContext(rect.size)
        imagemUserPlusOriginal.draw(in: rect)
        imagemUserPlus = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        /*UIGraphicsBeginImageContext( rect.size );
         [imagemFBOriginal drawInRect:rect];
         imagemFB = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();*/
        UIGraphicsBeginImageContext(rect.size)
        imagemGoogleOriginal.draw(in: rect)
        imagemGoogle = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIGraphicsBeginImageContext(rect.size)
        imagemCadastradoOriginal.draw(in: rect)
        imagemCadastrado = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.ajustaImagem(imagemFB, botao: botao_facebook, ajuste: 5.0)
        self.ajustaImagem(imagemGoogle, botao: botao_google, ajuste: 2.0)
        self.ajustaImagem(imagemUserPlus, botao: botao_cadastre, ajuste: 2.0)
        self.ajustaImagem(imagemCadastrado, botao: botao_cadastrado, ajuste: 5.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
