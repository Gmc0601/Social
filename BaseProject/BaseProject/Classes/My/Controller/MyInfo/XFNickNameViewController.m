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
    self.nickName = self.field.text;
    if (self.nickName.length) {
        if (self.saveBtnClick) {
            self.saveBtnClick(self.nickName);
        }
    }
    [self backBtnClick];
}

@end

