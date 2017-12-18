//
//  MessageModel.h
//  BaseProject
//
//  Created by cc on 2017/11/22.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
/*
 id  公告ID
 has_read 1已读 2未读
 "title": "bnvcn",//平台公告内容
 "create_time": "2017-09-11 21:40:11"//平台公告时间
 */
@property (nonatomic, copy) NSString *id, *has_read, *title, *create_time, *nickname;

@end
