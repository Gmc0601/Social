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

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

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
    self.topLabel = topLabel;
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
    _topImgView.hidden = YES;
    [self.view insertSubview:_topImgView belowSubview:topBtn];
    
    UIView *topView = [UIView xf_createViewWithColor:RGBGray(242)];
    topView.frame = topBtn.frame;
    [self.view insertSubview:topView belowSubview:_topImgView];
    
    UILabel *bottomLabel = [UILabel xf_labelWithFont:Font(13)
                                           textColor:RGBGray(153)
                                       numberOfLines:0
                                           alignment:NSTextAlignmentLeft];
    self.bottomLabel = bottomLabel;
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
    [self.view insertSubview:_bottomImgView belowSubview:bottomBtn];
    _bottomImgView.hidden = YES;
    
    UIView *bottomView = [UIView xf_createViewWithColor:RGBGray(242)];
    bottomView.frame = bottomBtn.frame;
    [self.view insertSubview:bottomView belowSubview:_bottomImgView];
    
    UIButton *submitBtn = [UIButton xf_bottomBtnWithTitle:@"提交"
                                                   target:self
                                                   action:@selector(submitBtnClick)];
    submitBtn.frame = CGRectMake(10, kScreenHeight - 54, kScreenWidth - 20, 44);
    [self.view addSubview:submitBtn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)btnClick:(XFUDButton *)btn {
    self.selectBtn = btn;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择上传类型"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                   
                                                         handler:^(UIAlertAction * action) {}];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.allowsEditing = NO;
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:controller animated:YES completion:nil];
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍摄照片" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.allowsEditing = NO;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:controller animated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:libraryAction];
    [alertController addAction:cameraAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)submitBtnClick {
    if (self.topImgView.image == nil) {
        [ConfigModel mbProgressHUD:[NSString stringWithFormat:@"请上传%@", self.topLabel.text] andView:nil];
        return;
    }
    
    if (self.bottomImgView.image == nil) {
        [ConfigModel mbProgressHUD:[NSString stringWithFormat:@"请上传%@", self.bottomLabel.text] andView:nil];
        return;
    }
    NSString *url = self.type == AssetType_House ? XFMyHouseUpdataUrl : XFMyCarUpdateUrl;
    [SVProgressHUD show];
    WeakSelf
    [HttpRequest postPath:url
                   params:@{@"front_image" : [UIImagePNGRepresentation(self.topImgView.image) base64EncodedString],
                            @"back_image" : [UIImagePNGRepresentation(self.bottomImgView.image) base64EncodedString]}
              resultBlock:^(id responseObject, NSError *error) {
                  [SVProgressHUD dismiss];
                  NSNumber *code = responseObject[@"error"];
                  if (code.integerValue == 0) {
                      [ConfigModel mbProgressHUD:@"提交成功" andView:nil];
                      [weakSelf backBtnClick];
                  } else {
                      [ConfigModel mbProgressHUD:@"提交失败" andView:nil];
                  }
              }];
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

