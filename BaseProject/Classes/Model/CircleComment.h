//
//  CircleComment.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleComment : NSObject

@property (nonatomic, copy) NSString *nickname; // 评论人昵称
@property (nonatomic, copy) NSString *content; // 评论内容
@property (nonatomic, copy) NSString *create_time; // 评论时间
@property (nonatomic, strong) NSNumber *user_id;

@end

