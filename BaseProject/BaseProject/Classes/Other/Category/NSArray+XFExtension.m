//
//  NSArray+XFExtension.m
//  FateCircle
//
//  Created by 王文利 on 2017/10/14.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "NSArray+XFExtension.h"

@implementation NSArray (XFExtension)

- (BOOL)hasContent {
    return [self isKindOfClass:[NSArray class]] && self.count;
}

@end
