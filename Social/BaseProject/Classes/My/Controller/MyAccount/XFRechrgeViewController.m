//
//  XFRechrgeViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFRechrgeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface XFRechrgeViewController ()

@property (nonatomic, weak) UILabel *myIntegralLabel;

@property (nonatomic, strong) UIButton *selectTextBtn;
@property (nonatomic, strong) UIButton *selectImgBtn;

@property (nonatomic, strong) NSArray *infoArray;

@property (nonatomic, copy) NSString *order_num;

@end

@implementation XFRechrgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(aliPaySuccess:)
                                                 name:@"AliPaySuccessNotification"
                                               object:nil];
}

- (void)aliPaySuccess:(NSNotification *)notification {
    NSDictionary *resultDic = notification.object;
    NSString *status = resultDic[@"resultStatus"];
    if (status.integerValue == 9000) {
        [ConfigModel mbProgressHUD:@"支付成功" andView:nil];
        [self gotoSuccessController:self.order_num];
    } else {
        [ConfigModel mbProgressHUD:@"支付失败" andView:nil];
    }
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
                          NSDictionary *infoDict = responseObject[@"info"];
                          if ([infoDict isKindOfClass:[NSDictionary class]]) {
                              NSArray *infoArray = infoDict[@"list"];
                              if ([infoArray hasContent]) {
                                  self.infoArray = infoArray;
                                  [self setupContent];
                                  [self getContentWithDict:self.infoArray.firstObject];
                              }
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
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0){
                          NSDictionary *infoDict = responseObject[@"info"];
                          if ([infoDict isKindOfClass:[NSDictionary class]]) {
                              [self sendzhifubaooder:infoDict[@"order_num"] dict:dict];
                          }
                      }
                  }
              }];
}

-(void)sendzhifubaooder:(NSString *)order_num dict:(NSDictionary *)dict {
    self.order_num = order_num;
    NSString *privateKey = @"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCsQtALrxnsLj+ZYa0hV7GzxLNlb3a5iaDdKE/4xG/A+Urz7C2lhV30up6rAQaRKolXOfiGPu9zFkTEXhRmBXqZsLqHCytHZk+kqZL6QlGOPdTGO8R77jgYREU/F1xOTg6G//BcAtDnGoOZ8ofdRWZmt/imh5jj9yL9eC9BihajzMAV8d7JVM39ZBB5SEC9/RIriE+iZTIYR9bTfV+ADbPRyGAwq7JJ17an7yG0rNrvS7cmbDgG8D244o6ajJ214bx27PjB+oZubFvgKkeT7r/8UTeNyv/IVkAKE4AcNkSdpB4FwddZbGwmMWsuufoiPVozzJ05e85CH73T+56MWmQrAgMBAAECggEBAImXeEvM2fzPWBdwcHRQcm0vsUdVR9Sc/LOJro76gHT36ol43WD3bPu8UF4wnIk5G6hjcoHwJRyc7eKXbt2qhKncArE5F6GZNAZHOFHSxQfDlX+dX6zJs16WsWTaiO025d2o8tjbmvbtM660jRcNhuSHEAIcDuAPl5Az/jLwVHMSFnji12sRFMMCj+EEnsufPKumJ39bwkMK1MSfIGfSuO8989izmjOm5dDSbBYU9Yop3Te3Ympnb6ojtEjwHXUZzQSHU+88WSu8QM6QhFXBaHAgaIrs8jD3efBVLVXmGwQNTkWdh7tF7wNXP+2UPpWEDljHtL5zaZxNFx07mlEP7lECgYEA8kCHXT8St9+QqcEtvzjCTVO306L+3kRMdsQ5tu6aKtZXz5ezNTTuHbqC5aGL4pxwhwLs3KMKkRkQwnuriT0lzlLxRdGkRwoyu4W9G+vo6ADq5PuPX8hgRxDHP//vnIPxXxW7Q1c+g0WFh5ZQ24bVqbaS3CMe5SlPFN2vrMnN4fkCgYEAtglxpQLKWsIg3wzwxFUcwn3EfMXRghy3j3XhhtbK0iX1MDVnaMF55bpy09Kb5KTXrgLMCxrYLmYvENfGbhVBn+RRVpC8tc7q9gFdcYAUNfqGak2LVDBKMPrn/3ueL6rmFso2uQ34yc1qnrCaUQ2agHS+zRK0QOf+yN2isrlKQEMCgYA1MA/IXFHKxy4m50AZDOg0PB5PPClDObGkHd8iF+8HWro63O6+ztk887dLnZVt8rUOH4lLxAxM4Tj5yldWMXO8gh9xGd88rbOH0ow7ticT0SfBkK3g9MiWsctddN7x+VIkc0wDNAOIpNn1c/5axJbixTAnXxqoa9JuHWI1yLUIWQKBgEiU/WYw9aQ4cUjebQWrdhsqcHTbn0zEzH/8HZ9Y92fRULEXKhM/ya3KqMxC1nvVKlYssVTgMEBX5/5MOsdb3F23eKMOdN/9D/xk0PBXhDd9m6i5IIvB8WMUN/rLPGh/ONzvZeBlbMRyDkgV3IHi7a64XfeAtLSIjDNlA+FFNhDnAoGADsy+SJzawaOtnuOdPZGPINZtc+ZnNczfQIUy6/h5ycVq7ORJ6HMl7DT0RB2T9IhS9HoYONGVtmI2tR/dAtMH/NbTMwjoLrCzzogHkEDZdApfDOjIPO4W8l4p9fGd+5hbtk1CaqL8XWaqfXgwajp5QdwOwsBtfIw/2Pxr1nT5ieo=";
    Order *order = [[Order alloc] init];
    order.partner = @"2088821474533441";
    order.seller = @"2088821474533441";
    order.tradeNO = order_num; //订单ID（由商家自行制定）
    order.productName = [NSString stringWithFormat:@"%@积分(赠送%@积分)¥%@", dict[@"buy_integral"], dict[@"send_integral"], dict[@"money"]];
     order.productDescription = [NSString stringWithFormat:@"%@积分(赠送%@积分)¥%@", dict[@"buy_integral"], dict[@"send_integral"], dict[@"money"]];
    order.amount = dict[@"money"]; //商品价格
    order.notifyURL = @" https://www.baidu.com"; //回调URL
    order.itBPay = @"30m";

    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";

    NSString *appScheme = @"baseProject";
    NSString *orderSpec = [order description];

    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];

    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];;

        NSArray *array = [[UIApplication sharedApplication] windows];
        UIWindow* win=[array objectAtIndex:0];
        [win setHidden:NO];

        [[AlipaySDK defaultService] payOrder:orderString
                                  fromScheme:appScheme
                                    callback:^(NSDictionary *resultDic) {
                                        NSString *status = resultDic[@"resultStatus"];
                                        FFLog(@"%@", resultDic);
                                        if (status.integerValue == 9000) {
                                            [ConfigModel mbProgressHUD:@"支付成功" andView:nil];
                                            [self gotoSuccessController:order_num];
                                        } else {
                                            [ConfigModel mbProgressHUD:@"支付失败" andView:nil];
                                        }
                                    }];
    }
}

- (void)gotoSuccessController:(NSString *)order_num {
    [HttpRequest postPath:XFAlipayPayUrl
                   params:@{@"order_no" : order_num}
              resultBlock:^(id responseObject, NSError *error) {
                  [self backBtnClick];
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

