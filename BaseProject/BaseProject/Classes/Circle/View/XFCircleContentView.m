//
//  XFCircleContentView.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleContentView.h"
#import "XFCirclePicView.h"
#import "XFCircleContentCellModel.h"

@interface XFCircleContentView ()<XFCirclePicViewDelegate>

@property (nonatomic, strong) UIView *paddingView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *followBtn;

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) XFCirclePicView *picView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIImageView *videoIconView;

@end

@implementation XFCircleContentView

- (void)setModel:(XFCircleContentCellModel *)model {
    _model = model;
    
    Circle *circle = model.circle;
    self.paddingView.frame = model.paddingViewFrame;
    self.iconView.frame = model.iconViewFrame;
    [self.iconView setImageWithURL:[NSURL URLWithString:circle.avatar_url] placeholder:Image(@"bg_tj_tx")];
    
    self.followBtn.frame = model.followBtnFrame;
    if (circle.attention_status.integerValue == 2) {
        [self.followBtn setTitleColor:RGBGray(204) forState:UIControlStateNormal];
        [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        self.followBtn.layer.borderColor = RGBGray(204).CGColor;
    } else {
        [self.followBtn setTitleColor:BlackColor forState:UIControlStateNormal];
        [self.followBtn setTitle:@"+关注" forState:UIControlStateNormal];
        self.followBtn.layer.borderColor = BlackColor.CGColor;
    }
    self.timeLabel.text = circle.upload_time;
    self.nameLabel.text = circle.nickname;
    
    self.timeLabel.size = [self.timeLabel sizeThatFits:CGSizeZero];
    self.nameLabel.left = self.iconView.right + 20;
    self.nameLabel.top = self.iconView.top + 2;
    
    CGFloat maxW = self.followBtn.left - 5 - self.timeLabel.width - 5 - self.nameLabel.left;
    self.nameLabel.size = [self.nameLabel sizeThatFits:CGSizeMake(maxW, CGFLOAT_MAX)];
    self.timeLabel.left = self.nameLabel.right + 5;
    self.timeLabel.centerY = self.nameLabel.centerY;
    
    self.descLabel.frame = model.descLabelFrame;
    self.descLabel.text = circle.talk_content;
    
    self.picView.frame = model.picViewFrame;
    self.picView.model = model;
    self.picView.hidden = !(circle.upload_type.integerValue == 1 && circle.image.count);
    
    self.videoImageView.hidden = circle.upload_type.integerValue != 2;
    self.videoImageView.frame = model.videoFrame;
    if (circle.image.count) {
        NSString *url = circle.image.firstObject;
        [self.videoImageView setImageURL:[NSURL URLWithString:url]];
    }
    self.videoIconView.center = CGPointMake(self.videoImageView.width * 0.5, self.videoImageView.height * 0.5);
}

#pragma mark ----------Action----------
- (void)iconViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleContentView:didClickIconView:)]) {
        [self.delegate circleContentView:self didClickIconView:self.model];
    }
}

- (void)followBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleContentView:didClickFollowBtn:)]) {
        [self.delegate circleContentView:self didClickFollowBtn:self.model];
    }
}

- (void)videoViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleContentView:didClickVideoView:)]) {
        [self.delegate circleContentView:self didClickVideoView:self.model];
    }
}

- (void)circlePicView:(XFCirclePicView *)picView didTapPicView:(NSInteger)index model:(XFCircleContentCellModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleContentView:didTapPicView:model:)]) {
        [self.delegate circleContentView:self didTapPicView:index model:model];
    }
}

#pragma mark ----------Lazy----------
- (UIView *)paddingView {
    if (_paddingView == nil) {
        _paddingView = [UIView xf_createPaddingView];
        [self addSubview:_paddingView];
    }
    return _paddingView;
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        [_iconView xf_cornerCut:25];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.userInteractionEnabled = YES;
        [_iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewTap)]];
        [self addSubview:_iconView];
    }
    return _iconView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [UILabel xf_labelWithFont:Font(15)
                                     textColor:BlackColor
                                 numberOfLines:1
                                     alignment:NSTextAlignmentLeft];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [UILabel xf_labelWithFont:Font(12)
                                     textColor:RGBGray(153)
                                 numberOfLines:1
                                     alignment:NSTextAlignmentLeft];
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIButton *)followBtn {
    if (_followBtn == nil) {
        _followBtn = [UIButton xf_titleButtonWithTitle:@"+关注"
                                            titleColor:BlackColor
                                             titleFont:Font(12)
                                                target:self
                                                action:@selector(followBtnClick)];
        _followBtn.layer.borderColor = BlackColor.CGColor;
        _followBtn.layer.borderWidth = 1;
        [_followBtn xf_cornerCut:3];
        [self addSubview:_followBtn];
    }
    return _followBtn;
}

- (UILabel *)descLabel {
    if (_descLabel == nil) {
        _descLabel = [UILabel xf_labelWithFont:Font(14)
                                     textColor:BlackColor
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
        [self addSubview:_descLabel];
    }
    return _descLabel;
}

- (XFCirclePicView *)picView {
    if (_picView == nil) {
        _picView = [[XFCirclePicView alloc] init];
        _picView.delegate = self;
        [self addSubview:_picView];
    }
    return _picView;
}

- (UIImageView *)videoImageView {
    if (_videoImageView == nil) {
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.backgroundColor = [UIColor lightGrayColor];
        _videoImageView.userInteractionEnabled = YES;
        [_videoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoViewTap)]];
        _videoImageView.clipsToBounds = YES;
        [self addSubview:_videoImageView];
    }
    return _videoImageView;
}

- (UIImageView *)videoIconView {
    if (_videoIconView == nil) {
        _videoIconView = [[UIImageView alloc] initWithImage:Image(@"icon_yfq_bf")];
        [self.videoImageView addSubview:_videoIconView];
    }
    return _videoIconView;
}


@end

