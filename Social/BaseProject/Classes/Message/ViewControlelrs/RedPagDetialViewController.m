//
//  RedPagDetialViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/30.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "RedPagDetialViewController.h"

@interface RedPagDetialViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;

@end

@implementation RedPagDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationView.backgroundColor = [UIColor clearColor];
    self.line.hidden = YES;
    self.titleLab.text = @"红包详情";
    self.titleLab.textColor = [UIColor whiteColor];
    self.rightBar.hidden = YES;
    [self.leftBar setImage:[UIImage imageNamed:@"nav_icon_fh_w"] forState:UIControlStateNormal];
    
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 31;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:self.model.head] placeholderImage:nil];
    self.nicknameLab.text = self.model.nick;
    NSString *str;
    
    if (self.model.get) {
        str= @"对方已经领取";
    }else {
        str = @"等待对方领取";
    }
    
    NSString *info = [NSString stringWithFormat:@"红包金额%.2f积分，%@",[self.model.count floatValue] ,str];
    self.infoLab.text = info;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
