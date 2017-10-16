//
//  XFGetMoneyViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFGetMoneyViewController.h"
#import "XFBindAlipayViewController.h"

@interface XFGetMoneyViewController ()

@property (nonatomic, weak) UIView *alertView;
@property (nonatomic, weak) UITextField *field;

@end

@implementation XFGetMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_themeNavView:@"提现"
                                   backTarget:self
                                   backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    UILabel *leftLabel1 = [UILabel xf_labelWithFont:Font(15)
                                          textColor:BlackColor
                                      numberOfLines:0
                                          alignment:NSTextAlignmentLeft];
    leftLabel1.text = @"提现到支付宝";
    leftLabel1.frame = CGRectMake(15, XFNavHeight, 100, 50);
    [self.view addSubview:leftLabel1];
    
    YYLabel *rightLabel = [YYLabel new];
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"未绑定支付宝账户"];
//    attr.font = Font(13);
//    attr.color = RGBGray(153);
//    NSMutableAttributedString *agreementAttr = [[NSMutableAttributedString alloc] initWithString:@" 立即绑定"];
//    agreementAttr.font = Font(13);
//    agreementAttr.color = RGB(86, 144, 56);
//    YYTextHighlight *highlight = [YYTextHighlight new];
//    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//        XFBindAlipayViewController *controller = [[XFBindAlipayViewController alloc] init];
//        [self pushController:controller];
//    };
//    [agreementAttr setTextHighlight:highlight range:agreementAttr.rangeOfAll];
//    [attr appendAttributedString:agreementAttr];
//    rightLabel.attributedText = attr.copy;
    /*  上面注释部分是未绑定支付宝账户  */
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"13011007870"];
    attr.font = Font(13);
    attr.color = BlackColor;
    NSMutableAttributedString *agreementAttr = [[NSMutableAttributedString alloc] initWithString:@" 修改"];
    agreementAttr.font = Font(13);
    agreementAttr.color = RGB(86, 144, 56);
    YYTextHighlight *highlight = [YYTextHighlight new];
    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        XFBindAlipayViewController *controller = [[XFBindAlipayViewController alloc] init];
        [self pushController:controller];
    };
    [agreementAttr setTextHighlight:highlight range:agreementAttr.rangeOfAll];
    [attr appendAttributedString:agreementAttr];
    rightLabel.attributedText = attr.copy;
    rightLabel.frame = CGRectMake(kScreenWidth - 215, XFNavHeight, 200, 50);
    rightLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:rightLabel];
    
    UIView *splitView1 = [UIView xf_createSplitView];
    splitView1.frame = CGRectMake(15, leftLabel1.bottom - 0.5, kScreenWidth - 30, 0.5);
    [self.view addSubview:splitView1];
    
    UILabel *leftLabel2 = [UILabel xf_labelWithFont:Font(15)
                                          textColor:BlackColor
                                      numberOfLines:0
                                          alignment:NSTextAlignmentLeft];
    leftLabel2.text = @"提现积分";
    leftLabel2.frame = CGRectMake(15, splitView1.bottom, 100, 40);
    [self.view addSubview:leftLabel2];
    
    UITextField *field = [[UITextField alloc] init];
    self.field = field;
    field.frame = CGRectMake(15, leftLabel2.bottom, kScreenWidth - 30, 60);
    field.font = FontB(50);
    field.textColor = BlackColor;
    [self.view addSubview:field];
    
    UIView *splitView2 = [UIView xf_createSplitView];
    splitView2.frame = CGRectMake(15, field.bottom  + 10, kScreenWidth - 30, 0.5);
    [self.view addSubview:splitView2];
    
    UILabel *leftLabel3 = [UILabel xf_labelWithFont:Font(12)
                                          textColor:RGBGray(153)
                                      numberOfLines:0
                                          alignment:NSTextAlignmentLeft];
    leftLabel3.text = @"可提现积分：100";
    leftLabel3.frame = CGRectMake(15, splitView2.bottom + 5, 100, 30);
    [self.view addSubview:leftLabel3];
    
    UILabel *leftLabel4 = [UILabel xf_labelWithFont:Font(12)
                                          textColor:RGBGray(153)
                                      numberOfLines:0
                                          alignment:NSTextAlignmentLeft];
    leftLabel4.text = @"不可提现积分：100";
    [leftLabel4 sizeToFit];
    leftLabel4.left = 15;
    leftLabel4.top = leftLabel3.bottom;
    [self.view addSubview:leftLabel4];
    
    UIButton *infoBtn = [UIButton xf_imgButtonWithImgName:@"tx_icon_sm"
                                                       target:self
                                                       action:@selector(infoBtnClick)];
    [infoBtn sizeToFit];
    infoBtn.left = leftLabel4.right + 10;
    infoBtn.centerY = leftLabel4.centerY;
    [self.view addSubview:infoBtn];
    
    UIButton *confirmBtn = [UIButton xf_bottomBtnWithTitle:@"确认提现"
                                                 target:self
                                                 action:@selector(confirmBtnClick)];
    confirmBtn.frame = CGRectMake(10, infoBtn.bottom + 30, kScreenWidth - 20, 44);
    [self.view addSubview:confirmBtn];
}

- (void)infoBtnClick {
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.alertView = alertView;
    alertView.userInteractionEnabled = YES;
    [alertView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomBtnClick)]];
    alertView.backgroundColor = MaskColor;
    
    UIView *contentView = [UIView xf_createWhiteView];
    contentView.width = kScreenWidth - 20;
    contentView.height = contentView.width * 0.5;
    contentView.centerX = alertView.width * 0.5;
    contentView.centerY = alertView.height * 0.5;
    [contentView xf_cornerCut:5];
    [alertView addSubview:contentView];
    
    UIButton *bottomBtn = [UIButton xf_bottomBtnWithTitle:@"知道了" target:self action:@selector(bottomBtnClick)];
    bottomBtn.frame = CGRectMake(20, contentView.height - 59, contentView.width - 40, 44);
    [contentView addSubview:bottomBtn];
    
    UILabel *infoLabel = [UILabel xf_labelWithFont:Font(14)
                                         textColor:BlackColor
                                     numberOfLines:0
                                         alignment:NSTextAlignmentCenter];
    infoLabel.text = @"该积分为充值赠送的积分，不允许提现哦";
    infoLabel.frame = CGRectMake(0, 0, contentView.width, bottomBtn.top);
    [contentView addSubview:infoLabel];
    
    
    alertView.alpha = 0;
    [self.view addSubview:alertView];
    [UIView animateWithDuration:0.25 animations:^{
        alertView.alpha = 1;
    }];
}

- (void)confirmBtnClick {
    FFLogFunc
    FFLog(@"%@", self.field.text);
}

- (void)bottomBtnClick {
    [UIView animateWithDuration:0.25 animations:^{
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.alertView removeFromSuperview];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
