//
//  ChatRequestModel.h
//  BaseProject
//
//  Created by cc on 2017/11/22.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatRequestModel : NSObject

/*
 "request_id": "1",//聊天请求id
 "request_time": "2017-09-18 15:58:35",//聊天请求发起时间
 "nickname": "\u6765\u6765\u6765",//聊天请求人昵称
 "avatar_url": "http:\/\/139.224.70.219:81\/\u6765\u6765\u6765"//聊天请求人头像
 */

@property (nonatomic, copy) NSString *request_id, *request_time, *nickname, *avatar_url;

@end
