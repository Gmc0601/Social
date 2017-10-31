//
//  XFFriendCircleCell.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFFriendCircleCell.h"
#import "XFCirclePicView.h"
#import "XFCircleContentCellModel.h"

@interface XFFriendCircleCell ()<XFCirclePicViewDelegate>

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) XFCirclePicView *picView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIImageView *videoIconView;

@property (nonatomic, strong) UIButton *rewardBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *zanBtn;
@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UIView *splitView;

@end

@implementation XFFriendCircleCell

- (void)setModel:(XFCircleContentCellModel *)model {
    _model = model;
    Circle *circle = model.circle;
    
    self.timeLabel.text = circle.upload_time;
    self.timeLabel.frame = model.timeLabelFrame;
    
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
    
    self.rewardBtn.frame = model.rewardBtnFrame;
    [self.rewardBtn setTitle:[NSString stringWithFormat:@" %d", circle.reward_num.intValue] forState:UIControlStateNormal];
    self.shareBtn.frame = model.shareBtnFrame;
    [self.shareBtn setTitle:[NSString stringWithFormat:@" %d", circle.reward_num.intValue] forState:UIControlStateNormal];
    self.zanBtn.frame = model.zanBtnFrame;
    [self.zanBtn setTitle:[NSString stringWithFormat:@" %d", circle.transmit_num.intValue] forState:UIControlStateNormal];
    self.commentBtn.frame = model.commentBtnFrame;
    [self.commentBtn setTitle:[NSString stringWithFormat:@" %d", circle.comment_num.intValue] forState:UIControlStateNormal];
    
    self.rewardBtn.hidden = self.shareBtn.hidden = self.zanBtn.hidden = self.commentBtn.hidden = model.type == CircleContentModelType_My;
    self.deleteBtn.hidden = model.type != CircleContentModelType_My;
    self.deleteBtn.frame = model.deleteBtnFrame;
    
    self.splitView.frame = CGRectMake(10, self.height - 0.5, kScreenWidth - 20, 0.5);
}

#pragma mark ----------Action----------
- (void)rewardBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(friendCircleCell:didClickRewardBtn:)]) {
        [self.delegate friendCircleCell:self didClickRewardBtn:self.model];
    }
}

- (void)shareBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(friendCircleCell:didClickShareBtn:)]) {
        [self.delegate friendCircleCell:self didClickShareBtn:self.model];
    }
}

- (void)zanBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(friendCircleCell:didClickZanBtn:)]) {
        [self.delegate friendCircleCell:self didClickZanBtn:self.model];
    }
}

- (void)commentBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(friendCircleCell:didClickCommentBtn:)]) {
        [self.delegate friendCircleCell:self didClickCommentBtn:self.model];
    }
}

- (void)deleteBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(friendCircleCell:didClickDeleteBtn:)]) {
        [self.delegate friendCircleCell:self didClickDeleteBtn:self.model];
    }
}

- (void)videoViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(friendCircleCell:didClickVideoView:)]) {
        [self.delegate friendCircleCell:self didClickVideoView:self.model];
    }
}

#pragma mark - -------------------<XFCirclePicViewDelegate>-------------------
- (void)circlePicView:(XFCirclePicView *)picView didTapPicView:(NSInteger)index model:(XFCircleContentCellModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(friendCircleCell:didTapPicView:model:)]) {
        [self.delegate friendCircleCell:self didTapPicView:index model:model];
    }
}

#pragma mark ----------Lazy----------
- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [UILabel xf_labelWithFont:Font(12)
                                     textColor:RGBGray(153)
                                 numberOfLines:1
                                     alignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)descLabel {
    if (_descLabel == nil) {
        _descLabel = [UILabel xf_labelWithFont:Font(14)
                                     textColor:BlackColor
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_descLabel];
    }
    return _descLabel;
}

- (XFCirclePicView *)picView {
    if (_picView == nil) {
        _picView = [[XFCirclePicView alloc] init];
        _picView.delegate = self;
        [self.contentView addSubview:_picView];
    }
    return _picView;
}

- (UIButton *)rewardBtn {
    if (_rewardBtn == nil) {
        _rewardBtn = [UIButton xf_buttonWithTitle:@" 0"
                                       titleColor:RGBGray(153)
                                        titleFont:Font(12)
                                          imgName:@"icon_yfq_ds_"
                                           target:self
                                           action:@selector(rewardBtnClick)];
        [self.contentView addSubview:_rewardBtn];
    }
    return _rewardBtn;
}

- (UIButton *)shareBtn {
    if (_shareBtn == nil) {
        _shareBtn = [UIButton xf_buttonWithTitle:@" 0"
                                      titleColor:RGBGray(153)
                                       titleFont:Font(12)
                                         imgName:@"icon_yfq_fx"
                                          target:self
                                          action:@selector(shareBtnClick)];
        [self.contentView addSubview:_shareBtn];
    }
    return _shareBtn;
}

- (UIButton *)zanBtn {
    if (_zanBtn == nil) {
        _zanBtn = [UIButton xf_buttonWithTitle:@" 0"
                                    titleColor:RGBGray(153)
                                     titleFont:Font(12)
                                       imgName:@"icon_yfq_dz"
                                        target:self
                                        action:@selector(zanBtnClick)];
        [self.contentView addSubview:_zanBtn];
    }
    return _zanBtn;
}

- (UIButton *)commentBtn {
    if (_commentBtn == nil) {
        _commentBtn = [UIButton xf_buttonWithTitle:@" 0"
                                        titleColor:RGBGray(153)
                                         titleFont:Font(12)
                                           imgName:@"icon_yfq_pl"
                                            target:self
                                            action:@selector(commentBtnClick)];
        [self.contentView addSubview:_commentBtn];
    }
    return _commentBtn;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton xf_titleButtonWithTitle:@"删除"
                                            titleColor:RGBGray(102)
                                             titleFont:Font(12)
                                                target:self
                                                action:@selector(deleteBtnClick)];
        [self.contentView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

- (UIView *)splitView {
    if (_splitView == nil) {
        _splitView = [UIView xf_createSplitView];
        [self.contentView addSubview:_splitView];
    }
    return _splitView;
}

- (UIImageView *)videoImageView {
    if (_videoImageView == nil) {
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.backgroundColor = [UIColor lightGrayColor];
        _videoImageView.userInteractionEnabled = YES;
        [_videoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoViewTap)]];
        _videoImageView.clipsToBounds = YES;
        [self.contentView addSubview:_videoImageView];
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


