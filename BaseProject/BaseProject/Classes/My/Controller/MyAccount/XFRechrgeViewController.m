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

@end

@implementation XFRechrgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_navView:@"交易记录"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, navView.bottom, kScreenWidth, 5);
    [self.view addSubview:paddingView];
    
    UILabel *myIntegralLabel = [UILabel xf_labelWithFont:Font(15)
                                               textColor:BlackColor
                                           numberOfLines:0
                                               alignment:NSTextAlignmentLeft];
    self.myIntegralLabel = myIntegralLabel;
    myIntegralLabel.text = @"我的积分：0";
    myIntegralLabel.frame = CGRectMake(20, paddingView.bottom, kScreenWidth - 40, 40);
    [self.view addSubview:myIntegralLabel];
    
    UILabel *selectLabel = [UILabel xf_labelWithFont:Font(12)
                                               textColor:RGBGray(204)
                                           numberOfLines:0
                                               alignment:NSTextAlignmentLeft];
    selectLabel.text = @"选择充值金额";
    selectLabel.frame = CGRectMake(20, myIntegralLabel.bottom - 10, kScreenWidth - 40, 40);
    [self.view addSubview:selectLabel];
    
    UIButton *btn1 = [self createTextBtn:@"10积分(赠送1积分)¥10" tag:0];
    btn1.top = selectLabel.bottom;
    
    UIButton *btn2 = [self createTextBtn:@"50积分(赠送10积分)¥28" tag:1];
    btn2.top = btn1.bottom + 10;
    UIButton *btn3 = [self createTextBtn:@"100积分(赠送30积分)¥50" tag:2];
    btn3.top = btn2.bottom + 10;
    UIButton *btn4 = [self createTextBtn:@"150积分(赠送50积分)¥99" tag:3];
    btn4.top = btn3.bottom + 10;
    
    [self textBtnClick:btn1];
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(10, btn4.bottom + 15, kScreenWidth - 20, 0.5);
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
    FFLog(@"立即充值");
    FFLog(@"%@", self.selectTextBtn.currentTitle);
    FFLog(@"%zd", self.selectImgBtn.tag);
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
