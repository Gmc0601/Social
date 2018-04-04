//
//  AddGroupMemberViewController.m
//  BaseProject
//
//  Created by cc on 2018/2/26.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "AddGroupMemberViewController.h"
#import "DiySearchBar.h"
#import "AddGroupMemberTableViewCell.h"
#import "ContactsModel.h"

@interface AddGroupMemberViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *noUseTableView;

@property (nonatomic, strong) DiySearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *dateSource, *addArr;

@end

@implementation AddGroupMemberViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = self.titleStr;
    [self.rightBar setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:self.noUseTableView];
    [self createDate];
}

- (void)createDate {
    [HttpRequest postPath:@"_friend_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            NSArray *infoArr = datadic[@"info"];
            NULLReturn(infoArr)
            for (NSDictionary *dic in infoArr) {
                ContactsModel *model = [[ContactsModel alloc] init];
                model.id = dic[@"id"];
                model.avatar_url = dic[@"avatar_url"];
                model.mobile = dic[@"mobile"];
                model.nickname = dic[@"nickname"];
                [self.dateSource addObject:model];
            }
            [self.noUseTableView reloadData];
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}

- (void)more:(UIButton *)sender {
    //    添加群聊
    EMError *error = nil;
    EMGroupOptions *setting = [[EMGroupOptions alloc] init];
    setting.maxUsersCount = 500;
//    setting.IsInviteNeedConfirm​ = NO; //邀请群成员时，是否需要发送邀请通知.若NO，被邀请的人自动加入群组
    setting.style = EMGroupStylePublicOpenJoin;// 创建不同类型的群组，这里需要才传入不同的类型
    EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:@"群组名称" description:@"" invitees:@[@"6001",@"6002"] message:@"邀请您加入群组" setting:setting error:&error];
    if(!error){
        NSLog(@"创建成功 -- %@",group);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dateSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%lu", (long)indexPath.row];
    AddGroupMemberTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AddGroupMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    ContactsModel *model = self.dateSource[indexPath.row];
    [cell update:model];
    
    cell.clickBlock = ^(BOOL click) {
        NSString *chatId = model.id;
        NSLog(@">>>>chatId<<<<<<<%@", chatId);
        NSLog(@"%lu",(long)indexPath.row);
    };
    
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeigh(65);
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //  进入群聊
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeigh(45))];
            view.backgroundColor = RGB(239, 240, 241);
            [view addSubview:self.searchBar];
            
            UIButton *sarchBtn = [[UIButton alloc] initWithFrame:FRAME(self.searchBar.right + SizeWidth(5), SizeHeigh(10), SizeWidth(45), SizeHeigh(25))];
            sarchBtn.backgroundColor = [UIColor lightGrayColor];
            [sarchBtn setTitle:@"搜索" forState:UIControlStateNormal];
            sarchBtn.layer.masksToBounds = YES;
            [sarchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
            sarchBtn.layer.cornerRadius = 3;
            sarchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [view addSubview:sarchBtn];
            
            UILabel *line = [[UILabel alloc] initWithFrame:FRAME(0, SizeHeigh(45) - 1, kScreenW, 1)];
            line.backgroundColor = RGB(239, 240, 241);
            [view addSubview:line];
            
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeigh(0))];
            
            view;
        });
    }
    return _noUseTableView;
}


- (void)searchClick:(UIButton *)sender {
    NSLog(@"%@", self.searchBar.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[DiySearchBar alloc] initWithFrame:FRAME(SizeWidth(10), SizeHeigh(10), SizeWidth(300), SizeHeigh(25))];
        _searchBar.layer.masksToBounds = YES;
        _searchBar.layer.cornerRadius =  5;
        _searchBar.layer.borderWidth = 1;
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.layer.borderColor = [RGB(239, 240, 241) CGColor];
        _searchBar.placeholder = @"搜索";
        
    }
    return _searchBar;
}


- (NSMutableArray *)dateSource {
    if (!_dateSource) {
        _dateSource = [[NSMutableArray alloc] init];
    }
    return _dateSource;
}

- (NSMutableArray *)addArr {
    if (!_addArr) {
        _addArr = [[NSMutableArray alloc] init];
    }
    return _addArr;
}

@end
