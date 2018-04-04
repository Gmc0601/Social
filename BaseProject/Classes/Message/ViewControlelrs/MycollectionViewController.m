//
//  MycollectionViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/12.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MycollectionViewController.h"

@interface MycollectionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,  strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UITableView *noUseTableView;

@end

@implementation MycollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"选择收藏";
    [self setUI];
    [self getData];
}

- (void)setUI {
    [self.view addSubview:self.noUseTableView];
}

- (void)getData {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = [tableView rectForRowAtIndexPath:indexPath].size.height;
    static NSString *cellIdentifyWithRowOne = @"cellIdentifyWithRowOne";
    return nil;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeigh(105);
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//       选中消息 回调 发送消息
    
    
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64- SizeHeigh(50)) style:UITableViewStylePlain];
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



@end
