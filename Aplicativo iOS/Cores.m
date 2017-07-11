//
//  Cores.m
//  Pintura a Jato
//
//  Created by daniel on 04/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Cores.h"

@implementation Cores

+(UIColor*)corCinzaPainel {
    return [UIColor colorWithRed:0xEF/255.0f green:0xEF/255.0f blue:0xF4/255.0f alpha:1.0f];
}

+(UIColor*)corZebradoPar {
    return [UIColor colorWithRed:0xE6/255.0f green:0xE6/255.0f blue:0xE6/255.0f alpha:1.0f];
}

+(UIColor*)corZebradoImpar {
    return [UIColor colorWithRed:0xBD/255.0f green:0xBD/255.0f blue:0xBD/255.0f alpha:1.0f];
}

+(UIColor*)corAzulClaro {
    return [UIColor colorWithRed:0.3125f green:0.75f blue:0.9375f alpha:1.0f]; // azul claro
}

+(UIColor*)corLaranja {
    //return [UIColor colorWithRed:0.89f green:0.4375f blue:0.10f alpha:1.0f];
    // 231 124 26
    //return [UIColor colorWithRed:225.0f/255.0f green:112.0f/255.0f blue:36.0f/255.0f alpha:1.0f];
    return [UIColor colorWithRed:231.0f/255.0f green:124.0f/255.0f blue:26.0f/255.0f alpha:1.0f];
}

+(UIColor*)corCinzaFundoBullet {
    return [UIColor colorWithRed:0.875f green:0.875f blue:0.875f alpha:1.0];
}

+(UIColor*)corCinzaBullet {
    return [UIColor colorWithRed:0.43f green:0.43f blue:0.43f alpha:1.0];
}

+(UIColor*)corVerdeCheck {
    //134 206 87
    return [UIColor colorWithRed:0.5234f green:0.8046f blue:0.3398f alpha:1.0];
}

+(UIColor*)corVermelhoRemove {
    // 220 86 72
    return [UIColor colorWithRed:0.8593f green:0.3359f blue:0.2812f alpha:1.0];
}

+(UIColor*)corAzulVisa {
    //64 102 179
    return [UIColor colorWithRed:0.25f green:0.3984f blue:0.6992f alpha:1.0];
}

+(UIColor*)corVermelhoMaster {
    // 213 50 37
    return [UIColor colorWithRed:0.8320f green:0.1953 blue:0.1445 alpha:1.0];
}

// Calendário

+(UIColor*)corCalendarioVermelho {
    // #FF0000
    return [UIColor colorWithRed:0xFF/255.0f green:0x00 blue:0x00 alpha:1.0];
}
+(UIColor*)corCalendarioVermelhoClaro {
    // #FF8888
    return [UIColor colorWithRed:0xFF/255.0f green:0x88/255.0f blue:0x88/255.0f alpha:1.0];
}
+(UIColor*)corCalendarioCinza {
    // #888888
    return [UIColor colorWithRed:0x88/255.0f green:0x88/255.0f blue:0x88/255.0f alpha:1.0];
}
+(UIColor*)corCalendarioCinzaClaro {
    // #CCCCCC
    return [UIColor colorWithRed:0xCC/255.0f green:0xCC/255.0f blue:0xCC/255.0f alpha:1.0];
}
+(UIColor*)corCalendarioFundoInicio {
    return [self corLaranja];
}
+(UIColor*)corCalendarioFundoBloqueadoFranqueado {
    return [self corAzulClaro];
}
+(UIColor*)corCalendarioFundoContinuacao {
    return [self corCalendarioCinza];
}
+(UIColor*)corCalendarioTextoMarcacao {
    return [UIColor whiteColor];
}
+(UIColor*)corCalendarioFundoCelula {
    return [UIColor whiteColor];
}

@end