//
//  ShouCangViewController.m
//  BaseProject
//
//  Created by 霍锐 on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ShouCangViewController.h"
#import "ShouCangTextTableViewCell.h"
#import "ShouCangAlert.h"
#import "ShouCangImgTableViewCell.h"
#import "YHPhotoBrowser.h"


@interface ShouCangViewController ()
/// 列表
@property(nonatomic,strong) UITableView* tbSimple;
@property(nonatomic,strong) NSMutableArray* allData;
@end

@implementation ShouCangViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - 初始化界面
- (void)initWithUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    [self initWithTableView];
}

- (NSMutableArray *)allData {
    if (!_allData) {
        _allData = [NSMutableArray array];
    }
    return _allData;
}

#pragma mark - 创建并初始化TableView
- (void)initWithTableView {
    UIView *navView = [UIView xf_navView:@"收藏"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];

    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, navView.bottom, kScreenWidth, 5);
    [self.view addSubview:paddingView];
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tb.frame = CGRectMake(0,
                          paddingView.bottom,
                          kScreenWidth,
                          kScreenHeight - paddingView.bottom);
    tb.hidden = NO;
    tb.delegate = self;
    tb.dataSource = self;
    tb.estimatedRowHeight = 44;
    tb.backgroundColor = [UIColor clearColor];
    [tb setShowsVerticalScrollIndicator:NO];
    [tb setShowsHorizontalScrollIndicator:NO];
    tb.tableFooterView = [UIView new];
    tb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tb];
    self.tbSimple = tb;

    [self.tbSimple registerClass:[ShouCangTextTableViewCell class] forCellReuseIdentifier:@"ShouCangTextTableViewCell"];
    [self.tbSimple registerClass:[ShouCangImgTableViewCell class] forCellReuseIdentifier:@"ShouCangImgTableViewCell"];


}

#pragma mark - 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
#pragma mark - 列数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allData.count;
//    return 3;
}

#pragma mark - cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary* dicValue = self.allData[indexPath.row];
    NSString* img = dicValue[@"img"];
    NSString* dataID = dicValue[@"id"];
    NSString* content = [dicValue[@"content"] isKindOfClass:[NSNumber class]] ? [dicValue[@"content"] stringValue]: dicValue[@"content"];
    if (IsNULL(content)) {
        content = @"";
    }
    NSString* create_time = dicValue[@"create_time"];

    if (!IsNULL(img) &&( [img hasSuffix:@".jpg"] || [img hasSuffix:@".png"])) {

        static NSString *cellID = @"ShouCangImgTableViewCell";
        ShouCangImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        __weak typeof(self) selfWeak = self;
        [cell cellFunctionIMGText:img
                          andTime:create_time];
        
        
        return cell;
    } else {

        static NSString *cellID = @"ShouCangTextTableViewCell";
        ShouCangTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        __weak typeof(self) selfWeak = self;
        [cell cellFunctionText:content andTime:create_time andBlock:^{
            NSLog(@"删除2");
            ShouCangAlert * alert = [[ShouCangAlert alloc]init];
            [alert function_ShowLeftBtnValue:@"取消" andRightBtnValue:@"确定" andBlock:^(int numValue) {
                if (numValue == 1) {
                    [selfWeak delData:dataID];
                }
            }];

        }];

        return cell;
    }




}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dicValue = self.allData[indexPath.row];
    NSString* img = dicValue[@"img"];
    if (!IsNULL(img) &&( [img hasSuffix:@".jpg"] || [img hasSuffix:@".png"])) {
        NSArray *srcStringArray = @[img ];

        YHPhotoBrowser *photoView = [[YHPhotoBrowser alloc]init];
        photoView.urlImgArr = srcStringArray;
        photoView.sourceRect = CGRectZero;
        photoView.indexTag = 0;
        [photoView show];

    }
}
#pragma mark - 优化分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark - cell下边Foot高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
#pragma mark - cell上边head高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - 获取数据
- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFApplyCollectlist
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  if([error isEqual:[NSNull null]] || error == nil){
                      NSLog(@"success");
                  }
                  NSDictionary *datadic = responseObject;
                  if ([datadic[@"error"] intValue] == 0) {
                      NSArray *info = datadic[@"info"];
                      NSLog(@"%@", info);
                      self.allData = [NSMutableArray arrayWithArray:info];
                      [self.tbSimple reloadData];

                  }else {
                      NSString *str = datadic[@"info"];
                      [ConfigModel mbProgressHUD:str andView:nil];
                  }
              }];
}

#pragma mark - 删除数据
- (void)delData: (NSString *)dataID {
    WeakSelf
    [HttpRequest postPath:XFApplyDeletecollect
                   params:@{@"id": dataID}
              resultBlock:^(id responseObject, NSError *error) {
                  if([error isEqual:[NSNull null]] || error == nil){
                      NSLog(@"success");
                  }
                  NSDictionary *datadic = responseObject;
                  NSString *str = datadic[@"info"];
                  [ConfigModel mbProgressHUD:str andView:nil];
              }];
}





@end
