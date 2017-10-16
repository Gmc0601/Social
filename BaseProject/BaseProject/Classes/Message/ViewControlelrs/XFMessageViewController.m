//
//  XFMessageViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFMessageViewController.h"

@interface XFMessageViewController ()

@property (nonatomic, strong) UIView *progressView;

@end

@implementation XFMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavView];

}

- (void)setupNavView {
    self.navigationController.navigationBarHidden = YES;
    UIView *navView = [UIView xf_createWhiteView];
    navView.frame = CGRectMake(0, 0, kScreenWidth, XFNavHeight);
    navView.backgroundColor = ThemeColor;
    [self.view addSubview:navView];
    
    UILabel *titleLabel = [UILabel xf_labelWithFont:Font(18)
                                          textColor:WhiteColor
                                      numberOfLines:0
                                          alignment:NSTextAlignmentCenter];
    titleLabel.text = @"消息";
    titleLabel.frame = CGRectMake(44, 20, kScreenWidth - 88, 44);
    [navView addSubview:titleLabel];
};

@end
