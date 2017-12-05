//
//  XFFriendCircleViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFFriendCircleViewController.h"
#import "XFCircleContentCellModel.h"
#import "XFFriendCircleCell.h"
#import "XFCircleDetailViewController.h"
#import "XFPlayVideoController.h"
#import "XFCircleShareView.h"
#import "XFCircleDetailViewController.h"

@interface XFFriendCircleViewController ()<UITableViewDataSource, UITableViewDelegate, XFFriendCircleCellDelegate, MWPhotoBrowserDelegate, XFCircleShareViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *photosArray;

@end

@implementation XFFriendCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (CGFloat)scrollOffset {
    return _tableView.contentOffset.y;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - XFCircleTabHeight - XFNavHeight - XFFriendBottomChatHeight);
    [self loadData];
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFFriendCircleUrl
                   params:@{@"id" : self.friendId}
              resultBlock:^(id responseObject, NSError *error) {
                  weakSelf.dataArray = [NSMutableArray array];
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSArray *infoArray = responseObject[@"info"];
                          for (int i = 0 ; i < infoArray.count; i++) {
                              NSDictionary *dict = infoArray[i];
                              XFCircleContentCellModel *model = [[XFCircleContentCellModel alloc] initWithCircle:[Circle mj_objectWithKeyValues:dict] andType:CircleContentModelType_Friend];
                              [weakSelf.dataArray addObject:model];
                          }
                          [self.tableView reloadData];
                      }
                  }
              }];
}

#pragma mark ----------<UITableViewDataSource>----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFFriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFFriendCircleCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark ----------<UITableViewDelegate>----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFCircleContentCellModel *model = self.dataArray[indexPath.row];
    return model.cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XFCircleContentCellModel *model = self.dataArray[indexPath.row];
    XFCircleDetailViewController *controller = [[XFCircleDetailViewController alloc] init];
    controller.circleId = model.circle.id;
    [self pushController:controller];
}

#pragma mark ----------<XFFriendCircleCellDelegate>----------
- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickRewardBtn:(XFCircleContentCellModel *)model {
    if ([self isNotLogin]) {
        [self showLoginController];
        return;
    }
    WeakSelf
    [HttpRequest postPath:XFCircleRewardUrl
                   params:@{@"real_id" : model.circle.id.stringValue,
                            @"reward" : @"1"
                            }
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSString *info = responseObject[@"info"];
                      [ConfigModel mbProgressHUD:info andView:nil];
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          model.circle.reward_num = @(model.circle.reward_num.integerValue + 1);
                          [weakSelf.tableView reloadData];
                      }
                  } else {
                      [ConfigModel mbProgressHUD:@"打赏失败" andView:nil];
                  }
              }];
}

- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickShareBtn:(XFCircleContentCellModel *)model {
    XFCircleShareView *shareView = [[XFCircleShareView alloc] init];
    shareView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
}

- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickZanBtn:(XFCircleContentCellModel *)model {
    if ([self isNotLogin]) {
        [self showLoginController];
        return;
    }
    Circle *circle = model.circle;
    if (circle.id) {
        NSString *type = circle.like_status.integerValue == 1 ? @"2" : @"1";
        [HttpRequest postPath:XFCircleZanUrl
                       params:@{@"real_id" : circle.id,
                                @"type" : type}
                  resultBlock:^(id responseObject, NSError *error) {
                      if (!error) {
                          NSNumber *errorCode = responseObject[@"error"];
                          if (errorCode.integerValue == 0){
                              NSDictionary *info = responseObject[@"info"];
                              NSNumber *type = info[@"type"];
                              circle.like_status = type;
                              if (type.integerValue == 2) {
                                  circle.like_status = @2;
                                  if (circle.like_num.integerValue >= 1) {
                                      circle.like_num = @(circle.like_num.integerValue - 1);
                                  }
                              } else {
                                  circle.like_status = @1;
                                  circle.like_num = @(circle.like_num.integerValue + 1);
                              }
                              [SVProgressHUD showSuccessWithStatus:info[@"message"]];
                              [self.tableView reloadData];
                          }
                      }
                  }];
    }
}

- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickCommentBtn:(XFCircleContentCellModel *)model {
    if ([self isNotLogin]) {
        [self showLoginController];
        return;
    }
    XFCircleDetailViewController *controller = [[XFCircleDetailViewController alloc] init];
    controller.circleId = model.circle.id;
    controller.showComment = YES;
    [self pushController:controller];
}

- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickVideoView:(XFCircleContentCellModel *)model {
    XFPlayVideoController *controller = [[XFPlayVideoController alloc] init];
    controller.videoUrl = model.circle.video;
    [self pushController:controller];
}

- (void)friendCircleCell:(XFFriendCircleCell *)cell didTapPicView:(NSInteger)index model:(XFCircleContentCellModel *)model {
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

#pragma mark - -------------------<XFCircleShareViewDelegate>-------------------
- (void)circleShareView:(XFCircleShareView *)view didClick:(CircleShareBtnType)type {
    FFLogFunc
}

#pragma mark ----------Lazy----------
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = WhiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[XFFriendCircleCell class] forCellReuseIdentifier:@"XFFriendCircleCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end

