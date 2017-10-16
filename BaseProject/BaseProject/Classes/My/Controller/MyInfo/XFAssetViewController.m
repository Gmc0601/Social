//
//  XFAssetViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFAssetViewController.h"

@interface XFAssetViewController ()

@property (nonatomic, strong) XFUDButton *topBtn;
@property (nonatomic, strong) XFUDButton *bottomBtn;

@end

@implementation XFAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_themeNavView:self.type == AssetType_House ? @"房产信息" : @"车产信息"
                                   backTarget:self
                                   backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    UILabel *topLabel = [UILabel xf_labelWithFont:Font(13)
                                         textColor:RGBGray(153)
                                     numberOfLines:0
                                         alignment:NSTextAlignmentLeft];
    topLabel.text = self.type == AssetType_House ? @"房产证所有权人页：" : @"行驶证主页：";
    topLabel.frame = CGRectMake(15, XFNavHeight, kScreenWidth - 30, 40);
    [self.view addSubview:topLabel];
    
    XFUDButton *topBtn = [self createBtn];
    self.topBtn = topBtn;
    topBtn.top = topLabel.bottom;
    
    UILabel *bottomLabel = [UILabel xf_labelWithFont:Font(13)
                                         textColor:RGBGray(153)
                                     numberOfLines:0
                                         alignment:NSTextAlignmentLeft];
    bottomLabel.text = self.type == AssetType_House ? @"房产证附记页：" : @"行驶证副页：";
    bottomLabel.frame = CGRectMake(15, topBtn.bottom + 15, kScreenWidth - 30, 40);
    [self.view addSubview:bottomLabel];
    
    XFUDButton *bottomBtn = [self createBtn];
    self.bottomBtn = bottomBtn;
    bottomBtn.top = bottomLabel.bottom;
}

- (XFUDButton *)createBtn {
    XFUDButton *button = [XFUDButton buttonWithType:UIButtonTypeCustom];
    button.padding = 5;
    [button setTitle:@"上传图片" forState:UIControlStateNormal];
    [button setTitleColor:BlackColor forState:UIControlStateNormal];
    [button setImage:Image(@"fcxx_icon_sczp") forState:UIControlStateNormal];
    button.backgroundColor = RGBGray(242);
    [button xf_cornerCut:3];
    button.left = 15;
    button.width = kScreenWidth - button.left * 2;
    button.height = button.width * 0.53;
    [self.view addSubview:button];
    return button;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
