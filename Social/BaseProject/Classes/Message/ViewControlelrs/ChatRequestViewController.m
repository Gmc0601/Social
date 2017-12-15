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
#import "XFPrepareChatView.h"


@interface ChatRequestViewController ()<UITableViewDelegate, UITableViewDataSource, XFPrepareChatViewDelegate>

@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, retain) NSIndexPath *indexpath;

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
    
    [self.dataArr removeAllObjects];
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
    self.indexpath = indexPath;
    ChatRequestModel *model = [[ChatRequestModel alloc] init];
    model = self.dataArr[indexPath.row];
    NSDictionary *dic = @{
                          @"request_id" : model.request_id
                          };
    
    [HttpRequest postPath:@"_check_request_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            NSDictionary *dic = datadic[@"info"];
            NSString *str = [NSString stringWithFormat:@"%@", dic[@"suggest_earnest"]];
            NSString *moeny = [NSString stringWithFormat:@"%@", dic[@"earnest"]];
            self.money = str;
            XFPrepareChatView *view = [[XFPrepareChatView alloc] initRequestWithSource:str andMoney:moeny];
            view.delegate = self;
            [self.view addSubview:view];
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
//    [HttpRequest postPath:XFFriendSuggestMoneyUrl
//                   params:@{@"id" : self.friendId}
//              resultBlock:^(id responseObject, NSError *error) {
//                  if (!error) {
//                      NSNumber *errorCode = responseObject[@"error"];
//                      if (errorCode.integerValue == 0) {
//                          NSDictionary *infoDict = responseObject[@"info"];
//                          if ([infoDict isKindOfClass:[NSDictionary class]] && infoDict.allKeys.count) {
//                              [self.view removeGestureRecognizer:self.up];
//                              [self.view removeGestureRecognizer:self.down];
//                              XFPrepareChatView *view = [[XFPrepareChatView alloc] initWithScore:infoDict[@"suggest_earnest"]];
//                              view.delegate = self;
//                              [self.view addSubview:view];
//                          }
//                      }
//                  }
//              }];
    
}

#pragma mark ----------<XFPrepareChatViewDelegate>----------
- (void)prepareChatViewClickCancelBtn:(XFPrepareChatView *)view {
    //  拒绝
//    [self.view addGestureRecognizer:self.up];
//    [self.view addGestureRecognizer:self.down];
    ChatRequestModel *model = [[ChatRequestModel alloc] init];
    model = self.dataArr[self.indexpath.row];
    WeakSelf
    NSDictionary *dic = @{
                          @"request_id" : model.request_id,
                          @"draw" : self.money,
                          };
    [HttpRequest postPath:@"_jueju_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            [ConfigModel mbProgressHUD:@"您已拒绝" andView:nil];
            [weakSelf createData];
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}

- (void)showinfo:(XFPrepareChatView *)view {
    NSLog(@"查看资料");
    
}

- (void)prepareChatView:(XFPrepareChatView *)view clickConfirmBtn:(NSString *)text {
    //  接受
//    [self.view addGestureRecognizer:self.up];
//    [self.view addGestureRecognizer:self.down];
//    FFLog(@"输入的诚意金：%@", text);
    ChatRequestModel *model = [[ChatRequestModel alloc] init];
    model = self.dataArr[self.indexpath.row];
    NSDictionary *dic = @{
                          @"request_id" : model.request_id,
                          @"draw" : self.money,
                          @"earnest" : text
                          };
    [HttpRequest postPath:@"_chitchat_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        
        
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            NSDictionary *dict = @{
                                   @"request_id" : model.request_id
                                   };
            
            [HttpRequest postPath:@"_check_request_001" params:dict resultBlock:^(id responseObject, NSError *error) {
                if([error isEqual:[NSNull null]] || error == nil){
                    NSLog(@"success");
                }
                NSDictionary *datadic = responseObject;
                if ([datadic[@"error"] intValue] == 0) {
                    NSDictionary *info =datadic[@"info"];
                    NSString *mobile = info[@"request_mobile"];
                    [ConfigModel jumptoChatViewController:self withId:mobile];
                    
                }else {
                    NSString *str = datadic[@"info"];
                    [ConfigModel mbProgressHUD:str andView:nil];
                }
            }];
            
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
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
