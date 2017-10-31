//
//  XFCircleSuggestCell.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//  可能认识的人Cell

#import <UIKit/UIKit.h>

@class XFCircleSuggestCell;
@protocol XFCircleSuggestCellDelegate <NSObject>

@optional
- (void)circleSuggestCellClickCloseBtn:(XFCircleSuggestCell *)cell;

@end

@interface XFCircleSuggestCell : UITableViewCell

+ (CGFloat)cellHeight;
@property (nonatomic, strong) NSArray *suggestArray;
@property (nonatomic, weak) id<XFCircleSuggestCellDelegate> delegate;

@end

