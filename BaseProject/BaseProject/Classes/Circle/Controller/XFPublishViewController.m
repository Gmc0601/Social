//
//  XFPublishViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFPublishViewController.h"

@interface XFPublishViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) XFTextView *textView;
@property (nonatomic, weak) UILabel *countLabel;

@end

@implementation XFPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
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
    
    UIButton *addBtn = [UIButton xf_imgButtonWithImgName:@"bg_tj"
                                                  target:self
                                                  action:@selector(addBtnClick)];
    addBtn.frame = CGRectMake(15, splitView.bottom + 20, 85, 85);
    [self.view addSubview:addBtn];
}


#pragma mark ----------Action----------
- (void)publishBtnClick {
    FFLogFunc
}

- (void)addBtnClick {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择照片来源"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                   
                                                         handler:^(UIAlertAction * action) {}];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {                                                                     UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        controller.allowsEditing = NO;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍摄照片" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.delegate = self;
            controller.allowsEditing = NO;
            controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:controller animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *movieAction = [UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.allowsEditing = NO;
        controller.mediaTypes = @[(NSString *)kUTTypeMovie];
        controller.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        controller.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:libraryAction];
    [alertController addAction:cameraAction];
    [alertController addAction:movieAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
