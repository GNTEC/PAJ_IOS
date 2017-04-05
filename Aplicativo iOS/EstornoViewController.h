//
//  EstornoViewController.h
//  Aplicativo iOS
//
//  Created by Robson Medeiros on 6/8/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EstornoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imagem_nome;
@property (weak, nonatomic) IBOutlet UIImageView *imagem_valor;
@property (weak, nonatomic) IBOutlet UIImageView *imagem_cartao;
@property (weak, nonatomic) IBOutlet UIImageView *imagem_motivo;

@property (weak, nonatomic) IBOutlet UIImageView *imagem_carrinho;
@property (weak, nonatomic) IBOutlet UIButton *botao_check;

@end
