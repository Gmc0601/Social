//
//  UIView+XFExtension.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XFExtension)

+ (instancetype)xf_navView:(NSString *)title
                backTarget:(id)target
                backAction:(SEL)action;

+ (instancetype)xf_themeNavView:(NSString *)title
                     backTarget:(id)target
                     backAction:(SEL)action;

+ (instancetype)xf_createSplitView;
+ (instancetype)xf_createPaddingView;
+ (instancetype)xf_createWhiteView;
+ (instancetype)xf_createViewWithColor:(UIColor *)color;


- (void)xf_cornerCut:(CGFloat)corner;

@end
