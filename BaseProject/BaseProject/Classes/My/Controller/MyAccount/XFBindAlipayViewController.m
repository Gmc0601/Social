//
//  XFBindAlipayViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFBindAlipayViewController.h"

@interface XFBindAlipayViewController ()

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *accountField;

@end

@implementation XFBindAlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_navView:@"绑定账号"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, navView.bottom, kScreenWidth, 5);
    [self.view addSubview:paddingView];
    
    UITextField *nameField = [self createField:@"真实姓名"];
    self.nameField = nameField;
    nameField.top = paddingView.bottom;
    
    UIView *splitView1 = [UIView xf_createSplitView];
    splitView1.frame = CGRectMake(10, nameField.bottom, kScreenWidth - 20, 0.5);
    [self.view addSubview:splitView1];
    
    UITextField *accountField = [self createField:@"支付宝账号"];
    self.accountField = accountField;
    accountField.top = splitView1.bottom;
    
    UIView *splitView2 = [UIView xf_createSplitView];
    splitView2.frame = CGRectMake(10, accountField.bottom, kScreenWidth - 20, 0.5);
    [self.view addSubview:splitView2];
    
    UIButton *bindBtn = [UIButton xf_bottomBtnWithTitle:@"绑定"
                                                 target:self
                                                 action:@selector(bindBtnClick)];
    bindBtn.frame = CGRectMake(10, splitView2.bottom + 20, kScreenWidth - 20, 44);
    [self.view addSubview:bindBtn];
}

- (void)bindBtnClick {
    FFLogFunc
    if (self.nameField.text.length == 0) {
        FFLog(@"真实姓名为空");
        return;
    }
    
    if (self.accountField.text.length == 0) {
        FFLog(@"支付宝账号为空");
        return;
    }
    
    [HttpRequest postPath:XFMyBindAlipayUrl
                   params:@{@"name" : self.nameField.text,
                            @"alipay_account" : self.accountField.text}
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0){
                          FFLog(@"绑定成功");
                          [NoteCenter postNotificationName:XFBindAliPaySuccessNotification object:self.accountField.text];
                          [self backBtnClick];
                      }
                  }
              }];
}

- (UITextField *)createField:(NSString *)text {
    UITextField *field = [[UITextField alloc] init];
    field.left = 15;
    field.width = kScreenWidth - 30;
    field.height = 50;
    field.font = Font(15);
    field.textColor = BlackColor;
    field.leftViewMode = UITextFieldViewModeAlways;
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = Font(15);
    label.textColor = BlackColor;
    label.size = CGSizeMake(90, field.height);
    field.leftView = label;
    field.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:field];
    return field;
}

@end

