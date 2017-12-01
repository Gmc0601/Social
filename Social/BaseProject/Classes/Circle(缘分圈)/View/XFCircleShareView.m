//
//  XFCircleShareView.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleShareView.h"

@interface XFCircleShareView ()

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, strong) XFUDButton *friendBtn;
@property (nonatomic, strong) XFUDButton *wechatBtn;
@property (nonatomic, strong) XFUDButton *qqBtn;
@property (nonatomic, strong) XFUDButton *qzoneBtn;
@property (nonatomic, strong) XFUDButton *weiboBtn;

@end

@implementation XFCircleShareView

- (instancetype)init {
    if (self == [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = MaskColor;
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        
        UIView *contentView = [UIView xf_createWhiteView];
        self.contentView = contentView;
        contentView.frame = CGRectMake(0, self.height, self.width, 0);
        [self addSubview:contentView];
        
        UIButton *friendBtn = [self createBtn:@"icon_fx_pyq" title:@"朋友圈"];
        friendBtn.tag = 0;
        friendBtn.top = 74;
        friendBtn.width = kScreenWidth * 0.2;
        friendBtn.height = 75;
        friendBtn.left = 0;
        
        UIButton *wechatBtn = [self createBtn:@"icon_fx_wx" title:@"微信好友"];
        wechatBtn.tag = 1;
        wechatBtn.frame = friendBtn.frame;
        wechatBtn.left = friendBtn.right;
        
        UIButton *qqBtn = [self createBtn:@"icon_fx_qq" title:@"QQ好友"];
        qqBtn.tag = 2;
        qqBtn.frame = wechatBtn.frame;
        qqBtn.left = wechatBtn.right;
        
        UIButton *qzoneBtn = [self createBtn:@"icon_fx_qqkj" title:@"QQ空间"];
        qzoneBtn.tag = 3;
        qzoneBtn.frame = qqBtn.frame;
        qzoneBtn.left = qqBtn.right;
        
        UIButton *weiboBtn = [self createBtn:@"icon_fx_wb" title:@"微博"];
        weiboBtn.tag = 4;
        weiboBtn.frame = qzoneBtn.frame;
        weiboBtn.left = qzoneBtn.right;
        
        UIView *splitView = [UIView xf_createSplitView];
        splitView.frame = CGRectMake(0, friendBtn.bottom + 60, self.width, 0.5);
        [self.contentView addSubview:splitView];
        
        UIButton *canBtn = [UIButton xf_titleButtonWithTitle:@"取消"
                                                  titleColor:BlackColor
                                                   titleFont:Font(15)
                                                      target:self
                                                      action:@selector(canBtnClick)];
        canBtn.frame = CGRectMake(0, splitView.bottom, self.width, 50);
        [self.contentView addSubview:canBtn];
        self.contentView.height = canBtn.bottom;
        
        [self show];
    }
    return self;
}

#pragma mark ----------Action----------
- (void)buttonClick:(XFUDButton *)button {
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleShareView:didClick:)]) {
        [self.delegate circleShareView:self didClick:(CircleShareBtnType)button.tag];
    }
}

- (void)canBtnClick {
    [self dismiss];
}

- (void)show {
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        self.contentView.bottom = kScreenHeight;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.contentView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (XFUDButton *)createBtn:(NSString *)imgName title:(NSString *)title {
    XFUDButton *button = [XFUDButton buttonWithType:UIButtonTypeCustom];
    button.padding = 12;
    button.titleLabel.font = Font(12);
    [button setTitleColor:RGBGray(143) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:Image(imgName) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    return button;
}

@end

