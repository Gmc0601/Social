//
//  XFLocationViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/10/23.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFLocationViewController.h"

@interface XFLocationCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *splitView;

@end

@implementation XFLocationCell

+ (CGFloat)cellHeight {
    return 55;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel xf_labelWithFont:Font(15)
                                      textColor:RGBGray(102)
                                  numberOfLines:1
                                      alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        _subtitleLabel = [UILabel xf_labelWithFont:Font(12)
                                         textColor:RGBGray(153)
                                     numberOfLines:1
                                         alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_subtitleLabel];
    }
    return _subtitleLabel;
}

- (UIView *)splitView {
    if (_splitView == nil) {
        _splitView = [UIView xf_createSplitView];
        [self.contentView addSubview:_splitView];
    }
    return _splitView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(15, 10, kScreenWidth - 30, 16);
    
    self.subtitleLabel.frame = CGRectMake(15, self.titleLabel.bottom + 7, kScreenWidth - 30, 12);
    
    self.splitView.frame = CGRectMake(15, self.height - 0.5, kScreenWidth - 30, 0.5);
}

@end

@interface XFLocationViewController ()<UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate, AMapLocationManagerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tipArray;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapReGeocodeSearchRequest *codeSearch;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, copy) NSString *city;

@property (nonatomic, strong) UITextField *field;

@end

@implementation XFLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getLocation];
}

- (void)setupUI {
    UIView *navView = [UIView xf_themeNavView:self.titleStr backTarget:self backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    UIView *searchView = [UIView xf_createWhiteView];
    searchView.frame = CGRectMake(0, XFNavHeight, kScreenWidth, 43);
    [self.view addSubview:searchView];
    
    UIButton *searchBtn = [UIButton xf_titleButtonWithTitle:@"搜索" titleColor:BlackColor titleFont:Font(13) target:self action:@selector(searchBtnClick)];
    searchBtn.backgroundColor = RGBGray(227);
    [searchBtn xf_cornerCut:3];
    searchBtn.size = CGSizeMake(53, 29);
    searchBtn.right = kScreenWidth - 16;
    searchBtn.centerY = searchView.height * 0.5;
    [searchView addSubview:searchBtn];
    
    UIView *fieldView = [UIView xf_createWhiteView];
    fieldView.left = 16;
    fieldView.width = searchBtn.left - 16 - fieldView.left;
    fieldView.height = searchBtn.height;
    fieldView.centerY = searchBtn.centerY;
    [fieldView xf_cornerCut:5];
    fieldView.layer.borderColor = RGBGray(224).CGColor;
    fieldView.layer.borderWidth = 0.5;
    [searchView addSubview:fieldView];
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:Image(@"icon_xzdz_ss")];
    searchIcon.size = CGSizeMake(13, 13);
    searchIcon.left = 8;
    searchIcon.centerY = fieldView.height * 0.5;
    [fieldView addSubview:searchIcon];
    
    UITextField *field = [[UITextField alloc] init];
    self.field = field;
    field.delegate = self;
    field.left = searchIcon.right + 8;
    field.top = 0;
    field.width = fieldView.width - field.left;
    field.height = fieldView.height;
    field.placeholder = @"搜索附近位置";
    field.font = Font(14);
    [fieldView addSubview:field];
    self.tipArray = [NSMutableArray array];
    self.addressArray = [NSMutableArray array];
    
    self.tableView.top = searchView.bottom;
    self.tableView.height = kScreenHeight - self.tableView.top;
    self.tableView.width = kScreenWidth;
    self.tableView.left = 0;
    [self.tableView reloadData];
}

- (void)getLocation {
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setLocationTimeout:10];
    [self.locationManager setReGeocodeTimeout:5];
    [self.locationManager startUpdatingLocation];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    self.location = location;
    [self getCity];
    [self searchAround];
    [self.locationManager stopUpdatingLocation];
}

- (void)getCity {
    self.codeSearch = [[AMapReGeocodeSearchRequest alloc] init];
    self.codeSearch.location = [AMapGeoPoint locationWithLatitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude];
    self.codeSearch.requireExtension = YES;
    [self.search AMapReGoecodeSearch:self.codeSearch];
}

- (void)searchAround {
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self.location.coordinate.latitude
                                                longitude:self.location.coordinate.longitude];
    request.types = @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.sortrule = 0;
    request.requireExtension = YES;
    [self.search AMapPOIAroundSearch: request];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        // 城市，用于输入提示
        NSString *province = response.regeocode.addressComponent.province;
        NSString *city = response.regeocode.addressComponent.city;
        self.city = [NSString stringWithFormat:@"%@%@", province, city];
    }
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count) {
        self.addressArray = response.pois.mutableCopy;
        [self.tableView reloadData];
    }
}

- (void)searchBtnClick {
    if (self.field.text.length == 0) {
        [self.tableView reloadData];
        return;
    }
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = self.field.text;
    if (self.city.length) {
        tips.city = self.city;
        tips.cityLimit = YES; //是否限制城市
    }
    [self.search AMapInputTipsSearch:tips];
}


/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    if (response.count == 0) {
        return;
    }
    [self.tipArray setArray:response.tips];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.field.text.length) {
        return self.tipArray.count;
    } else {
        return self.addressArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFLocationCell"];
    if (self.tipArray.count) {
        AMapTip *tip = self.tipArray[indexPath.row];
        cell.titleLabel.text = tip.name;
        cell.subtitleLabel.text = tip.address;
    } else {
        AMapPOI *poi = self.addressArray[indexPath.row];
        cell.titleLabel.text = poi.name;
        cell.subtitleLabel.text = poi.address;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XFLocationCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectAddress) {
        if (self.tipArray.count) {
            AMapTip *tip = self.tipArray[indexPath.row];
            NSString *name = tip.name;
            self.selectAddress(@{@"name" : name,
                                 @"location" : tip.location
                                 });
        } else {
            AMapPOI *poi = self.addressArray[indexPath.row];
            NSString *name = poi.name;
            self.selectAddress(@{@"name" : name,
                                 @"location" : poi.location
                                 });
        }
        
        [self backBtnClick];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[XFLocationCell class] forCellReuseIdentifier:@"XFLocationCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

