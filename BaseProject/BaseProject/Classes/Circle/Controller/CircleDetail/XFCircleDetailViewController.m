//
//  XFCircleDetailViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleDetailViewController.h"
#import "XFCircleContentCellModel.h"
#import "XFCircleContentView.h"
#import "XFCircleShareView.h"
#import "XFCircleRewardViewController.h"
#import "XFCircleCommentViewController.h"
#import "XFCircleZanViewController.h"
#import "XFPlayVideoController.h"

@interface XFCircleDetailViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate, XFCircleContentViewDelegate, XFCircleShareViewDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) XFCircleContentView *topView;

@property (nonatomic, strong) UIView *tabView;
@property (nonatomic, strong) UIView *tabSignView;
@property (nonatomic, strong) UIButton *currentTabBtn;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UIView *commentContentView;
@property (nonatomic, strong) XFTextView *textView;

@property (nonatomic, strong) Circle *circle;
@property (nonatomic, strong) XFCircleContentCellModel *model;

@property (nonatomic, assign) BOOL isComment; // 别的页面键盘通知本页面不处理

@property (nonatomic, strong) NSMutableArray *photosArray;

@end

@implementation XFCircleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setupNotification];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)dealloc {
    [NoteCenter removeObserver:self];
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFCircleDetailUrl
                   params:@{@"id" : self.circleId}
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSDictionary *dict = responseObject[@"info"];
                          Circle *circle = [Circle mj_objectWithKeyValues:dict];
                          weakSelf.circle = circle;
                          weakSelf.model = [[XFCircleContentCellModel alloc] initWithCircle:circle andType:CircleContentModelType_Detail];
                          [self setupUI];
                      }
                  }
              }];
}

- (void)setupChildControllers {
    XFCircleRewardViewController *circleController = [[XFCircleRewardViewController alloc] init];
    circleController.circleId = self.circleId;
    [self addChildViewController:circleController];
    
    XFCircleCommentViewController *albumController = [[XFCircleCommentViewController alloc] init];
    albumController.circleId = self.circleId;
    [self addChildViewController:albumController];
    
    XFCircleZanViewController *infocontroller = [[XFCircleZanViewController alloc] init];
    infocontroller.circleId = self.circleId;
    [self addChildViewController:infocontroller];
}

- (void)setupNotification {
    [NoteCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [NoteCenter addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    [self setupChildControllers];
    [self setupGesture];
    [self setupNavView];
    [self setupTopView];
    [self setupTabView];
    [self setupScrollView];
    [self setupBottomView];
}

- (void)setupGesture {
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewUpSwipe)];
    up.delegate = self;
    up.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewDownSwipe)];
    down.delegate = self;
    down.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:up];
    [self.view addGestureRecognizer:down];
}

- (void)setupNavView {
    UIView *navView = [UIView xf_themeNavView:@"缘分圈"
                                   backTarget:self
                                   backAction:@selector(backBtnClick)];
    
    XFUDButton *shareBtn = [XFUDButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:Image(@"icon_nav_fx") forState:UIControlStateNormal];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    shareBtn.titleLabel.font = Font(11);
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.frame = CGRectMake(kScreenWidth - 44, 20, 44, 44);
    shareBtn.padding = 5;
    [navView addSubview:shareBtn];
    [self.view addSubview:navView];
}

- (void)setupTopView{
    _topView = [[XFCircleContentView alloc] init];
    _topView.delegate = self;
    [self.view addSubview:_topView];
    _topView.model = self.model;
    _topView.frame = self.model.circleContentFrame;
    _topView.top = XFNavHeight;
}

- (void)setupTabView {
    _tabView = [UIView xf_createWhiteView];
    _tabView.frame = CGRectMake(0, self.topView.bottom, kScreenWidth, XFCircleTabHeight);
    
    UIButton *rewardBtn = [self createTabBtn:[NSString stringWithFormat:@"打赏 %@", self.circle.reward_num.stringValue] andTag:0];
    UIButton *commentBtn = [self createTabBtn:[NSString stringWithFormat:@"评论 %@", self.circle.comment_num.stringValue] andTag:1];
    UIButton *zanBtn = [self createTabBtn:[NSString stringWithFormat:@"点赞 %@", self.circle.like_num.stringValue] andTag:2];
    rewardBtn.size = commentBtn.size = zanBtn.size = CGSizeMake(kScreenWidth / 3, XFCircleTabHeight);
    rewardBtn.left = 0;
    commentBtn.left = rewardBtn.right;
    zanBtn.left = commentBtn.right;
    [_tabView addSubview:rewardBtn];
    [_tabView addSubview:commentBtn];
    [_tabView addSubview:zanBtn];
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(0, XFCircleTabHeight - 0.5, kScreenWidth, 0.5);
    [_tabView addSubview:splitView];
    
    UIView *signView = [UIView xf_createViewWithColor:ThemeColor];
    self.tabSignView = signView;
    signView.height = 2;
    signView.width = 30;
    signView.top = XFCircleTabHeight * 0.5 + 9;
    signView.centerX = rewardBtn.centerX;
    [_tabView addSubview:signView];
    
    [self.view addSubview:_tabView];
    [self tabBtnClick:rewardBtn];
}

- (void)setupScrollView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.scrollsToTop = NO;
    _scrollView.scrollEnabled = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = WhiteColor;
    _scrollView.top = self.tabView.bottom;
    _scrollView.height = kScreenHeight - XFNavHeight - XFCircleTabHeight - XFCircleDetailBottomHeight;
    _scrollView.width = kScreenWidth;
    _scrollView.left = 0;
    _scrollView.contentSize = CGSizeMake(kScreenWidth * self.childViewControllers.count, 0);
    [self.view addSubview:_scrollView];
    [self scrollViewDidEndScrollingAnimation:_scrollView];
}

- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = WhiteColor;
    bottomView.size = CGSizeMake(kScreenWidth, XFCircleDetailBottomHeight);
    bottomView.bottom = kScreenHeight;
    [self.view addSubview:bottomView];
    
    UIButton *rewardBtn = [UIButton xf_buttonWithTitle:@"  打赏"
                                            titleColor:RGBGray(153)
                                             titleFont:Font(12)
                                               imgName:@"icon_pl_ds"
                                                target:self
                                                action:@selector(rewardBtnClick)];
    [bottomView addSubview:rewardBtn];
    
    UIButton *commentBtn = [UIButton xf_buttonWithTitle:@"  评论"
                                             titleColor:RGBGray(153)
                                              titleFont:Font(12)
                                                imgName:@"icon_pl_pl"
                                                 target:self
                                                 action:@selector(commentBtnClick)];
    [bottomView addSubview:commentBtn];
    
    UIButton *zanBtn = [UIButton xf_buttonWithTitle:@"  赞"
                                         titleColor:RGBGray(153)
                                          titleFont:Font(12)
                                            imgName:@"icon_pl_dz"
                                             target:self
                                             action:@selector(zanBtnClick:)];
    [bottomView addSubview:zanBtn];
    
    rewardBtn.size = commentBtn.size = zanBtn.size = CGSizeMake(kScreenWidth / 3, bottomView.height);
    commentBtn.left = rewardBtn.right;
    zanBtn.left = commentBtn.right;
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(0, 0, kScreenWidth, 0.5);
    [bottomView addSubview:splitView];
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

#pragma mark ----------NSNotification----------
- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.isComment) {
        NSDictionary *dict = notification.userInfo;
        NSString *duration = dict[UIKeyboardAnimationDurationUserInfoKey];
        NSValue *endValue = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
        self.commentView.alpha = 0;
        [UIView animateWithDuration:duration.floatValue animations:^{
            self.commentView.alpha = 1;
            self.commentContentView.bottom = endValue.CGRectValue.origin.y;
        }];
    }
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    if (self.isComment) {
        NSDictionary *dict = notification.userInfo;
        NSString *duration = dict[UIKeyboardAnimationDurationUserInfoKey];
        NSValue *endValue = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            self.commentView.alpha = 0;
            self.commentContentView.top = endValue.CGRectValue.origin.y;
        } completion:^(BOOL finished) {
            self.isComment = NO;
        }];
    }
}

#pragma mark ----------<XFCircleContentViewDelegate>----------
- (void)circleContentView:(XFCircleContentView *)view didClickIconView:(XFCircleContentCellModel *)model {
    FFLogFunc
}

- (void)circleContentView:(XFCircleContentView *)view didClickVideoView:(XFCircleContentCellModel *)model {
    XFPlayVideoController *controller = [[XFPlayVideoController alloc] init];
    controller.videoUrl = model.circle.video;
    [self pushController:controller];
}

- (void)circleContentView:(XFCircleContentView *)view didTapPicView:(NSInteger)index model:(XFCircleContentCellModel *)model {
    self.photosArray = [NSMutableArray array];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    for (int i = 0; i < model.circle.image.count; i++) {
        [self.photosArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:model.circle.image[i]]]];
    }
    browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    [browser setCurrentPhotoIndex:index];
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photosArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photosArray.count) {
        return [self.photosArray objectAtIndex:index];
    }
    return nil;
}

- (void)circleContentView:(XFCircleContentView *)view didClickFollowBtn:(XFCircleContentCellModel *)model {
    Circle *circle = model.circle;
    if (circle.id) {
        NSString *type = circle.attention_status.integerValue == 2 ? @"1" : @"2";
        [HttpRequest postPath:XFCircleFollowUrl
                       params:@{@"real_id" : circle.id,
                                @"type" : type}
                  resultBlock:^(id responseObject, NSError *error) {
                      if (!error) {
                          NSNumber *errorCode = responseObject[@"error"];
                          if (errorCode.integerValue == 0){
                              NSDictionary *info = responseObject[@"info"];
                              NSNumber *type = info[@"type"];
                              circle.attention_status = type;
                              [SVProgressHUD showSuccessWithStatus:info[@"message"]];
                              self.topView.model = self.model;
                          }
                      }
                  }];
    }
}

#pragma mark ----------<XFCircleShareViewDelegate>----------
- (void)circleShareView:(XFCircleShareView *)view didClick:(CircleShareBtnType)type {
    FFLogFunc
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

- (void)viewUpSwipe {
    if (self.tabView.top > XFNavHeight) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tabView.top = XFNavHeight;
            self.scrollView.top = self.tabView.bottom;
        }];
    }
}

- (void)viewDownSwipe {
    NSInteger index = self.currentTabBtn.tag;
    CGFloat offset = 0;
    if (self.currentTabBtn.tag == 0) {
        offset = [((XFCircleRewardViewController *)self.childViewControllers[index]) scrollOffset];
    } else if (self.currentTabBtn.tag == 1) {
        offset = [((XFCircleCommentViewController *)self.childViewControllers[index]) scrollOffset];
    } else {
        offset = [((XFCircleZanViewController *)self.childViewControllers[index]) scrollOffset];
    }
    if (offset <= 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tabView.top = self.topView.bottom;
            self.scrollView.top = self.tabView.bottom;
        }];
    }
}

- (void)shareBtnClick {
    XFCircleShareView *shareView = [[XFCircleShareView alloc] init];
    shareView.delegate = self;
    [self.view addSubview:shareView];
}

- (void)rewardBtnClick {
    
}

- (void)commentBtnClick {
    self.isComment = YES;
    [self commentViewShow];
}

- (void)zanBtnClick:(UIButton *)btn {
    
}

- (void)cancelBtnClick {
    [self commentViewDismiss];
}

- (void)publishBtnClick {
    [self commentViewDismiss];
    if (self.textView.text.length) {
        [HttpRequest postPath:XFCircleSendCommentUrl
                       params:@{@"real_id" : self.circleId,
                                @"content" : self.textView.text}
                  resultBlock:^(id responseObject, NSError *error) {
                      FFLog(@"%@", responseObject);
                  }];
    }
}

- (void)commentViewShow {
    self.isComment = YES;
    [self commentView];
    [self.textView becomeFirstResponder];
}

- (void)commentViewDismiss {
    [self.textView resignFirstResponder];
}

#pragma mark ----------Private----------
- (UIButton *)createTabBtn:(NSString *)title andTag:(NSInteger)tag {
    UIButton *btn = [UIButton xf_titleButtonWithTitle:title
                                           titleColor:RGBGray(153)
                                            titleFont:Font(13)
                                               target:self
                                               action:@selector(tabBtnClick:)];
    [btn setTitleColor:BlackColor forState:UIControlStateSelected];
    btn.tag = tag;
    return btn;
}

#pragma mark ----------Lazy----------

- (UIView *)commentView {
    if (_commentView == nil) {
        _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _commentView.backgroundColor = MaskColor;
        
        UIButton *bgBtn = [UIButton xf_emptyButtonWithTarget:self action:@selector(commentViewDismiss)];
        bgBtn.frame = _commentView.bounds;
        bgBtn.backgroundColor = MaskColor;
        [_commentView addSubview:bgBtn];
        
        _commentContentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 130)];
        _commentContentView.backgroundColor = WhiteColor;
        [_commentView addSubview:_commentContentView];
        UIButton *cancelBtn = [UIButton xf_titleButtonWithTitle:@"取消"
                                                     titleColor:BlackColor
                                                      titleFont:Font(13)
                                                         target:self
                                                         action:@selector(cancelBtnClick)];
        cancelBtn.frame = CGRectMake(0, 0, 55, 44);
        [_commentContentView addSubview:cancelBtn];
        
        UIButton *publishBtn = [UIButton xf_titleButtonWithTitle:@"发布"
                                                      titleColor:BlackColor
                                                       titleFont:Font(13)
                                                          target:self
                                                          action:@selector(publishBtnClick)];
        publishBtn.frame = CGRectMake(kScreenWidth - 55, 0, 55, 44);
        [_commentContentView addSubview:publishBtn];
        
        _textView = [[XFTextView alloc] initWithFrame:CGRectMake(15, 44, kScreenWidth - 30, _commentContentView.height - 44)];
        _textView.textColor = BlackColor;
        _textView.font = Font(15);
        _textView.placeholder = @"写评论";
        _textView.placeholderColor = RGBGray(204);
        [_commentContentView addSubview:_textView];
        
        [self.commentContentView addSubview:self.textView];
        [self.view addSubview:_commentView];
    }
    return _commentView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

