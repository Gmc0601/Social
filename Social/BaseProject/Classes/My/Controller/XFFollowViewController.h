//
//  XFFollowViewController.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/19.
//  Copyright © 2017年 王文利. All rights reserved.
//  关注

#import "XFViewController.h"

typedef NS_ENUM(NSInteger, FollowType) {
    FollowType_Follow,
    FollowType_Fans,
    FollowType_Friends
};

@interface XFFollowViewController : XFViewController

@property (nonatomic, assign) FollowType followType;

@end
