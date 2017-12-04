//
//  XFRechrgeViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFRechrgeViewController.h"

@interface XFRechrgeViewController ()

@property (nonatomic, weak) UILabel *myIntegralLabel;

@property (nonatomic, strong) UIButton *selectTextBtn;
@property (nonatomic, strong) UIButton *selectImgBtn;

@property (nonatomic, strong) NSArray *infoArray;

@end

@implementation XFRechrgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_navView:@"充值"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
}

- (void)loadData {
    [HttpRequest postPath:XFMyRecharegListUrl
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0){
                          NSArray *infoArray = responseObject[@"info"];
                          if ([infoArray hasContent]) {
                              self.infoArray = infoArray;
                              [self setupContent];
                              [self getContentWithDict:self.infoArray.firstObject];
                          }
                      }
                  }
              }];
}

- (void)setupContent {
    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, XFNavHeight, kScreenWidth, 5);
    [self.view addSubview:paddingView];
    
    UILabel *myIntegralLabel = [UILabel xf_labelWithFont:Font(15)
                                               textColor:BlackColor
                                           numberOfLines:0
                                               alignment:NSTextAlignmentLeft];
    self.myIntegralLabel = myIntegralLabel;
    myIntegralLabel.text = [NSString stringWithFormat:@"我的积分：%@", self.count];
    myIntegralLabel.frame = CGRectMake(20, paddingView.bottom, kScreenWidth - 40, 40);
    [self.view addSubview:myIntegralLabel];
    
    UILabel *selectLabel = [UILabel xf_labelWithFont:Font(12)
                                           textColor:RGBGray(204)
                                       numberOfLines:0
                                           alignment:NSTextAlignmentLeft];
    selectLabel.text = @"选择充值金额";
    selectLabel.frame = CGRectMake(20, myIntegralLabel.bottom - 10, kScreenWidth - 40, 40);
    [self.view addSubview:selectLabel];
    
    CGFloat orignY = selectLabel.bottom;
    for (int i = 0; i < self.infoArray.count; i++) {
        NSString *title = [self getContentWithDict:self.infoArray[i]];
        UIButton *btn = [self createTextBtn:title tag:i];
        btn.top = orignY;
        orignY += (btn.height + 10);
        if (i == 0) {
            [self textBtnClick:btn];
        }
    }
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(10, orignY + 5, kScreenWidth - 20, 0.5);
    [self.view addSubview:splitView];
    
    UILabel *payStyleLabel = [UILabel xf_labelWithFont:Font(15)
                                             textColor:BlackColor
                                         numberOfLines:0
                                             alignment:NSTextAlignmentLeft];
    payStyleLabel.text = @"支付方式";
    payStyleLabel.frame = CGRectMake(20, splitView.bottom + 5, kScreenWidth - 40, 40);
    [self.view addSubview:payStyleLabel];
    
    UILabel *selectPayLabel = [UILabel xf_labelWithFont:Font(12)
                                              textColor:RGBGray(204)
                                          numberOfLines:0
                                              alignment:NSTextAlignmentLeft];
    selectPayLabel.text = @"选择支付方式";
    selectPayLabel.frame = CGRectMake(20, payStyleLabel.bottom - 10, kScreenWidth - 40, 40);
    [self.view addSubview:selectPayLabel];
    
    UIButton *alipayBtn = [self createImgBtn:@"icon_hy_zfb" tag:0];
    alipayBtn.left = 10;
    alipayBtn.top = selectPayLabel.bottom;
    
    UIButton *wechatBtn = [self createImgBtn:@"icon_hy_wxzf" tag:1];
    wechatBtn.left = alipayBtn.right + 30;
    wechatBtn.top = selectPayLabel.bottom;
    
    [self imgBtnClick:alipayBtn];
    
    UIButton *confirmBtn = [UIButton xf_bottomBtnWithTitle:@"立即充值"
                                                    target:self
                                                    action:@selector(confirmBtnClick)];
    confirmBtn.frame = CGRectMake(10, kScreenHeight - 54, kScreenWidth - 20, 44);
    [self.view addSubview:confirmBtn];
}

- (NSString *)getContentWithDict:(NSDictionary *)dict {
    NSString *buy_integral = dict[@"buy_integral"];
    NSString *money = dict[@"money"];
    NSString *send_integral = dict[@"send_integral"];
    return [NSString stringWithFormat:@"%@积分(赠送%@积分)¥%@", buy_integral, send_integral, money];
}

#pragma mark ----------Action----------
- (void)textBtnClick:(UIButton *)button {
    self.selectTextBtn.selected = NO;
    [self setupButton:self.selectTextBtn];
    button.selected = YES;
    self.selectTextBtn = button;
    [self setupButton:self.selectTextBtn];
}

- (void)imgBtnClick:(UIButton *)button {
    self.selectImgBtn.selected = NO;
    [self setupButton:self.selectImgBtn];
    button.selected = YES;
    self.selectImgBtn = button;
    [self setupButton:self.selectImgBtn];
}

- (void)confirmBtnClick {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *infoDict = self.infoArray[self.selectTextBtn.tag];
    [dict addEntriesFromDictionary:infoDict];
    dict[@"type"] = self.selectImgBtn.tag == 0 ? @"1" : @"2";
    [HttpRequest postPath:XFMyRechrgeUrl
                   params:dict
              resultBlock:^(id responseObject, NSError *error) {
#warning ,没有界面支持
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0){
                          NSDictionary *infoDict = responseObject[@"info"];
                          if ([infoDict isKindOfClass:[NSDictionary class]]) {
                              [ConfigModel mbProgressHUD:[NSString stringWithFormat:@"order_num:%@", infoDict[@"order_num"]] andView:nil];
                          }
                      }
                  }
              }];
}


#pragma mark ----------Private----------
- (UIButton *)createTextBtn:(NSString *)text tag:(NSInteger)tag {
    UIButton *button = [UIButton xf_titleButtonWithTitle:text
                                              titleColor:BlackColor
                                               titleFont:Font(13)
                                                  target:self
                                                  action:@selector(textBtnClick:)];
    button.left = 10;
    button.size = CGSizeMake(kScreenWidth - 20, 34);
    button.layer.borderWidth = 1;
    button.layer.borderColor = RGBGray(230).CGColor;
    [button xf_cornerCut:17];
    button.tag = tag;
    [self.view addSubview:button];
    return button;
}

- (UIButton *)createImgBtn:(NSString *)imgName tag:(NSInteger)tag  {
    UIButton *button = [UIButton xf_imgButtonWithImgName:imgName target:self action:@selector(imgBtnClick:)];
    button.size = CGSizeMake(126, 44);
    button.layer.borderWidth = 1;
    button.layer.borderColor = RGBGray(230).CGColor;
    [button xf_cornerCut:3];
    [self.view addSubview:button];
    button.tag = tag;
    return button;
}

- (void)setupButton:(UIButton *)button {
    if (button.selected) {
        [button setTitleColor:RGB(251, 120, 90) forState:UIControlStateNormal];
        button.layer.borderColor = RGBA(251, 120, 90, 0.5).CGColor;
    } else {
        [button setTitleColor:BlackColor forState:UIControlStateNormal];
        button.layer.borderColor = RGBGray(230).CGColor;
    }
}
@end

