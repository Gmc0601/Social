//
//  XFFriendFilterView.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/22.
//  Copyright © 2017年 王文利. All rights reserved.
//  有缘人前两个tab筛选

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FriendFilterType) {
    FriendFilterType_Normal,
    FriendFilterType_Charm
};

@class XFFriendFilterView;
@protocol XFFriendFilterViewDelegate <NSObject>

@optional
- (void)friendFilterView:(XFFriendFilterView *)view didSelect:(NSString *)text;
// 这是旧的------废弃
- (void)friendFilterView:(XFFriendFilterView *)view didSelectCharm:(NSString *)charm tortoise:(NSString *)tortoise;

// 这是新的
- (void)friendFilterView:(XFFriendFilterView *)view didSelectTopMin:(NSInteger)topMin topMax:(NSInteger)topMax bottomMin:(NSInteger)bottomMin bottomMax:(NSInteger)bottomMax;
@end

@interface XFFriendFilterView : UIView

- (instancetype)initWithDataArray:(NSArray *)dataArray
                      selectIndex:(NSInteger)index;
@property (nonatomic, weak) id<XFFriendFilterViewDelegate> delegate;

// 这是旧的------废弃
- (instancetype)initWithCharmCount:(CGFloat)charmCount
                     tortoiseCount:(CGFloat)tortoiseCount;

// 这是新的    赋值1-10, 并且min < max  阿弥陀佛，阿门
- (instancetype)initWitiTopMin:(NSInteger)topMin
                        topMax:(NSInteger)topMax
                     bottomMin:(NSInteger)bottomMin
                     bottomMax:(NSInteger)bottomMax;

@end

