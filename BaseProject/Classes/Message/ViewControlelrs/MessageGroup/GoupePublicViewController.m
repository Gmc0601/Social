//
//  GoupePublicViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/12.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GoupePublicViewController.h"
#import <YYKit.h>
#import "UILabel+Width.h"

@interface GoupePublicViewController ()

@property (nonatomic, strong) UIImageView *headImage, *icon;

@property (nonatomic, strong) UILabel *nickLab, *timeLab, *linenum;

@property (nonatomic, strong) UITextView *text;

@end

@implementation GoupePublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"群公告";
    self.rightBar.hidden = YES;
    [self setUI];
    
}

- (void)setUI {
    
    self.headImage = [[UIImageView alloc] initWithFrame:FRAME(SizeWidth(10), 64 + SizeHeigh(10), SizeWidth(40), SizeHeigh(45))];
    self.headImage.image = [UIImage imageNamed:@""];
    [self.view addSubview:self.headImage];
    
    self.nickLab = [[UILabel alloc] initWithFrame:FRAME(self.headImage.right + SizeWidth(10), self.headImage.top + SizeHeigh(5), 50, SizeHeigh(15))];
    self.nickLab.font =  [UIFont systemFontOfSize:15];
    float width = [UILabel getWidthWithTitle:@"" font:[UIFont systemFontOfSize:15]];
    [self.nickLab setWidth:width];
    [self.view addSubview:self.nickLab];
    
    self.icon = [[UIImageView alloc] initWithFrame:FRAME(self.nickLab.right + SizeWidth(5), self.headImage.top + SizeHeigh(5), SizeWidth(35), SizeHeigh(15))];
    self.icon.image = [UIImage imageNamed:@""];
    [self.view addSubview:self.icon];
    
    self.timeLab = [[UILabel alloc] initWithFrame:FRAME(self.headImage.right, self.nickLab.bottom + SizeHeigh(5), kScreenW , SizeHeigh(15))];
    self.timeLab.font = [UIFont systemFontOfSize:13];
    self.timeLab.textColor = UIColorHex(0x666666);
    [self.view addSubview:self.timeLab];
    
    self.line = [[UILabel alloc] initWithFrame:FRAME(10, self.headImage.bottom + SizeHeigh(10), kScreenW - 20, 1)];
    self.line.backgroundColor = UIColorHex(0x333333);
    [self.view addSubview:self.line];
    
    self.text = [[UITextView alloc] initWithFrame:FRAME(15, self.line.bottom + SizeHeigh(10), kScreenW - 30, SizeHeigh(300))];
    self.text.userInteractionEnabled = NO;
    self.text.text = @"dfasdfasdfasdfasdfasdfasdfasdfasdfase";
    self.text.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.text];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
