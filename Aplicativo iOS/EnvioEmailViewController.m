//
//  EnvioEmailViewController.m
//  Aplicativo iOS
//
//  Created by Robson Medeiros on 6/5/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

#import "EnvioEmailViewController.h"
#import "UIImage+FontAwesome.h"

@interface EnvioEmailViewController ()

@end

@implementation EnvioEmailViewController

- (void)viewDidLoad {
   
    CGSize size;

    size.width = 30;
    size.height = 30;

    UIColor *background_color = [UIColor colorWithRed:0.89f green:0.4375f blue:0.10f alpha:1.0f],
        *icon_color = [UIColor whiteColor];

    UIImage *image = [UIImage imageWithIcon:@"icon-signin" backgroundColor:background_color iconColor:icon_color
                              iconScale:1.0f andSize:size];

    _imagem_check.image = [UIImage imageWithIcon:@"icon-check" backgroundColor:[UIColor whiteColor] iconColor:[UIColor colorWithRed:0.066f green:0.512f blue:0.21f alpha:1.0f]
                                   iconScale:1.0f andSize:size];

    [_botao_prosseguir setImage:image forState:UIControlStateNormal];

    [[self navigationController] setNavigationBarHidden:YES animated:YES];

}		
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
- (IBAction)onContinuar:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
