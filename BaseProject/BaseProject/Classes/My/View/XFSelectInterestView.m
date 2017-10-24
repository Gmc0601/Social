//
//  XFSelectInterestView.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFSelectInterestView.h"

#define PurpleColor         RGB(101, 53, 157)
#define InterestBtnBaseTag  100
@interface XFSelectInterestView ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation XFSelectInterestView

- (instancetype)initWithSelectArray:(NSArray *)selectArray {
    if (self == [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        UIButton *bgBtn = [UIButton xf_emptyButtonWithTarget:self action:@selector(dismiss)];
        bgBtn.backgroundColor = MaskColor;
        bgBtn.frame = self.bounds;
        [self addSubview:bgBtn];
        UIView *contentView = [UIView xf_createViewWithColor:RGBGray(249)];
        self.contentView = contentView;
        contentView.width = kScreenWidth > 320 ? 340 : 300;
        [contentView xf_cornerCut:5];
        [self addSubview:contentView];
        
        UIButton *closeBtn = [UIButton xf_imgButtonWithImgName:@"sg_ic_quxiao"
                                                        target:self
                                                        action:@selector(closeBtnClick)];
        closeBtn.size = CGSizeMake(45, 45);
        closeBtn.right = contentView.width;
        [contentView addSubview:closeBtn];
        
        self.btnArray = [NSMutableArray array];
        for (int i = 0; i < self.dataArray.count; i++) {
            NSString *title = self.dataArray[i];
            UIButton *btn = [self createBtn:title];
            if (selectArray.count && [selectArray containsObject:title]) {
                btn.selected = YES;
            }
            btn.tag = i + InterestBtnBaseTag;
            btn.width = [btn sizeThatFits:CGSizeZero].width + 30;
            btn.height = 32;
            [self setupButton:btn];
            [contentView addSubview:btn];
            [self.btnArray addObject:btn];
        }
        
        CGFloat padding = 10;
        UIButton *btn11 = [contentView viewWithTag:InterestBtnBaseTag + 0];
        UIButton *btn12 = [contentView viewWithTag:InterestBtnBaseTag + 1];
        UIButton *btn13 = [contentView viewWithTag:InterestBtnBaseTag + 2];
        btn11.top = btn12.top = btn13.top = closeBtn.bottom + 15;
        btn11.left = (contentView.width - btn11.width - btn12.width - btn13.width - padding * 2) * 0.5;
        btn12.left = btn11.right + padding;
        btn13.left = btn12.right + padding;
        
        UIButton *btn21 = [contentView viewWithTag:InterestBtnBaseTag + 3];
        UIButton *btn22 = [contentView viewWithTag:InterestBtnBaseTag + 4];
        UIButton *btn23 = [contentView viewWithTag:InterestBtnBaseTag + 5];
        btn21.top = btn22.top = btn23.top = btn13.bottom + 18;
        btn21.left = (contentView.width - btn21.width - btn22.width - btn23.width - padding * 2) * 0.5;
        btn22.left = btn21.right + padding;
        btn23.left = btn22.right + padding;
        
        UIButton *btn31 = [contentView viewWithTag:InterestBtnBaseTag + 6];
        UIButton *btn32 = [contentView viewWithTag:InterestBtnBaseTag + 7];
        UIButton *btn33 = [contentView viewWithTag:InterestBtnBaseTag + 8];
        UIButton *btn34 = [contentView viewWithTag:InterestBtnBaseTag + 9];
        btn31.top = btn32.top = btn33.top = btn34.top = btn23.bottom + 18;
        btn31.left = (contentView.width - btn31.width - btn32.width - btn33.width - btn34.width - padding * 3) * 0.5;
        btn32.left = btn31.right + padding;
        btn33.left = btn32.right + padding;
        btn34.left = btn33.right + padding;
        
        UIButton *btn41 = [contentView viewWithTag:InterestBtnBaseTag + 10];
        UIButton *btn42 = [contentView viewWithTag:InterestBtnBaseTag + 11];
        UIButton *btn43 = [contentView viewWithTag:InterestBtnBaseTag + 12];
        UIButton *btn44 = [contentView viewWithTag:InterestBtnBaseTag + 13];
        btn41.top = btn42.top = btn43.top = btn44.top = btn33.bottom + 18;
        btn41.left = (contentView.width - btn41.width - btn42.width - btn43.width - btn44.width - padding * 3) * 0.5;
        btn42.left = btn41.right + padding;
        btn43.left = btn42.right + padding;
        btn44.left = btn43.right + padding;
        
        UIButton *btn51 = [contentView viewWithTag:InterestBtnBaseTag + 14];
        UIButton *btn52 = [contentView viewWithTag:InterestBtnBaseTag + 15];
        btn51.top = btn52.top = btn44.bottom + 18;
        btn51.left = (contentView.width - btn51.width - btn52.width - padding) * 0.5;
        btn52.left = btn51.right + padding;
        
        contentView.height = btn52.bottom + 47;
        contentView.centerX = self.width * 0.5;
        contentView.centerY = self.height * 0.5;
        
        [self show];
    }
    return self;
}

- (void)closeBtnClick {
    [self dismiss];
}

- (void)btnClick:(UIButton *)button {
    button.selected = !button.selected;
    [self setupButton:button];
}

- (void)show {
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (UIButton *btn in self.btnArray) {
        if (btn.selected) {
            [arrayM addObject:btn.currentTitle];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectInterestView:didselectItem:)]) {
        [self.delegate selectInterestView:self didselectItem:arrayM.copy];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIButton *)createBtn:(NSString *)text {
    UIButton *btn = [UIButton xf_titleButtonWithTitle:text
                                           titleColor:PurpleColor
                                            titleFont:Font(15)
                                               target:self
                                               action:@selector(btnClick:)];
    btn.height = 32;
    btn.layer.borderColor = PurpleColor.CGColor;
    btn.layer.borderWidth = 1;
    [btn xf_cornerCut:16];
    [self.contentView addSubview:btn];
    return btn;
}

- (void)setupButton:(UIButton *)button {
    if (button.selected) {
        [button setTitleColor:WhiteColor forState:UIControlStateNormal];
        button.backgroundColor = PurpleColor;
    } else {
        [button setTitleColor:PurpleColor forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
    }
}

- (NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = @[@"跳舞",
                       @"打游戏",
                       @"听音乐",
                       @"看电影",
                       @"看书",
                       @"烹饪",
                       @"绘画",
                       @"旅游",
                       @"写作",
                       @"跑步",
                       @"摄影",
                       @"游泳",
                       @"轮滑",
                       @"购物",
                       @"滑冰",
                       @"其他"];
    }
    return _dataArray;
}

@end

