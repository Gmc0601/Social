//
//  ChatBalloonView.h
//  SimpleLife
//
//  Created by angle yan on 17/4/20.
//  Copyright © 2017年 高砚祥. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ChatBalloonAlignment) {

    ChatBalloonAlignmentLeft,
    ChatBalloonAlignmentRight
};

@interface ChatBalloonView : UIView




/* 聊天框  文字*/
@property (nonatomic, copy) NSString *text;
/* 聊天框  颜色*/
@property (nonatomic, strong) UIColor *balloonColor;
/* 聊天框  文字颜色*/
@property (nonatomic, strong) UIColor *textColor;
/* 聊天框  文字的最大宽度*/
@property (nonatomic) CGFloat balloonWidth;
/* 聊天框  文字 大小  default 13*/
@property (nonatomic, strong) UIFont *font;
/* 文字Attribute  可以自定义 textAttribute*/
@property (nonatomic, strong)  NSDictionary * textAttributes;
/*气泡的方向  default left*/
@property (nonatomic) ChatBalloonAlignment balloonAlignment;
/* 设置 圆角   默认  4*/
@property (nonatomic) CGFloat corner;








@end
