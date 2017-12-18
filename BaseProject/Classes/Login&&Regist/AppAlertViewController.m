//
//  AppAlertViewController.m
//  easydoctor
//
//  Created by stone on 15/11/10.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import "AppAlertViewController.h"

@interface AppAlertViewController ()<UIAlertViewDelegate>

@end

@implementation AppAlertViewController
{
    UIViewController *parentController;
    sureBlock _sureBlock;
    cancelBlock _cancelBlock;
}

- (instancetype)initWithParentController:(UIViewController *)parent
{
    if (self = [super init]) {
        parentController = parent;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)showAlert:(NSString *)title message:(NSString *)message sureTitle:(NSString *)sureTitle cancelTitle:(NSString *)cancelTitle sure:(sureBlock)sure cancel:(cancelBlock)cancel
{
    if (ios8) {
        UIAlertController*alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction*cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
            if(cancel){
                cancel();
            }
            
        }];
        [alertController addAction:cancelAction];
        
        if(sureTitle != nil){
            UIAlertAction*otherAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction*action) {
                if(sure){
                    sure();
                }
            }];
            [alertController addAction:otherAction];
        }
        
        [parentController presentViewController:alertController animated:YES completion:nil];
    }else{
        self.view.backgroundColor = [UIColor blackColor];
        self.view.alpha = 0.3;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:sureTitle, nil];
        _cancelBlock = cancel;
        _sureBlock = sure;
        [alertView show];
    
        [parentController presentViewController:self animated:NO completion:nil];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:NO completion:^{
        if(buttonIndex == 1){
            if (_sureBlock) {
                _sureBlock();
            }
        }else{
            if (_cancelBlock) {
                _cancelBlock();
            }
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
