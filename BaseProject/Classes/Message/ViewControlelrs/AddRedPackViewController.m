//
//  AddRedPackViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/28.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AddRedPackViewController.h"
#import "XFRechrgeViewController.h"


@interface AddRedPackViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textfile;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *biliLab;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, copy) NSString *bili;

@end

@implementation AddRedPackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.leftBar setImage:[UIImage imageNamed:@"nav_icon_fh"] forState:UIControlStateNormal];
    self.titleLab.text = @"发红包";
    self.line.hidden = YES;
    self.rightBar.hidden = YES;
    self.textfile.keyboardType = UIKeyboardTypeNumberPad;
    [self.textfile addTarget:self action:@selector(change) forControlEvents:UIControlEventEditingChanged];
    
    
    [HttpRequest postPath:@"_hongbao_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            NSDictionary *info = datadic[@"info"];
            NSString *str = [NSString stringWithFormat:@"领取后平台抽取%@%@佣金", info[@"hongbao"], @"%"];
            self.bili = [NSString stringWithFormat:@"%@",info[@"hongbao"]];
            NSLog(@"...%@", self.bili);
            self.biliLab.text = str;
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
}

- (void)change {
    
    float count = [self.textfile.text floatValue] * (1 - [self.bili integerValue]*0.01);
    
    NSString *countstr = [NSString stringWithFormat:@"%.2f", count];
    
    NSLog(@"...%@", countstr);
    
    self.moneyLab.text = countstr;
    
}

- (IBAction)sendpack:(id)sender {
    
    NSDictionary *dic = @{
                          @"red_packet" : self.textfile.text,
                          @"mobile" : self.mobile
                          };
    
    [HttpRequest postPath:@"_let_contract_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            NSDictionary *info = datadic[@"info"];
            NSString *idStr = info[@"id"];
            if (self.moneybackBlock) {
                self.moneybackBlock(idStr);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            NSString *str = datadic[@"info"];
            [self showInfoView:str];
        }
    }];
    
    
    
    
}

- (void)showInfoView:(NSString *)info {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.infoView = view;
    UIButton *bgBtn = [UIButton xf_emptyButtonWithTarget:self action:@selector(dismiss)];
    bgBtn.backgroundColor = MaskColor;
    bgBtn.frame = view.bounds;
    [view addSubview:bgBtn];
    
    UIView *contentView = [UIView xf_createViewWithColor:RGBGray(249)];
    contentView.width = kScreenWidth > 320 ? 340 : 300;
    [contentView xf_cornerCut:5];
    [view addSubview:contentView];
    
    UILabel *label = [UILabel xf_labelWithFont:Font(14)
                                     textColor:BlackColor
                                 numberOfLines:1
                                     alignment:NSTextAlignmentCenter];
    label.text = info;
    label.frame = CGRectMake(0, 0, contentView.width, 110);
    [contentView addSubview:label];
    
    CGFloat btnW = (contentView.width - 60) * 0.5;
    UIButton *cancelBtn = [UIButton xf_buttonWithTitle:@"取消"
                                            titleColor:[UIColor blackColor]
                                             titleFont:Font(16)
                                               imgName:nil
                                                target:self
                                                action:@selector(cancelBtnClick)];
    cancelBtn.frame = CGRectMake(20, label.bottom, btnW, 42);
    cancelBtn.backgroundColor = RGBGray(241);
    [cancelBtn xf_cornerCut:2];
    [contentView addSubview:cancelBtn];
    
    UIButton *rightBtn = [UIButton xf_buttonWithTitle:@"充值"
                                           titleColor:[UIColor whiteColor]
                                            titleFont:Font(16)
                                              imgName:nil
                                               target:self
                                               action:@selector(rightBtnClick)];
    rightBtn.backgroundColor = ThemeColor;
    [rightBtn xf_cornerCut:2];
    rightBtn.frame = CGRectMake(cancelBtn.right + 20, label.bottom, btnW, 42);
    [contentView addSubview:rightBtn];
    
    contentView.height = rightBtn.bottom + 20;
    contentView.center = CGPointMake(KScreenWidth * 0.5, KScreenHeight * 0.5);
    
    
    self.infoView.alpha = 0;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.infoView.alpha = 1;
                     }];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (void)cancelBtnClick {
    [UIView animateWithDuration:0.25 animations:^{
        self.infoView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.infoView removeFromSuperview];
    }];
}

- (void)rightBtnClick {
    [UIView animateWithDuration:0.25 animations:^{
        self.infoView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.infoView removeFromSuperview];
        XFRechrgeViewController *controller = [[XFRechrgeViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
}

- (IBAction)tapgesture:(id)sender {
    
    [self.textfile endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
