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

@end

@implementation XFLocationCell

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

@end

@interface XFLocationViewController ()<UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tipArray;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) UITextField *field;

@end

@implementation XFLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    self.tipArray = [NSMutableArray array];
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
    field.left = searchIcon.right + 8;
    field.top = 0;
    field.width = fieldView.width - field.left;
    field.height = fieldView.height;
    field.placeholder = @"搜索附近位置";
    field.font = Font(14);
    [fieldView addSubview:field];
    
    self.tableView.top = searchView.bottom;
    self.tableView.height = kScreenHeight - self.tableView.top;
    self.tableView.width = kScreenWidth;
    self.tableView.left = 0;
    [self.tableView reloadData];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    
    [self.search AMapPOIAroundSearch:request];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    FFLog(@"123");
}

- (void)searchBtnClick {
    if (self.field.text.length == 0) {
        return;
    }
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = self.field.text;
    tips.city     = @"北京";
    tips.cityLimit = YES; //是否限制城市
    [self.search AMapInputTipsSearch:tips];
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (response.count == 0) {
        return;
    }
    [self.tipArray setArray:response.tips];
    [self.tableView reloadData];
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"123");
//    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tipArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFLocationCell"];
    AMapTip *tip = self.tipArray[indexPath.row];
    cell.titleLabel.text = tip.name;
    cell.detailTextLabel.text = tip.address;
    cell.titleLabel.size = CGSizeMake(kScreenWidth - 32, 15);
    cell.titleLabel.left = 16;
    cell.bottom = 26;
    cell.subtitleLabel.frame = cell.titleLabel.frame;
    cell.subtitleLabel.top = cell.titleLabel.bottom;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectAddress) {
        AMapTip *tip = self.tipArray[indexPath.row];
        NSString *name = tip.address;
        self.selectAddress(@{@"name" : name});
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

