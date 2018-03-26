//
//  ChangePhoneViewController.m
//  BaseProject
//
//  Created by 王文利 on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "ChangePhoneNextViewController.h"

@interface ChangePhoneViewController ()
/** 手机号 */
@property(nonatomic,strong) UILabel* telLabel;
/** 验证码 */
@property(nonatomic,strong) UITextField* tfCode;
/** 获取验证码 */
@property(nonatomic,strong) UIButton* btnCode;
/** 下一步 */
@property(nonatomic,strong) UIButton* btnNext;

@end

@implementation ChangePhoneViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - 初始化界面
- (void)initWithUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIView *navView = [UIView xf_navView:@"更换手机号"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];

    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, navView.bottom, kScreenWidth, 5);
    [self.view addSubview:paddingView];


    UIView* bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(paddingView.mas_bottom).with.mas_offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScreenW * 0.8);
        make.height.mas_equalTo(179);
    }];
    NSString* mobile = [[NSUserDefaults standardUserDefaults] objectForKey:Mobile];
    if (IsNULL(mobile)) {
        mobile = @"";
    } else {
        mobile = [NSString stringWithFormat:@"您的手机号: %@", mobile];
    }

    self.btnCode = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.btnCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnCode.layer setMasksToBounds:YES];
    [self.btnCode addTarget:self action:@selector(function_GetCode) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCode.layer setCornerRadius:4];
    [self.btnCode.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.btnCode.layer setBorderWidth:0.5];
    [bgView addSubview:self.btnCode];
    [self.btnCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.top).with.mas_offset(8);
        make.right.mas_equalTo(bgView.mas_right);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];



    UILabel* lbTel = [[UILabel alloc]init];
    [lbTel setText:mobile];
    [lbTel setTextColor: [UIColor darkGrayColor]];
    [lbTel setFont:[UIFont systemFontOfSize:15]];
    [lbTel setNumberOfLines:1];//默认为一行
    [lbTel setTextAlignment:NSTextAlignmentLeft];
    [bgView addSubview:lbTel];
    self.telLabel = lbTel;
    [lbTel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(bgView.mas_left);
        make.right.mas_equalTo(self.btnCode.mas_left).with.offset(-8);
        make.centerY.mas_equalTo(self.btnCode.mas_centerY);
    }];



    self.tfCode = [[UITextField alloc]init];
    self.tfCode.placeholder = @"请输入验证码";
    self.tfCode.clearButtonMode = UITextFieldViewModeAlways;
    self.tfCode.borderStyle = UITextBorderStyleNone;
    [bgView addSubview:self.tfCode];
    [self.tfCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.btnCode.mas_bottom).with.offset(8);
    }];

    UIView* lineView = [[UIView alloc]init];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.tfCode.mas_bottom);
    }];

    self.btnNext = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.btnNext setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnNext setBackgroundColor:[UIColor colorWithRed:0.58
                                                     green:0.22
                                                      blue:0.55
                                                     alpha:1.00]];
    [self.btnNext.layer setMasksToBounds:YES];
    [self.btnNext.layer setCornerRadius:4];
    [self.btnNext addTarget:self action:@selector(function_Next) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.btnNext];
    [self.btnNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).with.mas_offset(30);
        make.right.mas_equalTo(bgView.mas_right);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(44);
    }];


    //8 + 44 + 44 + 8 + 44 + 31 179


}


#pragma mark - 下一步
- (void)function_Next {


    //Code
    NSString* mobile = [[NSUserDefaults standardUserDefaults] objectForKey:Mobile];
    if (IsNULL(mobile) || mobile.length != 11) {
        [ConfigModel mbProgressHUD:@"请输入有效手机号" andView:nil];
        return;
    }
    if (self.tfCode.text.length == 0) {
        [ConfigModel mbProgressHUD:@"请输入有效验证码" andView:nil];
        return;
    }

    [HttpRequest postPath:@"_codemobile_001" params:@{@"mobile": mobile, @"code":self.tfCode.text} resultBlock:^(id responseObject, NSError *error) {

        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            ChangePhoneNextViewController* vvc = [[ChangePhoneNextViewController alloc]init];
            [self pushController:vvc];
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }

    }];

}


#pragma mark - 获取验证码
- (void)function_GetCode {
    NSString* mobile = [[NSUserDefaults standardUserDefaults] objectForKey:Mobile];
    if (IsNULL(mobile) || mobile.length != 11) {
        [ConfigModel mbProgressHUD:@"请输入有效手机号" andView:nil];
        return;

    }
    NSDictionary *dic = @{
                          @"mobile" : mobile
                          };

    [HttpRequest postPath:@"_sms_003" params:dic resultBlock:^(id responseObject, NSError *error) {

        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }

        NSLog(@"login>>>>>>%@", responseObject);
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            [ConfigModel mbProgressHUD:@"发送成功" andView:nil];
            __block int timeout=59 ; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置

                        [self.btnCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [self.btnCode setTitle:@"重获验证码" forState:UIControlStateNormal];
                        self.btnCode .userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置

                        [self.btnCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [self.btnCode setTitle:[NSString stringWithFormat:@"(%@s)",strTime] forState:UIControlStateNormal];
                        self.btnCode .userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }else {
            [ConfigModel mbProgressHUD:@"发送失败" andView:nil];
        }
        NSLog(@"error>>>>%@", error);

    }];
}




@end

