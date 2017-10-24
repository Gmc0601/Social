//
//  XFAssetViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFAssetViewController.h"

@interface XFAssetViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) XFUDButton *topBtn;
@property (nonatomic, strong) XFUDButton *bottomBtn;
@property (nonatomic, strong) UIImageView *topImgView;
@property (nonatomic, strong) UIImageView *bottomImgView;

@property (nonatomic, strong) XFUDButton *selectBtn;

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
    [topBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.topBtn = topBtn;
    topBtn.top = topLabel.bottom;
    
    _topImgView = [[UIImageView alloc] initWithFrame:topBtn.frame];
    _topImgView.contentMode = UIViewContentModeScaleAspectFit;
    _topImgView.clipsToBounds = YES;
    [self.view addSubview:_topImgView];
    _topImgView.hidden = YES;
    
    
    UILabel *bottomLabel = [UILabel xf_labelWithFont:Font(13)
                                           textColor:RGBGray(153)
                                       numberOfLines:0
                                           alignment:NSTextAlignmentLeft];
    bottomLabel.text = self.type == AssetType_House ? @"房产证附记页：" : @"行驶证副页：";
    bottomLabel.frame = CGRectMake(15, topBtn.bottom + 15, kScreenWidth - 30, 40);
    [self.view addSubview:bottomLabel];
    
    XFUDButton *bottomBtn = [self createBtn];
    [bottomBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.bottomBtn = bottomBtn;
    bottomBtn.top = bottomLabel.bottom;
    
    _bottomImgView = [[UIImageView alloc] initWithFrame:bottomBtn.frame];
    _bottomImgView.contentMode = UIViewContentModeScaleAspectFit;
    _bottomImgView.clipsToBounds = YES;
    [self.view addSubview:_bottomImgView];
    _bottomImgView.hidden = YES;
    
    UIButton *submitBtn = [UIButton xf_bottomBtnWithTitle:@"提交"
                                                   target:self
                                                   action:@selector(submitBtnClick)];
    submitBtn.frame = CGRectMake(10, kScreenHeight - 54, kScreenWidth - 20, 44);
    [self.view addSubview:submitBtn];
}

- (void)btnClick:(XFUDButton *)btn {
    self.selectBtn = btn;
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.allowsEditing = NO;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)submitBtnClick {
    //    self.topImgView.image;
    //    self.bottomImgView.image
    FFLogFunc
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.selectBtn == self.topBtn) {
        self.topImgView.image = image;
        self.topImgView.hidden = NO;
    } else {
        self.bottomImgView.image = image;
        self.bottomImgView.hidden = NO;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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

