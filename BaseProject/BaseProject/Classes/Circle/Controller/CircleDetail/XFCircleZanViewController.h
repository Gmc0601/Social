//
//  XFCircleZanViewController.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//  缘分圈详情点赞

#import "XFViewController.h"

@interface XFCircleZanViewController : XFViewController

@property (nonatomic, strong) NSNumber *circleId;
@property (nonatomic, strong) Circle *circle;
- (CGFloat)scrollOffset;

@end
