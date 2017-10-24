//
//  XFCircleCommentViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleCommentViewController.h"
#import "XFCircleCommentCell.h"
#import "XFCircleCommentCellModel.h"

@interface XFCircleCommentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation XFCircleCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (CGFloat)scrollOffset {
    return _tableView.contentOffset.y;
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - XFNavHeight - XFCircleTabHeight - XFCircleDetailBottomHeight);
    self.tableView.mj_header = [XFRefreshTool xf_header:self action:@selector(loadData)];
    self.tableView.mj_footer = [XFRefreshTool xf_footer:self action:@selector(loadMoreData)];
    self.currentPage = 1;
    self.dataArray = [NSMutableArray array];
}

- (void)loadData {
    WeakSelf
    self.currentPage = 1;
    [HttpRequest postPath:XFCircleCommentListUrl
                   params:@{@"page" : [NSString stringWithFormat:@"%zd", self.currentPage],
                            @"size" : XFDefaultPageSize,
                            @"id"   : self.circleId}
              resultBlock:^(id responseObject, NSError *error) {
                  [weakSelf.tableView.mj_header endRefreshing];
                  weakSelf.dataArray = [NSMutableArray array];
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          weakSelf.currentPage ++;
                          NSArray *infoArray = responseObject[@"info"];
                          if ([infoArray isKindOfClass:[NSArray class]]) {
                              for (int i = 0 ; i < infoArray.count; i++) {
                                  NSDictionary *dict = infoArray[i];
                                  XFCircleCommentCellModel *model = [[XFCircleCommentCellModel alloc] initWithComment:[CircleComment mj_objectWithKeyValues:dict]];
                                  [weakSelf.dataArray addObject:model];
                              }
                              if (infoArray.count < 10) {
                                  [self.tableView.mj_footer endRefreshingWithNoMoreData];
                              } else {
                                  [self.tableView.mj_footer endRefreshing];
                              }
                          } else {
                              [self.tableView.mj_footer endRefreshingWithNoMoreData];
                          }
                          [self.tableView reloadData];
                      }
                  }
              }];
}

- (void)loadMoreData {
    WeakSelf
    [HttpRequest postPath:XFCircleCommentListUrl
                   params:@{@"page" : [NSString stringWithFormat:@"%zd", self.currentPage],
                            @"size" : XFDefaultPageSize,
                            @"id"   : self.circleId}
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          weakSelf.currentPage ++;
                          NSArray *infoArray = responseObject[@"info"];
                          if ([infoArray isKindOfClass:[NSArray class]]) {
                              for (int i = 0 ; i < infoArray.count; i++) {
                                  NSDictionary *dict = infoArray[i];
                                  XFCircleCommentCellModel *model = [[XFCircleCommentCellModel alloc] initWithComment:[CircleComment mj_objectWithKeyValues:dict]];
                                  [weakSelf.dataArray addObject:model];
                              }
                              if (infoArray.count < 10) {
                                  [self.tableView.mj_footer endRefreshingWithNoMoreData];
                              } else {
                                  [self.tableView.mj_footer endRefreshing];
                              }
                          } else {
                              [self.tableView.mj_footer endRefreshingWithNoMoreData];
                          }
                          [self.tableView reloadData];
                      }
                  }
              }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFCircleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCircleCommentCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFCircleCommentCellModel *model = self.dataArray[indexPath.row];
    return model.cellH;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = WhiteColor;
        [_tableView registerClass:[XFCircleCommentCell class] forCellReuseIdentifier:@"XFCircleCommentCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end

