//
//  XFPublishViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFPublishViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "XFPlayVideoController.h"
#import "XFLocationViewController.h"

@interface XFPublishViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, TZImagePickerControllerDelegate, AMapSearchDelegate>

@property (nonatomic, weak) XFTextView *textView;
@property (nonatomic, weak) UILabel *countLabel;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSURL *videoPath;
@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation XFPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    self.photos = [NSMutableArray array];
    self.assets = [NSMutableArray array];
    UIView *navView = [UIView xf_themeNavView:@"缘分圈"
                                   backTarget:self
                                   backAction:@selector(backBtnClick)];
    
    UIButton *publishBtn = [UIButton xf_titleButtonWithTitle:@"发布"
                                                  titleColor:WhiteColor
                                                   titleFont:Font(15)
                                                      target:self
                                                      action:@selector(publishBtnClick)];
    publishBtn.frame = CGRectMake(kScreenWidth - 65, 20, 65, 44);
    
    [navView addSubview:publishBtn];
    [self.view addSubview:navView];
    
    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, navView.bottom, kScreenWidth, 5);
    [self.view addSubview:paddingView];
    
    XFTextView *textView = [[XFTextView alloc] initWithFrame:CGRectMake(20, paddingView.bottom + 10, kScreenWidth - 40, 160)];
    self.textView = textView;
    textView.placeholder = @"这一刻的想法...";
    textView.placeholderColor = RGBGray(204);
    textView.font = Font(13);
    textView.delegate = self;
    [self.view addSubview:textView];
    
    UILabel *countLabel = [UILabel xf_labelWithFont:Font(13)
                                          textColor:RGBGray(153)
                                      numberOfLines:1
                                          alignment:NSTextAlignmentRight];
    self.countLabel = countLabel;
    countLabel.text = @"0/140";
    countLabel.frame = CGRectMake(15, textView.bottom, kScreenWidth - 30, 40);
    [self.view addSubview:countLabel];
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(15, countLabel.bottom, kScreenWidth - 30, 0.5);
    [self.view addSubview:splitView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.frame = CGRectMake(15, splitView.bottom + 20, kScreenWidth - 15, 115);
    [self.view addSubview:scrollView];
    
    [self setupScrollView];
    
    UIImageView *locationView = [[UIImageView alloc] initWithImage:Image(@"icon_dw_h")];
    locationView.userInteractionEnabled = YES;
    [locationView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationViewTap)]];
    locationView.left = 15;
    locationView.top = self.scrollView.bottom + 25;
    [self.view addSubview:locationView];
    
    UILabel *label = [UILabel xf_labelWithFont:Font(13) textColor:BlackColor numberOfLines:1 alignment:NSTextAlignmentLeft];
    self.locationLabel = label;
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationViewTap)]];
    label.text = @"高新软件园";
    label.left = locationView.right + 5;
    label.height = 13;
    label.centerY = locationView.centerY;
    label.width = kScreenWidth - 15 - label.left;
    [self.view addSubview:label];
    
    [self getLocation];
}

- (void)getLocation {
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    NSString *latitude = [UserDefaults stringForKey:XFCurrentLatitudeKey];
    NSString *longitude = [UserDefaults stringForKey:XFCurrentLongitudeKey];
    regeo.location = [AMapGeoPoint locationWithLatitude:latitude.floatValue longitude:longitude.floatValue];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    FFLog(@"%@", response);
}

- (void)locationViewTap {
    XFLocationViewController *controller = [[XFLocationViewController alloc] init];
    [self pushController:controller];
}

- (void)setupScrollView {
    [self.scrollView removeAllSubviews];
    CGFloat itemH = 85;
    if (self.photos.count) {
        CGFloat maxX = 0;
        for (int i = 0; i < self.photos.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.userInteractionEnabled = YES;
            imgView.tag = i;
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewTap:)]];
            imgView.clipsToBounds = YES;
            imgView.image = self.photos[i];
            imgView.size = CGSizeMake(itemH, itemH);
            imgView.left = maxX;
            imgView.top = 15;
            maxX = imgView.right + 15;
            [self.scrollView addSubview:imgView];
            
            UIButton *btn = [UIButton xf_imgButtonWithImgName:@"icon_tp_sc" target:self action:@selector(deleteImgBtnClick:)];
            btn.size = CGSizeMake(16, 16);
            btn.centerX = imgView.right;
            btn.centerY = imgView.top;
            btn.tag = i;
            [self.scrollView addSubview:btn];
        }
        
        if (self.photos.count < 9) {
            UIButton *addBtn = [UIButton xf_imgButtonWithImgName:@"bg_tj"
                                                          target:self
                                                          action:@selector(addBtnClick)];
            addBtn.frame = CGRectMake(maxX, 15, itemH, itemH);
            [self.scrollView addSubview:addBtn];
            maxX = addBtn.right + 15;
        }
        self.scrollView.contentSize = CGSizeMake(maxX, 0);
    } else if (self.videoPath.absoluteString.length) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoViewTap)]];
        imgView.clipsToBounds = YES;
        imgView.image = [self getTheVideoPic];
        imgView.size = CGSizeMake(itemH, itemH);
        imgView.left = 0;
        imgView.top = 15;
        [self.scrollView addSubview:imgView];
        
        UIButton *btn = [UIButton xf_imgButtonWithImgName:@"icon_tp_sc" target:self action:@selector(deleteVideoBtnClick)];
        btn.size = CGSizeMake(16, 16);
        btn.centerX = imgView.right;
        btn.centerY = imgView.top;
        [self.scrollView addSubview:btn];
    } else {
        UIButton *addBtn = [UIButton xf_imgButtonWithImgName:@"bg_tj"
                                                      target:self
                                                      action:@selector(addBtnClick)];
        addBtn.frame = CGRectMake(0, 15, itemH, itemH);
        [self.scrollView addSubview:addBtn];
    }
}

- (void)deleteImgBtnClick:(UIButton *)btn {
    [self.photos removeObjectAtIndex:btn.tag];
    [self.assets removeObjectAtIndex:btn.tag];
    [self setupScrollView];
}

- (void)deleteVideoBtnClick {
    self.videoPath = nil;
    [self setupScrollView];
}

- (UIImage *)getTheVideoPic {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}

- (void)imgViewTap:(UITapGestureRecognizer *)ges {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.assets
                                                                                      selectedPhotos:self.photos
                                                                                               index:ges.view.tag];
    imagePickerVc.maxImagesCount = 9;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.photos = [NSMutableArray arrayWithArray:photos];
        self.assets = [NSMutableArray arrayWithArray:assets];
        [self setupScrollView];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)videoViewTap {
    XFPlayVideoController *controller = [[XFPlayVideoController alloc] init];
    controller.localUrl = self.videoPath;
    [self pushController:controller];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.countLabel.text = [NSString stringWithFormat:@"%tu/140", textView.text.length];
    if (textView.text.length >= 140) {
        textView.text = [textView.text substringToIndex:139];
    }
}


#pragma mark ----------Action----------
- (void)publishBtnClick {
    FFLogFunc
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.textView.text.length == 0) {
        FFLog(@"内容为空");
        return;
    }
    dict[@"talk_content"] = self.textView.text;
    if (self.locationLabel.text.length) {
        dict[@"address"] = self.locationLabel.text;
    }
    
    if (self.videoPath.absoluteString.length) {
        dict[@"upload_type"] = @"2";
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:self.videoPath
                      resultBlock:^(ALAsset *asset) {
                          ALAssetRepresentation *rep = [asset defaultRepresentation];
                          Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                          NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                          NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                          dict[@"video"] = [data base64EncodedString];
                          [HttpRequest postPath:XFCirclePublishUrl
                                         params:dict
                                    resultBlock:^(id responseObject, NSError *error) {
                                        FFLog(@"%@", responseObject);
                                    }];
                          
                      } failureBlock:^(NSError *error) {
                      }];
    } else {
        dict[@"upload_type"] = @"1";
        NSMutableString *str = [NSMutableString string];
        if (self.photos.count) {
            for (int i = 0; i < self.photos.count; i++) {
                UIImage *img = self.photos[i];
                NSData *data = UIImagePNGRepresentation(img);
                [str appendString:[data base64EncodedString]];
                if (i < self.photos.count - 1) {
                    [str appendString:@","];
                }
            }
        }
        dict[@"image"] = str.copy;
        [HttpRequest postPath:XFCirclePublishUrl
                       params:dict
                  resultBlock:^(id responseObject, NSError *error) {
                      FFLog(@"%@", responseObject);
                  }];
    }
    
}

- (void)addBtnClick {
    [self.textView resignFirstResponder];
    if (self.photos.count) {
        [self shoeImagePickerViewController];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择上传类型"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                   
                                                         handler:^(UIAlertAction * action) {}];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"传照片" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        [self shoeImagePickerViewController];
    }];
    
    UIAlertAction *movieAction = [UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.allowsEditing = NO;
        controller.mediaTypes = @[(NSString *)kUTTypeMovie];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        controller.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        [self presentViewController:controller animated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:libraryAction];
    [alertController addAction:movieAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)shoeImagePickerViewController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9
                                                                                        columnNumber:4
                                                                                            delegate:self
                                                                                   pushPhotoPickerVc:YES];
    if (self.assets.count) {
        imagePickerVc.selectedAssets = self.assets;
    }
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.navigationBar.barTintColor = ThemeColor;
    imagePickerVc.navigationBar.translucent = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO;
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.isStatusBarDefault = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - -------------------TZImagePickerControllerDelegate-------------------
- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    self.photos = [NSMutableArray arrayWithArray:photos];
    self.assets = [NSMutableArray arrayWithArray:assets];
    [self setupScrollView];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){ //如果是录制视频
        NSURL * url = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *urlStr = [url path];
        ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:urlStr]
                                          completionBlock:^(NSURL *assetURL, NSError *error) {
                                              self.videoPath = assetURL;
                                              self.photos = [NSMutableArray array];
                                              self.assets = [NSMutableArray array];
                                              [self setupScrollView];
                                          }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

