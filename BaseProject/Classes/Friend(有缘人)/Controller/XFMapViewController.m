//
//  XFMapViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/10/23.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "XFFriendFilterView.h"
#import "XFSeniorFilterViewController.h"
#import "XFFriendHomeViewController.h"

@interface XFMapViewController ()<XFFriendFilterViewDelegate, MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *seniorDict; // 普通筛选字典
@property (nonatomic, strong) NSMutableDictionary *normalDict; // 高级筛选字典

@property (nonatomic, strong) UIButton *clickBtn;

@end

@implementation XFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *navView = [UIView xf_themeNavView:@"地图交友" backTarget:self backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    UIView *filterView = [UIView xf_createViewWithColor:RGBA(255, 255, 255, 0.96)];
    filterView.frame = CGRectMake(0, XFNavHeight, kScreenWidth, 33);
    [self.view addSubview:filterView];
    
    CGFloat itemW = kScreenWidth / 3;
    for (int i = 0; i < 3; i++) {
        NSString *imgName = i == 2 ? @"icon_yyr_sx" : @"list_ic_2_0";
        NSString *title = @"";
        if (i == 0) {
            title = @"性别";
        } else if (i == 1) {
            title = @"魅力值";
        } else if (i == 2) {
            title = @"高级筛选";
        }
        
        XFLRButton *button = [XFLRButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:BlackColor forState:UIControlStateNormal];
        [button setImage:Image(imgName) forState:UIControlStateNormal];
        button.titleLabel.font = Font(13);
        [button addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        button.width = itemW;
        button.height = filterView.height;
        button.top = 0;
        button.left = i * itemW;
        [filterView addSubview:button];
    }
    
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, filterView.bottom, kScreenWidth, kScreenHeight - filterView.bottom)];
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.delegate = self;
    self.mapView = mapView;
    [self.view addSubview:_mapView];
    
    self.seniorDict = [NSMutableDictionary dictionary];
    self.normalDict = [NSMutableDictionary dictionary];
    [self loadData];
}

- (void)filterBtnClick:(XFLRButton *)button {
    self.clickBtn = button;
    if (button.tag == 0) {
        NSInteger index = 0;
        NSString *text = self.normalDict[@"sex"];
        if (text.length) {
            if ([text isEqualToString:@"1"]) {
                index = 1;
            } else if ([text isEqualToString:@"2"]) {
                index = 2;
            }
        }
        XFFriendFilterView *view = [[XFFriendFilterView alloc] initWithDataArray:@[@"不限性别", @"男", @"女"]
                                                                     selectIndex:index];
        view.tag = 1;
        view.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    } else if (button.tag == 1) {
        CGFloat charm = 0;
        CGFloat tor = 0;
        NSString *charmStr = self.normalDict[@"coolpoint"];
        if (charmStr.length) {
            charm = charmStr.floatValue;
        }
        NSString *torStr = self.normalDict[@"beetlepoint"];
        if (torStr.length) {
            tor = torStr.floatValue;
        }
        XFFriendFilterView *view = [[XFFriendFilterView alloc] initWithCharmCount:charm tortoiseCount:tor];
        view.tag = 2;
        view.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    } else if (button.tag == 2) {
        XFSeniorFilterViewController *controller = [[XFSeniorFilterViewController alloc] init];
        controller.orignDict = self.seniorDict;
        controller.confirmBack = ^(NSDictionary *dict) {
            self.seniorDict = dict.mutableCopy;
            if (dict.allKeys.count) {
                [self loadData];
            }
        };
        [self pushController:controller];
    }
}

#pragma mark ----------<XFFriendFilterViewDelegate>----------
- (void)friendFilterView:(XFFriendFilterView *)view didSelect:(NSString *)text {
    [self.clickBtn setTitle:text forState:UIControlStateNormal];
    if (view.tag == 0) {
        if (![text isEqualToString:@"附近"]) {
            self.normalDict[@"distance"] = text;
            if ([text isEqualToString:@"全城"]) {
                self.normalDict[@"distance"] = @"6";
            }
        } else {
            self.normalDict[@"distance"] = @"";
        }
        [self loadData];
    } else if (view.tag == 1) {
        if (![text containsString:@"不限"]) {
            if ([text isEqualToString:@"男"]) {
                self.normalDict[@"sex"] = @"1";
            } else {
                self.normalDict[@"sex"] = @"2";
            }
        } else {
            self.normalDict[@"sex"] = @"";
        }
        [self loadData];
    }
}

- (void)friendFilterView:(XFFriendFilterView *)view didSelectCharm:(NSString *)charm tortoise:(NSString *)tortoise {
    self.normalDict[@"coolpoint"] = charm;
    self.normalDict[@"beetlepoint"] = tortoise;
    [self loadData];
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFFriendMapUrl
                   params:[self getTheParams]
              resultBlock:^(id responseObject, NSError *error) {
                  weakSelf.dataArray = [NSMutableArray array];
                  if (!error) {
                      weakSelf.dataArray = [NSMutableArray array];
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSArray *infoArray = responseObject[@"info"];
                          for (int i = 0 ; i < infoArray.count; i++) {
                              NSDictionary *dict = infoArray[i];
                              User *user = [User mj_objectWithKeyValues:dict];
                              [weakSelf.dataArray addObject:user];
                          }
                          [self setupAnnotations];
                      }
                  }
              }];
}

- (void)setupAnnotations {
    NSMutableArray *coordinates = [NSMutableArray array];
    for (int i = 0; i < self.dataArray.count; i++) {
        User *user = self.dataArray[i];
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = CLLocationCoordinate2DMake(user.latitude.doubleValue, user.longitude.doubleValue);
        a1.title = [NSString stringWithFormat:@"%d", i];
        [coordinates addObject:a1];
    }
    for (MAPointAnnotation *ano in self.mapView.annotations) {
        [self.mapView removeAnnotation:ano];
    }
    [self.mapView addAnnotations:coordinates];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAAnnotationView*annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.frame = CGRectMake(0, 0, 49, 58);
        annotationView.canShowCallout = NO;       //设置气泡可以弹出，默认为NO
        
        NSString *title = annotation.title;
        User *user = self.dataArray[title.integerValue];
        NSString *iconName = [user.sex isEqualToString:@"1"] ? @"icon_dw_boy" : @"icon_dw_girl";
        annotationView.image = [UIImage imageNamed:iconName];
        annotationView.leftCalloutAccessoryView = nil;
        annotationView.rightCalloutAccessoryView = nil;
        
        UIImageView *imgView = [annotationView viewWithTag:999];
        [imgView removeFromSuperview];
        
        UIImageView *avatarView = [[UIImageView alloc] init];
        avatarView.contentMode = UIViewContentModeScaleAspectFill;
        avatarView.clipsToBounds = YES;
        avatarView.tag = 999;
        [avatarView sd_setImageWithURL:[NSURL URLWithString:user.avatar_url]];
        [annotationView addSubview:avatarView];
        avatarView.size = CGSizeMake(46, 46);
        [avatarView xf_cornerCut:23];
        avatarView.top = 1.5;
        avatarView.left = 1.5;
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    NSString *title = view.annotation.title;
    User *user = self.dataArray[title.integerValue];
    XFFriendHomeViewController *controller = [[XFFriendHomeViewController alloc] init];
    controller.friendId = user.id;
    [self pushController:controller];
}

- (NSDictionary *)getTheParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.seniorDict.allKeys.count) {
        [dict addEntriesFromDictionary:self.seniorDict];
    }
    if (self.normalDict.allKeys.count) {
        [dict addEntriesFromDictionary:self.normalDict];
    }
    NSString *distance = dict[@"distance"];
    if ([distance containsString:@"km"]) {
        distance = [distance substringToIndex:distance.length - 2];
    }
    NSString *latitude = [UserDefaults stringForKey:XFCurrentLatitudeKey];
    NSString *longitude = [UserDefaults stringForKey:XFCurrentLongitudeKey];
    if (latitude.length && longitude.length) {
        dict[@"lat"] = @"30.093917695683086";
        dict[@"long"] = @"120.19759118556976";
    }
    return dict;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

