//
//  XFMyCharmInfoViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/27.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFMyCharmInfoViewController.h"
#import "XFCharmRuleViewController.h"

@interface XFMyCharmInfoViewController ()

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation XFMyCharmInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self loadData];
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFMyCharmUrl
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSDictionary *info = responseObject[@"info"];
                          NSDictionary *userInfo = info[@"userinfo"];
                          User *user = [User mj_objectWithKeyValues:userInfo];
                          
                          NSDictionary *cpInfo = info[@"usercpinfo"];
                          if (!IsNULL(cpInfo[@"coolpoint"])) {
                              user.coolpoint = cpInfo[@"coolpoint"];
                          }
                          user.beetlepoint = cpInfo[@"beetlepoint"];
                          
                          NSDictionary *rankInfo = info[@"rankinginfo"];
                          user.city_bee = rankInfo[@"city_bee"];
                          user.city_coo = rankInfo[@"city_coo"];
                          user.country_bee = rankInfo[@"country_bee"];
                          user.country_coo = rankInfo[@"country_coo"];
                          user.friend_bee = rankInfo[@"friend_bee"];
                          user.friend_coo = rankInfo[@"friend_coo"];
                          
                          weakSelf.user = user;
                          [self setupUI];
                      }
                  }
              }];
}

- (void)setupUI {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - XFNavHeight - XFTabHeight - XFCircleTabHeight - 2)];
    _scrollView.backgroundColor = WhiteColor;
    [self.view addSubview:_scrollView];
    
    UIView *grayView = [UIView xf_createViewWithColor:RGBGray(242)];
    grayView.frame = CGRectMake(0, 0, kScreenWidth, 30);
    [_scrollView addSubview:grayView];
    
    UIButton *ruleBtn = [UIButton xf_buttonWithTitle:@" 规则详情"
                                          titleColor:RGBGray(204)
                                           titleFont:Font(12)
                                             imgName:@"w_icon_gzxq"
                                              target:self
                                              action:@selector(ruleBtnClick)];
    [ruleBtn sizeToFit];
    ruleBtn.left = 15;
    ruleBtn.centerY = grayView.height * 0.5;
    [grayView addSubview:ruleBtn];
    
    UIView *topView = [self createTopView];
    topView.top = grayView.bottom;
    [self.scrollView addSubview:topView];
    
    UIView *countryView = [self createItemView:@"全国排名"
                                           coo:self.user.country_coo.integerValue
                                           bee:self.user.country_bee.integerValue];
    countryView.top = topView.bottom;
    
    UIView *cityView = [self createItemView:@"所在地排名"
                                        coo:self.user.city_coo.integerValue
                                        bee:self.user.city_bee.integerValue];
    cityView.top = countryView.bottom;
    UIView *friendView = [self createItemView:@"好友排名"
                                          coo:self.user.friend_coo.integerValue
                                          bee:self.user.friend_bee.integerValue];
    friendView.top = cityView.bottom;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, friendView.bottom);
}

- (CGFloat)scrollOffset {
    return _scrollView.contentOffset.y;
}

- (UIView *)createTopView {
    UIView *view = [UIView xf_createWhiteView];
    view.width = kScreenWidth;
    
    UILabel *cooLabel = [self createInfoLabel:@"魅力分:" count:self.user.coolpoint.integerValue];
    cooLabel.top = 10;
    cooLabel.height = 54;
    cooLabel.width = (kScreenWidth - 40) / 3;
    cooLabel.left = cooLabel.width + 20;
    [view addSubview:cooLabel];
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithImage:Image(@"list_ic_2_0_0")];
    imgView1.top = cooLabel.bottom + 10;
    imgView1.centerX = cooLabel.centerX;
    [view addSubview:imgView1];
    
    UILabel *beeLabel = [self createInfoLabel:@"金龟分:" count:self.user.beetlepoint.integerValue];
    beeLabel.frame = cooLabel.frame;
    beeLabel.left = cooLabel.right + 10;
    [view addSubview:beeLabel];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithImage:Image(@"list_ic_2_0_0")];
    imgView2.top = beeLabel.bottom + 10;
    imgView2.centerX = beeLabel.centerX;
    [view addSubview:imgView2];
    
    view.height = imgView1.bottom + 20;
    return view;
}

- (UILabel *)createInfoLabel:(NSString *)leftStr count:(NSInteger)count {
    UILabel *label = [[UILabel alloc] init];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:leftStr];
    attrStr.font = Font(12);
    NSMutableAttributedString *countStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", count]];
    countStr.font = FontB(24);
    [attrStr appendAttributedString:countStr.copy];
    
    NSMutableAttributedString *fenStr = [[NSMutableAttributedString alloc] initWithString:@"分"];
    fenStr.font = Font(12);
    [attrStr appendAttributedString:fenStr.copy];
    
    attrStr.color = BlueColor;
    label.attributedText = attrStr;
    label.textAlignment = NSTextAlignmentCenter;
    [label xf_cornerCut:27];
    label.layer.borderColor = BlueColor.CGColor;
    label.layer.borderWidth = 1;
    return label;
}

- (UIView *)createItemView:(NSString *)title coo:(NSInteger)coo bee:(NSInteger)bee {
    UIView *view = [UIView xf_createWhiteView];
    view.width = kScreenWidth;
    view.height = 60;
    
    UILabel *infoLabel = [UILabel xf_labelWithFont:Font(13)
                                         textColor:RGBGray(153)
                                     numberOfLines:1
                                         alignment:NSTextAlignmentLeft];
    infoLabel.text = title;
    infoLabel.frame = CGRectMake(15, 5, 75, view.height);
    [view addSubview:infoLabel];
    
    UILabel *cooLabel = [self createItemLabel:coo];
    cooLabel.width = (kScreenWidth - 40) / 3;
    cooLabel.height = view.height;
    cooLabel.left = cooLabel.width + 20;
    cooLabel.top = 0;
    [view addSubview:cooLabel];
    
    UILabel *beeLabel = [self createItemLabel:bee];
    beeLabel.frame = cooLabel.frame;
    beeLabel.left = cooLabel.right + 10;
    [view addSubview:beeLabel];
    [self.scrollView addSubview:view];
    return view;
}

- (UILabel *)createItemLabel:(NSInteger)count {
    UILabel *label = [[UILabel alloc] init];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"第 "];
    attrStr.font = Font(12);
    NSMutableAttributedString *countStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", count]];
    countStr.font = FontB(24);
    [attrStr appendAttributedString:countStr.copy];
    
    NSMutableAttributedString *fenStr = [[NSMutableAttributedString alloc] initWithString:@" 名"];
    fenStr.font = Font(12);
    [attrStr appendAttributedString:fenStr.copy];
    
    attrStr.color = BlackColor;
    label.attributedText = attrStr;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

#pragma mark ----------Action----------
- (void)ruleBtnClick {
    XFCharmRuleViewController *controller = [[XFCharmRuleViewController alloc] init];
    [self pushController:controller];
}

@end

