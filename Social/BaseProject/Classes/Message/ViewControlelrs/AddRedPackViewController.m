//
//  AddRedPackViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/28.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AddRedPackViewController.h"

@interface AddRedPackViewController (){
    NSString *bili ;
}
@property (weak, nonatomic) IBOutlet UITextField *textfile;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *biliLab;

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
            bili = [NSString stringWithFormat:@"领取后平台抽取%@佣金", info[@"hongbao"]];
            NSString *str = [NSString stringWithFormat:@"%@",bili];
            self.biliLab.text = str;
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
}

- (void)change {
    
    float count = [self.textfile.text floatValue] * ([bili intValue]/100);
    
    NSString *countstr = [NSString stringWithFormat:@"%.2f", count];
    
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
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
    
    
    
}
- (IBAction)tapgesture:(id)sender {
    
    [self.textfile endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
