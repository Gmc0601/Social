//
//  XFCharmRuleViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/27.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCharmRuleViewController.h"

@interface XFCharmRuleViewController ()

@property (nonatomic, weak) UIWebView *webView;

@end

@implementation XFCharmRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_navView:@"规则说明"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, navView.bottom, kScreenWidth, 5);
    [self.view addSubview:paddingView];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, paddingView.bottom, kScreenWidth, kScreenHeight - paddingView.bottom)];
    self.webView = webView;
    webView.backgroundColor = WhiteColor;
    [self.view addSubview:webView];
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFMyCharmRuleUrl
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSString *info = responseObject[@"info"];
                          [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:info]]];
                          
                      }
                  }
              }];
}

@end

