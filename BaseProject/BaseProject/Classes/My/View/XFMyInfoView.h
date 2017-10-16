//
//  XFMyInfoView.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFMyInfoView;
@protocol XFMyInfoViewDelegate <NSObject>

@optional
- (void)myInfoView:(XFMyInfoView *)view didTapBottomView:(NSInteger)tag;
- (void)myInfoViewDidTapSignLabel:(XFMyInfoView *)view;
- (void)myInfoViewDidClickIconBtn:(XFMyInfoView *)view;

@end

@interface XFMyInfoView : UIView

@property (nonatomic, strong) User *user;
@property (nonatomic, weak) id<XFMyInfoViewDelegate> delegate;

@end
