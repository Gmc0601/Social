//
//  XFViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFViewController.h"

@interface XFViewController ()

@end

@implementation XFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushController:(UIViewController *)controller {
    [self.navigationController pushViewController:controller animated:YES];
}

@end
