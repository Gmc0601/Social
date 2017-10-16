//
//  XFCircleContentView.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFCircleContentCellModel, XFCircleContentView;

@protocol XFCircleContentViewDelegate <NSObject>

@optional
- (void)circleContentView:(XFCircleContentView *)view didClickIconView:(XFCircleContentCellModel *)model;
- (void)circleContentView:(XFCircleContentView *)view didClickFollowBtn:(XFCircleContentCellModel *)model;

@end

@interface XFCircleContentView : UIView

@property (nonatomic, strong) XFCircleContentCellModel *model;
@property (nonatomic, weak) id<XFCircleContentViewDelegate> delegate;

@end
