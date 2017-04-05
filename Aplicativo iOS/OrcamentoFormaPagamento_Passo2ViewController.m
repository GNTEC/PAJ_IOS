//
//  OrcamentoFormaPagamento_Passo2ViewController.m
//  Aplicativo iOS
//
//  Created by Robson Medeiros on 6/10/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

#import "OrcamentoFormaPagamento_Passo2ViewController.h"
#import "UIViewController+Prototipo.h"
#import "UIImage+FontAwesome.h"

@interface OrcamentoFormaPagamento_Passo2ViewController ()

@end

@implementation OrcamentoFormaPagamento_Passo2ViewController
- (IBAction)onCheck:(id)sender {
    
    UIButton *botao = sender;
    
    [botao setSelected:![botao isSelected]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    
    tap1.numberOfTapsRequired = 1;

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    
    tap2.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    
    tap3.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    
    tap4.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    
    tap5.numberOfTapsRequired = 1;
    
    [_item1 setUserInteractionEnabled:YES];
    [_item1 addGestureRecognizer:tap1];

    [_item2 setUserInteractionEnabled:YES];
    [_item2 addGestureRecognizer:tap2];

    [_item3 setUserInteractionEnabled:YES];
    [_item3 addGestureRecognizer:tap3];

    [_item4 setUserInteractionEnabled:YES];
    [_item4 addGestureRecognizer:tap4];

    [_item5 setUserInteractionEnabled:YES];
    [_item5 addGestureRecognizer:tap5];
    
    //237 e 239 244
    
    UIColor *cor1 = [UIColor colorWithRed:223.0f/255.0f green:223.0f/255.0f blue:223.0f/255.0f alpha:1.0f];
    UIColor *cor2 = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    
    _imagem_cifrao.image = [self iconeBotao:@"usd" cor:[UIColor whiteColor] corFundo:[self corLaranja]];
    
    _imagem_cartao.image = [self iconeBotao:@"credit-card" cor:[self corLaranja] corFundo:cor1];
    
    _imagem_dinheiro.image = [self iconeBotao:@"money" cor:[self corVerdeCheck] corFundo:cor2];
    
    UIImage *imagemCheckEmpty1 = [UIImage imageWithIcon:@"icon-check-empty" backgroundColor:cor1 iconColor:[self corCinzaBullet] iconScale:1.0f andSize:CGSizeMake(24, 24)];
    
    UIImage *imagemCheck1 = [UIImage imageWithIcon:@"icon-check" backgroundColor:cor1 iconColor:[self corCinzaBullet] iconScale:1.0f andSize:CGSizeMake(24, 24)];
    
    UIImage *imagemCheckEmpty2 = [UIImage imageWithIcon:@"icon-check-empty" backgroundColor:cor2 iconColor:[self corCinzaBullet] iconScale:1.0f andSize:CGSizeMake(24, 24)];
    
    UIImage *imagemCheck2 = [UIImage imageWithIcon:@"icon-check" backgroundColor:cor2 iconColor:[self corCinzaBullet] iconScale:1.0f andSize:CGSizeMake(24, 24)];
    
    [_botao1 setImage:imagemCheckEmpty2 forState:UIControlStateNormal];
    [_botao1 setImage:imagemCheck2 forState:UIControlStateSelected];

    [_botao2 setImage:imagemCheckEmpty1 forState:UIControlStateNormal];
    [_botao2 setImage:imagemCheck1 forState:UIControlStateSelected];

    [_botao3 setImage:imagemCheckEmpty2 forState:UIControlStateNormal];
    [_botao3 setImage:imagemCheck2 forState:UIControlStateSelected];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onTap {
    
    [self performSegueWithIdentifier:@"SeguePassoPagamentoParaCartao" sender:self];
    
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
