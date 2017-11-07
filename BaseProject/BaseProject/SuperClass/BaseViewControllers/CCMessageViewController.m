//
//  CCMessageViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/6.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCMessageViewController.h"

@interface CCMessageViewController ()

@end

@implementation CCMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *navView = [UIView xf_createWhiteView];
    navView.frame = CGRectMake(0, 0, kScreenWidth, XFNavHeight);
    navView.backgroundColor = ThemeColor;
    [self.view addSubview:navView];
    
    self.titleLab = [UILabel xf_labelWithFont:Font(18)
                                          textColor:WhiteColor
                                      numberOfLines:0
                                          alignment:NSTextAlignmentCenter];
    self.titleLab.text = @"";
    self.titleLab.frame = CGRectMake(44, 20, kScreenWidth - 88, 44);
    [navView addSubview:self.titleLab];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if (viewControllers.count > 1){
        UIButton *btn = [UIButton xf_titleButtonWithTitle:@""
                                               titleColor:WhiteColor
                                                titleFont:Font(15)
                                                   target:self
                                                   action:@selector(back)];
        [btn setImage:[UIImage imageNamed:@"nav_icon_fh_w"] forState:UIControlStateNormal];
        btn.frame = FRAME(5, 20, 65, 44);
        [navView addSubview:btn];
    }
    
    self.rightBtn = [UIButton xf_titleButtonWithTitle:@"发布"
                                                  titleColor:WhiteColor
                                                   titleFont:Font(15)
                                                      target:self
                                                      action:@selector(moreClick)];
    self.rightBtn.frame = CGRectMake(kScreenWidth - 65, 20, 65, 44);
    [navView addSubview:self.rightBtn];
    
}


- (void)moreClick {
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
