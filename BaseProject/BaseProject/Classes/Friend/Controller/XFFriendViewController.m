//
//  XFFriendViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/18.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFFriendViewController.h"
#import "XFFriendCell.h"
#import "XFFriendFilterView.h"
#import "XFSeniorFilterViewController.h"
#import "XFFriendHomeViewController.h"

@interface XFFriendViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, XFFriendFilterViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation XFFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    UIView *navView = [UIView xf_createWhiteView];
    navView.frame = CGRectMake(0, 0, kScreenWidth, XFNavHeight);
    navView.backgroundColor = ThemeColor;
    [self.view addSubview:navView];
    
    UIView *fileterView = [UIView xf_createWhiteView];
    fileterView.frame = CGRectMake(0, XFNavHeight, kScreenWidth, 33);
    [self.view addSubview:fileterView];
    
    CGFloat itemW = kScreenWidth * 0.25;
    for (int i = 0; i < 4; i++) {
        NSString *imgName = i == 3 ? @"icon_yyr_sx" : @"list_ic_2_0";
        NSString *title = @"";
        if (i == 0) {
            title = @"附近";
        } else if (i == 1) {
            title = @"性别";
        } else if (i == 2) {
            title = @"魅力值";
        } else if (i == 3) {
            title = @"高级筛选";
        }
        
        XFLRButton *button = [XFLRButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:BlackColor forState:UIControlStateNormal];
        [button setImage:Image(imgName) forState:UIControlStateNormal];
        button.titleLabel.font = Font(13);
        [button addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        button.width = itemW;
        button.height = fileterView.height;
        button.top = 0;
        button.left = i * itemW;
        [fileterView addSubview:button];
    }
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(0, fileterView.height - 0.5, fileterView.width, 0.5);
    [fileterView addSubview:splitView];
    [self.collectionView reloadData];
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFFriendHomeUrl
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  weakSelf.dataArray = [NSMutableArray array];
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSArray *infoArray = responseObject[@"info"];
                          for (int i = 0 ; i < infoArray.count; i++) {
                              NSDictionary *dict = infoArray[i];
                              User *user = [User mj_objectWithKeyValues:dict];
                              [weakSelf.dataArray addObject:user];
                          }
                          [self.collectionView reloadData];
                      }
                  }
    }];
}

- (NSDictionary *)getTheParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    
    
    
    
    return dict;
}

#pragma mark ----------<UICollectionViewDataSource>----------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XFFriendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFFriendCell" forIndexPath:indexPath];
    cell.backgroundColor = WhiteColor;
    cell.user = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XFFriendHomeViewController *controller = [[XFFriendHomeViewController alloc] init];
    User *user = self.dataArray[indexPath.item];
    controller.friendId = user.id;
    [self pushController:controller];
}

#pragma mark ----------<XFFriendFilterViewDelegate>----------
- (void)friendFilterView:(XFFriendFilterView *)view didSelect:(NSString *)text {
    if (view.tag == 0) {
        
    }
}

#pragma mark ----------Action----------
- (void)filterBtnClick:(XFLRButton *)button {
    if (button.tag == 0) {
        XFFriendFilterView *view = [[XFFriendFilterView alloc] initWithDataArray:@[@"附近", @"1km", @"3km", @"4km", @"5km", @"10km", @"全城"]
                                                                     selectIndex:0];
        view.tag = 0;
        view.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    } else if (button.tag == 1) {
        XFFriendFilterView *view = [[XFFriendFilterView alloc] initWithDataArray:@[@"不限性别", @"男", @"女"]
                                                                     selectIndex:0];
        view.tag = 1;
        view.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    } else if (button.tag == 2) {
        XFFriendFilterView *view = [[XFFriendFilterView alloc] initWithCharmCount:2.3 tortoiseCount:3.5];
        view.tag = 3;
        view.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    } else if (button.tag == 3) {
        XFSeniorFilterViewController *controller = [[XFSeniorFilterViewController alloc] init];
        [self pushController:controller];
    }
}

#pragma mark ----------Private----------

#pragma mark ----------Lazy----------
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat top = XFNavHeight + XFFriendFilterHeight;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, top, kScreenWidth, kScreenHeight - top - XFTabHeight)
                                             collectionViewLayout:self.layout];
        [_collectionView registerClass:[XFFriendCell class] forCellWithReuseIdentifier:@"XFFriendCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = PaddingColor;
        _collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 5;
        _layout.minimumLineSpacing = 5;
        CGFloat itemW = floorf((kScreenWidth  - 15) * 0.5);
        CGFloat itemH = itemW * 1.25;
        _layout.itemSize = CGSizeMake(itemW, itemH);
    }
    return _layout;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
