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
#import "ContactsViewController.h"
#import "ChatRequestViewController.h"
#import "ChatInfoTableViewCell.h"

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 2 ? 10 : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%lu%lu", indexPath.section, indexPath.row];
    
    if (indexPath.section < 2) {
        UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        switch (indexPath.section) {
            case 0:{
                cell.textLabel.text = @"好友通讯录";
            }
                break;
            case 1:{
                cell.textLabel.text = @"聊天请求";
            }
                break;
                
            default:
                break;
        }
        return cell;
    }else {
        ChatInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if  (!cell){
            NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed :@"ChatInfoTableViewCell" owner :nil options :nil ];
            cell = [  nibs lastObject ];
        }
        return cell;
    }
    
    
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 2 ? 70 : 48;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        ContactsViewController *vc = [[ContactsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 1) {
        ChatRequestViewController *vc = [[ChatRequestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64- SizeHeigh(50)) style:UITableViewStyleGrouped];
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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



@end
