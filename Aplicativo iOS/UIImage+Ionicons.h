//
//  UIImage+Ionicons.h
//  Aplicativo iOS
//
//  Created by daniel on 08/06/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Ionicons)
+(UIImage*)imageWithIonicIcon:(NSString*)identifier backgroundColor:(UIColor*)bgColor iconColor:(UIColor*)iconColor iconScale:(CGFloat)scale andSize:(CGSize)size;
@end