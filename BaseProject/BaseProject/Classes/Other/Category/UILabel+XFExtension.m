//
//  UILabel+XFExtension.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "UILabel+XFExtension.h"

@implementation UILabel (XFExtension)

+ (instancetype)xf_labelWithFont:(UIFont *)font
                       textColor:(UIColor *)color
                   numberOfLines:(NSInteger)lines
                       alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.numberOfLines = lines;
    label.textAlignment = alignment;
    return label;
}

@end
