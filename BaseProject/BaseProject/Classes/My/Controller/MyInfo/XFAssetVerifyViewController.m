//
//  XFAssetVerifyViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFAssetVerifyViewController.h"

@interface XFAssetVerifyViewController ()

@end

@implementation XFAssetVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_themeNavView:@"资产审核"
                                   backTarget:self
                                   backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    
    NSString *imgName = @"";
    NSString *title = @"";
    if (self.status == AssetVerifyStatus_Fail) {
        imgName = @"zcsh_icon_shsb";
        title = @"以上资料已提交，审核失败";
    } else if (self.status == AssetVerifyStatus_Procress) {
        imgName = @"zcsh_icon_shz";
        title = @"以上资料已提交，审核中";
    } else if (self.status == AssetVerifyStatus_Success) {
        imgName = @"zcsh_icon_shcg";
        title = @"以上资料已提交，审核成功";
    }
    UIImageView *imgView = [[UIImageView alloc] initWithImage:Image(imgName)];
    imgView.top = XFNavHeight + 150;
    imgView.centerX = kScreenWidth * 0.5;
    [self.view addSubview:imgView];
    
    UILabel *infoLabel = [UILabel xf_labelWithFont:Font(13)
                                         textColor:RGBGray(153)
                                     numberOfLines:1
                                         alignment:NSTextAlignmentCenter];
    infoLabel.text = title;
    infoLabel.frame = CGRectMake(20, imgView.bottom + 32, kScreenWidth - 40, 15);
    [self.view addSubview:infoLabel];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

