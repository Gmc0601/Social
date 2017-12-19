//
//  XFNickNameViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFNickNameViewController.h"

@interface XFNickNameViewController ()

@property (nonatomic, weak) UITextField *field;

@end

@implementation XFNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_navView:@"昵称"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, navView.bottom, kScreenWidth, 5);
    [self.view addSubview:paddingView];
    
    UITextField *field = [[UITextField alloc] init];
    self.field = field;
    field.font = Font(14);
    field.textColor = BlackColor;
    NSMutableAttributedString *placeStr = [[NSMutableAttributedString alloc] initWithString:@"请输入昵称"];
    placeStr.font = Font(14);
    placeStr.color = RGBA(204, 204, 204, 0.7);
    field.attributedPlaceholder = placeStr.copy;
    field.frame = CGRectMake(15, paddingView.bottom, kScreenWidth - 30, 50);
    if (self.nickName.length) {
        field.text = self.nickName;
    }
    [self.view addSubview:field];
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(15, field.bottom, kScreenWidth - 30, 0.5);
    [self.view addSubview:splitView];
    
    UIButton *overBtn = [UIButton xf_bottomBtnWithTitle:@"完成"
                                                 target:self
                                                 action:@selector(overBtnClick)];
    overBtn.frame = CGRectMake(10, kScreenHeight - 54, kScreenWidth - 10, 44);
    [self.view addSubview:overBtn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)overBtnClick {
   
    
    if (self.field.text.length == 0) {
        [ConfigModel mbProgressHUD:@"请输入昵称" andView:nil];
        return;
    }
    
    if ([self.update isEqualToString:@"1"]) {
        
        if (self.saveBtnClick) {
            self.saveBtnClick(self.field.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    
    WeakSelf
    [HttpRequest postPath:XFMyBasicInfoUpdateUrl
                   params:@{@"nickname" : self.field.text}
              resultBlock:^(id responseObject, NSError *error) {
                  NSNumber *errorCode = responseObject[@"error"];
                  if (errorCode.integerValue == 0){
                      weakSelf.nickName = self.field.text;
                      if (weakSelf.nickName.length) {
                          if (weakSelf.saveBtnClick) {
                              weakSelf.saveBtnClick(self.nickName);
                          }
                      }
                      [weakSelf backBtnClick];
                  } else {
                      [ConfigModel mbProgressHUD:responseObject[@"info"] andView:nil];
                  }
              }];
    
}

@end

