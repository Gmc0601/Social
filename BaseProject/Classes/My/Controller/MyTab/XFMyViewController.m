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
#import "ShouCangViewController.h"

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

@property (nonatomic, strong)UIView *blackBottomView;
@property (nonatomic, strong)UITapGestureRecognizer *tapGes;
@property (nonatomic, strong)UIView *whiteBottomView;
@property (nonatomic, strong)UIImageView *codeImageView;

@end

@implementation XFMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildControllers];
    [self setupUI];
    [self loadData];
    [self setupNotification];
}

- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:XFLoginSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutSuccess)
                                                 name:XFLogoutSuccessNotification
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
    //二维码按钮
    UIButton *codeButton = [[UIButton alloc]init];
    //    [codeButton setBackgroundImage:[UIImage imageNamed:@"yyr_icon_yszh"] forState:UIControlStateNormal];
    [codeButton setImage:[UIImage imageNamed:@"icon_ewm"] forState:UIControlStateNormal];
    [codeButton addTarget:self action:@selector(showCodeImageViewMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:codeButton];
    codeButton.centerY = self.settingBtn.centerY;
    codeButton.left = self.settingBtn.right + 5;
    codeButton.width = 55;
    codeButton.height = 55;
//    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.settingBtn.mas_centerY);
//        make.left.equalTo(self.settingBtn.mas_right).with.offset(RESIZE_UI(5));
//        make.width.height.mas_offset(55);
//    }];
    //收藏按钮
    UIButton *shoucangButton = [[UIButton alloc]init];
    [shoucangButton setTitle:@"收藏" forState:UIControlStateNormal];
    shoucangButton.titleLabel.font = Font(15);
    [shoucangButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shoucangButton addTarget:self action:@selector(shoucangMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:shoucangButton];
    shoucangButton.centerY = self.accountBtn.centerY;
    shoucangButton.right = self.accountBtn.left;
    shoucangButton.width = 85;
    shoucangButton.height = 44;
//    [shoucangButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.accountBtn.mas_centerY);
//        make.right.equalTo(self.accountBtn.mas_left);
//        make.width.mas_offset(85);
//        make.height.mas_offset(44);
//    }];

}

#pragma mark - 收藏入口方法
- (void)shoucangMethod {
    ShouCangViewController *shoucangVC = [[ShouCangViewController alloc]init];
    [self pushController:shoucangVC];
}

#pragma mark - 显示二维码
- (void)showCodeImageViewMethod {

    //生成黑色背景
    _blackBottomView = [[UIView alloc]init];
    _blackBottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    UIWindow *windows =[[UIApplication sharedApplication].delegate window];
    [windows addSubview:_blackBottomView];
    _blackBottomView.frame = windows.bounds;
//    [_blackBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(windows);
//    }];

    _tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAll)];
    [_blackBottomView addGestureRecognizer:_tapGes];

    //生成白色背景
    _whiteBottomView = [[UIView alloc]init];
    _whiteBottomView.backgroundColor = [UIColor whiteColor];
    _whiteBottomView.layer.masksToBounds = YES;
    _whiteBottomView.layer.cornerRadius = 10.0f;
    [_blackBottomView addSubview:_whiteBottomView];
    _whiteBottomView.centerX = _blackBottomView.centerX;
    _whiteBottomView.centerY = _blackBottomView.centerY;
    _whiteBottomView.width = RESIZE_UI(300);
    _whiteBottomView.height = RESIZE_UI(300);
//    [_whiteBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_blackBottomView.mas_centerX);
//        make.centerY.equalTo(_blackBottomView.mas_centerY);
//        make.width.height.mas_offset(RESIZE_UI(300));
//    }];

    //生成二维码
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];

    // 2.恢复默认
    [filter setDefaults];

    // 3.给过滤器添加数据(正则表达式/账号和密码)
    //http://m.wangmacaifu.com/#/register/wmcf-xxxxxx
    //    NSString *dataString = [NSString stringWithFormat:@"http://m.wmjr888.com/?invitationcode=%@#login-register",[SingletonManager sharedManager].userModel.invitationcode];
    NSString *userId = [NSString stringWithFormat:@"%@",self.user.id];
    NSString *dataString = userId;//user_id
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];

    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];

    // 5.显示二维码
    self.codeImageView = [[UIImageView alloc]init];
    [_whiteBottomView addSubview:self.codeImageView];
    self.codeImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    self.codeImageView.center = _whiteBottomView.center;
    self.codeImageView.width = RESIZE_UI(250);
    self.codeImageView.height = RESIZE_UI(250);


    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"朋友可以通过扫码，添加你为好友";
    nameLabel.textColor = RGBGray(102);
    nameLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [_whiteBottomView addSubview:nameLabel];
    nameLabel.top = self.codeImageView.bottom;
    nameLabel.centerX = self.codeImageView.centerX;
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.codeImageView.mas_bottom);
//        make.centerX.equalTo(self.codeImageView.mas_centerX);
//    }];

}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - 关闭全部
- (void)closeAll {

    [_codeImageView removeFromSuperview];
    _codeImageView = nil;
    [_whiteBottomView removeFromSuperview];
    _whiteBottomView = nil;
    [_blackBottomView removeGestureRecognizer:_tapGes];
    _tapGes = nil;
    [_blackBottomView removeFromSuperview];
    _blackBottomView = nil;

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

- (void)logoutSuccess {
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
                          /*
                           #define User_url       @"avatar_url" // 头像
                           #define User_Nick      @"nickname"
                           */
                          [ConfigModel saveString:user.nickname forKey:User_Nick];
                          [ConfigModel saveString:user.avatar_url forKey:User_url];

                          weakSelf.myInfoView.user = user;
                      } else {
                          self.myInfoView.user = nil;
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
    if ([self isNotLogin]) {
        [self showLoginController];
    } else {
        XFMyInfoViewController *controller = [[XFMyInfoViewController alloc] init];
        [self pushController:controller];
    }
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
    if ([self isNotLogin]) {
        [self showLoginController];
    } else {
        XFSettingViewController *controller = [[XFSettingViewController alloc] init];
        [self pushController:controller];
    }
}

- (void)accountBtnClick {
    if ([self isNotLogin]) {
        [self showLoginController];
    } else {
        XFAccountViewController *controller = [[XFAccountViewController alloc] init];
        [self pushController:controller];
    }
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

