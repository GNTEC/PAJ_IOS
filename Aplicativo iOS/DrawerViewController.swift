//
//  DrawerViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

class DrawerViewController : MMDrawerController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /*UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenuClick:)];*/
        let imagemMenu = UIImage(icon:"icon-reorder", backgroundColor: self.corLaranja(), iconColor: UIColor.white, iconScale: 1.0, andSize: CGSize(width: 32, height: 32))
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(self.onMenuClick), for: .touchUpInside)
        button.bounds = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.setImage(imagemMenu, for: UIControlState())
        let item = UIBarButtonItem(customView: button)
        let image = UIImage(named: "pintura_a_jato")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 32))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        let item2 = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = item2
        /*UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:imagemMenu style:UIBarButtonItemStylePlain target:self action:@selector(onMenuClick:)];*/
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.hidesBackButton = true
        //UIViewController * vc = [[MenuLateralViewController alloc] init];
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuLateralViewController")
        self.leftDrawerViewController = vc
        //drawerController = [[MMDrawerController alloc] initWithCenterViewController:self leftDrawerViewController:menuController];
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onMenuClick(_ sender: AnyObject) {
        self.toggle(MMDrawerSide.left, animated: true, completion: { _ in })
    }
}
