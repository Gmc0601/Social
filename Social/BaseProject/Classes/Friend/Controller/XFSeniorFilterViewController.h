//
//  XFSeniorFilterViewController.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/22.
//  Copyright © 2017年 王文利. All rights reserved.
//  高级筛选

#import "XFViewController.h"

@interface XFSeniorFilterViewController : XFViewController

@property (nonatomic, copy) void (^confirmBack)(NSDictionary *dict);

@end

