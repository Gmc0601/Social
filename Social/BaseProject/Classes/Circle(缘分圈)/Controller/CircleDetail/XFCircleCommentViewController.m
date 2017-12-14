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
#import "XFFriendHomeViewController.h"

@interface XFCircleCommentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation XFCircleCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (CGFloat)scrollOffset {
    return _tableView.contentOffset.y;
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - XFNavHeight - XFCircleTabHeight - XFCircleDetailBottomHeight);
    [self.tableView reloadData];
}

- (void)reloadTheData {
    [self.tableView reloadData];
}

- (void)setCommentArray:(NSArray *)commentArray {
    _commentArray = commentArray;
    self.dataArray = [NSMutableArray array];
    for (int i = 0; i < commentArray.count; i++) {
        XFCircleCommentCellModel *model = [[XFCircleCommentCellModel alloc] initWithComment:commentArray[i]];
        [self.dataArray addObject:model];
    }
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
    cell.nameLabelTap = ^{
        XFCircleCommentCellModel *model = self.dataArray[indexPath.row];
        XFFriendHomeViewController *controller = [[XFFriendHomeViewController alloc] init];
        controller.friendId = model.comment.user_id;;
        [self pushController:controller];
    };
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

