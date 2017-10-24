//
//  XFFriendCircleCell.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFCircleContentCellModel, XFFriendCircleCell;
@protocol XFFriendCircleCellDelegate <NSObject>

@optional
- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickRewardBtn:(XFCircleContentCellModel *)model;
- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickShareBtn:(XFCircleContentCellModel *)model;
- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickZanBtn:(XFCircleContentCellModel *)model;
- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickCommentBtn:(XFCircleContentCellModel *)model;
- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickDeleteBtn:(XFCircleContentCellModel *)model;
- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickVideoView:(XFCircleContentCellModel *)model;
- (void)friendCircleCell:(XFFriendCircleCell *)cell didTapPicView:(NSInteger)index model:(XFCircleContentCellModel *)model;
@end

@interface XFFriendCircleCell : UITableViewCell

@property (nonatomic, strong) XFCircleContentCellModel *model;
@property (nonatomic, weak) id<XFFriendCircleCellDelegate> delegate;

@end

