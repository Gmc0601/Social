//
//  XFViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFViewController.h"
#import "TBNavigationController.h"

@interface XFViewController ()

@end

@implementation XFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showLoginController {
    LoginViewController *controller = [[LoginViewController alloc] init];
    TBNavigationController *na = [[TBNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:na animated:YES completion:nil];
    return;

}

- (BOOL)isNotLogin {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:IsLogin];
}

- (void)pushController:(UIViewController *)controller {
    [self.navigationController pushViewController:controller animated:YES];
}

@end
