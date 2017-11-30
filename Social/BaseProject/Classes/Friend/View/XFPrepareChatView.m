//
//  XFPrepareChatView.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/22.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFPrepareChatView.h"

@interface XFPrepareChatView ()

@property (nonatomic, weak) UITextField *field;

@end

@implementation XFPrepareChatView

- (instancetype)initWithScore:(NSString *)score {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        UIButton *bgBtn = [UIButton xf_emptyButtonWithTarget:self action:@selector(endEdit)];
        bgBtn.backgroundColor = MaskColor;
        bgBtn.frame = self.bounds;
        [self addSubview:bgBtn];
        
        UIView *contentView = [UIView xf_createWhiteView];
        contentView.width = kScreenWidth > 320 ? 340 : 300;
        [contentView xf_cornerCut:5];
        [self addSubview:contentView];
        
        UIButton *infoBtn = [UIButton xf_buttonWithTitle:@" 聊天看诚意金哟"
                                              titleColor:RGBGray(153)
                                               titleFont:Font(12)
                                                 imgName:@"tx_icon_sm"
                                                  target:nil
                                                  action:nil];
        infoBtn.frame = CGRectMake(0, 0, 140, 45);
        infoBtn.userInteractionEnabled = NO;
        [contentView addSubview:infoBtn];
        
        UILabel *suggestLabel = [UILabel xf_labelWithFont:Font(13) 
                                                textColor:RGBGray(102)
                                            numberOfLines:1
                                                alignment:NSTextAlignmentLeft];
        suggestLabel.text = @"建议诚意金：";
        suggestLabel.width = [suggestLabel sizeThatFits:CGSizeZero].width;
        suggestLabel.left = 15;
        suggestLabel.height = 50;
        suggestLabel.top = infoBtn.bottom;
        [contentView addSubview:suggestLabel];
        
        UILabel *countLabel = [[UILabel alloc] init];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:score];
        attrStr.font = FontB(14);
        NSMutableAttributedString *rightAttrStr = [[NSMutableAttributedString alloc] initWithString:@"积分"];
        attrStr.font = FontB(15);
        [attrStr appendAttributedString:rightAttrStr];
        attrStr.color = RGB(139, 157, 100);
        countLabel.attributedText = attrStr;
        [countLabel sizeToFit];
        countLabel.left = suggestLabel.right;
        countLabel.bottom = suggestLabel.centerY + 10;
        [contentView addSubview:countLabel];
        
        
        UILabel *infoLabel = [UILabel xf_labelWithFont:Font(13)
                                                textColor:BlackColor
                                            numberOfLines:1
                                                alignment:NSTextAlignmentLeft];
        infoLabel.text = @"诚意金(积分)";
        infoLabel.width = 150;
        infoLabel.left = 15;
        infoLabel.height = 50;
        infoLabel.top = suggestLabel.bottom + 10;
        [contentView addSubview:infoLabel];

        UITextField *field = [[UITextField alloc] init];
        self.field = field;
        field.borderStyle = UITextBorderStyleNone;
        field.font = FontB(30);
        field.textColor = BlackColor;
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.frame = CGRectMake(15, infoLabel.bottom, contentView.width - 30, 45);
        [contentView addSubview:field];
        
        UIView *splitView = [UIView xf_createSplitView];
        splitView.frame = CGRectMake(15, field.bottom, contentView.width - 30, 0.5);
        [contentView addSubview:splitView];
        
        UILabel *explainLabel = [UILabel xf_labelWithFont:Font(12)
                                                textColor:RGBGray(204)
                                            numberOfLines:1
                                                alignment:NSTextAlignmentLeft];
        explainLabel.text = @"对方拒绝诚意金，诚意金退换到账";
        explainLabel.frame = CGRectMake(15, splitView.bottom, contentView.width - 30, 30);;
        [contentView addSubview:explainLabel];
        
        UIButton *cancelBtn = [UIButton xf_titleButtonWithTitle:@"取消"
                                                     titleColor:BlackColor
                                                      titleFont:FontB(15)
                                                         target:self
                                                         action:@selector(dismiss)];
        cancelBtn.backgroundColor = RGBGray(242);
        [cancelBtn xf_cornerCut:3];
        [contentView addSubview:cancelBtn];
        
        UIButton *confirmBtn = [UIButton xf_titleButtonWithTitle:@"确定"
                                                     titleColor:WhiteColor
                                                      titleFont:FontB(15)
                                                         target:self
                                                         action:@selector(confirmBtnClick)];
        confirmBtn.backgroundColor = ThemeColor;
        [confirmBtn xf_cornerCut:3];
        [contentView addSubview:confirmBtn];
        
        cancelBtn.size = confirmBtn.size = CGSizeMake((contentView.width - 45) * 0.5, 44);
        cancelBtn.left = 15;
        confirmBtn.left = cancelBtn.right + 15;
        cancelBtn.top = confirmBtn.top = explainLabel.bottom + 30;
        
        contentView.height = confirmBtn.bottom + 15;
        contentView.centerX = self.width * 0.5;
        contentView.centerY = self.height * 0.5;
        [self show];
    }
    return self;
}

- (instancetype)initRequestWithSource:(NSString *)score {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        UIButton *bgBtn = [UIButton xf_emptyButtonWithTarget:self action:@selector(endEdit)];
        bgBtn.backgroundColor = MaskColor;
        bgBtn.frame = self.bounds;
        [self addSubview:bgBtn];
        
        UIView *contentView = [UIView xf_createWhiteView];
        contentView.width = kScreenWidth > 320 ? 340 : 300;
        [contentView xf_cornerCut:5];
        [self addSubview:contentView];
        
        UIButton *infoBtn = [UIButton xf_buttonWithTitle:@" 可以减少诚意金金额"
                                              titleColor:RGBGray(153)
                                               titleFont:Font(12)
                                                 imgName:@"tx_icon_sm"
                                                  target:nil
                                                  action:nil];
        infoBtn.frame = CGRectMake(0, 0, 140, 45);
        infoBtn.userInteractionEnabled = NO;
        [contentView addSubview:infoBtn];
        
        UILabel *suggestLabel = [UILabel xf_labelWithFont:Font(13)
                                                textColor:RGBGray(102)
                                            numberOfLines:1
                                                alignment:NSTextAlignmentLeft];
        suggestLabel.text = @"建议诚意金：";
        suggestLabel.width = [suggestLabel sizeThatFits:CGSizeZero].width;
        suggestLabel.left = 15;
        suggestLabel.height = 50;
        suggestLabel.top = infoBtn.bottom;
        [contentView addSubview:suggestLabel];
        
        UILabel *countLabel = [[UILabel alloc] init];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:score];
        attrStr.font = FontB(14);
        NSMutableAttributedString *rightAttrStr = [[NSMutableAttributedString alloc] initWithString:@"积分"];
        attrStr.font = FontB(15);
        [attrStr appendAttributedString:rightAttrStr];
        attrStr.color = RGB(139, 157, 100);
        countLabel.attributedText = attrStr;
        [countLabel sizeToFit];
        countLabel.left = suggestLabel.right;
        countLabel.bottom = suggestLabel.centerY + 10;
        [contentView addSubview:countLabel];
        
        
        UILabel *infoLabel = [UILabel xf_labelWithFont:Font(13)
                                             textColor:BlackColor
                                         numberOfLines:1
                                             alignment:NSTextAlignmentLeft];
        infoLabel.text = @"诚意金(积分)";
        infoLabel.width = 150;
        infoLabel.left = 15;
        infoLabel.height = 50;
        infoLabel.top = suggestLabel.bottom + 10;
        [contentView addSubview:infoLabel];
        
        UITextField *field = [[UITextField alloc] init];
        self.field = field;
        field.borderStyle = UITextBorderStyleNone;
        field.font = FontB(30);
        field.textColor = BlackColor;
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.frame = CGRectMake(15, infoLabel.bottom, contentView.width - 30, 45);
        [contentView addSubview:field];
        
        UIView *splitView = [UIView xf_createSplitView];
        splitView.frame = CGRectMake(15, field.bottom, contentView.width - 30, 0.5);
        [contentView addSubview:splitView];
        
        UILabel *explainLabel = [UILabel xf_labelWithFont:Font(12)
                                                textColor:RGBGray(204)
                                            numberOfLines:1
                                                alignment:NSTextAlignmentLeft];
        explainLabel.text = @"领取后，平台抽取20%佣金";
        explainLabel.frame = CGRectMake(15, splitView.bottom, contentView.width - 30, 30);;
        [contentView addSubview:explainLabel];
        
        UIButton *cancelBtn = [UIButton xf_titleButtonWithTitle:@"拒绝"
                                                     titleColor:BlackColor
                                                      titleFont:FontB(15)
                                                         target:self
                                                         action:@selector(dismiss)];
        cancelBtn.backgroundColor = RGBGray(242);
        [cancelBtn xf_cornerCut:3];
        [contentView addSubview:cancelBtn];
        
        UIButton *perInfoBtn = [UIButton xf_titleButtonWithTitle:@"查看资料"
                                                      titleColor:BlackColor
                                                       titleFont:FontB(15)
                                                          target:self
                                                          action:@selector(perInfoClick)];
        perInfoBtn.backgroundColor = RGBGray(242);
        [perInfoBtn xf_cornerCut:3];
        [contentView addSubview:perInfoBtn];
        
        UIButton *confirmBtn = [UIButton xf_titleButtonWithTitle:@"接受"
                                                      titleColor:WhiteColor
                                                       titleFont:FontB(15)
                                                          target:self
                                                          action:@selector(confirmBtnClick)];
        confirmBtn.backgroundColor = ThemeColor;
        [confirmBtn xf_cornerCut:3];
        [contentView addSubview:confirmBtn];
        
    
        cancelBtn.size = confirmBtn.size = perInfoBtn.size = CGSizeMake((contentView.width-20) * 0.3, 44);
        cancelBtn.left = 15;
        
        perInfoBtn.left = cancelBtn.right + 15;
        confirmBtn.left = perInfoBtn.right + 15;
        cancelBtn.top = confirmBtn.top = perInfoBtn.top = explainLabel.bottom + 30;
        
        contentView.height = confirmBtn.bottom + 15;
        contentView.centerX = self.width * 0.5;
        contentView.centerY = self.height * 0.5;
        [self show];
    }
    return self;
}

- (void)perInfoClick {
    [self endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showinfo:)]) {
            [self.delegate showinfo:self];
        }
        [self removeFromSuperview];
    }];

}

#pragma mark ----------Action----------
- (void)confirmBtnClick {
    [self endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(prepareChatView:clickConfirmBtn:)]) {
            [self.delegate prepareChatView:self clickConfirmBtn:self.field.text];
        }
        [self removeFromSuperview];
    }];

}

- (void)endEdit {
    [self.field resignFirstResponder];
}

- (void)show {
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    if (self.delegate && [self.delegate respondsToSelector:@selector(prepareChatViewClickCancelBtn:)]) {
        [self.delegate prepareChatViewClickCancelBtn:self];
    }
    [self endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
