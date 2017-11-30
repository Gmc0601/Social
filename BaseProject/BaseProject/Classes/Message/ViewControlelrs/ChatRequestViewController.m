//
//  ChatRequestViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ChatRequestViewController.h"
#import "ChatInfoTableViewCell.h"
#import "ChatRequestModel.h"

@interface ChatRequestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) NSMutableArray *dataArr;

@end

@implementation ChatRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"聊天请求";
    self.rightBtn.hidden= YES;
    [self createData];
    [self.view addSubview:self.noUseTableView];
}


- (void)createData {
    [HttpRequest postPath:@"_chat_request_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            
            NSArray *infoArr = datadic[@"info"];
            NULLReturn(infoArr)
            for (NSDictionary *dic in infoArr) {
                ChatRequestModel *model = [[ChatRequestModel alloc] init];
                model.avatar_url = dic[@"avatar_url"];
                model.nickname = dic[@"nickname"];
                model.request_id = dic[@"request_id"];
                model.request_time = dic[@"request_time"];
                [self.dataArr addObject:model];
            }
            [self.noUseTableView reloadData];
            
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%ld", indexPath.row];
    ChatInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if  (!cell){
        NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed :@"ChatInfoTableViewCell" owner :nil options :nil ];
        cell = [  nibs lastObject ];
    }
    ChatRequestModel *model = [[ChatRequestModel alloc] init];
    model = self.dataArr[indexPath.row];
    
    [cell updateChatRequest:model];
    
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
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

@end
