//
//  XFCircleCommentCell.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleCommentCell.h"

@interface XFCircleCommentCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIView *splitView;

@end

@implementation XFCircleCommentCell

- (void)setModel:(XFCircleCommentCellModel *)model {
    _model = model;
    self.nameLabel.frame = model.nameLabelFrame;
    self.nameLabel.text = model.comment.nickname;
    
    self.timeLabel.frame = model.timeLabelFrame;
    self.timeLabel.text = model.comment.create_time;
    
    self.commentLabel.frame = model.commentLabelFrame;
    self.commentLabel.text = model.comment.content;
    
    self.splitView.frame = model.splitViewFrame;
}

#pragma mark ----------Lazy----------
- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [UILabel xf_labelWithFont:FontB(15)
                                     textColor:BlackColor
                                 numberOfLines:1
                                     alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [UILabel xf_labelWithFont:Font(13)
                                     textColor:RGBGray(153)
                                 numberOfLines:1
                                     alignment:NSTextAlignmentRight];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)commentLabel {
    if (_commentLabel == nil) {
        _commentLabel = [UILabel xf_labelWithFont:Font(13)
                                        textColor:RGBGray(102)
                                    numberOfLines:0
                                        alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_commentLabel];
    }
    return _commentLabel;
}

- (UIView *)splitView {
    if (_splitView == nil) {
        _splitView = [UIView xf_createSplitView];
        [self.contentView addSubview:_splitView];
    }
    return _splitView;
}

@end

