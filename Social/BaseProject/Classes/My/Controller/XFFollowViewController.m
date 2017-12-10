//
//  XFFollowViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/19.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFFollowViewController.h"
#import "XFMyFollowUserCell.h"
#import "XFFriendHomeViewController.h"

@interface XFFollowViewController ()<UITableViewDelegate, UITableViewDataSource, XFMyFollowUserCellDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) User *followUser;

@end

@implementation XFFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
    [self setupNotification];
}

- (void)setupUI {
    self.view.backgroundColor = WhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSString *title = @"我关注的";
    if (self.followType == FollowType_Fans) {
        title = @"关注我的";
    } else if (self.followType == FollowType_Friends) {
        title = @"互为关注";
    }
    UIView *navView = [UIView xf_navView:title
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, navView.bottom, kScreenWidth, 5);
    [self.view addSubview:paddingView];
    
    [self.tableView reloadData];
}

- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:@"ThisFollowSuccess"
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadData {
    WeakSelf
    NSString *url = @"";
    if (self.followType == FollowType_Follow) {
        url = XFMyFollowUrl;
    } else if (self.followType == FollowType_Fans) {
        url = XFMyFansUrl;
    } else if (self.followType == FollowType_Friends) {
        url = XFMyFriendsUrl;
    }
    [HttpRequest postPath:url
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  weakSelf.dataArray = [NSMutableArray array];
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSArray *array = responseObject[@"info"];
                          [weakSelf.dataArray addObjectsFromArray:[User mj_objectArrayWithKeyValuesArray:array]];
                      }
                      [weakSelf.tableView reloadData];
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
    XFMyFollowUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFMyFollowUserCell" forIndexPath:indexPath];
    cell.backgroundColor = WhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.type = (MyFollowUserType)self.followType;
    cell.user = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XFMyFollowUserCell cellHeight];
}

#pragma mark ----------<XFMyFollowUserCellDelegate>----------
- (void)myFollowUserCell:(XFMyFollowUserCell *)cell didClickUserBtn:(User *)user {
    XFFriendHomeViewController *controller = [[XFFriendHomeViewController alloc] init];
    controller.friendId = user.id;
    [self pushController:controller];
}

- (void)myFollowUserCell:(XFMyFollowUserCell *)cell didClickFollowBtn:(User *)user {
    if (self.followType == FollowType_Fans) {
        [HttpRequest postPath:XFFriendFollowUrl
                       params:@{@"id" : user.id,
                                @"type" : @"2"}
                  resultBlock:^(id responseObject, NSError *error) {
                      if (!error) {
                          NSNumber *errorCode = responseObject[@"error"];
                          if (errorCode.integerValue == 0){
                              NSDictionary *infoDict = responseObject[@"info"];
                              [ConfigModel mbProgressHUD:infoDict[@"message"] andView:nil];
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"ThisFollowSuccess" object:nil];
                          }
                      }
                  }];
    } else {
        self.followUser = user;
        [[[UIAlertView alloc] initWithTitle:@"确认取消关注吗"
                                    message:nil
                                   delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"确定", nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [HttpRequest postPath:XFFriendFollowUrl
                       params:@{@"id" : self.followUser.id,
                                @"type" : @"1"}
                  resultBlock:^(id responseObject, NSError *error) {
                      if (!error) {
                          NSNumber *errorCode = responseObject[@"error"];
                          if (errorCode.integerValue == 0){
                              NSDictionary *infoDict = responseObject[@"info"];
                              [ConfigModel mbProgressHUD:infoDict[@"message"] andView:nil];
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"ThisFollowSuccess" object:nil];
                          }
                      }
                  }];
    }
}


#pragma mark ----------Lazy----------
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XFNavHeight + 5, kScreenWidth, kScreenHeight - XFNavHeight - 5)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[XFMyFollowUserCell class] forCellReuseIdentifier:@"XFMyFollowUserCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PaddingCell"];
        _tableView.backgroundColor = WhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end

