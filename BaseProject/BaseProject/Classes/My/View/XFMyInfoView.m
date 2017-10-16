//
//  XFMyInfoView.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFMyInfoView.h"

@interface XFMyInfoView ()

@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) UILabel *signLabel;

@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *followLabel;
@property (nonatomic, strong) UILabel *friendLabel;

@end

@implementation XFMyInfoView

- (instancetype)init {
    if (self == [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 270);
        UIImageView *imgView = [[UIImageView alloc] initWithImage:Image(@"bg_wd")];
        imgView.frame = self.bounds;
        [self addSubview:imgView];
        
        _iconBtn = [UIButton xf_imgButtonWithImgName:@"bg_tj_tx" target:self action:@selector(iconBtnClick)];
        _iconBtn.size = CGSizeMake(72, 72);
        _iconBtn.top = 64;
        _iconBtn.centerX = kScreenWidth * 0.5;
        [_iconBtn xf_cornerCut:32];
        [self addSubview:_iconBtn];
        
        _nameLabel = [YYLabel new];
        _nameLabel.frame = CGRectMake(20, _iconBtn.bottom + 20, kScreenWidth - 40, 18);
        [self addSubview:_nameLabel];
        
        _signLabel = [UILabel xf_labelWithFont:Font(13)
                                     textColor:WhiteColor
                                 numberOfLines:1
                                     alignment:NSTextAlignmentCenter];
        _signLabel.frame = CGRectMake(20, _nameLabel.bottom + 15, kScreenWidth - 40, 14);
        _signLabel.userInteractionEnabled = YES;
        [_signLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signLabelTap)]];
        [self addSubview:_signLabel];
        
        CGFloat height = self.height - _signLabel.bottom;
        UIView *leftView = [self createBottomItemView:@"关注我的" height:height tag:0];
        self.fansLabel = [leftView viewWithTag:100];
        UIView *middleView = [self createBottomItemView:@"我关注的" height:height tag:1];
        self.followLabel = [middleView viewWithTag:100];
        UIView *rightView = [self createBottomItemView:@"互为关注" height:height tag:2];
        self.friendLabel = [rightView viewWithTag:100];
        leftView.top = middleView.top = rightView.top = _signLabel.bottom;
        leftView.left = 0;
        middleView.left = leftView.right;
        rightView.left = middleView.right;
        [self addSubview:leftView];
        [self addSubview:middleView];
        [self addSubview:rightView];
        
        UIView *splitView1 = [UIView xf_createWhiteView];
        splitView1.size = CGSizeMake(0.5, 21);
        splitView1.left = leftView.right;
        splitView1.centerY = leftView.centerY;
        [self addSubview:splitView1];
        
        UIView *splitView2 = [UIView xf_createWhiteView];
        splitView2.frame = splitView1.frame;
        splitView2.left = middleView.right;
        [self addSubview:splitView2];
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;
    [self.iconBtn setImageWithURL:[NSURL URLWithString:user.avatar_url]
                         forState:UIControlStateNormal
                      placeholder:Image(@"bg_tj_tx")];
    if (user.nickname.length) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:user.nickname];
        attrStr.font = FontB(18);
        attrStr.color = WhiteColor;
        [attrStr appendString:@" "];
        [attrStr appendAttributedString:[NSAttributedString attachmentStringWithEmojiImage:Image([user.sex isEqualToString:@"1"] ? @"icon_boy" : @"icon_girl")
                                                                                  fontSize:16]];
        self.nameLabel.attributedText = attrStr.copy;
    }
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.signLabel.text = user.sdf;
    if (user.sdf.length == 0) {
        self.signLabel.text = @"还没有个性签名";
    }
    
    self.fansLabel.text = user.guanzhumy_num.stringValue;
    self.followLabel.text = user.myguanzhu_num.stringValue;
    self.friendLabel.text = user.mutual_attention_num.stringValue;
}

#pragma mark ----------Private----------
- (UIView *)createBottomItemView:(NSString *)info height:(CGFloat)height tag:(NSInteger)tag {
    UIView *view = [UIView xf_createViewWithColor:[UIColor clearColor]];
    view.size = CGSizeMake(kScreenWidth / 3, height);
    view.tag = tag;
    UILabel *countLabel = [UILabel xf_labelWithFont:Font(15)
                                          textColor:WhiteColor
                                      numberOfLines:1
                                          alignment:NSTextAlignmentCenter];
    countLabel.text = @"0";
    countLabel.size = CGSizeMake(view.width, 20);
    countLabel.bottom = view.height * 0.5;
    countLabel.tag = 100;
    [view addSubview:countLabel];
    
    UILabel *infoLabel = [UILabel xf_labelWithFont:Font(12)
                                          textColor:WhiteColor
                                      numberOfLines:1
                                          alignment:NSTextAlignmentCenter];
    infoLabel.text = info;
    infoLabel.size = CGSizeMake(view.width, 20);
    infoLabel.top = view.height * 0.5;
    [view addSubview:infoLabel];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTap:)]];
    return view;
}

#pragma mark ----------Action----------
- (void)iconBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myInfoViewDidClickIconBtn:)]) {
        [self.delegate myInfoViewDidClickIconBtn:self];
    }
}

- (void)signLabelTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myInfoViewDidTapSignLabel:)]) {
        [self.delegate myInfoViewDidTapSignLabel:self];
    }
}

- (void)bottomViewTap:(UITapGestureRecognizer *)ges {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myInfoView:didTapBottomView:)]) {
        [self.delegate myInfoView:self didTapBottomView:ges.view.tag];
    }
}

@end
