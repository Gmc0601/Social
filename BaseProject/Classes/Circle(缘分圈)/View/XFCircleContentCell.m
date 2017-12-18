//
//  XFCircleContentCell.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleContentCell.h"
#import "XFCircleContentCellModel.h"
#import "XFCircleContentView.h"

@interface XFCircleContentCell ()<XFCircleContentViewDelegate>

@property (nonatomic, strong) XFCircleContentView *circleView;

@property (nonatomic, strong) UIButton *rewardBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *zanBtn;
@property (nonatomic, strong) UIButton *commentBtn;

@end

@implementation XFCircleContentCell

- (void)setModel:(XFCircleContentCellModel *)model {
    _model = model;
    
    Circle *circle = model.circle;
    
    self.circleView.frame = model.circleContentFrame;
    self.circleView.model = model;
    
    self.rewardBtn.frame = model.rewardBtnFrame;
    [self.rewardBtn setTitle:[NSString stringWithFormat:@" %d", circle.reward_num.intValue] forState:UIControlStateNormal];
    self.shareBtn.frame = model.shareBtnFrame;
    [self.shareBtn setTitle:[NSString stringWithFormat:@" %d", circle.transmit_num.intValue] forState:UIControlStateNormal];
    self.zanBtn.frame = model.zanBtnFrame;
    [self.zanBtn setTitle:[NSString stringWithFormat:@" %d", circle.like_num.intValue] forState:UIControlStateNormal];
    if (circle.like_status.integerValue == 1) {
        [self.zanBtn setImage:Image(@"icon_yfq_dz_pre") forState:UIControlStateNormal];
    } else {
        [self.zanBtn setImage:Image(@"icon_yfq_dz") forState:UIControlStateNormal];
    }
    self.commentBtn.frame = model.commentBtnFrame;
    [self.commentBtn setTitle:[NSString stringWithFormat:@" %d", circle.comment_num.intValue] forState:UIControlStateNormal];
}

#pragma mark ----------<XFCircleContentViewDelegate>----------
- (void)circleContentView:(XFCircleContentView *)view didClickIconView:(XFCircleContentCellModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleContentCell:didClickIconView:)]) {
        [self.delegate circleContentCell:self didClickIconView:self.model];
    }
}

- (void)circleContentView:(XFCircleContentView *)view didClickFollowBtn:(XFCircleContentCellModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleContentCell:didClickFollowBtn:)]) {
        [self.delegate circleContentCell:self didClickFollowBtn:self.model];
    }
}

- (void)circleContentView:(XFCircleContentView *)view didClickVideoView:(XFCircleContentCellModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleContentCell:didClickVideoView:)]) {
        [self.delegate circleContentCell:self didClickVideoView:self.model];
    }
}

- (void)circleContentView:(XFCircleContentView *)view didTapPicView:(NSInteger)index model:(XFCircleContentCellModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleContentCell:didTapPicView:model:)]) {
        [self.delegate circleContentCell:self didTapPicView:index model:self.model];
    }
}

#pragma mark ----------Action----------
- (void)rewardBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleContentCell:didClickRewardBtn:)]) {
        [self.delegate circleContentCell:self didClickRewardBtn:self.model];
    }
}

- (void)shareBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleContentCell:didClickShareBtn:)]) {
        [self.delegate circleContentCell:self didClickShareBtn:self.model];
    }
}

- (void)zanBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleContentCell:didClickZanBtn:)]) {
        [self.delegate circleContentCell:self didClickZanBtn:self.model];
    }
}

- (void)commentBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleContentCell:didClickCommentBtn:)]) {
        [self.delegate circleContentCell:self didClickCommentBtn:self.model];
    }
}

#pragma mark ----------Lazy----------
- (XFCircleContentView *)circleView {
    if (_circleView == nil) {
        _circleView = [[XFCircleContentView alloc] init];
        _circleView.delegate = self;
        [self.contentView addSubview:_circleView];
    }
    return _circleView;
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

@end

