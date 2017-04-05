//
//  UIViewController+Prototipo.m
//  Aplicativo iOS
//
//  Created by daniel on 07/06/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

#import "UIViewController+Prototipo.h"
#import "UIImage+FontAwesome.h"

@implementation UIViewController (Prototipo)

-(UIColor*)corCinzaPainel {
    return [Cores corCinzaPainel];
}

-(UIColor*)corZebradoPar {
    return [Cores corZebradoPar];
}

-(UIColor*)corZebradoImpar {
    return [Cores corZebradoImpar];
}

-(UIColor*)corAzulClaro {
    return [Cores corAzulClaro];
}

-(UIColor*)corLaranja {
    return [Cores corLaranja];
}

-(UIColor*)corCinzaFundoBullet {
    return [Cores corCinzaFundoBullet];
}

-(UIColor*)corCinzaBullet {
    return [Cores corCinzaBullet];
}

-(UIColor*)corVerdeCheck {
    return [Cores corVerdeCheck];
}

-(UIColor*)corVermelhoRemove {
    return [Cores corVermelhoRemove];
}

-(UIColor*)corAzulVisa {
    return [Cores corAzulVisa];
}

-(UIColor*)corVermelhoMaster {
    return [Cores corVermelhoMaster];
}

-(UIImage*)iconeLista:(NSString *)nome cor:(UIColor *)cor corFundo:(UIColor *)corFundo {
    
    CGSize size = CGSizeMake(24,24);
    
    return [UIImage imageWithIcon:[NSString stringWithFormat:@"icon-%@", nome] backgroundColor:corFundo iconColor:cor
                 iconScale:1.0f andSize:size];
}

-(UIImage*)iconeListaPequeno:(NSString *)nome cor:(UIColor *)cor corFundo:(UIColor *)corFundo {
    
    CGSize size = CGSizeMake(20,20);
    
    return [UIImage imageWithIcon:[NSString stringWithFormat:@"icon-%@", nome] backgroundColor:corFundo iconColor:cor
                        iconScale:1.0f andSize:size];
}

-(UIImage*)iconeBotao:(NSString *)nome cor:(UIColor *)cor corFundo:(UIColor *)corFundo {
    
    CGSize size = CGSizeMake(30,30);
    
    return [UIImage imageWithIcon:[NSString stringWithFormat:@"icon-%@", nome] backgroundColor:corFundo iconColor:cor
                        iconScale:1.0f andSize:size];
}

-(UIImage*)iconeQuadrado:(NSString *)nome cor:(UIColor *)cor corFundo:(UIColor *)corFundo tamanho:(CGFloat)tamanho {
    
    CGSize size = CGSizeMake(tamanho,tamanho);
    
    return [UIImage imageWithIcon:[NSString stringWithFormat:@"icon-%@", nome] backgroundColor:corFundo iconColor:cor
                        iconScale:1.0f andSize:size];
}


-(void)ajustaImagem:(UIImage*)imagem Botao:(UIButton*)botao Ajuste:(CGFloat)ajuste {
    
    //CGRect posicao = CGRectMake(0, 0, 30, 30);
    
    [botao setImage:imagem forState:UIControlStateNormal];
    
    CGFloat top = (botao.frame.size.height - imagem.size.height)/2.0f;
    CGFloat bottom = top;
    CGFloat left = ajuste;
    //CGFloat right = (botao.frame.size.width - 30.0f - (left*2));
    CGFloat right = left + (imagem.size.width*2.0f);
    
    botao.imageEdgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
}

@end
