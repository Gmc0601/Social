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

@interface XFMyAlbumViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, MWPhotoBrowserDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *photosArray;

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
        self.photosArray = [NSMutableArray array];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        for (int i = 0; i < self.dataArray.count; i++) {
            [self.photosArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:self.dataArray[i]]]];
        }
        browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
        browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        [browser setCurrentPhotoIndex:indexPath.item];
        [browser showNextPhotoAnimated:YES];
        [browser showPreviousPhotoAnimated:YES];
        
        // Present
        [self.navigationController pushViewController:browser animated:YES];
    }
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

