//
//  XFCirclePicView.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//  缘分圈图片View

#import <UIKit/UIKit.h>
@class XFCircleContentCellModel, XFCirclePicView;

@protocol XFCirclePicViewDelegate <NSObject>

@optional
- (void)circlePicView:(XFCirclePicView *)picView didTapPicView:(NSInteger)index model:(XFCircleContentCellModel *)model;

@end

@interface XFCirclePicView : UIView

@property (nonatomic, strong) XFCircleContentCellModel *model;
@property (nonatomic, weak) id<XFCirclePicViewDelegate> delegate;

@end

