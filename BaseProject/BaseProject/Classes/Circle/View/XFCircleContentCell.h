//
//  XFCircleContentCell.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//  缘分圈内容Cell

#import <UIKit/UIKit.h>

@class XFCircleContentCellModel, XFCircleContentCell;

@protocol XFCircleContentCellDelegate <NSObject>

@optional
- (void)circleContentCell:(XFCircleContentCell *)cell didClickIconView:(XFCircleContentCellModel *)model;
- (void)circleContentCell:(XFCircleContentCell *)cell didClickFollowBtn:(XFCircleContentCellModel *)model;
- (void)circleContentCell:(XFCircleContentCell *)cell didClickRewardBtn:(XFCircleContentCellModel *)model;
- (void)circleContentCell:(XFCircleContentCell *)cell didClickShareBtn:(XFCircleContentCellModel *)model;
- (void)circleContentCell:(XFCircleContentCell *)cell didClickZanBtn:(XFCircleContentCellModel *)model;
- (void)circleContentCell:(XFCircleContentCell *)cell didClickCommentBtn:(XFCircleContentCellModel *)model;

@end

@interface XFCircleContentCell : UITableViewCell

@property (nonatomic, strong) XFCircleContentCellModel *model;
@property (nonatomic, weak) id<XFCircleContentCellDelegate> delegate;

@end
