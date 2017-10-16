//
//  XFMyAlbumViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/27.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFMyAlbumViewController.h"

@interface XFMyAlbumCell : UICollectionViewCell

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation XFMyAlbumCell

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

@interface XFMyAlbumViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation XFMyAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (CGFloat)scrollOffset {
    return _collectionView.contentOffset.y;
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFMyAlbumUrl
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  weakSelf.dataArray = [NSMutableArray array];
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0){
                          NSDictionary *info = responseObject[@"info"];
                          if ([info isKindOfClass:[NSDictionary class]]) {
                              NSArray *dataArray = info[@"img"];
                              [weakSelf.dataArray addObjectsFromArray:dataArray];
                          }
                      }
                      [self.collectionView reloadData];
                  }
              }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
        [cell removeAllSubviews];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:Image(@"bg_tj")];
        imgView.frame = cell.bounds;
        [cell addSubview:imgView];
        return cell;
    } else {
        XFMyAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFMyAlbumCell" forIndexPath:indexPath];
        cell.url = self.dataArray[indexPath.item - 1];
        cell.backgroundColor = RandomColor;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        FFLog(@"添加相册");
    } else {
        FFLog(@"点击图片");
    }
}

#pragma mark ----------Lazy----------
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - XFCircleTabHeight - XFNavHeight)
                                             collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.contentInset = UIEdgeInsetsMake(17, 17, 17, 17);
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_collectionView registerClass:[XFMyAlbumCell class] forCellWithReuseIdentifier:@"XFMyAlbumCell"];
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
