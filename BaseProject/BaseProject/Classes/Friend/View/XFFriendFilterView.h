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

@end

@interface XFFriendFilterView : UIView

- (instancetype)initWithDataArray:(NSArray *)dataArray
                      selectIndex:(NSInteger)index;
@property (nonatomic, weak) id<XFFriendFilterViewDelegate> delegate;

- (instancetype)initWithCharmCount:(CGFloat)charmCount
                     tortoiseCount:(CGFloat)tortoiseCount;

@end
