//
//  XFFriendViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFFriendViewController.h"
#import "XFFriendCell.h"
#import "XFFriendFilterView.h"
#import "XFSeniorFilterViewController.h"
#import "XFFriendHomeViewController.h"
#import "XFMapViewController.h"
#import "MJRefresh.h"
#import "XFLocationViewController.h"
#import "FrindeListTableViewCell.h"

@interface XFFriendViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, XFFriendFilterViewDelegate, AMapLocationManagerDelegate, AMapSearchDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UITextField *textField;


@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) AMapReGeocodeSearchRequest *codeSearch;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) NSMutableDictionary *seniorDict; // 高级筛选字典
@property (nonatomic, strong) NSMutableDictionary *normalDict; // 普通筛选字典

@property (nonatomic, strong) UIButton *clickBtn;

@property (nonatomic) BOOL list;

@end

@implementation XFFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.list = NO;
    [self setupUI];
    [self getLocation];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavView];
    UIView *fileterView = [UIView xf_createWhiteView];
    fileterView.frame = CGRectMake(0, XFNavHeight, kScreenWidth, 33);
    [self.view addSubview:fileterView];

    CGFloat itemW = (kScreenWidth - SizeWidth(30))/4;
    for (int i = 0; i < 5; i++) {
        NSString *imgName = i == 4 ? @"icon_yyr_sx" : @"list_ic_2_0";
        NSString *title = @"";
        if (i == 0) {
            title = @"附近";
        } else if (i == 1) {
            title = @"性别";
        } else if (i == 2) {
            title = @"魅力值";
        } else if (i == 4) {
            title = @"高级筛选";
        }

        XFLRButton *button = [XFLRButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:BlackColor forState:UIControlStateNormal];
        if (i == 3) {
            [button setImage:Image(@"yyr_icon_yszh") forState:UIControlStateNormal];
        }else {
            [button setImage:Image(imgName) forState:UIControlStateNormal];
        }

        button.titleLabel.font = Font(13);
        [button addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        if (i == 3) {
            button.width = SizeWidth(30);
        }else {
            button.width = itemW;
        }
        button.height = fileterView.height;
        button.top = 0;
        if (i == 4) {
            button.left = (i- 1) * itemW + SizeWidth(30);
        }else {
            button.left = i * itemW;
        }

        [fileterView addSubview:button];
    }

    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(0, fileterView.height - 0.5, fileterView.width, 0.5);
    [fileterView addSubview:splitView];

    self.seniorDict = [NSMutableDictionary dictionary];
    self.normalDict = [NSMutableDictionary dictionary];
    self.normalDict[@"distance"] = @"20km";

    self.collectionView.mj_header = [XFRefreshTool xf_header:self action:@selector(loadData)];
    self.collectionView.mj_footer = [XFRefreshTool xf_footer:self action:@selector(loadMoreData)];

    UIButton *mapBtn = [UIButton xf_imgButtonWithImgName:@"btn_yyr_dt" target:self action:@selector(mapBtnClick)];
    mapBtn.size = CGSizeMake(50, 50);
    mapBtn.right = kScreenWidth - 30;
    mapBtn.bottom = kScreenHeight - 75;
    [self.view addSubview:mapBtn];
}

- (void)setupNavView {
    UIView *navView = [UIView xf_createWhiteView];
    navView.frame = CGRectMake(0, 0, kScreenWidth, XFNavHeight);
    navView.backgroundColor = ThemeColor;
    [self.view addSubview:navView];

    UIView *searchView = [UIView xf_createViewWithColor:RGBA(249, 249, 249, 0.5)];
    searchView.frame = CGRectMake(kScreenWidth - 177 - 16, 28, 177, 32);
    [searchView xf_cornerCut:16];
    [navView addSubview:searchView];

    UIImageView *imgView = [[UIImageView alloc] initWithImage:Image(@"icon_nav_ss")];
    imgView.centerY = searchView.height * 0.5;
    imgView.right = searchView.width - 15;
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewTap)]];
    [searchView addSubview:imgView];

    UITextField *textField = [[UITextField alloc] init];
    self.textField = textField;
    textField.font = Font(13);
    textField.placeholder = @"输入手机号搜索";
    [searchView addSubview:textField];
    textField.height = searchView.height;
    textField.left = 15;
    textField.width = imgView.left - 10 - textField.left;

    UIImageView *locationView = [[UIImageView alloc] initWithImage:Image(@"icon_dw_b")];
    locationView.left = 16;
    locationView.centerY = searchView.centerY;
    locationView.userInteractionEnabled = YES;
    [locationView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationViewTap)]];
    [navView addSubview:locationView];

    UILabel *locationLabel = [UILabel xf_labelWithFont:Font(13)
                                             textColor:WhiteColor
                                         numberOfLines:1
                                             alignment:NSTextAlignmentLeft];
    locationLabel.userInteractionEnabled = YES;
    [locationLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationViewTap)]];
    [navView addSubview:locationView];
    self.locationLabel = locationLabel;
    locationLabel.left = locationView.right + 5;
    locationLabel.width = searchView.left - 5 - locationLabel.left;
    locationLabel.height = 13;
    locationLabel.centerY = locationView.centerY;
    [navView addSubview:locationLabel];
}

- (void)searchViewTap {
    [self loadData];
}

- (void)mapBtnClick {
    XFMapViewController *controller = [[XFMapViewController alloc] init];
    [self pushController:controller];
}

- (void)locationViewTap {
    XFLocationViewController *controller = [[XFLocationViewController alloc] init];
    controller.titleStr = @"选择地址";
    WeakSelf
    controller.selectAddress = ^(NSDictionary *dict) {
        NSString *name = dict[@"name"];
        weakSelf.locationLabel.text = name;
        AMapGeoPoint *point = dict[@"location"];
        weakSelf.location = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
        [weakSelf loadData];
    };
    [self pushController:controller];
}

- (void)loadData {
    WeakSelf
    self.currentPage = 1;
    [HttpRequest postPath:XFFriendHomeUrl
                   params:[self getTheParams]
              resultBlock:^(id responseObject, NSError *error) {
                  [weakSelf.collectionView.mj_header endRefreshing];
                  [weakSelf.noUseTableView.mj_header endRefreshing];
                  weakSelf.dataArray = [NSMutableArray array];
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSArray *infoArray = responseObject[@"info"];
                          if ([infoArray isKindOfClass:[NSArray class]] && infoArray.count) {
                              weakSelf.currentPage ++;
                              for (int i = 0 ; i < infoArray.count; i++) {
                                  NSDictionary *dict = infoArray[i];
                                  User *user = [User mj_objectWithKeyValues:dict];
                                  [weakSelf.dataArray addObject:user];
                              }
                          }
                          if (infoArray.count == 0) {
                              [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                              [self.noUseTableView.mj_footer endRefreshingWithNoMoreData];

                          } else {
                              [self.collectionView.mj_footer endRefreshing];
                              [self.noUseTableView.mj_footer endRefreshing];
                          }
                          [self.collectionView reloadData];
                          [self.noUseTableView reloadData];
                      } else {
                          NSString *info = responseObject[@"info"];
                          if ([info isKindOfClass:[NSString class]] && info.length) {
                              [ConfigModel mbProgressHUD:info andView:nil];
                          }
                      }
                  }
              }];
}

- (void)loadMoreData {
    WeakSelf
    [HttpRequest postPath:XFFriendHomeUrl
                   params:[self getTheParams]
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          weakSelf.currentPage ++;
                          NSArray *infoArray = responseObject[@"info"];
                          if ([infoArray isKindOfClass:[NSArray class]] && infoArray.count) {
                              weakSelf.currentPage ++;
                              for (int i = 0 ; i < infoArray.count; i++) {
                                  NSDictionary *dict = infoArray[i];
                                  User *user = [User mj_objectWithKeyValues:dict];
                                  [weakSelf.dataArray addObject:user];
                              }
                          }
                          if (infoArray.count == 0) {
                              [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                              [self.noUseTableView.mj_footer endRefreshingWithNoMoreData];
                          } else {
                              [self.collectionView.mj_footer endRefreshing];
                              [self.collectionView.mj_footer endRefreshing];
                          }
                          [self.collectionView reloadData];
                          [self.noUseTableView reloadData];
                      } else {
                          NSString *info = responseObject[@"info"];
                          if ([info isKindOfClass:[NSString class]] && info.length) {
                              [ConfigModel mbProgressHUD:info andView:nil];
                          }
                      }
                  }
              }];
}

- (NSDictionary *)getTheParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.textField.text.length) {
        dict[@"id"] = self.textField.text;
    } else {
        if (self.seniorDict.allKeys.count) {
            [dict addEntriesFromDictionary:self.seniorDict];
        }
        if (self.normalDict.allKeys.count) {
            [dict addEntriesFromDictionary:self.normalDict];
        }

        NSString *distance = dict[@"distance"];
        if ([distance containsString:@"km"]) {
            distance = [distance substringToIndex:distance.length - 2];
            dict[@"distance"] = distance;
        }


        NSString *city = [UserDefaults objectForKey:XFCurrentCityKey];
        if (city.length) {
            if ([[city substringFromIndex:city.length - 1] isEqualToString:@"市"]) {
                city = [city substringToIndex:city.length - 1];
            }
            if (distance.length == 0) {
                dict[@"city"] = city;
            }
        }
        dict[@"page"] = [NSString stringWithFormat:@"%zd", self.currentPage];
        dict[@"size"] = XFDefaultPageSize;
    }

    NSString *latitude = [NSString stringWithFormat:@"%f", self.location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", self.location.coordinate.longitude];
    if (latitude.length && longitude.length) {
        dict[@"lat"] = latitude;
        dict[@"long"] = longitude;
    }
    return dict;
}

- (void)getLocation {
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        self.locationManager = [[AMapLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [self.locationManager setLocationTimeout:10];
        [self.locationManager setReGeocodeTimeout:5];
        [self.locationManager startUpdatingLocation];
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    } else {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有开启获取定位权限，请去系统设置打开此权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        [self loadData];
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    self.location = location;
    self.codeSearch = [[AMapReGeocodeSearchRequest alloc] init];
    self.codeSearch.location = [AMapGeoPoint locationWithLatitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude];

    self.codeSearch.requireExtension = YES;
    [self.search AMapReGoecodeSearch:self.codeSearch];
    [self.locationManager stopUpdatingLocation];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        self.locationLabel.text = response.regeocode.formattedAddress;
        NSString *city = response.regeocode.addressComponent.city;
        if (city.length) {
            [UserDefaults setObject:city forKey:XFCurrentCityKey];
            [UserDefaults synchronize];

            if ([[city substringFromIndex:city.length - 1] isEqualToString:@"市"]) {
                city = [city substringToIndex:city.length - 1];
            }
            NSString *latitude = [NSString stringWithFormat:@"%f", self.location.coordinate.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%f", self.location.coordinate.longitude];
            if (latitude.length && longitude.length) {
                [HttpRequest postPath:@"_appjwdu_001"
                               params:@{@"long" : longitude,
                                        @"lat" : latitude,
                                        @"citys" : city
                                        }
                          resultBlock:^(id responseObject, NSError *error) {
                          }];
            }

        }
    }
    [self loadData];
}
#pragma mark ----------<UITableViewDataSource>----------


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *ID = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    FrindeListTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FrindeListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.user = self.dataArray[indexPath.row];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeigh(75);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    XFFriendHomeViewController *controller = [[XFFriendHomeViewController alloc] init];
    User *user = self.dataArray[indexPath.row];
    controller.friendId = user.id;
    [self pushController:controller];
}

#pragma mark ----------<UICollectionViewDataSource>----------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XFFriendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFFriendCell" forIndexPath:indexPath];
    cell.backgroundColor = WhiteColor;
    cell.user = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XFFriendHomeViewController *controller = [[XFFriendHomeViewController alloc] init];
    User *user = self.dataArray[indexPath.item];
    controller.friendId = user.id;
    [self pushController:controller];
}

#pragma mark ----------<XFFriendFilterViewDelegate>----------
- (void)friendFilterView:(XFFriendFilterView *)view didSelect:(NSString *)text {
    [self.clickBtn setTitle:text forState:UIControlStateNormal];
    if (view.tag == 0) {
        if (![text isEqualToString:@"全城"]) {
            if ([text isEqualToString:@"附近"]) {
                self.normalDict[@"distance"] = @"20km";
            } else {
                self.normalDict[@"distance"] = text;
            }
        } else {
            [self.normalDict removeObjectForKey:@"distance"];
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
    if (charm.integerValue > 0) {
        self.normalDict[@"coolpoint"] = charm;
    } else {
        [self.normalDict removeObjectForKey:@"coolpoint"];
    }

    if (tortoise.integerValue > 0) {
        self.normalDict[@"beetlepoint"] = tortoise;
    } else {
        [self.normalDict removeObjectForKey:@"beetlepoint"];
    }
    [self loadData];
}

#pragma mark ----------Action----------
- (void)filterBtnClick:(XFLRButton *)button {
    self.clickBtn = button;
    if (button.tag == 0) {
        NSInteger index = 0;
        NSString *text = self.normalDict[@"distance"];
        NSArray *array = @[@"附近", @"1km", @"3km", @"4km", @"5km", @"10km", @"全城"];
        if (text.length) {
            if ([array containsObject:text]) {
                index = [array indexOfObject:text];
            } else {
                if ([text isEqualToString:@"6"]) {
                    index = array.count - 1;
                }
            }
        }
        XFFriendFilterView *view = [[XFFriendFilterView alloc] initWithDataArray:array
                                                                     selectIndex:index];
        view.tag = 0;
        view.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    } else if (button.tag == 1) {
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
    } else if (button.tag == 2) {
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
    } else if (button.tag == 4) {
        XFSeniorFilterViewController *controller = [[XFSeniorFilterViewController alloc] init];
        controller.orignDict = self.seniorDict;
        controller.confirmBack = ^(NSDictionary *dict) {
            self.seniorDict = dict.mutableCopy;
            [self loadData];
        };
        [self pushController:controller];
    } else if ( button.tag == 3) {
        //   切换视图
        self.list = !self.list;
        if (self.list) {
            self.collectionView.hidden = YES;
            self.noUseTableView.hidden = NO;

        }else {
            self.collectionView.hidden = NO;
            self.noUseTableView.hidden = YES;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark ----------Lazy----------
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat top = XFNavHeight + XFFriendFilterHeight;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, top, kScreenWidth, kScreenHeight - top - XFTabHeight)
                                             collectionViewLayout:self.layout];
        [_collectionView registerClass:[XFFriendCell class] forCellWithReuseIdentifier:@"XFFriendCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = PaddingColor;
        _collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        [self.view addSubview:_collectionView];
        [self.view addSubview:self.noUseTableView];
        self.noUseTableView.hidden = YES;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 5;
        _layout.minimumLineSpacing = 5;
        CGFloat itemW = floorf((kScreenWidth  - 15) * 0.5);
        CGFloat itemH = itemW * 1.25;
        _layout.itemSize = CGSizeMake(itemW, itemH);
    }
    return _layout;
}


- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        CGFloat top = XFNavHeight + XFFriendFilterHeight;
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, kScreenW, kScreenH - SizeHeigh(50) - top) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _noUseTableView.mj_header = [XFRefreshTool xf_header:self action:@selector(loadData)];
        _noUseTableView.mj_footer = [XFRefreshTool xf_footer:self action:@selector(loadMoreData)];

        //        _noUseTableView.tableHeaderView = ({
        //            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.01)];
        //            view;
        //        });
        //        _noUseTableView.tableFooterView = ({
        //            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeigh(0))];
        //            view;
        //        });
    }
    return _noUseTableView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

