//
//  XFAccountViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/19.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFAccountViewController.h"
#import "XFTradeRecordViewController.h"
#import "XFRechrgeViewController.h"
#import "XFGetMoneyViewController.h"

@interface XFAccountViewController ()

@property (nonatomic, weak) UILabel *integralLabel;
@property (nonatomic, weak) UILabel *incomeLabel;
@property (nonatomic, weak) UILabel *expendLabel;
@property (nonatomic, weak) UILabel *payLabel;

@end

@implementation XFAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_navView:@"账户"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    
    UIButton *recordBtn = [UIButton xf_titleButtonWithTitle:@"交易记录"
                                                 titleColor:BlackColor
                                                  titleFont:Font(15)
                                                     target:self
                                                     action:@selector(recordBtnClick)];
    recordBtn.frame = CGRectMake(kScreenWidth - 85, 20, 85, 44);
    [navView addSubview:recordBtn];
    [self.view addSubview:navView];
    
    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, navView.bottom, kScreenWidth, 5);
    [self.view addSubview:paddingView];
    
    
    UILabel *integralLabel = [UILabel xf_labelWithFont:Font(15)
                                             textColor:BlackColor
                                         numberOfLines:1
                                             alignment:NSTextAlignmentCenter];
    integralLabel.text = @"我的积分";
    integralLabel.frame = CGRectMake(0, paddingView.bottom + 45, kScreenWidth, 15);
    [self.view addSubview:integralLabel];
    
    
    UILabel *countLabel = [UILabel xf_labelWithFont:FontB(50)
                                          textColor:BlackColor
                                      numberOfLines:1
                                          alignment:NSTextAlignmentCenter];
    countLabel.text = @"0";
    self.integralLabel = countLabel;
    countLabel.frame = CGRectMake(0, integralLabel.bottom + 20, kScreenWidth, 38);
    [self.view addSubview:countLabel];
    
    UIView *inView = [self createItemView:@"积分收入"];
    inView.top = countLabel.bottom + 55;
    inView.left = 0;
    [self.view addSubview:inView];
    self.incomeLabel = [inView viewWithTag:100];
    
    UIView *rechargeView = [self createItemView:@"积分充值"];
    rechargeView.top = countLabel.bottom + 55;
    rechargeView.left = inView.right;
    [self.view addSubview:rechargeView];
    self.payLabel = [rechargeView viewWithTag:100];
    
    UIView *outView = [self createItemView:@"积分支出"];
    outView.top = countLabel.bottom + 55;
    outView.left = rechargeView.right;
    [self.view addSubview:outView];
    self.expendLabel = [outView viewWithTag:100];
    
    UIView *splitView1 = [UIView xf_createSplitView];
    splitView1.size = CGSizeMake(0.5, 28);
    splitView1.left = inView.right;
    splitView1.centerY = inView.centerY;
    [self.view addSubview:splitView1];
    
    UIView *splitView2 = [UIView xf_createSplitView];
    splitView2.size = CGSizeMake(0.5, 28);
    splitView2.left = rechargeView.right;
    splitView2.centerY = rechargeView.centerY;
    [self.view addSubview:splitView2];
    
    UIButton *outBtn = [UIButton xf_titleButtonWithTitle:@"提现"
                                              titleColor:BlackColor
                                               titleFont:Font(15)
                                                  target:self
                                                  action:@selector(outBtnClick)];
    outBtn.backgroundColor = RGBGray(242);
    [outBtn xf_cornerCut:5];
    outBtn.size = CGSizeMake(kScreenWidth - 20, 44);
    outBtn.left = 10;
    outBtn.top = outView.bottom + 10;
    [self.view addSubview:outBtn];
    
    UIButton *inBtn = [UIButton xf_bottomBtnWithTitle:@"充值"
                                               target:self
                                               action:@selector(inBtnClick)];
    inBtn.frame = CGRectMake(10, outBtn.bottom + 10, kScreenWidth - 20, 44);
    [self.view addSubview:inBtn];
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFMyAccountUrl
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  NSDictionary *info = responseObject[@"info"];
                  NSNumber *integral = info[@"integral"];
                  
                  if ([integral isKindOfClass:[NSNumber class]]) {
                      weakSelf.integralLabel.text = integral.stringValue;
                  } else if ([integral isKindOfClass:[NSString class]]) {
                      weakSelf.integralLabel.text = (NSString *)integral;
                  } else {
                      weakSelf.integralLabel.text = @"0";
                  }

                  NSNumber *income = info[@"income"];
                  if ([income isKindOfClass:[NSNumber class]]) {
                      weakSelf.incomeLabel.text = income.stringValue;
                  } else {
                      weakSelf.incomeLabel.text = @"0";
                  }
                  
                  NSNumber *expend = info[@"expend"];
                  if ([income isKindOfClass:[NSNumber class]]) {
                      weakSelf.expendLabel.text = expend.stringValue;
                  } else {
                      weakSelf.expendLabel.text = @"0";
                  }

                  NSNumber *pay = info[@"pay"];
                  if ([income isKindOfClass:[NSNumber class]]) {
                      weakSelf.payLabel.text = pay.stringValue;
                  } else {
                      weakSelf.payLabel.text = @"0";
                  }
              }];
}

#pragma mark ----------Action----------
- (void)recordBtnClick {
    XFTradeRecordViewController *controller = [[XFTradeRecordViewController alloc] init];
    [self pushController:controller];
}

- (void)outBtnClick {
    XFGetMoneyViewController *controller = [[XFGetMoneyViewController alloc] init];
    [self pushController:controller];
}

- (void)inBtnClick {
    XFRechrgeViewController *controller = [[XFRechrgeViewController alloc] init];
    [self pushController:controller];
}

- (UIView *)createItemView:(NSString *)info {
    UIView *view = [UIView xf_createWhiteView];
    view.size = CGSizeMake(kScreenWidth / 3, 55);
    
    UILabel *infoLabel = [UILabel xf_labelWithFont:Font(12)
                                         textColor:RGBGray(204)
                                     numberOfLines:1
                                         alignment:NSTextAlignmentCenter];
    infoLabel.text = info;
    infoLabel.frame = CGRectMake(0, 0, view.width, 25);
    [view addSubview:infoLabel];
    
    UILabel *countLabel = [UILabel xf_labelWithFont:FontB(18)
                                          textColor:RGBGray(102)
                                      numberOfLines:1
                                          alignment:NSTextAlignmentCenter];
    countLabel.text = @"0";
    countLabel.frame = CGRectMake(0, infoLabel.bottom, view.width, 30);
    countLabel.tag = 100;
    [view addSubview:countLabel];
    
    
    return view;
}

@end

