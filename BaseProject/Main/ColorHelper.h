//
//  ColorHelper.h
//  LVSportBoom
//
//  Created by lenwave_IOS02 on 16/5/24.
//  Copyright © 2016年 maia. All rights reserved.
//

#ifndef ColorHelper_h
#define ColorHelper_h

/**
 * 颜色宏
 */

#define Random_Color  [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0   blue:arc4random()%255/255.0  alpha:1];


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBwithALPHA(rgbValue,alt) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(float)alt]


#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define WhiteColor    [UIColor whiteColor]
#define ClearColor    [UIColor clearColor]
#define RedColor      [UIColor redColor]
#define GreenColor    [UIColor greenColor]
#define BlackColor    [UIColor blackColor]
#define ClearColor    [UIColor clearColor]
#define GrayColor     [UIColor grayColor]

#define HomePage_Color  UIColorFromRGB(0x54bcf9)//

#define Deviece_Page_Color UIColorFromRGB(0x45abe6)


#define Main_Color UIColorFromRGB(0xfa854b) ///主色
#define Assist_Color UIColorFromRGB(0xf5c662) ///辅色
#define Main_DotBlue_Color UIColorFromRGB(0x22b2da) ///点缀色   商品
#define Main_DotGreen_Color UIColorFromRGB(0x32b16c) ///点缀色  任务

#define Main_DotColor(value) ([value isEqualToString:@"任务"] ? (Main_DotGreen_Color) :(Main_DotBlue_Color)) ///点缀色  任务




#define BigBtn_Color UIColorFromRGB(0xfa7532) ///bigButton
#define BigBtn_High_Color UIColorFromRGBwithALPHA(0xfa7532,0.8)







//分割线
#define FGX_line_color UIColorFromRGB(0xd9d9d9)//

// 运动 背景色
#define Run_BackGroud_Color UIColorFromRGB(0x393940)

//背景色
#define BackGround_Color UIColorFromRGB(0xeeeeee)


//设置字体颜色黑色透明度

#define TEXT_666 UIColorFromRGB(0x666666)
#define TEXT_999 UIColorFromRGB(0x999999)
#define TEXT_333 UIColorFromRGB(0x333333)

#define TEXT_COLOR_BLACK_80  [UIColor colorWithRed:0 green:0 blue:0 alpha:.80]
#define TEXT_COLOR_BLACK_70  [UIColor colorWithRed:0 green:0 blue:0 alpha:.70]
#define TEXT_COLOR_BLACK_54  [UIColor colorWithRed:0 green:0 blue:0 alpha:.54]
#define TEXT_COLOR_BLACK_27  [UIColor colorWithRed:0 green:0 blue:0 alpha:.27]
#define TEXT_COLOR_BLACK_30  [UIColor colorWithRed:0 green:0 blue:0 alpha:.30]
#define TEXT_COLOR_BLACK_17  [UIColor colorWithRed:0 green:0 blue:0 alpha:.17]


#define TEXT_COLOR_WHITE_90  [UIColor colorWithRed:1 green:1 blue:1 alpha:.90]
#define TEXT_COLOR_WHITE_60  [UIColor colorWithRed:1 green:1 blue:1 alpha:.60]




/**
 *  动态详情  的输入框
 */

#define CHAT_BG_COLOR UIColorFromRGB(0xecedf1)





















































#endif /* ColorHelper_h */
