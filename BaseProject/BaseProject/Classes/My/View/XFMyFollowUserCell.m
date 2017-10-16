//
//  XFMyFollowUserCell.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/19.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFMyFollowUserCell.h"

@interface XFMyFollowUserCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UIView *splitView;

@end

@implementation XFMyFollowUserCell

+ (CGFloat)cellHeight {
    return 70;
}

- (void)setUser:(User *)user {
    _user = user;
    self.imgView.frame = CGRectMake(20, 10, 50, 50);
    
    self.nameLabel.left = self.imgView.right + 10;
    self.nameLabel.top = self.imgView.top + 4;
    self.nameLabel.height = 17;
    self.nameLabel.text = user.nickname;
    self.followBtn.size = CGSizeMake(70, 30); // 82
    if (self.type == MyFollowUserType_Follow) {
        [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
    } else if (self.type == MyFollowUserType_Fans) {
        [self.followBtn setTitle:@"+关注" forState:UIControlStateNormal];
    } else if (self.type == MyFollowUserType_Friends) {
        [self.followBtn setTitle:@"互为关注" forState:UIControlStateNormal];
        self.followBtn.size = CGSizeMake(82, 30);
    }
    
    if (self.type == MyFollowUserType_Fans) {
        [self.followBtn setTitleColor:RGBGray(242) forState:UIControlStateNormal];
        self.followBtn.backgroundColor = RGB(101, 53, 157);
    } else {
        [self.followBtn setTitleColor:RGBGray(102) forState:UIControlStateNormal];
        self.followBtn.backgroundColor = RGBGray(242);
    }
    self.followBtn.centerY = self.imgView.centerY;
    self.followBtn.right = self.width - 15;
    
    self.nameLabel.width = self.followBtn.left - 10 - self.nameLabel.left;
    
    self.splitView.frame = CGRectMake(10, self.height - 0.5, self.width - 20, 0.5);
}

#pragma mark ----------Action----------
- (void)iconBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myFollowUserCell:didClickUserBtn:)]) {
        [self.delegate myFollowUserCell:self didClickUserBtn:0];
    }
}

- (void)followBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myFollowUserCell:didClickFollowBtn:)]) {
        [self.delegate myFollowUserCell:self didClickFollowBtn:0];
    }
}

#pragma mark ----------Lazy----------
- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = Image(@"bg_tj_tx");
        [_imgView xf_cornerCut:25];
        [self.contentView addSubview:_imgView];
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [UILabel xf_labelWithFont:Font(17)
                                     textColor:BlackColor
                                 numberOfLines:1
                                     alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIButton *)followBtn {
    if (_followBtn == nil) {
        _followBtn = [UIButton xf_titleButtonWithTitle:@"已关注"
                                            titleColor:RGBGray(102)
                                             titleFont:Font(15)
                                                target:self
                                                action:@selector(followBtnClick)];
        [_followBtn xf_cornerCut:5];
        _followBtn.backgroundColor = RGBGray(242);
        [self.contentView addSubview:_followBtn];
    }
    return _followBtn;
}

- (UIView *)splitView {
    if (_splitView == nil) {
        _splitView = [UIView xf_createSplitView];
        [self.contentView addSubview:_splitView];
    }
    return _splitView;
}

@end
