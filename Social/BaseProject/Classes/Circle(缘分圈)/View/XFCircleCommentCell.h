//
//  XFCircleCommentCell.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//  缘分圈详情评论Cell

#import <UIKit/UIKit.h>
#import "XFCircleCommentCellModel.h"

@interface XFCircleCommentCell : UITableViewCell

@property (nonatomic, strong) XFCircleCommentCellModel *model;
@property (nonatomic, copy) void (^nameLabelTap) ();

@end

