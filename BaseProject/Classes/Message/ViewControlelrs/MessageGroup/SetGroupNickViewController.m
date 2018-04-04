//
//  SetGroupNickViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/12.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "SetGroupNickViewController.h"
#import <YYKit.h>

@interface SetGroupNickViewController ()

@property (nonatomic, strong) UIButton *setBtn;

@property (nonatomic, strong) UITextField *nicktext;

@property (nonatomic, strong) UILabel *linenum;


@end

@implementation SetGroupNickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = @"群聊名称";
    self.rightBar.hidden = YES;
    
    self.nicktext = [[UITextField alloc] initWithFrame:FRAME(15, 64 + SizeHeigh(10), kScreenW - 30, SizeHeigh(20))];
    if (self.nickName) {
        self.nicktext.text =  self.nickName;
    }
    [self.view addSubview:self.nicktext];
    
    self.linenum = [[UILabel alloc]initWithFrame:FRAME(15, self.nicktext.bottom + 1, kScreenW - 30, 1)];
    self.linenum.backgroundColor = UIColorHex(0x666666);
    [self.view addSubview:self.linenum];
    
    
    self.setBtn = [[UIButton alloc] initWithFrame:FRAME(15, self.linenum.bottom + SizeHeigh(10), kScreenW -  30, SizeHeigh(45))];
    [self.setBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.setBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    self.setBtn.backgroundColor = ThemeColor;
    self.setBtn.layer.masksToBounds = YES;
    self.setBtn.layer.cornerRadius = 5;
    [self.view addSubview:self.setBtn];
    
    
}

- (void)finish {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
