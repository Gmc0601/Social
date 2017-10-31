//
//  XFCircleRewardViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleRewardViewController.h"

@interface XFCircleRewardViewController ()

@end

@implementation XFCircleRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [UILabel xf_labelWithFont:Font(12) textColor:BlackColor numberOfLines:0 alignment:NSTextAlignmentLeft];
    label.text = @"没有找到服务器返回的打赏的内容，'_particulars_001' 接口里面没有，也没看到单独的接口";
    label.frame = CGRectMake(0, 0, kScreenWidth, 50);
    [self.view addSubview:label];
}

- (CGFloat)scrollOffset {
    return 0;
}

@end
