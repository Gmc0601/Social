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

+ (NSString *)myTimeStr:(NSString *)formatTimeStr {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [format dateFromString:formatTimeStr];
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    int temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = NSLocalizedString(@"Just", @"刚刚");
    } else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前", temp];
    } else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",temp];
    } else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%d天前",temp];
    } else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%d月前",temp];
    } else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d年前",temp ];
    }
    
    return  result;
}

@end
