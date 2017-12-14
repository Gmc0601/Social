//
//  Circle.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "Circle.h"
#import "User.h"

@implementation Circle

MJExtensionLogAllProperties
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"image"  : [NSString class],
             @"like"            : [User class],
             @"reward"          : [User class],
             @"comment"         : [CircleComment class]};
}

@end
