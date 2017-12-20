//
//  XFFriendHomeViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/22.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFFriendHomeViewController.h"
#import "XFPrepareChatView.h"
#import "XFFriendInfoViewController.h"
#import "XFFriendCircleViewController.h"
#import "XFFriendAlbumViewController.h"
#import "XFFriendTopView.h"
#import "XFPrepareChatView.h"
#import "XFRechrgeViewController.h"

@interface XFFriendHomeViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate, XFPrepareChatViewDelegate>

@property (nonatomic, strong) XFFriendTopView *topView;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UIView *tabView;
@property (nonatomic, strong) UIView *tabSignView;
@property (nonatomic, strong) UIButton *currentTabBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *chatBtn;

@property (nonatomic, strong) UISwipeGestureRecognizer *up;
@property (nonatomic, strong) UISwipeGestureRecognizer *down;

@property (nonatomic, assign) NSString *friendStatus;

@property (nonatomic, strong) User *user;

@property (nonatomic, strong) UIView *infoView;

@end

@implementation XFFriendHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildControllers];
    [self setupUI];
    [self loadUserInfo];
}

- (void)setupChildControllers {
    XFFriendCircleViewController *circleController = [[XFFriendCircleViewController alloc] init];
    circleController.friendId = self.friendId;
    [self addChildViewController:circleController];
    
    XFFriendAlbumViewController *albumController = [[XFFriendAlbumViewController alloc] init];
    albumController.friendId = self.friendId;
    [self addChildViewController:albumController];
    
    XFFriendInfoViewController *infocontroller = [[XFFriendInfoViewController alloc] init];
    infocontroller.friendId = self.friendId;
    [self addChildViewController:infocontroller];
}

- (void)setupUI {
    self.view.backgroundColor = WhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewUpSwipe)];
    up.delegate = self;
    up.direction = UISwipeGestureRecognizerDirectionUp;
    self.up = up;
    UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewDownSwipe)];
    down.delegate = self;
    down.direction = UISwipeGestureRecognizerDirectionDown;
    self.down = down;
    [self.view addGestureRecognizer:up];
    [self.view addGestureRecognizer:down];
    [self setupTopView];
    [self setupNavView];
    [self setupTabView];
    [self setupScrollView];
    [self setupBottomView];
}

- (void)setupTopView {
    _topView = [[XFFriendTopView alloc] init];
    [self.view addSubview:_topView];
}

- (void)setupNavView {
    UIView *navView = [[UIView alloc] init];
    self.navView = navView;
    navView.frame = CGRectMake(0, 0, kScreenWidth, XFNavHeight);
    navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navView];
    
    UIButton *backBtn = [UIButton xf_imgButtonWithImgName:@"icon_yyr_fh" target:self action:@selector(backBtnClick)];
    backBtn.frame = CGRectMake(16, 28, 28, 28);
    [navView addSubview:backBtn];
    
    UIButton *followBtn = [UIButton xf_titleButtonWithTitle:@"关注"
                                                 titleColor:WhiteColor
                                                  titleFont:Font(12)
                                                     target:self
                                                     action:@selector(followBtnClick)];
    self.followBtn = followBtn;
    followBtn.backgroundColor = RGBA(144, 56, 143, 0.38);
    [followBtn xf_cornerCut:3];
    followBtn.layer.borderColor = RGBA(255, 255, 255, 0.38).CGColor;
    followBtn.layer.borderWidth = 1;
    followBtn.size = CGSizeMake(54, 24);
    followBtn.top = 30;
    followBtn.right = kScreenWidth - 16;
    [navView addSubview:followBtn];
}

- (void)setupTabView {
    _tabView = [UIView xf_createWhiteView];
    _tabView.frame = CGRectMake(0, self.topView.bottom, kScreenWidth, XFCircleTabHeight);
    
    UIButton *circleBtn = [self createTabBtn:@"缘分圈" andTag:0];
    UIButton *albumBtn = [self createTabBtn:@"相册" andTag:1];
    UIButton *infoBtn = [self createTabBtn:@"信息资料" andTag:2];
    circleBtn.size = albumBtn.size = infoBtn.size = CGSizeMake(kScreenWidth / 3, XFCircleTabHeight);
    circleBtn.left = 0;
    albumBtn.left = circleBtn.right;
    infoBtn.left = albumBtn.right;
    [_tabView addSubview:circleBtn];
    [_tabView addSubview:albumBtn];
    [_tabView addSubview:infoBtn];
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(0, XFCircleTabHeight - 0.5, kScreenWidth, 0.5);
    [_tabView addSubview:splitView];
    
    UIView *signView = [UIView xf_createViewWithColor:BlueColor];
    self.tabSignView = signView;
    signView.top = splitView.bottom;
    signView.height = 2;
    signView.width = [circleBtn.titleLabel sizeThatFits:CGSizeZero].width;
    signView.centerX = circleBtn.centerX;
    [_tabView addSubview:signView];
    
    [self.view addSubview:_tabView];
    [self tabBtnClick:circleBtn];
}

- (void)setupScrollView {
    self.scrollView.top = self.tabView.bottom;
    self.scrollView.height = kScreenHeight - XFNavHeight - XFCircleTabHeight - XFFriendBottomChatHeight;
    self.scrollView.width = kScreenWidth;
    self.scrollView.left = 0;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * self.childViewControllers.count, 0);
    
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
    [self.view bringSubviewToFront:self.tabView];
}

- (void)setupBottomView {
    UIView *bottomView = [UIView xf_createWhiteView];
    bottomView.frame = CGRectMake(0, kScreenHeight - XFFriendBottomChatHeight, kScreenWidth, XFFriendBottomChatHeight);
    
    UIButton *chatBtn = [UIButton xf_bottomBtnWithTitle:@"聊天" target:self action:@selector(chatBtnClick)];
    self.chatBtn = chatBtn;
    chatBtn.frame = CGRectMake(10, 3, kScreenWidth - 20, 44);
    [bottomView addSubview:chatBtn];
    [self.view addSubview:bottomView];
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
                          User *user = [User mj_objectWithKeyValues:infoDict[@"userinfo"]];
                          NSDictionary *basicinfo = infoDict[@"basicinfo"];
                          user.address = basicinfo[@"address"];
                          user.age = basicinfo[@"age"];
                          weakSelf.user = user;
                          weakSelf.topView.user = user;
                          weakSelf.friendStatus = infoDict[@"status"];
                          if ([weakSelf.friendStatus isEqualToString:@"2"]) {
                              [weakSelf.chatBtn setTitle:@"待对方通过申请" forState:UIControlStateNormal];
                              weakSelf.chatBtn.userInteractionEnabled = NO;
                          }
                          [self resetFollowBtn];
                      }
                  }
              }];
}

#pragma mark ----------<UIScrollViewDelegate>----------
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x / scrollView.width;
    XFViewController *controller = self.childViewControllers[index];
    if (controller.isViewLoaded) return;
    UIView *view = controller.view;
    view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:view];
}

#pragma mark ----------<UIGestureRecognizerDelegate>----------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark ----------<XFPrepareChatViewDelegate>----------
- (void)prepareChatViewClickCancelBtn:(XFPrepareChatView *)view {
    [self.view addGestureRecognizer:self.up];
    [self.view addGestureRecognizer:self.down];
}

- (void)prepareChatView:(XFPrepareChatView *)view clickConfirmBtn:(NSString *)text {
    [self.view addGestureRecognizer:self.up];
    [self.view addGestureRecognizer:self.down];
    if (text.integerValue <= 0) {
        [ConfigModel mbProgressHUD:@"诚意金不能为0" andView:nil];
        return;
    }
    
    WeakSelf
    [HttpRequest postPath:XFApplyChatUrl
                   params:@{@"earnest" : text,
                            @"id" : self.friendId.stringValue}
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSDictionary *infoDict = responseObject[@"info"];
                          if ([infoDict isKindOfClass:[NSDictionary class]]) {
                              NSString *message = infoDict[@"message"];
                              if ([message isKindOfClass:[NSString class]] && message.length) {
                                  [ConfigModel mbProgressHUD:message andView:nil];
                              }
                          }
                      } else {
                          NSString *info = responseObject[@"info"];
                          if ([info isKindOfClass:[NSString class]] && info.length) {
                              [weakSelf showInfoView:info];
                          }
                      }
                  }
              }];
}

- (void)showInfoView:(NSString *)info {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.infoView = view;
    UIButton *bgBtn = [UIButton xf_emptyButtonWithTarget:self action:@selector(dismiss)];
    bgBtn.backgroundColor = MaskColor;
    bgBtn.frame = view.bounds;
    [view addSubview:bgBtn];
    
    UIView *contentView = [UIView xf_createViewWithColor:RGBGray(249)];
    contentView.width = kScreenWidth > 320 ? 340 : 300;
    [contentView xf_cornerCut:5];
    [view addSubview:contentView];
    
    UILabel *label = [UILabel xf_labelWithFont:Font(14)
                                     textColor:BlackColor
                                 numberOfLines:1
                                     alignment:NSTextAlignmentCenter];
    label.text = info;
    label.frame = CGRectMake(0, 0, contentView.width, 110);
    [contentView addSubview:label];
    
    CGFloat btnW = (contentView.width - 60) * 0.5;
    UIButton *cancelBtn = [UIButton xf_buttonWithTitle:@"取消"
                                            titleColor:[UIColor blackColor]
                                             titleFont:Font(16)
                                               imgName:nil
                                                target:self
                                                action:@selector(cancelBtnClick)];
    cancelBtn.frame = CGRectMake(20, label.bottom, btnW, 42);
    cancelBtn.backgroundColor = RGBGray(241);
    [cancelBtn xf_cornerCut:2];
    [contentView addSubview:cancelBtn];
    
    UIButton *rightBtn = [UIButton xf_buttonWithTitle:@"充值"
                                            titleColor:[UIColor whiteColor]
                                             titleFont:Font(16)
                                               imgName:nil
                                                target:self
                                                action:@selector(rightBtnClick)];
    rightBtn.backgroundColor = ThemeColor;
    [rightBtn xf_cornerCut:2];
    rightBtn.frame = CGRectMake(cancelBtn.right + 20, label.bottom, btnW, 42);
    [contentView addSubview:rightBtn];
    
    contentView.height = rightBtn.bottom + 20;
    contentView.center = CGPointMake(KScreenWidth * 0.5, KScreenHeight * 0.5);
    
    
    self.infoView.alpha = 0;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.infoView.alpha = 1;
                     }];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (void)cancelBtnClick {
    [UIView animateWithDuration:0.25 animations:^{
        self.infoView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.infoView removeFromSuperview];
    }];
}

- (void)rightBtnClick {
    [UIView animateWithDuration:0.25 animations:^{
        self.infoView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.infoView removeFromSuperview];
        XFRechrgeViewController *controller = [[XFRechrgeViewController alloc] init];
        [self pushController:controller];
    }];
}

#pragma mark ----------Action----------
- (void)tabBtnClick:(UIButton *)button {
    if (button == self.currentTabBtn) return;
    self.currentTabBtn.selected = NO;
    button.selected = YES;
    self.currentTabBtn = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tabSignView.width = [button.titleLabel sizeThatFits:CGSizeZero].width;
        self.tabSignView.centerX = button.centerX;
    }];
    
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth * button.tag, 0) animated:YES];
}

- (void)chatBtnClick {
    if ([self isNotLogin]) {
        [self showLoginController];
        return;
    }
    if ([self.friendStatus isEqualToString:@"3"]) {
        [ConfigModel jumptoChatViewController:self withId:self.user.mobile.stringValue];
    } else if ([self.friendStatus isEqualToString:@"1"] || [self.friendStatus isEqualToString:@"2"]) {
        [HttpRequest postPath:XFFriendSuggestMoneyUrl
                       params:@{@"id" : self.friendId}
                  resultBlock:^(id responseObject, NSError *error) {
                      if (!error) {
                          NSNumber *errorCode = responseObject[@"error"];
                          if (errorCode.integerValue == 0) {
                              NSDictionary *infoDict = responseObject[@"info"];
                              if ([infoDict isKindOfClass:[NSDictionary class]] && infoDict.allKeys.count) {
                                  [self.view removeGestureRecognizer:self.up];
                                  [self.view removeGestureRecognizer:self.down];
                                  NSString *score = infoDict[@"suggest_earnest"];
                                  if ([score isKindOfClass:[NSNumber class]]) {
                                      score = @"0";
                                  }
                                  XFPrepareChatView *view = [[XFPrepareChatView alloc] initWithScore:infoDict[@"suggest_earnest"]];
                                  view.delegate = self;
                                  [self.view addSubview:view];
                              }
                          }
                      }
                  }];

    }
}

- (void)followBtnClick {
    if ([self isNotLogin]) {
        [self showLoginController];
        return;
    }
    NSString *type = self.user.guanzhu.integerValue == 2 ? @"1" : @"2";
    if (self.user.id) {
        [HttpRequest postPath:XFFriendFollowUrl
                       params:@{@"id" : self.user.id,
                                @"type" : type}
                  resultBlock:^(id responseObject, NSError *error) {
                      if (!error) {
                          NSNumber *errorCode = responseObject[@"error"];
                          if (errorCode.integerValue == 0){
                              NSDictionary *info = responseObject[@"info"];
                              NSNumber *type = info[@"type"];
                              self.user.guanzhu = type;
                              [SVProgressHUD showSuccessWithStatus:info[@"message"]];
                              [self resetFollowBtn];
                          }
                      }
                  }];
    }
    
}

- (void)viewUpSwipe {
    if (self.tabView.top > XFNavHeight) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tabView.top = XFNavHeight;
            self.scrollView.top = self.tabView.bottom;
            self.navView.backgroundColor = ThemeColor;
        }];
    }
}

- (void)viewDownSwipe {
    NSInteger index = self.currentTabBtn.tag;
    CGFloat offset = 0;
    if (self.currentTabBtn.tag == 0) {
        offset = [((XFFriendCircleViewController *)self.childViewControllers[index]) scrollOffset];
    } else if (self.currentTabBtn.tag == 1) {
        offset = [((XFFriendAlbumViewController *)self.childViewControllers[index]) scrollOffset];
    } else {
        offset = [((XFFriendInfoViewController *)self.childViewControllers[index]) scrollOffset];
    }
    if (offset <= 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tabView.top = self.topView.bottom;
            self.scrollView.top = self.tabView.bottom;
            self.navView.backgroundColor = [UIColor clearColor];
        }];
    }
}

#pragma mark ----------Private----------
- (UIButton *)createTabBtn:(NSString *)title andTag:(NSInteger)tag {
    UIButton *btn = [UIButton xf_titleButtonWithTitle:title
                                           titleColor:RGBGray(153)
                                            titleFont:Font(15)
                                               target:self
                                               action:@selector(tabBtnClick:)];
    [btn setTitleColor:BlackColor forState:UIControlStateSelected];
    btn.tag = tag;
    return btn;
}

- (void)resetFollowBtn {
    [self.followBtn setTitle:self.user.guanzhu.integerValue == 2 ? @"已关注" : @"+关注" forState:UIControlStateNormal];
    NSString *currentUid = [[NSUserDefaults standardUserDefaults] objectForKey:UserId];
    self.followBtn.hidden = self.chatBtn.hidden = [self.user.id.stringValue isEqualToString:currentUid];
}

#pragma mark ----------Lazy----------
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollsToTop = NO;
        _scrollView.scrollEnabled = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = WhiteColor;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

@end

