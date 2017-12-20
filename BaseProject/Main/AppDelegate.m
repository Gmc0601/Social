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
#import "SystemMessageViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件

@interface AppDelegate ()<AMapLocationManagerDelegate,EMChatManagerDelegate,JPUSHRegisterDelegate>{
    int havenewMessage;
}

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
    havenewMessage = 0;
    [AMapServices sharedServices].apiKey = XFAMapKey; // 测试时换成跟Bundld id 对应的高德地图Key
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[TBTabBarController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1144171011115768#haichat"];
        options.apnsCertName = @"push";  //  push   正式    pushtext
    EMError *error  = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (!error) {
        NSLog(@"初始化成功");
        
    }
    [self registerRemoteNotification];
    [self jpush:launchOptions];
    
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

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}



- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

#pragma mark --  Jpush
- (void)jpush:(NSDictionary *)launchOptions {
    //极光推送
    
//    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        // 可以添加自定义categories
//        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
//        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
//    }
//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:APPKey
                          channel:nil
                 apsForProduction:YES
            advertisingIdentifier:nil];
}

#pragma mark  --  推动消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    //   横条通知
     [self goToMssageViewController];
    
}

//   环信接受消息
- (void)messagesDidReceive:(NSArray *)aMessages {
    //  设置未读数
  int num = [ConfigModel getIntObjectforKey:Unreadnum];
    num++;
    [ConfigModel saveIntegerObject:num forKey:Unreadnum];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = num;
    for (EMMessage *msg in aMessages) {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        // App在后台
        if (state == UIApplicationStateBackground) {
            //发送本地推送
            if (NSClassFromString(@"UNUserNotificationCenter")) { // ios 10
                // 设置触发时间
                havenewMessage++;
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                content.sound = [UNNotificationSound defaultSound];
                // 提醒，可以根据需要进行弹出，比如显示消息详情，或者是显示“您有一条新消息”;
//                content.badge = [NSNumber numberWithInteger:5];
                NSString * str = [NSString stringWithFormat:@"您收到了%d条消息", havenewMessage];
                content.body = str;
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:msg.messageId content:content trigger:trigger];
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
            }else {
                havenewMessage++;
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate date]; //触发通知的时间
                NSString * str = [NSString stringWithFormat:@"您收到了%d条消息", havenewMessage];
                notification.alertBody = str;
                notification.alertAction = @"Open";
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:HaveNewMessage object:nil];
            
            AudioServicesPlaySystemSound(1312);
            

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
//  点击通知唤起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
//    AudioServicesPlaySystemSound(1007);;
    if (application.applicationState ==UIApplicationStateActive) {
        
    }else{
        [self goToMssageViewController];
    }
    
}

-(void)goToMssageViewController{
    SystemMessageViewController *VC = [SystemMessageViewController new];
    VC.present = YES;
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
    [self.window.rootViewController presentViewController:na animated:YES completion:nil];
    
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    int num = [ConfigModel getIntObjectforKey:Unreadnum];
    [UIApplication sharedApplication].applicationIconBadgeNumber = num;
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}


// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:HaveNewMessage object:nil];
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
