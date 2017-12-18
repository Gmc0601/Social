//
//  XFCircleCommentCellModel.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleCommentCellModel.h"

@implementation XFCircleCommentCellModel

- (instancetype)initWithComment:(CircleComment *)comment {
    _comment = comment;
    CGRect rect = CGRectZero;
    rect.size.width = 180;
    rect.size.height = 45;
    rect.origin.y = 0;
    rect.origin.x = kScreenWidth - rect.size.width - 10;
    self.timeLabelFrame = rect;
    
    rect.origin.x = 15;
    rect.size.width = CGRectGetMinX(self.timeLabelFrame) - 10 - rect.origin.x;
    self.nameLabelFrame = rect;
    
    CGFloat commentMaxW = kScreenWidth - 30;
    rect.size = [comment.content xf_sizeWithFont:Font(13) maxW:commentMaxW];
    rect.origin.y = CGRectGetMaxY(self.nameLabelFrame);
    self.commentLabelFrame = rect;
    
    self.splitViewFrame = CGRectMake(15, CGRectGetMaxY(self.commentLabelFrame) + 15, kScreenWidth - 30, 0.5);
    self.cellH = CGRectGetMaxY(self.splitViewFrame);
    
    return self;
}

@end

