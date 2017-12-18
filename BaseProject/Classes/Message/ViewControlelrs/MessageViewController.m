//
//  MessageViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MessageViewController.h"
#import "AnnouncementViewController.h"
#import "MessageModel.h"
#import "XFCircleDetailViewController.h"

@interface MessageViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) NSMutableArray *dataArr;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == NormalMessage) {
        self.titleLab.text = @"消息";
    }else {
        self.titleLab.text = @"缘分圈消息";
    }
    [self.rightBtn setTitle:@"清空" forState:UIControlStateNormal];
    
    [self.view addSubview:self.noUseTableView];
    [self createData];
    
}

- (void)createData {
    NSString *url ;
    if (self.type == NormalMessage) {   //  xiaoxi
        url = @"_notice_001";
        /*
         id  公告ID
         has_read 1已读 2未读
         "title": "bnvcn",//平台公告内容
         "create_time": "2017-09-11 21:40:11"//平台公告时间
         */
        [HttpRequest postPath:url params:nil resultBlock:^(id responseObject, NSError *error) {
            if([error isEqual:[NSNull null]] || error == nil){
                NSLog(@"success");
            }
            NSDictionary *datadic = responseObject;
            if ([datadic[@"error"] intValue] == 0) {
                NSArray *infoArr = datadic[@"info"];
                 NULLReturn(infoArr)
                for (NSDictionary *dic in infoArr) {
                    MessageModel *model = [[MessageModel alloc] init];
                    model.id = dic[@"id"];
                    model.nickname = dic[@"title"];
                    model.title = dic[@"title"];
                    model.has_read = dic[@"has_read"];
                    [self.dataArr addObject:model];
                    NSLog(@"%lu", self.dataArr.count);
                     [self.noUseTableView reloadData];
                }
            }else {
                NSString *str = datadic[@"info"];
                [ConfigModel mbProgressHUD:str andView:nil];
            }
        }];
        
    }else {  //  缘分圈
        url = @"_lot_messages_001";
        /*
         "id"//缘分圈id
         "nickname": "\u6765\u6765\u6765\u8bc4\u8bba\u4f60\u7684\u670b\u53cb\u5708\u52a8\u6001",//昵称+评论你的缘分圈动态/赞你的缘分圈动态/打赏你缘分圈动态
         "create_time": "2017-09-19 15:46:06"//时间
         “has_read” 1已读 2未读
         */
        [HttpRequest postPath:url params:nil resultBlock:^(id responseObject, NSError *error) {
            if([error isEqual:[NSNull null]] || error == nil){
                NSLog(@"success");
            }
            NSDictionary *datadic = responseObject;
            if ([datadic[@"error"] intValue] == 0) {
                NSArray *infoArr = datadic[@"info"];
                 NULLReturn(infoArr)
                for (NSDictionary *dic in infoArr) {
                    MessageModel *model = [[MessageModel alloc] init];
                    model.id = dic[@"id"];
                    model.nickname = dic[@"title"];
                    model.create_time = dic[@"create_time"];
                    model.has_read = dic[@"has_read"];
                    [self.dataArr addObject:model];
                    NSLog(@"%lu", self.dataArr.count);
                     [self.noUseTableView reloadData];
                }
            }else {
                NSString *str = datadic[@"info"];
                [ConfigModel mbProgressHUD:str andView:nil];
            }
        }];
    }
    
}

- (void)moreClick {
    
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否清空所有消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (self.type == NormalMessage) {
            //   平台公告删除
            [HttpRequest postPath:@"_deletenotice_001" params:nil resultBlock:^(id responseObject, NSError *error) {
                if([error isEqual:[NSNull null]] || error == nil){
                    NSLog(@"success");
                }
                NSDictionary *datadic = responseObject;
                if ([datadic[@"error"] intValue] == 0) {
                    [ConfigModel mbProgressHUD:@"清空成功" andView:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    NSString *str = datadic[@"info"];
                    [ConfigModel mbProgressHUD:str andView:nil];
                }
            }];
            
        }else {
            [HttpRequest postPath:@"_delete_lotmessages_001" params:nil resultBlock:^(id responseObject, NSError *error) {
                if([error isEqual:[NSNull null]] || error == nil){
                    NSLog(@"success");
                }
                NSDictionary *datadic = responseObject;
                if ([datadic[@"error"] intValue] == 0) {
                    [ConfigModel mbProgressHUD:@"清空成功" andView:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    NSString *str = datadic[@"info"];
                    [ConfigModel mbProgressHUD:str andView:nil];
                }
            }];
        }
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"%ld", indexPath.row];
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        
    }
    NSString *title;
    MessageModel *model = [[MessageModel alloc] init];
    model = self.dataArr[indexPath.row];
//    if (self.type == NormalMessage) {
//        title = model.title;
//    }else {
        title = model.nickname;
//    }
    cell.textLabel.text = title;
    cell.detailTextLabel.textColor = UIColorFromHex(0x999999);
    cell.detailTextLabel.font = Font(12);
    cell.detailTextLabel.text = model.create_time;
    return cell;
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageModel *model = [[MessageModel alloc] init];
    model = self.dataArr[indexPath.row];
    if (self.type == NormalMessage) {
        AnnouncementViewController *vc = [[AnnouncementViewController alloc] init];
        vc.id = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (self.type == PredestinationMessage) {
        //  缘分圈
        MessageModel *model = [[MessageModel alloc] init];
        model = self.dataArr[indexPath.row];
        
        XFCircleDetailViewController *vc = [[XFCircleDetailViewController alloc] init];
        vc.circleId = [NSNumber numberWithString:model.id];
        vc.showComment = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
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
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

@end
