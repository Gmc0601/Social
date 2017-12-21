//
//  XFViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFViewController.h"
#import "TBNavigationController.h"
#import "DemoCallManager.h"
@interface XFViewController ()

@end

@implementation XFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DemoCallManager sharedManager];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent animated:YES];
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
