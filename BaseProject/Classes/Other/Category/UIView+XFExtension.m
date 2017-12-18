//
//  UIView+XFExtension.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "UIView+XFExtension.h"

@implementation UIView (XFExtension)

+ (instancetype)xf_navView:(NSString *)title
                backTarget:(id)target
                backAction:(SEL)action {
    UIView *view = [self xf_createWhiteView];
    view.frame = CGRectMake(0, 0, kScreenWidth, XFNavHeight);
    
    UILabel *titleLabel = [UILabel xf_labelWithFont:Font(18)
                                          textColor:BlackColor
                                      numberOfLines:0
                                          alignment:NSTextAlignmentCenter];
    titleLabel.text = title;
    titleLabel.frame = CGRectMake(44, 20, kScreenWidth - 88, 44);
    
    UIButton *backBtn = [UIButton xf_imgButtonWithImgName:@"nav_icon_fh" target:target action:action];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(0, XFNavHeight - 0.5, kScreenWidth, 0.5);
    
    [view addSubview:backBtn];
    [view addSubview:titleLabel];
    [view addSubview:splitView];
    
    return view;
}

+ (instancetype)xf_themeNavView:(NSString *)title
                     backTarget:(id)target
                     backAction:(SEL)action {
    UIView *view = [self xf_createWhiteView];
    view.frame = CGRectMake(0, 0, kScreenWidth, XFNavHeight);
    view.backgroundColor = ThemeColor;
    
    UILabel *titleLabel = [UILabel xf_labelWithFont:Font(18)
                                          textColor:WhiteColor
                                      numberOfLines:0
                                          alignment:NSTextAlignmentCenter];
    titleLabel.text = title;
    titleLabel.frame = CGRectMake(44, 20, kScreenWidth - 88, 44);
    
    UIButton *backBtn = [UIButton xf_imgButtonWithImgName:@"nav_icon_fh_w" target:target action:action];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    
    [view addSubview:backBtn];
    [view addSubview:titleLabel];
    
    return view;
}

+ (instancetype)xf_createSplitView {
    return [self xf_createViewWithColor:SplitColor];
}

+ (instancetype)xf_createPaddingView {
    return [self xf_createViewWithColor:RGBGray(240)];
}

+ (instancetype)xf_createWhiteView {
    return [self xf_createViewWithColor:WhiteColor];
}

+ (instancetype)xf_createViewWithColor:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    return view;
}

- (void)xf_cornerCut:(CGFloat)corner {
    self.layer.cornerRadius = corner;
    self.layer.masksToBounds = YES;
}

@end
