//
//  UILabel+XFExtension.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (XFExtension)

+ (instancetype)xf_labelWithFont:(UIFont *)font
                       textColor:(UIColor *)color
                   numberOfLines:(NSInteger)lines
                       alignment:(NSTextAlignment)alignment;

@end
