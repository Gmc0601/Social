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

@interface XFMapViewController ()<XFFriendFilterViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *seniorDict; // 普通筛选字典
@property (nonatomic, strong) NSMutableDictionary *normalDict; // 高级筛选字典

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
    self.mapView = mapView;
    [self.view addSubview:_mapView];
    
    self.seniorDict = [NSMutableDictionary dictionary];
    self.normalDict = [NSMutableDictionary dictionary];
}

- (void)filterBtnClick:(XFLRButton *)button {
    if (button.tag == 0) {
        NSInteger index = 0;
        NSString *text = self.normalDict[@"sex"];
        NSArray *array = @[@"不限性别", @"男", @"女"];
        if (text.length) {
            if ([array containsObject:text]) {
                index = [array indexOfObject:text];
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
    if (view.tag == 0) {
        if (![text isEqualToString:@"附近"]) {
            self.normalDict[@"distance"] = text;
            if ([text isEqualToString:@"全城"]) {
                self.normalDict[@"distance"] = @"6";
            }
            [self loadData];
        } else {
            self.normalDict[@"distance"] = @"";
        }
    } else if (view.tag == 1) {
        if (![text isEqualToString:@"不限"]) {
            self.normalDict[@"sex"] = text;
            [self loadData];
        } else {
            self.normalDict[@"sex"] = @"";
        }
    }
}

- (void)friendFilterView:(XFFriendFilterView *)view didSelectCharm:(NSString *)charm tortoise:(NSString *)tortoise {
    self.normalDict[@"coolpoint"] = charm;
    self.normalDict[@"beetlepoint"] = tortoise;
    [self loadData];
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFFriendHomeUrl
                   params:[self getTheParams]
              resultBlock:^(id responseObject, NSError *error) {
                  weakSelf.dataArray = [NSMutableArray array];
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSArray *infoArray = responseObject[@"info"];
                          for (int i = 0 ; i < infoArray.count; i++) {
                              NSDictionary *dict = infoArray[i];
                              User *user = [User mj_objectWithKeyValues:dict];
                              [weakSelf.dataArray addObject:user];
                          }
                      }
                  }
              }];
}

- (NSDictionary *)getTheParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.seniorDict.allKeys.count) {
        [dict addEntriesFromDictionary:self.seniorDict];
    }
    if (self.normalDict.allKeys.count) {
        [dict addEntriesFromDictionary:self.normalDict];
    }
    NSString *latitude = [UserDefaults stringForKey:XFCurrentLatitudeKey];
    NSString *longitude = [UserDefaults stringForKey:XFCurrentLongitudeKey];
    if (latitude.length && longitude.length) {
        dict[@"lat"] = latitude;
        dict[@"long"] = longitude;
    }
    
    FFLog(@"%@", dict);
    return dict;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
