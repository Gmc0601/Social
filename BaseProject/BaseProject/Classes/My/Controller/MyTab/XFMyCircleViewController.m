//
//  XFMyCircleViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/27.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFMyCircleViewController.h"
#import "XFCircleContentCellModel.h"
#import "XFFriendCircleCell.h"
#import "XFCircleDetailViewController.h"
#import "XFPlayVideoController.h"

@interface XFMyCircleViewController ()<UITableViewDataSource, UITableViewDelegate, XFFriendCircleCellDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *photosArray;

@end

@implementation XFMyCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupNotification];
}

- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:XFLoginSuccessNotification
                                               object:nil];
}

- (void)loginSuccess {
    [self loadData];
}

- (CGFloat)scrollOffset {
    return _tableView.contentOffset.y;
}

- (void)setupUI {
    self.view.backgroundColor = RandomColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - XFCircleTabHeight - XFNavHeight);
    [self loadData];
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFMyCircleUrl
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  weakSelf.dataArray = [NSMutableArray array];
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSArray *infoArray = responseObject[@"info"];
                          for (int i = 0 ; i < infoArray.count; i++) {
                              NSDictionary *dict = infoArray[i];
                              Circle *circle = [Circle mj_objectWithKeyValues:dict];
                              circle.isMine = YES;
                              XFCircleContentCellModel *model = [[XFCircleContentCellModel alloc] initWithCircle:circle andType:CircleContentModelType_My];
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
    if (model.circle.id) {
        XFCircleDetailViewController *controller = [[XFCircleDetailViewController alloc] init];
        controller.circleId = model.circle.id;
        [self pushController:controller];
    }
}

#pragma mark ----------<XFFriendCircleCellDelegate>----------
- (void)friendCircleCell:(XFFriendCircleCell *)cell didClickDeleteBtn:(XFCircleContentCellModel *)model {
    NSNumber *circleId = model.circle.id;
    if (circleId.integerValue <= 0) {
        return;
    }
    [HttpRequest postPath:XFMyCircleDeleteUrl
                   params:@{@"id" : circleId}
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                          [self.dataArray removeObject:model];
                          [self.tableView reloadData];
                      }
                  }
              }];
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

