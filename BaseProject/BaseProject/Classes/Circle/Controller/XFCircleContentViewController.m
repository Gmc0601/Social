//
//  XFCircleContentViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleContentViewController.h"
#import "XFCircleSuggestCell.h"
#import "XFCircleContentCell.h"
#import "XFCircleContentCellModel.h"
#import "XFCircleDetailViewController.h"
#import "XFPlayVideoController.h"


@interface XFCircleContentViewController ()<UITableViewDelegate, UITableViewDataSource, XFCircleContentCellDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *suggestArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *photosArray;

@end

@implementation XFCircleContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.view.backgroundColor = RandomColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat tableViewH = kScreenHeight - XFTabHeight - XFNavHeight - XFCircleTabHeight;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, tableViewH);
    self.tableView.mj_header = [XFRefreshTool xf_header:self action:@selector(loadData)];
    self.tableView.mj_footer = [XFRefreshTool xf_footer:self action:@selector(loadMoreData)];
    self.currentPage = 1;
}

- (void)loadData {
    WeakSelf
    self.currentPage = 1;
    [HttpRequest postPath:[self getTheUrl]
                   params:[self getTheParams]
              resultBlock:^(id responseObject, NSError *error) {
                  [weakSelf.tableView.mj_header endRefreshing];
                  weakSelf.dataArray = [NSMutableArray array];
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          weakSelf.currentPage ++;
                          NSArray *infoArray = responseObject[@"info"];
                          for (int i = 0 ; i < infoArray.count; i++) {
                              NSDictionary *dict = infoArray[i];
                              XFCircleContentCellModel *model = [[XFCircleContentCellModel alloc] initWithCircle:[Circle mj_objectWithKeyValues:dict] andType:CircleContentModelType_Home];
                              [weakSelf.dataArray addObject:model];
                          }
                          if (infoArray.count < 10) {
                              [self.tableView.mj_footer endRefreshingWithNoMoreData];
                          } else {
                              [self.tableView.mj_footer endRefreshing];
                          }
                          [self.tableView reloadData];
                      }
                  }
              }];
    
    if (self.type == CircleContentType_Hot) {
        [HttpRequest postPath:XFCircleSuggestUrl
                       params:nil
                  resultBlock:^(id responseObject, NSError *error) {
                      weakSelf.suggestArray = [NSMutableArray array];
                      if (!error) {
                          NSNumber *errorCode = responseObject[@"error"];
                          if (errorCode.integerValue == 0) {
                              NSArray *infoArray = responseObject[@"info"];
                              if ([infoArray hasContent]) {
                                  [weakSelf.suggestArray addObjectsFromArray:[User mj_objectArrayWithKeyValuesArray:infoArray]];
                              }
                              [self.tableView reloadData];
                          }
                      }
                  }];
    }
}

- (void)loadMoreData {
    WeakSelf
    [HttpRequest postPath:[self getTheUrl]
                   params:[self getTheParams]
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          weakSelf.currentPage ++;
                          NSArray *infoArray = responseObject[@"info"];
                          for (int i = 0 ; i < infoArray.count; i++) {
                              NSDictionary *dict = infoArray[i];
                              XFCircleContentCellModel *model = [[XFCircleContentCellModel alloc] initWithCircle:[Circle mj_objectWithKeyValues:dict] andType:CircleContentModelType_Home];
                              [weakSelf.dataArray addObject:model];
                          }
                          if (infoArray.count < 10) {
                              [self.tableView.mj_footer endRefreshingWithNoMoreData];
                          } else {
                              [self.tableView.mj_footer endRefreshing];
                          }
                          [self.tableView reloadData];
                      }
                  }
              }];
}

#pragma mark ----------<UITableViewDataSource>----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.suggestArray.count ? 1 : 0;
    } else if (section == 1) {
        return self.dataArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XFCircleSuggestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCircleSuggestCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.suggestArray = self.suggestArray;
        return cell;
    } else {
        XFCircleContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCircleContentCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
}

#pragma mark ----------<UITableViewDelegate>----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [XFCircleSuggestCell cellHeight];
    } else {
        XFCircleContentCellModel *model = self.dataArray[indexPath.row];
        return model.cellH;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    
    XFCircleContentCellModel *model = self.dataArray[indexPath.row];
    XFCircleDetailViewController *controller = [[XFCircleDetailViewController alloc] init];
    controller.circleId = model.circle.id;
    [self pushController:controller];
}

#pragma mark ----------<XFCircleContentCellDelegate>----------
- (void)circleContentCell:(XFCircleContentCell *)cell didClickIconView:(XFCircleContentCellModel *)model {
    FFLogFunc
}

- (void)circleContentCell:(XFCircleContentCell *)cell didClickFollowBtn:(XFCircleContentCellModel *)model {
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
                              [self.tableView reloadData];
                          }
                      }
                  }];
    }
}

- (void)circleContentCell:(XFCircleContentCell *)cell didClickRewardBtn:(XFCircleContentCellModel *)model {
    FFLogFunc
}

- (void)circleContentCell:(XFCircleContentCell *)cell didClickShareBtn:(XFCircleContentCellModel *)model {
    FFLogFunc
}

- (void)circleContentCell:(XFCircleContentCell *)cell didClickZanBtn:(XFCircleContentCellModel *)model {
    Circle *circle = model.circle;
    if (circle.id) {
        NSString *type = circle.like_status.integerValue == 2 ? @"1" : @"2";
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
                                  circle.like_num = @(circle.like_num.integerValue + 1);
                              } else {
                                  if (circle.like_num.integerValue > 1) {
                                      circle.like_num = @(circle.like_num.integerValue - 1);
                                  }
                              }
                              [SVProgressHUD showSuccessWithStatus:info[@"message"]];
                              [self.tableView reloadData];
                          }
                      }
                  }];
    }
}

- (void)circleContentCell:(XFCircleContentCell *)cell didClickCommentBtn:(XFCircleContentCellModel *)model {
    FFLogFunc
}

- (void)circleContentCell:(XFCircleContentCell *)cell didClickVideoView:(XFCircleContentCellModel *)model {
    XFPlayVideoController *controller = [[XFPlayVideoController alloc] init];
    controller.videoUrl = model.circle.video;
    [self pushController:controller];
}

- (void)circleContentCell:(XFCircleContentCell *)cell didTapPicView:(NSInteger)index model:(XFCircleContentCellModel *)model {
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

#pragma mark ----------Private----------
- (NSString *)getTheUrl {
    if (self.type == CircleContentType_Hot) {
        return XFCircleHotUrl;
    } else if (self.type == CircleContentType_Near) {
        return XFCircleNearUrl;
    } else if (self.type == CircleContentType_New) {
        return XFCircleNewUrl;
    } else if (self.type == CircleContentType_Follow) {
        return XFCircleMyFollowUrl;
    } else {
        return @"";
    }
}

- (NSDictionary *)getTheParams {
    if (self.type == CircleContentType_Near) {
        NSString *latitude = [UserDefaults stringForKey:XFCurrentLatitudeKey];
        NSString *longitude = [UserDefaults stringForKey:XFCurrentLongitudeKey];
        if (latitude.length && longitude.length) {
            return @{@"page" : [NSString stringWithFormat:@"%zd", self.currentPage],
                     @"size" : XFDefaultPageSize,
                     @"long" : latitude,
                     @"lat"  : longitude};
        }
    }
    return @{@"page" : [NSString stringWithFormat:@"%zd", self.currentPage],
             @"size" : XFDefaultPageSize};
}

#pragma mark ----------Lazy----------
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = PaddingColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [_tableView registerClass:[XFCircleSuggestCell class] forCellReuseIdentifier:@"XFCircleSuggestCell"];
        [_tableView registerClass:[XFCircleContentCell class] forCellReuseIdentifier:@"XFCircleContentCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end

