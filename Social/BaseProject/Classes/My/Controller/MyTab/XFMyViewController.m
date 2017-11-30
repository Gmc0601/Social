//
//  XFMyViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFMyViewController.h"
#import "XFMyInfoView.h"
#import "XFSettingViewController.h"
#import "XFFollowViewController.h"
#import "XFAccountViewController.h"
#import "XFMyInfoViewController.h"
#import "XFSignatureViewController.h"
#import "XFMyCircleViewController.h"
#import "XFMyAlbumViewController.h"
#import "XFMyCharmInfoViewController.h"

@interface XFMyViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate, XFMyInfoViewDelegate>
@property (nonatomic, strong) XFMyInfoView *myInfoView;

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIButton *accountBtn;

@property (nonatomic, strong) UIView *tabView;
@property (nonatomic, strong) UIView *tabSignView;
@property (nonatomic, strong) UIButton *currentTabBtn;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) User *user;

@end

@implementation XFMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildControllers];
    [self setupUI];
    [self loadData];
    [self setupNotification];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self isNotLogin]) {
            [self showLoginController];
        }
    });
}

- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:XFLoginSuccessNotification
                                               object:nil];
}

- (void)setupChildControllers {
    XFMyCircleViewController *circleController = [[XFMyCircleViewController alloc] init];
    [self addChildViewController:circleController];
    
    XFMyAlbumViewController *albumController = [[XFMyAlbumViewController alloc] init];
    [self addChildViewController:albumController];
    
    XFMyCharmInfoViewController *infocontroller = [[XFMyCharmInfoViewController alloc] init];
    [self addChildViewController:infocontroller];
}

- (void)setupUI {
    self.view.backgroundColor = WhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewUpSwipe)];
    up.delegate = self;
    up.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewDownSwipe)];
    down.delegate = self;
    down.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:up];
    [self.view addGestureRecognizer:down];
    
    [self setupInfoView];
    [self setupNavView];
    [self setupTabView];
    [self setupScrollView];
}

- (void)setupInfoView {
    _myInfoView = [[XFMyInfoView alloc] init];
    _myInfoView.delegate = self;
    [self.view addSubview:_myInfoView];
}

- (void)setupNavView {
    self.navView.frame = CGRectMake(0, 0, kScreenWidth, XFNavHeight);
    self.settingBtn.frame = CGRectMake(0, 20, 44, 44);
    self.accountBtn.frame = CGRectMake(kScreenWidth - 85, 20, 85, 44);
}

- (void)setupTabView {
    _tabView = [UIView xf_createWhiteView];
    _tabView.frame = CGRectMake(0, self.myInfoView.bottom, kScreenWidth, XFCircleTabHeight + 2);
    
    UIButton *circleBtn = [self createTabBtn:@"缘分圈" andTag:0];
    UIButton *albumBtn = [self createTabBtn:@"相册" andTag:1];
    UIButton *infoBtn = [self createTabBtn:@"魅力值" andTag:2];
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
    self.scrollView.height = kScreenHeight - XFNavHeight - self.tabView.height - XFTabHeight;
    self.scrollView.width = kScreenWidth;
    self.scrollView.left = 0;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * self.childViewControllers.count, 0);
    
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
}

- (void)loginSuccess {
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
                          weakSelf.user = user;
                          weakSelf.myInfoView.user = user;
                      }
                  }
              }];
}

#pragma mark ----------<XFMyInfoViewDelegate>----------
- (void)myInfoView:(XFMyInfoView *)view didTapBottomView:(NSInteger)tag {
    XFFollowViewController *controller = [[XFFollowViewController alloc] init];
    controller.followType = (FollowType)tag;
    [self pushController:controller];
    
}

- (void)myInfoViewDidTapSignLabel:(XFMyInfoView *)view {
    XFSignatureViewController *controller = [[XFSignatureViewController alloc] init];
    controller.saveBtnClick = ^(NSString *sign) {
        self.user.sdf = sign;
        self.myInfoView.user = self.user;
    };
    [self pushController:controller];
    
}

- (void)myInfoViewDidClickIconBtn:(XFMyInfoView *)view {
    XFMyInfoViewController *controller = [[XFMyInfoViewController alloc] init];
    [self pushController:controller];
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


#pragma mark ----------Action----------
- (void)settingBtnClick {
    XFSettingViewController *controller = [[XFSettingViewController alloc] init];
    [self pushController:controller];
}

- (void)accountBtnClick {
    XFAccountViewController *controller = [[XFAccountViewController alloc] init];
    [self pushController:controller];
}

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

- (void)viewUpSwipe {
    if (self.tabView.top > XFNavHeight) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tabView.top = XFNavHeight;
            self.scrollView.top = self.tabView.bottom;
            //            self.myInfoView.bottom = XFNavHeight;
        }];
    }
}

- (void)viewDownSwipe {
    NSInteger index = self.currentTabBtn.tag;
    CGFloat offset = 0;
    if (self.currentTabBtn.tag == 0) {
        offset = [((XFMyCircleViewController *)self.childViewControllers[index]) scrollOffset];
    } else if (self.currentTabBtn.tag == 1) {
        offset = [((XFMyAlbumViewController *)self.childViewControllers[index]) scrollOffset];
    } else {
        offset = [((XFMyCharmInfoViewController *)self.childViewControllers[index]) scrollOffset];
    }
    if (offset <= 0) {
        [UIView animateWithDuration:0.25 animations:^{
            //            self.myInfoView.top = 0;
            self.tabView.top = self.myInfoView.bottom;
            self.scrollView.top = self.tabView.bottom;
        }];
    }
}


#pragma mark ----------Lazy----------
- (UIView *)navView {
    if (_navView == nil) {
        _navView = [[UIView alloc] init];
        [self.view addSubview:_navView];
    }
    return _navView;
}

- (UIButton *)settingBtn {
    if (_settingBtn == nil) {
        _settingBtn = [UIButton xf_imgButtonWithImgName:@"icon_w_sz"
                                                 target:self
                                                 action:@selector(settingBtnClick)];
        [self.navView addSubview:_settingBtn];
    }
    return _settingBtn;
}

- (UIButton *)accountBtn {
    if (_accountBtn == nil) {
        _accountBtn = [UIButton xf_titleButtonWithTitle:@"我的账户"
                                             titleColor:WhiteColor
                                              titleFont:Font(15)
                                                 target:self
                                                 action:@selector(accountBtnClick)];
        [self.navView addSubview:_accountBtn];
    }
    return _accountBtn;
}

#pragma mark ----------Private----------
- (UIButton *)createTabBtn:(NSString *)title andTag:(NSInteger)tag {
    UIButton *btn = [UIButton xf_titleButtonWithTitle:title
                                           titleColor:RGBGray(153)
                                            titleFont:Font(15)
                                               target:self
                                               action:@selector(tabBtnClick:)];
    [btn setTitleColor:BlackColor forState:UIControlStateSelected];
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = tag;
    return btn;
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

