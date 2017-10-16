//
//  XFSelectInterestView.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//  个人信息选择兴趣

#import <UIKit/UIKit.h>

@class XFSelectInterestView;
@protocol XFSelectInterestViewDelegate <NSObject>

@optional
- (void)selectInterestView:(XFSelectInterestView *)view didselectItem:(NSArray *)array;

@end

@interface XFSelectInterestView : UIView

@property (nonatomic, weak) id<XFSelectInterestViewDelegate> delegate;
- (instancetype)initWithSelectArray:(NSArray *)selectArray;

@end
