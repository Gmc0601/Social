//
//  XFCircleContentViewController.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//  缘分圈内容

#import "XFViewController.h"

typedef NS_ENUM(NSInteger, CircleContentType) {
    CircleContentType_Hot,
    CircleContentType_Near,
    CircleContentType_New,
    CircleContentType_Follow
};

@interface XFCircleContentViewController : XFViewController

@property (nonatomic, assign) CircleContentType type;

@end

