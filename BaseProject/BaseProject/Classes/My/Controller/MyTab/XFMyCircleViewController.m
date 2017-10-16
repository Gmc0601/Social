//
//  XFMyCircleViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/27.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFMyCircleViewController.h"
#import "XFCircleContentCellModel.h"
#import "XFFriendCircleCell.h"
#import "XFCircleDetailViewController.h"

@interface XFMyCircleViewController ()<UITableViewDataSource, UITableViewDelegate, XFFriendCircleCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation XFMyCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (CGFloat)scrollOffset {
    return _tableView.contentOffset.y;
}

- (void)setupUI {
    self.view.backgroundColor = RandomColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - XFCircleTabHeight - XFNavHeight);
    [self loadData];
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFMyCircleUrl
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  weakSelf.dataArray = [NSMutableArray array];
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSArray *infoArray = responseObject[@"info"];
                          for (int i = 0 ; i < infoArray.count; i++) {
                              NSDictionary *dict = infoArray[i];
                              Circle *circle = [Circle mj_objectWithKeyValues:dict];
                              circle.isMine = YES;
                              XFCircleContentCellModel *model = [[XFCircleContentCellModel alloc] initWithCircle:circle andType:CircleContentModelType_My];
                              [weakSelf.dataArray addObject:model];
                          }
                          [self.tableView reloadData];
                      }
                  }
              }];
}

#pragma mark ----------<UITableViewDataSource>----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFFriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFFriendCircleCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark ----------<UITableViewDelegate>----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFCircleContentCellModel *model = self.dataArray[indexPath.row];
    return model.cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XFCircleContentCellModel *model = self.dataArray[indexPath.row];
    if (model.circle.id) {
        XFCircleDetailViewController *controller = [[XFCircleDetailViewController alloc] init];
        controller.circleId = model.circle.id;
        [self pushController:controller];
    }
}

#pragma mark ----------<XFFriendCircleCellDelegate>----------
- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickRewardBtn:(XFCircleContentCellModel *)model {
    FFLogFunc
}

- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickShareBtn:(XFCircleContentCellModel *)model {
    FFLogFunc
}

- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickZanBtn:(XFCircleContentCellModel *)model {
    FFLogFunc
}

- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickCommentBtn:(XFCircleContentCellModel *)model {
    FFLogFunc
}

- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickDeleteBtn:(XFCircleContentCellModel *)model {
    FFLogFunc
}

#pragma mark ----------Lazy----------
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = WhiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[XFFriendCircleCell class] forCellReuseIdentifier:@"XFFriendCircleCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
