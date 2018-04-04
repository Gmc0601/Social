//
//  GroupListViewController.m
//  BaseProject
//
//  Created by cc on 2018/2/5.
//  Copyright © 2018年 cc. All rights reserved.
//   群聊
//

#import "GroupListViewController.h"
#import "DiySearchBar.h"
#import <YYKit.h>
#import "AddGroupMemberViewController.h"

@interface GroupListViewController ()<UITableViewDelegate, UITableViewDataSource, EMGroupManagerDelegate>

@property (nonatomic, retain) UITableView *noUseTableView;

@property (nonatomic, strong) DiySearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = @"群聊";
    [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"ic_wgz"] forState:UIControlStateNormal];
    [self.view addSubview:self.noUseTableView];
    [self adddate];
}

- (void)adddate {
    // Registered as SDK delegate
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataSource) name:@"reloadGroupList" object:nil];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}
#pragma mark - EMGroupManagerDelegate

- (void)didUpdateGroupList:(NSArray *)groupList
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:groupList];
    [self.noUseTableView reloadData];
}
- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    
    NSArray *rooms = [[EMClient sharedClient].groupManager getJoinedGroups];
    [self.dataSource addObjectsFromArray:rooms];
    
    [self.noUseTableView reloadData];
}

- (void)moreClick {
    AddGroupMemberViewController *vc = [[AddGroupMemberViewController alloc] init];
    vc.titleStr = @"创建群聊";
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%lu", indexPath.row];
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    NSString *imageName = @"img_qltx_b";
    //        NSString *imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
    cell.imageView.image = [UIImage imageNamed:imageName];
    if (group.subject && group.subject.length > 0) {
        cell.textLabel.text = group.subject;
    }
    else {
        cell.textLabel.text = group.groupId;
    }

    
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeigh(75);
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //  进入群聊
    EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    [ConfigModel jumpgroupChatViewController:self withGroupId:group.groupId];
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeigh(45))];
            view.backgroundColor = [UIColor whiteColor];
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

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
