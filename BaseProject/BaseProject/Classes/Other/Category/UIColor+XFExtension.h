//
//  UIColor+XFExtension.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/22.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XFExtension)

+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;

@end
