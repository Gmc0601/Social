//
//  XFLocationViewController.h
//  FateCircle
//
//  Created by 王文利 on 2017/10/16.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFViewController.h"

@interface XFLocationViewController : XFViewController

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, copy) void (^selectAddress)(NSDictionary *dict);

@end
