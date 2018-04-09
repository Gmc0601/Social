//
//  XFPrepareChatView.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/22.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFPrepareChatView.h"

@interface XFPrepareChatView ()<UITextFieldDelegate>

@property (nonatomic, assign) BOOL textnow;

@property (nonatomic, weak) UITextField *tfMoney;

@property (nonatomic, copy) NSString *moeny;

@property (nonatomic, weak) UITextField *tfRemarks;



@end

@implementation XFPrepareChatView

- (instancetype)initWithScore:(NSString *)score {
    self = [super init];
    if (self) {
        [self CreateView:score andMoney:nil];
    }
    return self;
}

- (instancetype)initRequestWithSource:(NSString *)score andMoney:(NSString *)money{
    self = [super init];
    if (self) {
        self.moeny = money;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
        [center addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
        self.textnow = NO;
        [self CreateView:score andMoney:money];
    }
    return self;
}


- (void)CreateView: (NSString *)score andMoney: (NSString *)money {
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

    CGFloat remarkTop = 0;
    CGFloat tfCenterHeight = 30;
    if ([score isEqualToString:@"0"]) {
        remarkTop = suggestLabel.bottom;
    } else {
        UILabel *moneyLabel = [UILabel xf_labelWithFont:Font(13)
                                              textColor:BlackColor
                                          numberOfLines:1
                                              alignment:NSTextAlignmentLeft];
        moneyLabel.text = @"您的诚意金:";
        moneyLabel.width = [suggestLabel sizeThatFits:CGSizeZero].width;
        moneyLabel.left = 15;
        moneyLabel.height = 50;
        moneyLabel.top = suggestLabel.bottom;
        [contentView addSubview:moneyLabel];

        UITextField *fieldM = [[UITextField alloc] init];
        self.tfMoney = fieldM;
        fieldM.borderStyle = UITextBorderStyleRoundedRect;
        fieldM.font = FontB(15);
        fieldM.textColor = BlackColor;
        fieldM.keyboardType = UIKeyboardTypeNumberPad;
        fieldM.frame = CGRectMake(CGRectGetMaxX(moneyLabel.frame),
                                  moneyLabel.top + (50 - tfCenterHeight) * 0.5,
                                  contentView.width - CGRectGetMaxX(moneyLabel.frame) - 30,
                                  tfCenterHeight);
        [contentView addSubview:fieldM];
        if (money != nil) {
            fieldM.delegate = self;
            fieldM.placeholder = money;
            [fieldM addTarget:self action:@selector(change) forControlEvents:UIControlEventEditingChanged];
        }




        UILabel *moneyRemarksLabel = [UILabel xf_labelWithFont:Font(13)
                                                     textColor:BlackColor
                                                 numberOfLines:1
                                                     alignment:NSTextAlignmentCenter];
        moneyRemarksLabel.text = @"积分";
        moneyRemarksLabel.font = Font(13);
        CGFloat moneyRemarksWIdth = [moneyRemarksLabel sizeThatFits:CGSizeZero].width;;
        moneyRemarksLabel.frame = CGRectMake(0, 0, moneyRemarksWIdth + 10, tfCenterHeight - 10);
        self.tfMoney.rightView = moneyRemarksLabel;
        self.tfMoney.rightViewMode = UITextFieldViewModeAlways;
        remarkTop = moneyLabel.bottom;

    }


    UILabel *remarksLabel = [UILabel xf_labelWithFont:Font(13)
                                            textColor:BlackColor
                                        numberOfLines:1
                                            alignment:NSTextAlignmentLeft];
    remarksLabel.text = @"备注:";
    remarksLabel.width = [suggestLabel sizeThatFits:CGSizeZero].width;
    remarksLabel.left = 15;
    remarksLabel.height = 50;
    remarksLabel.top = remarkTop;
    [contentView addSubview:remarksLabel];

    UITextField *fieldRemarks = [[UITextField alloc] init];
    self.tfRemarks = fieldRemarks;
    fieldRemarks.borderStyle = UITextBorderStyleRoundedRect;
    fieldRemarks.font = FontB(15);
    fieldRemarks.textColor = BlackColor;
    fieldRemarks.keyboardType = UIKeyboardTypeDefault;
//    fieldRemarks.frame = CGRectMake(CGRectGetMaxX(remarksLabel.frame), remarksLabel.top, contentView.width - CGRectGetMaxX(remarksLabel.frame), 50);
    fieldRemarks.frame = CGRectMake(CGRectGetMaxX(remarksLabel.frame),
                              remarksLabel.top + (50 - tfCenterHeight) * 0.5,
                              contentView.width - CGRectGetMaxX(remarksLabel.frame) - 30,
                              tfCenterHeight);
    [contentView addSubview:fieldRemarks];




    //=--------
    UILabel *explainLabel = [UILabel xf_labelWithFont:Font(12)
                                            textColor:RGBGray(204)
                                        numberOfLines:1
                                            alignment:NSTextAlignmentLeft];
    explainLabel.text = @"对方拒绝诚意金，诚意金退换到账";
    explainLabel.frame = CGRectMake(15, self.tfRemarks.bottom + 15, contentView.width - 30, 30);;
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

    //---------


    contentView.height = confirmBtn.bottom + 15;
    contentView.centerX = self.width * 0.5;
    contentView.centerY = self.height * 0.5;
    [self show];
}


- (void)keyboardDidShow
{
    self.textnow = YES;
}

- (void)keyboardDidHide
{
    self.textnow = NO;
}

- (void)change {
    if ([self.tfMoney.text floatValue] > [self.moeny floatValue]) {
        self.tfMoney.text = self.moeny;
    }
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
    if (self.tfMoney.text.stringByTrim.length == 0) {
        self.tfMoney.text = @"0";
    }
    if (self.tfRemarks.text.stringByTrim.length == 0) {
        [ConfigModel mbProgressHUD:@"请填写备注" andView:nil];
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(prepareChatView:clickConfirmBtn:)]) {
            NSString* textValue = [NSString stringWithFormat:@"%@;;%@", self.tfMoney.text, self.tfRemarks.text];
            [self.delegate prepareChatView:self clickConfirmBtn:textValue];
        }
        [self removeFromSuperview];
    }];

}

- (void)endEdit {

    if (self.textnow) {
        [self.tfMoney resignFirstResponder];
        [self.tfRemarks resignFirstResponder];

    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    [self.tfMoney resignFirstResponder];
    [self.tfRemarks resignFirstResponder];
    
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
