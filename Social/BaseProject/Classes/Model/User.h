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
@property (nonatomic, copy) NSString *avatar_id; // 头像字符串（个人信息中）
@property (nonatomic, copy) NSString *nickname; // 昵称
@property (nonatomic, copy) NSString *sdf; // 个性签名
@property (nonatomic, copy) NSString *sex; // 性别 1男  2女
@property (nonatomic, strong) NSNumber *guanzhumy_num; // 我关注的
@property (nonatomic, strong) NSNumber *myguanzhu_num; // 关注我的
@property (nonatomic, strong) NSNumber *mutual_attention_num; // 互为关注
@property (nonatomic, strong) NSNumber *mobile;
@property (nonatomic, strong) NSNumber *id; // 用户ID号
@property (nonatomic, strong) NSNumber *coolpoint; // 用户颜值分
@property (nonatomic, strong) NSNumber *beetlepoint; // 用户金龟分
@property (nonatomic, strong) NSNumber *user_type; // 1 未关注 2 已关注
@property (nonatomic, copy) NSString *age; // 用户年龄
@property (nonatomic, copy) NSString *address; // 用户所在地址
@property (nonatomic, copy) NSString *height; // 身高
@property (nonatomic, copy) NSString *weight; // 体重
@property (nonatomic, copy) NSString *hobby; // 爱好
@property (nonatomic, copy) NSString *education; // 学历
@property (nonatomic, copy) NSString *feeling; // 感情状况
@property (nonatomic, copy) NSString *spouse; // 择偶标准
@property (nonatomic, copy) NSString *job; // 工作
@property (nonatomic, copy) NSString *income; // 收入
@property (nonatomic, copy) NSString *house; // 车产
@property (nonatomic, copy) NSString *car; // 房产

@property (nonatomic, strong) NSNumber *city_bee;
@property (nonatomic, strong) NSNumber *city_coo;
@property (nonatomic, strong) NSNumber *country_bee;
@property (nonatomic, strong) NSNumber *country_coo;
@property (nonatomic, strong) NSNumber *friend_bee;
@property (nonatomic, strong) NSNumber *friend_coo;

@property (nonatomic, copy) NSString *distance; // 距离， 有缘人页面使用

@property (nonatomic, strong) NSNumber *guanzhu; // 有缘人首页使用 1未关注2已关注


@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@end

