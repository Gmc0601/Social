//
//  ViewController.m
//  BaseProject
//
//  Created by cc on 2017/6/14.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ViewController.h"
#import "TBTabBarController.h"
#import "DemoCallManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TBTabBarController *_tabBC = [[TBTabBarController alloc] init];
//    [DemoCallManager sharedManager];
    
    [self addChildViewController:_tabBC];
    [self.view addSubview:_tabBC.view];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
