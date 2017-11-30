//
//  XFTradeRecordViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFTradeRecordViewController.h"
#import "XFTradeRecordCell.h"

@interface XFTradeRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation XFTradeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_navView:@"交易记录"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    self.tableView.frame = CGRectMake(0, navView.bottom, kScreenWidth, kScreenHeight - XFNavHeight);
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFMyTradeRecordUrl
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  weakSelf.dataArray = [NSMutableArray array];
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSArray *array = responseObject[@"info"];
                          [weakSelf.dataArray addObjectsFromArray:[TradeRecord mj_objectArrayWithKeyValuesArray:array]];
                      }
                      [weakSelf.tableView reloadData];
                  }
              }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count ? 2 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaddingCell" forIndexPath:indexPath];
        cell.backgroundColor = PaddingColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        XFTradeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFTradeRecordCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupContent];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 5;
    } else {
        return [XFTradeRecordCell cellHeight];
    }
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = WhiteColor;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PaddingCell"];
        [_tableView registerClass:[XFTradeRecordCell class] forCellReuseIdentifier:@"XFTradeRecordCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end

