//
//  MessageViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MessageViewController.h"
#import "AnnouncementViewController.h"

@interface MessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *noUseTableView;

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
}

- (void)moreClick {
    if (self.type == NormalMessage) {
        
    }else {
        
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"%ld", indexPath.row];
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        
    }
    
    cell.textLabel.text = @"潇潇拒绝了你的消息";
    cell.detailTextLabel.textColor = UIColorFromHex(0x999999);
    cell.detailTextLabel.font = Font(12);
    cell.detailTextLabel.text = @"10:30";
    return cell;
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == NormalMessage) {
        AnnouncementViewController *vc = [[AnnouncementViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (self.type == PredestinationMessage) {
        //  缘分圈
        
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

@end
