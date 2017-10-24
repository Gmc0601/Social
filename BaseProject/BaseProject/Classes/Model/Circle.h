//
//  Circle.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Circle : NSObject

@property (nonatomic, copy) NSString *uid; // 缘分圈发布人id
@property (nonatomic, copy) NSString *avatar_url; // 头像
@property (nonatomic, copy) NSString *nickname; //  昵称

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *talk_content; // 发布内容
@property (nonatomic, strong) NSNumber *upload_type; // 缘分圈发布类型：1图片 2视频
@property (nonatomic, strong) NSArray *image; // 发布的图片
@property (nonatomic, copy) NSString *video; // 发布的视频
@property (nonatomic, copy) NSString *upload_time; // 发布时间
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *address; // 发布所在地址

@property (nonatomic, strong) NSNumber *like_status; //点赞状态 1 未点赞 2 已点赞
@property (nonatomic, strong) NSNumber *attention_status; //关注状态 1 未关注 2 已关注
@property (nonatomic, strong) NSNumber *comment_num;// 评论数
@property (nonatomic, strong) NSNumber *like_num; // 点赞数
@property (nonatomic, strong) NSNumber *reward_num; // 打赏数
@property (nonatomic, strong) NSNumber *transmit_num; // 分享数

@property (nonatomic, strong) NSArray *like; //  点赞用户
@property (nonatomic, strong) NSArray *reward; // 打赏用户
@property (nonatomic, strong) NSArray *comment; // 评论

@property (nonatomic, assign) BOOL isMine;


@end

