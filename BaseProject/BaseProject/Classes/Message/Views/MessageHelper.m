//
//  MessageHelper.m
//  SimpleLife
//
//  Created by angle yan on 17/4/19.
//  Copyright © 2017年 高砚祥. All rights reserved.
//

#import "MessageHelper.h"

@interface MessageHelper ()<EMChatManagerDelegate,EMClientDelegate,EMChatroomManagerDelegate>


@property (nonatomic , strong) NSMutableArray *listAry;



@end



static MessageHelper *helper = nil;
@implementation MessageHelper



+ (MessageHelper *)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
        [[EMClient sharedClient].chatManager addDelegate:helper delegateQueue:dispatch_get_main_queue()];

        [[EMClient sharedClient] addDelegate:helper delegateQueue:dispatch_get_main_queue()];
        
    });
    return helper;
}

- (NSArray *)listAry{
    if (_listAry==nil) {
        _listAry =  [[[EMClient sharedClient].chatManager getAllConversations]  mutableCopy];
    }
    return _listAry;
}




/*
 *     发送消息， 如果发送失败，会尝试一次重发。
 */
- (void)sendMessage:(EMMessage *)aMessage
           progress:(void (^)(int progress))aProgressBlock
         completion:(void (^)(EMMessage *message, EMError *error))aCompletionBlock
{
    aMessage.ext = @{@"task_id":@"123456789"};
    
   
    
    [[EMClient sharedClient].chatManager sendMessage:aMessage progress:nil completion:^(EMMessage *message, EMError *error) {
        if (error) {
            [[EMClient sharedClient].chatManager resendMessage:message progress:nil completion:aCompletionBlock];
        }
        
    }];
}

/*
 *  收到消息
 */
- (void)messagesDidReceive:(NSArray *)aMessages{
    
    [aMessages enumerateObjectsWithOptions:(NSEnumerationConcurrent) usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EMMessage *message = aMessages[idx];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReserveMessageNotification" object:message];
        
    }];
}


/*  拉黑  */
- (void)addUserToBlackList:(NSString *)aUsername
                completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock{
    
}






- (void)connectionStateDidChange:(EMConnectionState)aConnectionState
{
    NSLog(@"聊天服务器已断开");
}









@end
