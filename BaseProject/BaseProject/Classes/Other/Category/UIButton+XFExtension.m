//
//  UIButton+XFExtension.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "UIButton+XFExtension.h"

@implementation UIButton (XFExtension)

+ (instancetype)xf_emptyButtonWithTarget:(id)target
                                  action:(SEL)action {
    return [self xf_buttonWithTitle:nil
                         titleColor:nil
                          titleFont:nil
                            imgName:@""
                             target:target
                             action:action];
}

+ (instancetype)xf_imgButtonWithImgName:(NSString *)imgName
                                 target:(id)target
                                 action:(SEL)action {
    return [self xf_buttonWithTitle:nil
                         titleColor:nil
                          titleFont:nil
                            imgName:imgName
                             target:target
                             action:action];
}

+ (instancetype)xf_titleButtonWithTitle:(NSString *)title
                             titleColor:(UIColor *)color
                              titleFont:(UIFont *)font
                                 target:(id)target
                                 action:(SEL)action {
    return [self xf_buttonWithTitle:title
                         titleColor:color
                          titleFont:font
                            imgName:nil
                             target:target
                             action:action];
}

+ (instancetype)xf_buttonWithTitle:(NSString *)title
                        titleColor:(UIColor *)color
                         titleFont:(UIFont *)font
                           imgName:(NSString *)imgName
                            target:(id)target
                            action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (color) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    if (font) {
        button.titleLabel.font = font;
    }
    if (imgName.length) {
        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    }
    if (action && target) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

+ (instancetype)xf_bottomBtnWithTitle:(NSString *)title
                               target:(id)target
                               action:(SEL)action {
    UIButton *btn = [self xf_titleButtonWithTitle:title
                                       titleColor:WhiteColor
                                        titleFont:Font(15)
                                           target:target
                                           action:action];
    btn.backgroundColor = ThemeColor;
    [btn xf_cornerCut:5];
    return btn;
}

@end
