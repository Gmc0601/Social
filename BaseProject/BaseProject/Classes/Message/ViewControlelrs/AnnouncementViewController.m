//
//  AnnouncementViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AnnouncementViewController.h"

@interface AnnouncementViewController ()

@end

@implementation AnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"公告详情";
    self.rightBtn.hidden= YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
