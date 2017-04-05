//
//  LojaComprovanteViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit
class LojaComprovanteViewController: UIViewController {
    @IBOutlet weak var imagem_check: UIImageView!
    @IBOutlet weak var botaoAdicionar: UIButton!
    @IBOutlet weak var numero_pedido: UILabel!
    
    var pedido: PedidoLoja?
    
    func definePedido(_ pedido: PedidoLoja?) {
        self.pedido = pedido
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let size: CGSize = CGSize(width: 30, height: 30)
        let icon_color = UIColor.white
        let image = UIImage.init(icon:"icon-signin", backgroundColor: UIColor.clear, iconColor: icon_color, iconScale: 1.0, andSize: size)
        self.imagem_check.image = UIImage.init(icon:"icon-check", backgroundColor: UIColor.white, iconColor: UIColor(red: 0.066, green: 0.512, blue: 0.21, alpha: 1.0), iconScale: 1.0, andSize: size)
        botaoAdicionar!.setImage(image, for: UIControlState())
        //[[self navigationController] setNavigationBarHidden:NO animated:YES];
        
        self.numero_pedido.text = String(format: "#%06d", pedido!.id);
        
        self.navigationItem.hidesBackButton = true
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
    
    @IBAction func onContinuar(_ sender: AnyObject) {
        let indice = self.navigationController!.viewControllers.count - 5
        let vc = self.navigationController!.viewControllers[indice]
        self.navigationController!.popToViewController(vc, animated: true)!
    }
}
