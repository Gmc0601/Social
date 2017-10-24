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
    
    if (self.localUrl.absoluteString.length) {
        _player = [AVPlayer playerWithURL:self.localUrl];
    } else {
        NSURL *url = [NSURL fileURLWithPath:self.videoUrl];
        _player = [AVPlayer playerWithURL:url];
    }
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view.layer insertSublayer:playerLayer atIndex:0];
    [_player play];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
