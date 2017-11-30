//
//  XFPrepareChatView.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/22.
//  Copyright © 2017年 王文利. All rights reserved.
//  准备聊天-诚意金

#import <UIKit/UIKit.h>

@class XFPrepareChatView;
@protocol XFPrepareChatViewDelegate <NSObject>

@optional

- (void)showinfo:(XFPrepareChatView *)view;
- (void)prepareChatViewClickCancelBtn:(XFPrepareChatView *)view;
- (void)prepareChatView:(XFPrepareChatView *)view clickConfirmBtn:(NSString *)text;

@end

@interface XFPrepareChatView : UIView

- (instancetype)initWithScore:(NSString *)score;

- (instancetype)initRequestWithSource:(NSString *)score;

@property (nonatomic, weak) id<XFPrepareChatViewDelegate> delegate;

@end
