//
//  XFFriendInfoViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/22.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFFriendInfoViewController.h"

@interface XFFriendInfoViewController ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) User *user;

@end

@implementation XFFriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUserInfo];
}

- (CGFloat)scrollOffset {
    return _scrollView.contentOffset.y;
}

- (void)loadUserInfo {
    WeakSelf
    [HttpRequest postPath:XFFriendInfoUrl
                   params:@{@"id" : self.friendId}
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSDictionary *infoDict = responseObject[@"info"];
                          NSDictionary *basicinfo = infoDict[@"basicinfo"];
                          NSDictionary *geren = infoDict[@"geren"];
                          NSDictionary *userinfo = infoDict[@"userinfo"];
                          NSDictionary *xiangxi = infoDict[@"xiangxi"];
                          NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
                          [userDict addEntriesFromDictionary:basicinfo];
                          [userDict addEntriesFromDictionary:geren];
                          [userDict addEntriesFromDictionary:userinfo];
                          [userDict addEntriesFromDictionary:xiangxi];
                          
                          User *user = [User mj_objectWithKeyValues:userDict];
                          weakSelf.user = user;
                          [self setupUI];
                      }
                  }
              }];
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - XFCircleTabHeight - XFNavHeight - XFFriendBottomChatHeight)];
    scrollView.backgroundColor = WhiteColor;
    self.scrollView.bounces = YES;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    UIView *basicView = [self createSectionView:@"基本信息" isFriend:YES];
    
    UIView *ageView = [self createItemView:@"年龄：" andInfo:self.user.age];
    ageView.top = basicView.bottom;
    
    UIView *nickView = [self createItemView:@"昵称：" andInfo:self.user.nickname];
    nickView.top = ageView.bottom;
    
    UIView *cityView = [self createItemView:@"居住地：" andInfo:self.user.address];
    cityView.top = nickView.bottom;
    
    UIView *splitView1 = [UIView xf_createSplitView];
    splitView1.frame = CGRectMake(0, cityView.bottom + 5, kScreenWidth, 0.5);
    [self.scrollView addSubview:splitView1];
    
    NSString *uid = [UserDefaults objectForKey:UserId];
    BOOL isFriend = self.user.guanzhu.integerValue == 2 || [uid isEqualToString:self.user.id.stringValue];
    UIView *personView = [self createSectionView:@"个人信息" isFriend:isFriend];
    personView.top = splitView1.bottom;
    
    CGFloat contentY = personView.bottom;
    if (isFriend) {
        UIView *heightView = [self createItemView:@"身高：" andInfo:self.user.height];
        heightView.top = personView.bottom;
        
        UIView *weightView = [self createItemView:@"体重：" andInfo:self.user.weight];
        weightView.top = heightView.bottom;
        
        UIView *interestView = [self createItemView:@"兴趣爱好：" andInfo:self.user.hobby];
        interestView.top = weightView.bottom;
        
        UIView *educationView = [self createItemView:@"学历：" andInfo:self.user.education];
        educationView.top = interestView.bottom;
        
        UIView *feelingView = [self createItemView:@"情感状况：" andInfo:self.user.feeling];
        feelingView.top = educationView.bottom;
        contentY = feelingView.bottom + 5;
    }
    
    UIView *splitView2 = [UIView xf_createSplitView];
    splitView2.frame = CGRectMake(0, contentY, kScreenWidth, 0.5);
    [self.scrollView addSubview:splitView2];
    
    UIView *detailView = [self createSectionView:@"详细信息" isFriend:isFriend];
    detailView.top = splitView2.bottom;
    
    if (isFriend) {
        UIView *workView = [self createItemView:@"工作：" andInfo:self.user.job];
        workView.top = detailView.bottom;
        
        UIView *incomeView = [self createItemView:@"收入：" andInfo:self.user.income];
        incomeView.top = workView.bottom;
        
        UIView *houseView = [self createItemView:@"房产：" andInfo:self.user.house];
        houseView.top = incomeView.bottom;
        
        UIView *carView = [self createItemView:@"车产：" andInfo:self.user.car];
        carView.top = houseView.bottom;
    }
}

#pragma mark ----------Private----------
- (UIView *)createSectionView:(NSString *)title isFriend:(BOOL)friend {
    UIView *view = [UIView xf_createWhiteView];
    view.size = CGSizeMake(kScreenWidth, 40);
    
    UIView *bubbleView = [UIView xf_createViewWithColor:BlueColor];
    bubbleView.size = CGSizeMake(6, 6);
    bubbleView.left = 15;
    bubbleView.centerY = view.height * 0.5;
    [bubbleView xf_cornerCut:3];
    [view addSubview:bubbleView];
    
    UILabel *label = [UILabel xf_labelWithFont:FontB(13)
                                     textColor:BlackColor
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
    label.text = title;
    label.left = bubbleView.right + 5;
    label.top = 0;
    label.height = view.height;
    label.width = 200;
    [view addSubview:label];
    
    UILabel *rightLabel = [UILabel xf_labelWithFont:Font(13)
                                          textColor:RGBGray(204)
                                      numberOfLines:1
                                          alignment:NSTextAlignmentRight];
    rightLabel.text = @"只有互相成为好友才可以看呦";
    rightLabel.size = CGSizeMake(200, view.height);
    rightLabel.top = 0;
    rightLabel.right = view.width - 15;
    [view addSubview:rightLabel];
    rightLabel.hidden = friend;
    [self.scrollView addSubview:view];
    return view;
}


- (UIView *)createItemView:(NSString *)title andInfo:(NSString *)info {
    UIView *view = [UIView xf_createWhiteView];
    view.size = CGSizeMake(kScreenWidth, 25);
    
    UILabel *titleLabel = [UILabel xf_labelWithFont:Font(13)
                                          textColor:RGBGray(102)
                                      numberOfLines:0
                                          alignment:NSTextAlignmentLeft];
    titleLabel.text = title;
    titleLabel.frame = CGRectMake(15, 0, 75, view.height);
    [view addSubview:titleLabel];
    
    UILabel *infoLabel = [UILabel xf_labelWithFont:Font(15)
                                         textColor:BlackColor
                                     numberOfLines:0
                                         alignment:NSTextAlignmentLeft];
    if (![info isKindOfClass:[NSNull class]] && info.length) {
        infoLabel.text = info;
    }
    infoLabel.frame = CGRectMake(titleLabel.right, 0, view.width - 15 - titleLabel.right, view.height);
    infoLabel.tag = 100;
    [view addSubview:infoLabel];
    [self.scrollView addSubview:view];
    return view;
}

@end

