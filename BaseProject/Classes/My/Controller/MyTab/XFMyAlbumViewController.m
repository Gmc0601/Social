//
//  XFMyAlbumViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/27.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFMyAlbumViewController.h"

@interface XFMyAlbumCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *imgDict;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation XFMyAlbumCell

- (void)setImgDict:(NSDictionary *)imgDict {
    _imgDict = imgDict;
    [self.imgView setImageURL:[NSURL URLWithString:imgDict[@"img"]]];
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

@interface XFMyAlbumViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, MWPhotoBrowserDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *photosArray;

@end

@implementation XFMyAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNotification];
    [self loadData];
}

- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:XFLoginSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:XFLogoutSuccessNotification
                                               object:nil];
}

- (void)loginSuccess {
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
                          NSArray *infoArray = responseObject[@"info"];
                          if ([infoArray isKindOfClass:[NSArray class]] && infoArray.count) {
                              for (int i = 0; i < infoArray.count; i++) {
                                  NSDictionary *imgDict = infoArray[i];
                                  if ([imgDict isKindOfClass:[NSDictionary class]] && imgDict.allKeys.count) {
                                      [self.dataArray addObject:imgDict];
                                  }
                              }
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
    if ([self isNotLogin]) {
        return 0;
    } else {
        return self.dataArray.count + 1;
    }
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
        cell.imgDict = self.dataArray[indexPath.item - 1];
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择上传类型"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                       
                                                             handler:^(UIAlertAction * action) {}];
        UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.delegate = self;
            controller.allowsEditing = NO;
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:controller animated:YES completion:nil];
        }];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍摄照片" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.delegate = self;
            controller.allowsEditing = NO;
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:controller animated:YES completion:nil];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:libraryAction];
        [alertController addAction:cameraAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        self.photosArray = [NSMutableArray array];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        for (int i = 0; i < self.dataArray.count; i++) {
            NSDictionary *imgDict = self.dataArray[i];
            [self.photosArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imgDict[@"img"]]]];
        }
        browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
        browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        [browser setCurrentPhotoIndex:indexPath.item - 1];
        [browser showNextPhotoAnimated:YES];
        [browser showPreviousPhotoAnimated:YES];
        
        // Present
        [self.navigationController pushViewController:browser animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [SVProgressHUD show];
    WeakSelf
    // 相册上传图片压缩60%
    [HttpRequest postPath:XFMyAlbumUploadUrl
                   params:@{@"img" : [UIImageJPEGRepresentation(image, 0.6) base64EncodedString]}
              resultBlock:^(id responseObject, NSError *error) {
                  [SVProgressHUD dismiss];
                  NSNumber *code = responseObject[@"error"];
                  if (code.integerValue == 0) {
                      [ConfigModel mbProgressHUD:@"上传成功" andView:nil];
                      NSDictionary *infoDict = responseObject[@"info"];

                      if (infoDict && [infoDict isKindOfClass:[NSDictionary class]] && infoDict.allKeys.count) {
                          [weakSelf loadData];
                      }
                  } else {
                      [ConfigModel mbProgressHUD:@"上传失败" andView:nil];
                  }
              }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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

