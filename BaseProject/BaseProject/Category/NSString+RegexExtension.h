//
//  NSString+RegexExtension.h
//  YJTabBarPer
//
//  Created by hongjiwei on 16/3/10.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegexExtension)
/**
 *  是否是座机电话号码
 *
 *  @param phone
 *
 *  @return
 */
- (BOOL)isPhone ;



- (BOOL)passwordUsed;


/**
 *  是否是email
 *
 *  @return
 */
- (BOOL)isEmail;

/**
 *  是否是url
 *
 *  @return
 */
- (BOOL)isUrl;

/**
 *  是否是电话号码
 *
 *  @return
 */
- (BOOL)isTelephone;

/**
 *  去掉文字中的emji表情
 *
 *  @return 
 */
- (NSString *)deleteEmjiWithString:(NSString *)string;



/**
 *  使用底层 获取唯一标示
 */
+ (NSString *)createTheOnlyString;


/**
 *  是不是昨天
 */

- (BOOL)isYesterday;


/**
 *  使用一个时间样式(yyyy-MM-dd hh-mm-ss)调用得到当前时间
 */
- (NSString *)getNowTime;


/**
 *  使用一个时间样式(yyyy-MM-dd hh-mm-ss)调用
 */
- (NSString *)getTimeWithDate:(NSDate *)date;


/**
 *  时区转换
 *
 *  @param utcDate: 给定一个时区(yyyy-MM-ddThh:mm:ss+0000)
 *
 *  @return 本地的时间string;
 */
-(NSString *)getLocalDateFormateUTCDate;

-(NSString *)getLocalDateFormateUTCDateActivity;

-(NSString *)getLocalDateFormateUTCDateActivityEdit;

-(NSString *)getLocalDateFormateUTCDateMonth;
/**
 *  时长 (self->@"yyyy-MM-dd hh:mm:ss" 格式的字符串)
 *
 *  @return 刚刚, 多久之前, 06-23 17:32:23
 */
- (NSString *)taskTimeWithString;


/**
 *  是不空字符串
 *
 */
- (BOOL)isBlankString;




/**
 *  String 转  Data
 */

- (NSData *)getData;


//----------------------------------------本软件使用--------------------------------------------

/**
 *  将一个NSData转换成16进制的string
 *
 *  @return 16进制string
 */
+ (NSString *)hexStringFromString:(NSData *)data;


/**
 *  将一个16进制4位的字符串,转换(AFCE->CEAF)位置并转成二进制
 */
- (NSString * )handleStringU16;

/**
 *  拼接处理字符串 U32
 */

- (NSString * )handleStringU32;



/**
 *   传入一个秒单位的时间
 *
 *   返回xx小时xx分钟 或 xx分钟xx秒
 */
- (NSString *)changeToHour;
+ (NSString *)deviceModelName;

@end
