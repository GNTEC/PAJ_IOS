//
//  UIViewController+Prototipo.h
//  Aplicativo iOS
//
//  Created by daniel on 07/06/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Cores.h"

@interface UIViewController (Prototipo)

-(UIColor*)corCinzaPainel;
-(UIColor*)corZebradoPar;
-(UIColor*)corZebradoImpar;
-(UIColor*)corAzulClaro;
-(UIColor*)corLaranja;
-(UIColor*)corCinzaFundoBullet;
-(UIColor*)corCinzaBullet;
-(UIColor*)corVermelhoMaster;
-(UIColor*)corAzulVisa;
-(UIColor*)corVerdeCheck;
-(UIColor*)corVermelhoRemove;

-(UIImage*)iconeLista:(NSString*)nome cor:(UIColor*)cor corFundo:(UIColor*)corFundo;
-(UIImage*)iconeListaPequeno:(NSString*)nome cor:(UIColor*)cor corFundo:(UIColor*)corFundo;
-(UIImage*)iconeBotao:(NSString*)nome cor:(UIColor*)cor corFundo:(UIColor*)corFundo;
-(UIImage*)iconeQuadrado:(NSString *)nome cor:(UIColor *)cor corFundo:(UIColor *)corFundo tamanho:(CGFloat)tamanho;

-(void)ajustaImagem:(UIImage*)imagem Botao:(UIButton*)botao Ajuste:(CGFloat)ajuste;

@end
