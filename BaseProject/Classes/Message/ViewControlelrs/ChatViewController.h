//
//  ChatViewController.h
//  SimpleLife
//
//  Created by angle yan on 17/4/20.
//  Copyright © 2017年 高砚祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMessageViewController.h"

@interface ChatViewController :CCMessageViewController


@property (nonatomic, copy) NSString *firstMessage;
@property (nonatomic) BOOL simpleServer;


- (instancetype)initWithConversation:(NSString *)conversation type:(EMConversationType)type;
- (void)sendMessage:(NSString *)text;

- (instancetype)initWithFriendID:(NSString *)chatID;

@end
