//
//  XFCircleViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleViewController.h"
#import "XFCircleContentViewController.h"
#import "XFPublishViewController.h"

#define CircleTabBaseTag    100
@interface XFCircleViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *tabTitleArray;
@property (nonatomic, strong) UIButton *currentTabBtn;

@property (nonatomic, weak) UIView *tabView;
@property (nonatomic, strong) UIView *signView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation XFCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLocation];
}

- (void)setupUI {
    [self setupNavView];
    [self setupChildVcs];
    [self setupTabView];
}

- (void)setupLocation {
    
}

- (void)setupNavView {
    self.navigationController.navigationBarHidden = YES;
    UIView *navView = [UIView xf_createWhiteView];
    navView.frame = CGRectMake(0, 0, kScreenWidth, XFNavHeight);
    navView.backgroundColor = ThemeColor;
    [self.view addSubview:navView];
    
    UILabel *titleLabel = [UILabel xf_labelWithFont:Font(18)
                                          textColor:WhiteColor
                                      numberOfLines:0
                                          alignment:NSTextAlignmentCenter];
    titleLabel.text = @"缘分圈";
    titleLabel.frame = CGRectMake(44, 20, kScreenWidth - 88, 44);
    [navView addSubview:titleLabel];
    
    UIButton *publishBtn = [UIButton xf_titleButtonWithTitle:@"发布"
                                                  titleColor:WhiteColor
                                                   titleFont:Font(15)
                                                      target:self
                                                      action:@selector(publishBtnClick)];
    publishBtn.frame = CGRectMake(kScreenWidth - 65, 20, 65, 44);
    [navView addSubview:publishBtn];
}

- (void)setupChildVcs {
    for (NSInteger i = 0; i < self.tabTitleArray.count; i++) {
        XFCircleContentViewController *controller = [[XFCircleContentViewController alloc] init];
        controller.type = (CircleContentType)i;
        [self addChildViewController:controller];
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * self.tabTitleArray.count, 0);
}

- (void)setupTabView {
    UIView *tabView = [UIView xf_createViewWithColor:RGBGray(242)];
    tabView.frame = CGRectMake(0, XFNavHeight, kScreenWidth, XFCircleTabHeight);
    self.tabView = tabView;
    [self.view addSubview:tabView];
    
    CGFloat itemW = kScreenWidth / self.tabTitleArray.count;
    UIButton *fistBtn = nil;
    for (int i = 0; i < self.tabTitleArray.count; i++) {
        NSString *title = self.tabTitleArray[i];
        UIButton *button = [UIButton xf_titleButtonWithTitle:title
                                                  titleColor:BlackColor
                                                   titleFont:Font(13)
                                                      target:self
                                                      action:@selector(tabBtnClick:)];
        button.width = itemW;
        button.height = tabView.height;
        button.left = i * itemW;
        button.top = 0;
        button.tag = i + CircleTabBaseTag;
        [tabView addSubview:button];
        if (i == 0) {
            fistBtn = button;
        }
    }
    
    UIView *signView = [UIView xf_createViewWithColor:ThemeColor];
    signView.height = 2;
    signView.width = [fistBtn.titleLabel sizeThatFits:CGSizeZero].width;
    signView.top = 33;
    signView.centerX = fistBtn.centerX;
    self.signView = signView;
    [tabView addSubview:signView];
    
    [self tabBtnClick:fistBtn];
    [self setupContentView];
}


#pragma mark ----------<UIScrollViewDelegate----------
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setupContentView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setupContentView];
    UIButton *button = [self.tabView viewWithTag:[self getTheCurrentIndex] + CircleTabBaseTag];
    [self tabBtnClick:button];
}

#pragma mark ----------Action----------
- (void)publishBtnClick {
    XFPublishViewController *controller = [[XFPublishViewController alloc] init];
    [self pushController:controller];
}

- (int)getTheCurrentIndex {
    return self.scrollView.contentOffset.x / self.scrollView.width;
}

- (void)tabBtnClick:(UIButton *)button {
    if (button == self.currentTabBtn) return;
    self.currentTabBtn.selected = NO;
    [self setupButton:self.currentTabBtn];
    button.selected = YES;
    self.currentTabBtn = button;
    [self setupButton:self.currentTabBtn];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.signView.width = [button.titleLabel sizeThatFits:CGSizeZero].width;
        self.signView.centerX = button.centerX;
    }];
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = kScreenWidth * (button.tag - CircleTabBaseTag);
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark ----------Private----------
- (void)setupButton:(UIButton *)button {
    if (button.selected) {
        button.titleLabel.font = FontB(13);
        [button setTitleColor:ThemeColor forState:UIControlStateNormal];
    } else {
        button.titleLabel.font = Font(13);
        [button setTitleColor:BlackColor forState:UIControlStateNormal];
    }
}

- (void)setupContentView {
    XFCircleContentViewController *controller = self.childViewControllers[[self getTheCurrentIndex]];
    if (controller.isViewLoaded) return;
    UIView *view = controller.view;
    view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:view];
}

#pragma mark ----------Lazy----------
- (NSArray *)tabTitleArray {
    if (_tabTitleArray == nil) {
        _tabTitleArray = @[@"热度", @"附近", @"最新", @"我的关注"];
    }
    return _tabTitleArray;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.top = XFNavHeight + XFCircleTabHeight;
        _scrollView.left = 0;
        _scrollView.width = kScreenWidth;
        _scrollView.height = kScreenHeight - _scrollView.top - XFTabHeight;
        _scrollView.backgroundColor = WhiteColor;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
