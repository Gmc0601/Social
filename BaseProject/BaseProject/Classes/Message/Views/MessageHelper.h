//
//  MessageHelper.h
//  SimpleLife
//
//  Created by angle yan on 17/4/19.
//  Copyright © 2017年 高砚祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageHelper : NSObject



@property (nonatomic , strong, readonly) NSMutableArray *listAry;



+ (MessageHelper *)shareHelper;


/*!
 *  \~chinese
 *  收到消息
 *
 *  param aMessages  消息列表<EMMessage>
 *
 *  \~english
 *  Delegate method will be invoked when receiving new messages
 *
 *  param message  Receivecd message list<EMMessage>
 */
- (void)messagesDidReceive:(NSArray *)aMessages;


/*!
 *  \~chinese
 *  发送消息
 *
 *  param aMessages  消息<EMMessage>
 *  param message  如果发送失败，会尝试一次重发；
 */
- (void)sendMessage:(EMMessage *)aMessage
           progress:(void (^)(int progress))aProgressBlock
         completion:(void (^)(EMMessage *message, EMError *error))aCompletionBlock;


@end
