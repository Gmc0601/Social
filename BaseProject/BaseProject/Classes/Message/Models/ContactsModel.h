//
//  ContactsModel.h
//  BaseProject
//
//  Created by cc on 2017/11/22.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsModel : NSObject

/*"id": "",//聊天好友id
 
 "mobile": "",//聊天好友mobile
 
 "nickname": "\u6765\u6765\u6765",//聊天好友昵称
 "avatar_url": "http:\/\/139.224.70.219:81\/\u6765\u6765\u6765"//聊天好友头像*/

@property (nonatomic, copy) NSString * id, *mobile, *nickname, *avatar_url;


@end
