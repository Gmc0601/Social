//
//  UIButton+XFExtension.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XFExtension)

+ (instancetype)xf_emptyButtonWithTarget:(id)target
                                  action:(SEL)action;

+ (instancetype)xf_imgButtonWithImgName:(NSString *)imgName
                                 target:(id)target
                                 action:(SEL)action;

+ (instancetype)xf_titleButtonWithTitle:(NSString *)title
                             titleColor:(UIColor *)color
                              titleFont:(UIFont *)font
                                 target:(id)target
                                 action:(SEL)action;

+ (instancetype)xf_buttonWithTitle:(NSString *)title
                        titleColor:(UIColor *)color
                         titleFont:(UIFont *)font
                           imgName:(NSString *)imgName
                            target:(id)target
                            action:(SEL)action;

+ (instancetype)xf_bottomBtnWithTitle:(NSString *)title
                               target:(id)target
                               action:(SEL)action;

@end
