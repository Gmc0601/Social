//
//  XFAccountViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/19.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFAccountViewController.h"
#import "XFTradeRecordViewController.h"
#import "XFRechrgeViewController.h"
#import "XFGetMoneyViewController.h"
#import "MyAccountTableViewCell.h"

@interface XFAccountViewController ()
/// 列表
@property(nonatomic,strong) UITableView* tbSimple;
@property(nonatomic,strong) NSMutableArray* allData;
@end

@implementation XFAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.allData = [NSMutableArray array];
    [self loadData];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_navView:@"账户"
                              backTarget:self
                              backAction:@selector(backBtnClick)];

    UIButton *recordBtn = [UIButton xf_titleButtonWithTitle:@"交易记录"
                                                 titleColor:BlackColor
                                                  titleFont:Font(15)
                                                     target:self
                                                     action:@selector(recordBtnClick)];
    recordBtn.frame = CGRectMake(kScreenWidth - 85, 20, 85, 44);
    [navView addSubview:recordBtn];
    [self.view addSubview:navView];

    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, navView.bottom, kScreenWidth, 5);
    [self.view addSubview:paddingView];
    [self initWithTableView];


}

- (void)loadData {


    WeakSelf
    [HttpRequest postPath:XFMyAccountUrl
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  NSDictionary *info = responseObject[@"info"];
                  /*
                   chongzhi = 0;
                   shouru = 0;
                   zengsong = 0;
                   */
                  NSNumber *integral = info[@"chongzhi"];
                  if ([integral isKindOfClass:[NSNumber class]]) {
                      [self.allData appendObject:integral.stringValue];
                  } else if ([integral isKindOfClass:[NSString class]]) {
                      [self.allData appendObject:(NSString *)integral];
                  } else {
                      [self.allData appendObject:@"0"];
                  }

                  NSNumber *income = info[@"shouru"];
                  if ([income isKindOfClass:[NSNumber class]]) {
                      [self.allData appendObject:income.stringValue];
                  } else {
                      [self.allData appendObject:@"0"];
                  }

                  NSNumber *expend = info[@"zengsong"];
                  if ([income isKindOfClass:[NSNumber class]]) {
                      [self.allData appendObject:expend.stringValue];
                  } else {
                      [self.allData appendObject:@"0"];
                  }

                  [self.tbSimple reloadData];
              }];
}

#pragma mark ----------Action----------
- (void)recordBtnClick {
    XFTradeRecordViewController *controller = [[XFTradeRecordViewController alloc] init];
    [self pushController:controller];
}
#pragma mark - 提现
- (void)outBtnClick {
    XFGetMoneyViewController *controller = [[XFGetMoneyViewController alloc] init];
    [self pushController:controller];
}
#pragma mark - 充值
- (void)inBtnClick {
    XFRechrgeViewController *controller = [[XFRechrgeViewController alloc] init];
    [self pushController:controller];
}

- (UIView *)createItemView:(NSString *)info {
    UIView *view = [UIView xf_createWhiteView];
    view.size = CGSizeMake(kScreenWidth / 3, 55);

    UILabel *infoLabel = [UILabel xf_labelWithFont:Font(12)
                                         textColor:RGBGray(204)
                                     numberOfLines:1
                                         alignment:NSTextAlignmentCenter];
    infoLabel.text = info;
    infoLabel.frame = CGRectMake(0, 0, view.width, 25);
    [view addSubview:infoLabel];

    UILabel *countLabel = [UILabel xf_labelWithFont:FontB(18)
                                          textColor:RGBGray(102)
                                      numberOfLines:1
                                          alignment:NSTextAlignmentCenter];
    countLabel.text = @"0";
    countLabel.frame = CGRectMake(0, infoLabel.bottom, view.width, 30);
    countLabel.tag = 100;
    [view addSubview:countLabel];


    return view;
}




#pragma mark - 创建并初始化TableView
- (void)initWithTableView {
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tb.hidden = NO;
    tb.delegate = self;
    tb.dataSource = self;
    tb.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [tb setShowsVerticalScrollIndicator:NO];
    [tb setShowsHorizontalScrollIndicator:NO];
    UIView* bgView = [[UIView alloc]init];
    [bgView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    tb.tableFooterView = bgView;
    tb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tb];
    self.tbSimple = tb;
    [self.tbSimple registerNib:[UINib nibWithNibName:@"MyAccountTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyAccountTableViewCell"];
    CGFloat standardHeight = KScreenHeight - 64;
    if (@available(iOS 11.0, *)) {
        self.tbSimple.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tbSimple.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tbSimple.scrollIndicatorInsets = self.tbSimple.contentInset;
        standardHeight = KScreenHeight - 88 + 20;
    }
    [self.tbSimple setFrame:CGRectMake(0, KScreenHeight - standardHeight, KScreenWidth, standardHeight)];
}

#pragma mark - 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
#pragma mark - 列数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allData.count;
}

#pragma mark - cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"MyAccountTableViewCell";
    MyAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (MyAccountTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [cell cell_InitWithfirstValue:self.allData[indexPath.section] andForth:indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            //充值
            [self outBtnClick];
            break;
        case 1:
            //提现
            [self outBtnClick];
            break;
        case 2:
            //暂无消息
            break;

        default:
            break;
    }
}
#pragma mark - 优化分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}
#pragma mark - 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MyAccountTableViewCell standardHeight];
}
#pragma mark - cell下边Foot高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
#pragma mark - cell上边head高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
@end

