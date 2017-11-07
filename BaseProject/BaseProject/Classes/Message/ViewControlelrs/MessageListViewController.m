//
//  MessageListViewController.m
//  BaseProject
//
//  Created by cc on 2017/9/20.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MessageListViewController.h"
#import "ChatViewController.h"
#import "LoginViewController.h"
#import "TBNavigationController.h"
#import "SystemMessageViewController.h"
@interface MessageListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (nonatomic, retain) UITableView *noUseTableView;

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"消息";
    [self.rightBtn setTitle:@"系统消息" forState:UIControlStateNormal];
}
- (IBAction)loginClick:(id)sender {
    TBNavigationController *na = [[TBNavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [self presentViewController:na animated:YES completion:nil];
}
- (void)moreClick {
    SystemMessageViewController *vc = [[SystemMessageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([ConfigModel getBoolObjectforKey:IsLogin]) {

        [self.view addSubview:self.noUseTableView];
    }else {
        [self.noUseTableView removeFromSuperview];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 2 ? 10 : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%lu%lu", indexPath.section, indexPath.row];
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.textLabel.text = @"hello";
    return cell;
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 2 ? 70 : 48;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64- SizeHeigh(50)) style:UITableViewStyleGrouped];
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

}



@end
