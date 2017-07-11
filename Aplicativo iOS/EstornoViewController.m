//
//  EstornoViewController.m
//  Aplicativo iOS
//
//  Created by Robson Medeiros on 6/8/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

#import "EstornoViewController.h"
#import "UIViewController+Prototipo.h"

@interface EstornoViewController ()

@end

@implementation EstornoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imagem_nome.image = [self iconeBotao:@"user" cor:[self corCinzaBullet] corFundo:[self corCinzaFundoBullet]];
    _imagem_cartao.image = [self iconeBotao:@"credit-card" cor:[self corCinzaBullet] corFundo:[self corCinzaFundoBullet]];
    _imagem_valor.image = [self iconeBotao:@"usd" cor:[self corCinzaBullet] corFundo:[self corCinzaFundoBullet]];
    _imagem_motivo.image = [self iconeBotao:@"commenting" cor:[self corCinzaBullet] corFundo:[self corCinzaFundoBullet]];
    
    _imagem_carrinho.image = [self iconeBotao:@"shopping-cart" cor:[UIColor whiteColor] corFundo:[self corLaranja]];
    
    [_botao_check setImage:[self iconeBotao:@"check" cor:[UIColor whiteColor] corFundo:[self corLaranja]] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onContinuar:(id)sender {
    
    uint indice = self.navigationController.viewControllers.count - 3;
    
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:indice];
    
    [self.navigationController popToViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
