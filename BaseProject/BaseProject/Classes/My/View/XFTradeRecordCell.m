//
//  XFTradeRecordCell.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFTradeRecordCell.h"

@interface XFTradeRecordCell ()

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *recordLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIView *splitView;

@end

@implementation XFTradeRecordCell

+ (CGFloat)cellHeight {
    return 55;
}

- (void)setupContent {
    self.infoLabel.frame = CGRectMake(10, 3, 150, self.height * 0.5);
    self.timeLabel.frame = CGRectMake(10, self.height * 0.5 - 3, 150, self.height * 0.5);
    self.recordLabel.frame = CGRectMake(self.width - 160, 3, 150, self.height * 0.5);
    self.stateLabel.frame = CGRectMake(self.width - 160, self.height * 0.5 - 3, 150, self.height * 0.5);
    self.splitView.frame = CGRectMake(10, self.height - 0.5, self.width - 20, 0.5);
    
    self.infoLabel.text = @"提现";
    self.timeLabel.text = @"2017-04-09 13:32";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"-1000积分"];
    attrStr.font = FontB(15);
    attrStr.color = RGB(87, 173, 104);
    self.recordLabel.attributedText = attrStr;
    self.recordLabel.textAlignment = NSTextAlignmentRight;
    
    self.stateLabel.text = @"提现审核中";
}

#pragma mark ----------Lazy----------
- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [UILabel xf_labelWithFont:Font(14)
                                     textColor:RGBGray(102)
                                 numberOfLines:1
                                     alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_infoLabel];
    }
    return _infoLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [UILabel xf_labelWithFont:Font(14)
                                     textColor:RGBGray(153)
                                 numberOfLines:1
                                     alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)recordLabel {
    if (_recordLabel == nil) {
        _recordLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_recordLabel];
    }
    return _recordLabel;
}

- (UILabel *)stateLabel {
    if (_stateLabel == nil) {
        _stateLabel = [UILabel xf_labelWithFont:Font(12)
                                      textColor:RGBGray(153)
                                  numberOfLines:1
                                      alignment:NSTextAlignmentRight];
        [self.contentView addSubview:_stateLabel];
    }
    return _stateLabel;
}

- (UIView *)splitView {
    if (_splitView == nil) {
        _splitView = [UIView xf_createSplitView];
        [self.contentView addSubview:_splitView];
    }
    return _splitView;
}

@end

