//
//  TradeRecord.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/25.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeRecord : NSObject

@property (nonatomic, copy) NSString *integral; // 操作积分
@property (nonatomic, copy) NSString *service_integral; // 抽佣积分
@property (nonatomic, copy) NSString *name; // 操作名称
@property (nonatomic, copy) NSString *time; // 时间
@property (nonatomic, copy) NSString *type; // 类型：  +收入    -支出
@property (nonatomic, copy) NSString *tuihui;
@property (nonatomic, copy) NSString *status; // 状态
@property (nonatomic, copy) NSString *jiaoyi;
@property (nonatomic, copy) NSString *nickname;

@end

