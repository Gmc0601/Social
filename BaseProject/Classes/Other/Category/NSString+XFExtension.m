//
//  NSString+XFExtension.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "NSString+XFExtension.h"

@implementation NSString (XFExtension)

- (CGSize)xf_sizeWithFont:(UIFont *)font {
    return [self xf_sizeWithFont:font maxW:MAXFLOAT];
}

- (CGSize)xf_sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
