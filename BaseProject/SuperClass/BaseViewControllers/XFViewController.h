//
//  XFViewController.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFViewController : UIViewController

- (void)backBtnClick;
- (void)showLoginController;
- (BOOL)isNotLogin;
- (void)pushController:(UIViewController *)controller;

@end
