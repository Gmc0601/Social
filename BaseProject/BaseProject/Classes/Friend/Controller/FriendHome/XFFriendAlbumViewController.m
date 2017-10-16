//
//  XFFriendAlbumViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFFriendAlbumViewController.h"

@interface XFFriendAlbumCell : UICollectionViewCell

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation XFFriendAlbumCell

- (void)setUrl:(NSString *)url {
    _url = url;
    [self.imgView setImageURL:[NSURL URLWithString:url]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgView.frame = self.bounds;
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        [self.contentView addSubview:_imgView];
    }
    return _imgView;
}

@end


@interface XFFriendAlbumViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation XFFriendAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (CGFloat)scrollOffset {
    return _collectionView.contentOffset.y;
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFFriendAlbumUrl
                   params:@{@"id" : self.friendId}
              resultBlock:^(id responseObject, NSError *error) {
                  weakSelf.dataArray = [NSMutableArray array];
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0){
                          NSDictionary *info = responseObject[@"info"];
                          NSArray *dataArray = info[@"img"];
                          [weakSelf.dataArray addObjectsFromArray:dataArray];
                      }
                      [self.collectionView reloadData];
                  }
              }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XFFriendAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFFriendAlbumCell" forIndexPath:indexPath];
    cell.url = self.dataArray[indexPath.item];
    cell.backgroundColor = RandomColor;
    return cell;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - XFCircleTabHeight - XFNavHeight - XFFriendBottomChatHeight)
                                             collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.contentInset = UIEdgeInsetsMake(17, 17, 17, 17);
        [_collectionView registerClass:[XFFriendAlbumCell class] forCellWithReuseIdentifier:@"XFFriendAlbumCell"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 7;
        _layout.minimumLineSpacing = 7;
        CGFloat itemW = floorf((kScreenWidth  - 17 * 2 - 7 * 2) / 3);
        _layout.itemSize = CGSizeMake(itemW, itemW);
    }
    return _layout;
}

@end
