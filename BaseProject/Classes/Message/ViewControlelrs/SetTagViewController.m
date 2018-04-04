//
//  SetTagViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/12.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "SetTagViewController.h"
#import <YYKit.h>


@interface SetTagViewController (){
    NSString *pleacelhoder, *btnTitle;
}

@property (nonatomic, strong) YYTextView *textView;

@property (nonatomic, strong) UIButton *configBtn;

@end

@implementation SetTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    
    [self setUI];
}

- (void)resetFather {
    if (self.type == GroupSet) {
        self.titleLab.text = @"群公告";
        pleacelhoder =  @"请填写想要发布的群公告";
        btnTitle = @"发布";
    }else {
        pleacelhoder =  @"请输入标签内容";
       self.titleLab.text = @"标签";
        btnTitle =  @"保存";
    }
    
    
    self.rightBar.hidden = YES;
    
}

- (void)setUI {
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.configBtn];
}


- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc] initWithFrame:FRAME(SizeWidth(10), 64 + SizeHeigh(10), kScreenW - SizeWidth(20), SizeHeigh(200))];
        _textView.layer.masksToBounds =  YES;
        _textView.layer.cornerRadius = 5;
        _textView.layer.borderWidth =  1;
        _textView.layer.borderColor =  [UIColorHex(0x666666) CGColor];
        _textView.placeholderText = pleacelhoder;
    }
    return _textView;
}

- (UIButton *)configBtn {
    if (!_configBtn) {
        _configBtn = [[UIButton alloc] initWithFrame:FRAME(SizeWidth(10), self.textView.bottom + SizeHeigh(10), kScreenW - SizeWidth(20), SizeHeigh(45))];
        _configBtn.backgroundColor = ThemeColor;
        [_configBtn setTitle:btnTitle forState:UIControlStateNormal];
        [_configBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _configBtn.layer.masksToBounds = YES;
        _configBtn.layer.cornerRadius = 5;
        _configBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _configBtn;
}

- (void)saveBtnClick {
    //  保存标签
    
    if (self.type == GroupSet ) {
        [self groupSet];
    }
    
    if (self.type == TagSet) {
        [self tagset];
    }
    
}
//  保存群聊
- (void)groupSet {
    
}
// 保存标签 
- (void)tagset {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
