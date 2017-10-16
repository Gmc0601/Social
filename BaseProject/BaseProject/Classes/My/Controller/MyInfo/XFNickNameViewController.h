//
//  XFNickNameViewController.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//  设置昵称

#import "XFViewController.h"

@interface XFNickNameViewController : XFViewController

@property (nonatomic, copy) void (^saveBtnClick)(NSString *nickName);
@property (nonatomic, copy) NSString *nickName;

@end
