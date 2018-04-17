//
//  XFPlayVideoController.m
//  FateCircle
//
//  Created by 王文利 on 2017/10/16.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFPlayVideoController.h"
#import <AVFoundation/AVFoundation.h>

@interface XFPlayVideoController ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation XFPlayVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backBtn = [UIButton xf_imgButtonWithImgName:@"nav_icon_fh_w" target:self action:@selector(backBtnClick)];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    [self.view addSubview:backBtn];
    self.view.backgroundColor = [UIColor blackColor];
    


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // 通知主线程刷新
            if (self.localUrl.absoluteString.length) {
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.localUrl];
                _player = [AVPlayer playerWithPlayerItem:playerItem];
            } else {
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.videoUrl]];
                _player = [AVPlayer playerWithPlayerItem:playerItem];
            }
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
            playerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [self.view.layer insertSublayer:playerLayer atIndex:0];
            [_player play];
        });
    });
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
