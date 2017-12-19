//
//  NSString+XFExtension.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XFExtension)

- (CGSize)xf_sizeWithFont:(UIFont *)font;
- (CGSize)xf_sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

+ (NSString *)myTimeStr:(NSString *)formatTimeStr;

@end
