//
//  RegistViewController.m
//  BaseProject
//
//  Created by cc on 2017/10/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "RegistViewController.h"
#import "CCTextField.h"
#import "XFMyInfoViewController.h"
#import "AddInfoViewController.h"

//#import "MobileViewController.h"

@interface RegistViewController ()<BaseTextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, retain) CCTextField *mobile, *code, *pwd1, *pwd2;

@property (nonatomic, retain) UIButton *loginBtn, *codeBtn;

@property (nonatomic, retain) UILabel *textLab;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightBar.hidden = YES;
    [self.leftBar setImage:[UIImage imageNamed:@"nav_icon_fh"] forState:UIControlStateNormal];
    
    self.leftBar.frame = FRAME(10, 25, 25, 25);
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    if (self.type == Forget) {
        UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(0, 0, kScreenW , SizeHeigh(30))];
        lab.backgroundColor = UIColorFromHex(0xf0f0f0);
        lab.textColor = UIColorFromHex(0x999999);
        lab.text = @"  请通过注册手机号来进行密码找回";
        [self.view addSubview:lab];
    }
    
    for (int i = 0; i < 4; i++) {
        UILabel *line = [[UILabel alloc] initWithFrame:FRAME(40, SizeHeigh(150) + i*SizeHeigh(50), kScreenW - 80, 1)];
        line.backgroundColor = UIColorFromHex(0xcccccc);
        [self.view addSubview:line];
    }
    
//    [self setCustomerTitle:@"注册"];
    self.titleLab.text = @"注册";
    
    [self.view addSubview:self.loginBtn];

    self.mobile = [[CCTextField alloc] initWithFrame:FRAME(40, 100 * k_screenH, kScreenW - 80 - SizeWidth(100), 50 *k_screenH) PlaceholderStr:@"手机号" isBorder:NO withLeftImage:@""];
    
    [self.view addSubview:self.mobile];
    
    self.code = [[CCTextField alloc] initWithFrame:FRAME(40, 150 * k_screenH, kScreenW - 80, 50 *k_screenH) PlaceholderStr:@"请输入验证码" isBorder:NO withLeftImage:@""];
    
    [self.view addSubview:self.code];
    
    self.pwd2 = [[CCTextField alloc] initWithFrame:FRAME(40, 250 * k_screenH, kScreenW - 80, 50 *k_screenH) PlaceholderStr:@"确认密码" isBorder:NO withLeftImage:@""];
    
    self.pwd2.secureTextEntry = YES;
    
//    if (self.type == Forget) {
    [self.view addSubview:self.pwd2];
//    }

    self.pwd1 = [[CCTextField alloc] initWithFrame:FRAME(40, 200 * k_screenH, kScreenW - 80, 50 * k_screenH) PlaceholderStr:@"设置6-12位字母或数字" isBorder:NO withLeftImage:@""];
    
    self.pwd1.secureTextEntry = YES;
    
    [self.view addSubview:self.pwd1];
    
    [self.view addSubview:self.codeBtn];
    
}

- (void)buttonClick:(UIButton *)sender {
    
    if (self.type == Regist) {
        
        if (self.mobile.text.length == 0) {
            [ConfigModel mbProgressHUD:@"请输入正确手机号" andView:nil];
            return;
        }
        if (self.code.text.length == 0) {
            [ConfigModel mbProgressHUD:@"请输入验证码" andView:nil];
            return;
        }
        if (self.pwd1.text.length == 0) {
            [ConfigModel mbProgressHUD:@"请输入密码" andView:nil];
            return;
        }
        
        if (6 > self.pwd1.text.length || self.pwd1.text.length > 12) {
            [ConfigModel mbProgressHUD:@"请输入6-12位有效密码" andView:nil];
            return;
        }
        
        NSDictionary *dic = @{
                              @"mobile" : self.mobile.text,
                              @"code" : self.code.text,
                              @"loginPass" : self.pwd1.text,
                              };
        
        [HttpRequest postPath:@"_register_001" params:dic resultBlock:^(id responseObject, NSError *error) {
            NSLog(@".....%@", responseObject);
            if([error isEqual:[NSNull null]] || error == nil){
                NSLog(@"success");
            }
            NSDictionary *datadic = responseObject;
            if ([datadic[@"error"] intValue] == 0) {
                NSDictionary *infoDic = datadic[@"info"];
                NSString *usertoken = infoDic[@"userToken"];
                NSString *userId = infoDic[@"userId"];
                NSString *nickname = infoDic[@"nickname"];
                
                [ConfigModel saveBoolObject:YES forKey:IsLogin];
                [ConfigModel saveString:usertoken forKey:UserToken];
                [ConfigModel saveString:userId forKey:UserId];
                [ConfigModel saveString:nickname forKey:NickName];
                AddInfoViewController *vc = [[AddInfoViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else {
                NSString *str = datadic[@"info"];
                [ConfigModel mbProgressHUD:str andView:nil];
            }
            
        }];
        
    }else {
        if (self.mobile.text.length == 0) {
            [ConfigModel mbProgressHUD:@"请输入正确手机号" andView:nil];
        }
        if (self.code.text.length == 0) {
            [ConfigModel mbProgressHUD:@"请输入验证码" andView:nil];
        }
        if (self.pwd1.text.length == 0) {
            [ConfigModel mbProgressHUD:@"请输入密码" andView:nil];
        }

        NSDictionary *dic = @{
                              @"mobile" : self.mobile.text,
                              @"code" : self.code.text,
                              @"loginPass" : self.pwd1.text,
                              };
        
        [HttpRequest postPath:@"_set_pwd_001" params:dic resultBlock:^(id responseObject, NSError *error) {
            
            if([error isEqual:[NSNull null]] || error == nil){
                NSLog(@"success");
            }
            NSDictionary *datadic = responseObject;
            if ([datadic[@"error"] intValue] == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                NSString *str = datadic[@"info"];
                [ConfigModel mbProgressHUD:str andView:nil];
            }
            
        }];
    }
}

- (void)hidenKeyboard {
    [self.mobile resignFirstResponder];
    [self.pwd1 resignFirstResponder];
    [self.code resignFirstResponder];
    [self.pwd2 resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW - 40 - SizeWidth(100), SizeHeigh(105), SizeWidth(100), SizeHeigh(35))];
        _codeBtn.backgroundColor = [UIColor clearColor];
        [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _codeBtn.tag = 108;
        _codeBtn.layer.masksToBounds = YES;
        _codeBtn.layer.borderWidth = 1;
        _codeBtn.layer.borderColor = [[UIColor blackColor] CGColor];
        [_codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _codeBtn.titleLabel.font = NormalFont(14);
    }
    return _codeBtn;
}

-(void)codeBtnClick:(UIButton *)sender{
    
    if (self.mobile.text.length != 11) {
        [ConfigModel mbProgressHUD:@"请输入有效手机号" andView:nil];
        return;
        
    }
    NSDictionary *dic = @{
                          @"mobile" : self.mobile.text
                          };
    
    [HttpRequest postPath:@"_sms_002" params:dic resultBlock:^(id responseObject, NSError *error) {
        
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
                        
                        [self.codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [self.codeBtn setTitle:@"重获验证码" forState:UIControlStateNormal];
                        self.codeBtn .userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        
                        [self.codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [self.codeBtn setTitle:[NSString stringWithFormat:@"(%@s)",strTime] forState:UIControlStateNormal];
                        self.codeBtn .userInteractionEnabled = NO;
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

-(UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] initWithFrame:FRAME(40, SizeHeigh(315), kScreenW - 80, SizeHeigh(43))];
        _loginBtn.backgroundColor = ThemeColor;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = SizeHeigh(5);
        [_loginBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.tag = 11;

        [_loginBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.titleLabel.font = NormalFont(15);
    }
    return _loginBtn;
}

@end
