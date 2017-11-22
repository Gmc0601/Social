//
//  NSString+RegexExtension.m
//  YJTabBarPer
//
//  Created by hongjiwei on 16/3/10.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import "NSString+RegexExtension.h"
#import <sys/utsname.h>
//#import "UserInfoModel.h"

@implementation NSString (RegexExtension)

- (BOOL)isPhone{
    NSString *regex = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}


- (BOOL)passwordUsed
{
  
    NSString *      regex = @"[0-9A-Za-z]{8,16}";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}


- (BOOL)isEmail
{
    NSString *      regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isUrl
{
    NSString *      regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isTelephone
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-9]|8[0-9]|7[0-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    return  [regextestmobile evaluateWithObject:self]   ||
    [regextestphs evaluateWithObject:self]      ||
    [regextestct evaluateWithObject:self]       ||
    [regextestcu evaluateWithObject:self]       ||
    [regextestcm evaluateWithObject:self];
}

#pragma mark - 获取唯一标示
+ (NSString *)createTheOnlyString{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef stringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *)(stringRef);
}


/**
 *  是不是昨天
 */

- (BOOL)isYesterday{
    NSTimeInterval interval = [[NSDate new] timeIntervalSince1970] - 3600*24;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:newDate];
    if ([self hasPrefix:dateStr]) {
        return YES;
    }else{
        return NO;
    }
}


/**
 *  去掉文字中的emji表情
 *
 *  @return
 */
- (NSString *)deleteEmjiWithString:(NSString *)string{

    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[\\ud800\\udc00-\\udbff\\udfff\\ud800-\\udfff]" options:0 error:nil];
    
    NSString *deleteStr  = [regularExpression stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@""];
    return deleteStr;
}



/**
 *  使用一个时间样式(yyyy-MM-dd hh-mm-ss)调用得到当前时间
 */
- (NSString *)getNowTime{
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:self];
    return  [formatter stringFromDate:now];
}

- (NSString *)getTimeWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:self];
    return  [formatter stringFromDate:date];
}





/**
 *  时区转换
 *
 *  @param utcDate: 给定一个时区(yyyy-MM-ddThh:mm:ss+0000)
 *
 *  @return 本地的时间string;
 */
/*

-(NSString *)getLocalDateFormateUTCDate
{
  

    NSDate *dateFormatted = [NSDate mt_dateFromISOString:self];///此处的格式需要到方法中自己加
    //输出格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

-(NSString *)getLocalDateFormateUTCDateActivity
{
    NSDate *dateFormatted = [NSDate mt_dateFromISOString:self];///此处的格式需要到方法中自己加
    //输出格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM.dd HH:mm"];
    
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

-(NSString *)getLocalDateFormateUTCDateActivityEdit
{
    NSDate *dateFormatted = [NSDate mt_dateFromISOString:self];///此处的格式需要到方法中自己加
    //输出格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}


-(NSString *)getLocalDateFormateUTCDateMonth
{
    NSDate *dateFormatted = [NSDate mt_dateFromISOString:self];///此处的格式需要到方法中自己加
    //输出格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM.dd HH:mm"];
    
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}
*/
#pragma mark - 任务发布了多久
- (NSString *)taskTimeWithString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:self];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    [dateFormatter setDateFormat:@"HH:mm"];
    if (interval < 60) {
        return @"刚刚";
    }else if (interval >= 60 && interval <= 3600){
        return [NSString stringWithFormat: @"%d 分钟前",(int)interval/60];
    }else if(interval > 3600 && [date isToday]){
        return [NSString stringWithFormat: @"%d 小时前",(int)interval/3600];
    }else if  ([self isYesterday])
    {
        return [NSString stringWithFormat: @"昨天  %@",[dateFormatter stringFromDate:date]];
    }else{
        [dateFormatter setDateFormat:@"MM-dd  HH:mm"];
        return [dateFormatter stringFromDate:date];
    }
}




/**
 *  是不空字符串
 *
 */
- (BOOL)isBlankString{
    
    NSMutableString *str = [self mutableCopy];
    
   NSString *newStr = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (newStr == nil || newStr == NULL) {
        return YES;
    }
    if ([newStr isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    if ([[newStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


/**
 *  String -> Data
 *
 */

- (NSData *)getData{

    return [[NSData alloc] initWithBase64EncodedString:self options:NSUTF8StringEncoding];

}

//----------------------------------------本软件使用--------------------------------------------


/**
 *  将一个NSData转换成16进制的string
 *
 *  @return 16进制string
 */
+ (NSString *)hexStringFromString:(NSData *)data{
    //    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    //    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[data bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}


#pragma mark -拼接处理字符串 U16 把一个16进制的字符串转化为二进制的字符串的方法
-(NSString * )handleStringU16{
    NSString * str1=[self substringWithRange:NSMakeRange(0, 2)];
    NSString * str2 = [self substringWithRange:NSMakeRange(2, 2)];
    NSString * newstr = [str2 stringByAppendingString:str1];
    
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] init];
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"a"];
    [hexDic setObject:@"1011" forKey:@"b"];
    [hexDic setObject:@"1100" forKey:@"c"];
    [hexDic setObject:@"1101" forKey:@"d"];
    [hexDic setObject:@"1110" forKey:@"e"];
    [hexDic setObject:@"1111" forKey:@"f"];
    
    NSMutableString *binaryString=[[NSMutableString alloc] init];
    if (newstr.length) {
        for (int i=0; i<[newstr length]; i++) {
            NSRange rage;
            rage.length = 1;
            rage.location = i;
            NSString *key = [newstr substringWithRange:rage];
            [binaryString appendString:hexDic[key]];
        }
    }
    return binaryString;

}



- (NSString * )handleStringU32{
    NSString * str1=[self substringWithRange:NSMakeRange(0, 2)];  //10
    NSString * str2 = [self substringWithRange:NSMakeRange(2, 2)];//3d
    NSString * str3 = [self substringWithRange:NSMakeRange(4, 2)];//a3
    NSString * str4 = [self substringWithRange:NSMakeRange(6, 2)];//04
    NSString * newstr = [str4 stringByAppendingString:str3];
    newstr = [newstr stringByAppendingString:str2];
    newstr = [newstr stringByAppendingString:str1];
    
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] init];
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"a"];
    [hexDic setObject:@"1011" forKey:@"b"];
    [hexDic setObject:@"1100" forKey:@"c"];
    [hexDic setObject:@"1101" forKey:@"d"];
    [hexDic setObject:@"1110" forKey:@"e"];
    [hexDic setObject:@"1111" forKey:@"f"];
    NSMutableString *binaryString=[[NSMutableString alloc] init];
    if (newstr.length) {
        for (int i=0; i<[newstr length]; i++) {
            NSRange rage;
            rage.length = 1;
            rage.location = i;
            NSString *key = [newstr substringWithRange:rage];
            [binaryString appendString:hexDic[key]];
        }
    }
    return binaryString;
    return newstr;
}



- (NSString *)changeToHour{
//    if ([self intValue]>=24*3600) {
//        return [NSString stringWithFormat:@"%d 天 %d 时",[self intValue]/(3600*24),([self intValue]%(3600*24))/3600];
//    }else if ([self intValue]>=3600) {
//       return [NSString stringWithFormat:@"%d h %d m",[self intValue]/3600,([self intValue]%3600)/60];
//    }else{
//        return [NSString stringWithFormat:@"%d m",[self intValue]/60];
//    }
    
    NSString *timeStr = [NSString stringWithFormat:@"%.1f h",[self floatValue]/3600];
    timeStr = [self isEqualToString:@"0"]?@"0 h":timeStr;
    return timeStr;
}

+ (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceModel;
}














@end
