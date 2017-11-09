//
//  SystemMessageViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/6.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "MessageViewController.h"
#import "AnnouncementViewController.h"

@interface SystemMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *noUseTableView;

@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"系统消息";
    self.rightBtn.hidden= YES;
    [self.view addSubview:self.noUseTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 2 ? 10 : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = [NSString stringWithFormat:@"%ld", indexPath.row];
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
    if (indexPath.section < 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *str;
        switch (indexPath.section) {
            case 0:{
                str = @"缘分圈消息";
            }
                break;
            case 1:{
                str = @"平台公告";
            }
                break;
            default:
                break;
        }
        cell.textLabel.text = str;
    }else {
        cell.textLabel.text = @"潇潇拒绝了你的诚意金";
        cell.detailTextLabel.font = Font(12);
        cell.detailTextLabel.textColor = UIColorFromHex(0x999999);
        cell.detailTextLabel.text = @"10：30";
    }
   
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        MessageViewController *vc = [[MessageViewController alloc] init];
        vc.type = PredestinationMessage;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        MessageViewController *vc = [[MessageViewController alloc] init];
        vc.type = NormalMessage;
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


@end
