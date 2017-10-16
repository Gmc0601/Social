//
//  User.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/25.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *avatar_url; // 头像
@property (nonatomic, copy) NSString *nickname; // 昵称
@property (nonatomic, copy) NSString *sdf; // 个性签名
@property (nonatomic, copy) NSString *sex; // 性别
@property (nonatomic, strong) NSNumber *guanzhumy_num; // 我关注的
@property (nonatomic, strong) NSNumber *myguanzhu_num; // 关注我的
@property (nonatomic, strong) NSNumber *mutual_attention_num; // 互为关注

@property (nonatomic, strong) NSNumber *id; // 用户ID号
@property (nonatomic, strong) NSNumber *coolpoint; // 用户颜值分
@property (nonatomic, strong) NSNumber *beetlepoint; // 用户金龟分
@property (nonatomic, strong) NSNumber *user_type; // 1 未关注 2 已关注
@property (nonatomic, copy) NSString *age; // 用户年龄
@property (nonatomic, copy) NSString *address; // 用户所在地址

@property (nonatomic, strong) NSNumber *city_bee;
@property (nonatomic, strong) NSNumber *city_coo;
@property (nonatomic, strong) NSNumber *country_bee;
@property (nonatomic, strong) NSNumber *country_coo;
@property (nonatomic, strong) NSNumber *friend_bee;
@property (nonatomic, strong) NSNumber *friend_coo;

@property (nonatomic, copy) NSString *distance; // 距离， 有缘人页面使用

@property (nonatomic, strong) NSNumber *guanzhu; // 有缘人首页使用 1未关注2已关注

@end
