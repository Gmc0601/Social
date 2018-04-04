//
//  ContactsViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsModel.h"
#import "ChatRequestModel.h"
#import "ChatRequestViewController.h"
#import "GroupListViewController.h"

@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource>{
    int questCount;
    int unreadCount;
}

@property (nonatomic, retain) UITableView *noUseTableView;

@property (nonatomic, retain) NSMutableArray *dataArr;

@property (nonatomic, retain) UILabel *lab;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"通讯录";
    self.rightBtn.hidden= YES;
    [self createData];
    [self.view addSubview:self.noUseTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)createData {
    
    
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
                [self.dataArr addObject:model];
            }
            [self.noUseTableView reloadData];
    
            
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
    [HttpRequest postPath:@"_chat_request_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            
            NSArray *infoArr = datadic[@"info"];
            NULLReturn(infoArr)
            NSMutableArray *newArr = [NSMutableArray new];
            for (NSDictionary *dic in infoArr) {
                ChatRequestModel *model = [[ChatRequestModel alloc] init];
                model.avatar_url = dic[@"avatar_url"];
                model.nickname = dic[@"nickname"];
                model.request_id = dic[@"request_id"];
                model.request_time = dic[@"request_time"];
                [newArr addObject:model];
            }
            questCount = (int)newArr.count;
            
            [self.noUseTableView reloadData];
            
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
        
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section > 1 ? self.dataArr.count : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    if (indexPath.section < 2) {
        UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        switch (indexPath.section) {
            case 0:{
                cell.textLabel.text = @"群聊";
                 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 1:{
                cell.textLabel.text = @"聊天请求";
                [cell.contentView addSubview:self.lab];
                if (questCount <= 0) {
                    self.lab.hidden = YES;
                }else if(questCount > 99){
                    self.lab.hidden = NO;
                    self.lab.text = [NSString stringWithFormat:@"9+"];
                }else {
                    self.lab.hidden = NO;
                    self.lab.text = [NSString stringWithFormat:@"%d", questCount];
                }
                
            }
                break;
                
            default:
                break;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else {
        UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellID];
        UIImageView *head ;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            head = [[UIImageView alloc] initWithFrame:FRAME(15, 7.5, SizeHeigh(50), SizeHeigh(50))];
            head.backgroundColor = [UIColor clearColor];
            head.image = [UIImage imageNamed:@"bg_tj_tx"];
            head.layer.masksToBounds= YES;
            head.layer.cornerRadius = 25;
            [cell.contentView addSubview:head];
            cell.imageView.backgroundColor = [UIColor clearColor];
            cell.imageView.image = [UIImage imageNamed:@"bg_tj_tx"];
            cell.imageView.hidden =YES;
        }
        if (self.dataArr.count > 0) {
            ContactsModel *model = self.dataArr[indexPath.row];
            [head sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"bg_tj_tx"]];
            if (IsNULL(model.nickname)) {
                [ConfigModel mbProgressHUD:@"nickname -->  null" andView:nil];
            }else {
              cell.textLabel.text = model.nickname;
            }
            
        }
        return cell;
    }
    
   
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeigh(65);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section ) {
        case 0:{
            //  群聊
            GroupListViewController *vc = [[GroupListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            //  聊天请求
            if (indexPath.section == 1) {
                ChatRequestViewController *vc = [[ChatRequestViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 2:{
            //   联系人界面 跳转到聊天界面
            ContactsModel *model = [[ContactsModel alloc] init];
            model = self.dataArr[indexPath.row];
            [ConfigModel jumptoChatViewController:self withId:model.mobile];
        }
            break;
            
        default:
            break;
    }
    
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStyleGrouped];
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.01)];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeigh(0))];
            view;
        });
    }
    return _noUseTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

- (UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc] initWithFrame:FRAME(kScreenW - 40, 12, 30, 20)];
        _lab.layer.masksToBounds = YES;
        _lab.layer.cornerRadius = 10;
        _lab.backgroundColor = [UIColor redColor];
        _lab.textColor = [UIColor whiteColor];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.font = NormalFont(10);
    }
    return _lab;
}

@end
