//
//  XFSignatureViewController.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//  个性签名

#import "XFViewController.h"

@interface XFSignatureViewController : XFViewController

@property (nonatomic, copy) void (^saveBtnClick)(NSString *sign);

@end
