//
//  CCUrl.h
//  CarSticker
//
//  Created by cc on 2017/3/21.
//  Copyright © 2017年 cc. All rights reserved.
//

#ifndef CCUrl_h
#define CCUrl_h
/*
 接口文档
 */
#define TokenKey @"1e56c95504a9a846e4c7043704a20f25"

#define AMapKey @"9fec32e1488995b3cdaef7c1f32ba31e"

#define UmengAPPKey @"59f04601f43e48186a00001b"

#define UDID     0

/*****************************测试开关*******************************/

#define HHTest   1      // 1 测试  0 上传

/*****************************测试开关*******************************/

#if HHTest

#define    BaseApi       @"http://139.224.70.219:81/index.php"

#else

#define    BaseApi      @"正式地址"

#endif

#pragma mark - 接口地址 -

#define LoginURL @"_login_001"

#define BrandList @"_brandlist_001"


//宽高
#define KScreenWidth [UIScreen mainScreen].bounds.size.width

#define KScreenHeight [UIScreen mainScreen].bounds.size.height




#define Navi_Height 64
#define Tabbar_Height 49

//去掉nav 和 tabbar
#define Home_Height (KScreenHeight - Navi_Height -Tabbar_Height)

#define Height_NoNav (KScreenHeight - Navi_Height)


/**
 *  屏幕比
 */
#define MainScreen_Scale KScreenWidth/KScreenHeight///宽:高






//字体加颜色




/**
 *  屏幕比 设置 宽度 (以iphone6为标准定的)
 *
 */


#define Width_Ratio (KScreenWidth/375)
#define Height_Ratio (KScreenHeight/667)

#define Width(d) (d*Width_Ratio)
#define Height(d) (d*Height_Ratio)


//商品图片 宽高比

#define Goods_Image_Scale (Width(105)/Height(70))



/*
 *   User Info
 */

#define IsLogin @"islogin"

#define UserToken @"userTOken"

#define UserId @"UserId"

#define Mobile @"mobile"

#define simple_user @"gao111"
#define friendID @"gao112"



#define User_token     @"userToken"
#define User_Id        @"userId"
#define User_url       @"avatar_url" // 头像
#define User_Nick      @"nickname"
#define User_Cash      @"cash" /// 押金
#define User_Money     @"money" /// 余额 （可提现）
#define User_username  @"username" /// 手机号
#define User_Longitude @"longitude" //经纬度
#define User_Latitude  @"latitude"
#define User_City      @"city"
#define User_Place     @"place"
#define User_Mobile     @"mobile"//手机号

#define ChatPWD @"9876543210"


#endif /* CCUrl_h */
