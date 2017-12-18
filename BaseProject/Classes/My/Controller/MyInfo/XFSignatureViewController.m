//
//  XFSignatureViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFSignatureViewController.h"

@interface XFSignatureViewController ()<UITextViewDelegate>

@property (nonatomic, weak) UITextView *textView;

@end

@implementation XFSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_navView:@"个性签名"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, navView.bottom, kScreenWidth, 5);
    [self.view addSubview:paddingView];
    
    XFTextView *textView = [[XFTextView alloc] init];
    self.textView = textView;
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = RGBGray(224).CGColor;
    [textView xf_cornerCut:3];
    textView.font = Font(13);
    textView.placeholder = @"请输入个性签名";
    textView.placeholderColor = RGBGray(204);
    textView.left = 15;
    textView.delegate = self;
    textView.top = paddingView.bottom + 20;
    textView.width = kScreenWidth - 30;
    textView.height = textView.width / 2.6;
    [self.view addSubview:textView];
    
    UILabel *infoLabel = [UILabel xf_labelWithFont:Font(13)
                                         textColor:RGBGray(153)
                                     numberOfLines:0
                                         alignment:NSTextAlignmentRight];
    infoLabel.text = @"最多可输入24个字符";
    infoLabel.frame = CGRectMake(15, textView.bottom, kScreenWidth - 30, 50);
    [self.view addSubview:infoLabel];
    
    UIButton *saveBtn = [UIButton xf_bottomBtnWithTitle:@"保存"
                                                 target:self
                                                 action:@selector(btnClick)];
    saveBtn.frame = CGRectMake(10, infoLabel.bottom, kScreenWidth - 20, 44);
    [self.view addSubview:saveBtn];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 24) {
        textView.text = [textView.text substringToIndex:24];
    }
}

- (void)btnClick {
    WeakSelf
    if (self.textView.text.length) {
        [HttpRequest postPath:XFMySignUrl
                       params:@{@"sdf" : self.textView.text}
                  resultBlock:^(id responseObject, NSError *error) {
                      NSString *info = responseObject[@"info"];
                      NSNumber *code = responseObject[@"error"];
                      if (code.integerValue == 0) {
                          [SVProgressHUD showSuccessWithStatus:info];
                          if (weakSelf.textView.text.length) {
                              if (weakSelf.saveBtnClick) {
                                  weakSelf.saveBtnClick(self.textView.text);
                              }
                          }
                          [self backBtnClick];
                      }
                  }];
    }
}

@end

