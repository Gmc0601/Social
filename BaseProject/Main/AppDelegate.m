//
//  AppDelegate.m
//  BaseProject
//
//  Created by cc on 2017/6/14.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AppDelegate.h"
#import "TBTabBarController.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<AMapLocationManagerDelegate,EMChatManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    [AMapServices sharedServices].apiKey = XFAMapKey; // 测试时换成跟Bundld id 对应的高德地图Key
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[TBTabBarController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1144171011115768#haichat"];
        options.apnsCertName = @"pushtext";  //  push   正式
    EMError *error  = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (!error) {
        NSLog(@"初始化成功");
        
    }
    
    
    
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    //添加监听在线推送消息
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    //  友盟
    [[UMSocialManager defaultManager] openLog:YES];
    
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UmengAPPKey];
    
    [self configUSharePlatformsset];
    [self getLocation];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}



- (void)messagesDidReceive:(NSArray *)aMessages {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收到环信通知" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    

//
    for (EMMessage *msg in aMessages) {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        // App在后台
        if (state == UIApplicationStateBackground) {
            //发送本地推送
            if (NSClassFromString(@"UNUserNotificationCenter")) { // ios 10
                // 设置触发时间
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                content.sound = [UNNotificationSound defaultSound];
                // 提醒，可以根据需要进行弹出，比如显示消息详情，或者是显示“您有一条新消息”
                content.body = @"提醒内容";
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:msg.messageId content:content trigger:trigger];
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
            }else {
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate date]; //触发通知的时间
                notification.alertBody = @"提醒内容";
                notification.alertAction = @"Open";
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
        }
    }
}


- (void)configUSharePlatformsset
{
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:@"wx3747000883cbfae5"
                                       appSecret:@"9f215c7bd25466b723d9e1841201384b"
                                     redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine
                                          appKey:@"wx3747000883cbfae5"
                                       appSecret:@"9f215c7bd25466b723d9e1841201384b"
                                     redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:@"1106464264"
                                       appSecret:@"FeYxsPRwBOIaPw4t"
                                     redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone
                                          appKey:@"1106464264"
                                       appSecret:@"FeYxsPRwBOIaPw4t"
                                     redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
                                          appKey:@"3569527049"
                                       appSecret:@"a21ddf43b1d8380e4b7ecc81158d8cd4"
                                     redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    /* 支付宝的appKey */
//        [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession
//                                              appKey:@"2015111700822536"
//                                           appSecret:nil
//                                         redirectURL:nil];
}

- (void)getLocation {
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setLocationTimeout:10];
    [self.locationManager setReGeocodeTimeout:5];
    [self.locationManager startUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    [UserDefaults setObject:[NSString stringWithFormat:@"%f", location.coordinate.latitude] forKey:XFCurrentLatitudeKey];
    [UserDefaults setObject:[NSString stringWithFormat:@"%f", location.coordinate.longitude] forKey:XFCurrentLongitudeKey];
    [self.locationManager stopUpdatingLocation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}


// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}






- (void)applicationDidBecomeActive:(UIApplication *)application {}


- (void)applicationWillTerminate:(UIApplication *)application {}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                      standbyCallback:^(NSDictionary *resultDic) {
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySuccessNotification" object:resultDic];
                                                      }];
            
            return YES;
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                      standbyCallback:^(NSDictionary *resultDic) {
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySuccessNotification" object:resultDic];
                                                      }];
            
            return YES;
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                      standbyCallback:^(NSDictionary *resultDic) {
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySuccessNotification" object:resultDic];
                                                      }];
            
            return YES;
        }
    }
    return result;
}

@end
