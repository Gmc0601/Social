//
//  XFCircleRewardViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleRewardViewController.h"
#import "XFFriendHomeViewController.h"
#import "XFOriginTableViewCell.h"



@interface XFCircleRewardViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation XFCircleRewardViewController

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rewardArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFOriginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFOriginTableViewCell" forIndexPath:indexPath];
    
    User *user = self.rewardArray[indexPath.row];
    [cell becomeValue:user];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XFFriendHomeViewController *controller = [[XFFriendHomeViewController alloc] init];
    User *user = self.rewardArray[indexPath.row];
    controller.friendId = user.user_id;;
    [self pushController:controller];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = WhiteColor;

        [_tableView registerNib:[UINib nibWithNibName:@"XFOriginTableViewCell" bundle:nil] forCellReuseIdentifier:@"XFOriginTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end

