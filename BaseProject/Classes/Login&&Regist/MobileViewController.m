//
//  MobileViewController.m
//  BaseProject
//
//  Created by cc on 2017/10/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MobileViewController.h"
#import "CCTextField.h"
@interface MobileViewController ()

@property (nonatomic, retain) CCTextField *mobile, *code;

@property (nonatomic, retain) UIButton *loginBtn, *codeBtn;

@end

@implementation MobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"绑定手机号"];
    UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(0, 0, kScreenW , SizeHeigh(30))];
    lab.backgroundColor = UIColorFromHex(0xf0f0f0);
    lab.textColor = UIColorFromHex(0x999999);
    lab.text = @"   为了您的账户安全，请绑定您的手机号";
    [self.view addSubview:lab];
    
    for (int i = 0; i < 2; i++) {
        UILabel *line = [[UILabel alloc] initWithFrame:FRAME(40, SizeHeigh(150) + i*SizeHeigh(50), kScreenW - 80, 1)];
        line.backgroundColor = UIColorFromHex(0xcccccc);
        [self.view addSubview:line];
    }
    
    [self.view addSubview:self.loginBtn];
    
    self.mobile = [[CCTextField alloc] initWithFrame:FRAME(40, 100 * k_screenH, kScreenW - 80 - SizeWidth(100), 50 *k_screenH) PlaceholderStr:@"手机号" isBorder:NO withLeftImage:@""];
    
    [self.view addSubview:self.mobile];
    
    self.code = [[CCTextField alloc] initWithFrame:FRAME(40, 150 * k_screenH, kScreenW - 80, 50 *k_screenH) PlaceholderStr:@"请输入验证码" isBorder:NO withLeftImage:@""];
    
    [self.view addSubview:self.code];
    
}

- (void)buttonClick:(UIButton *)sender {

    [self.navigationController pushViewController:[MobileViewController new] animated:YES];
}

- (void)hidenKeyboard {
    [self.mobile resignFirstResponder];
    [self.code resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW - 40 - SizeWidth(100), SizeHeigh(105), SizeWidth(100), SizeHeigh(35))];
        _codeBtn.backgroundColor = [UIColor clearColor];
        [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:UIColorFromHex(0xfb785a) forState:UIControlStateNormal];
        _codeBtn.tag = 108;
        _codeBtn.layer.masksToBounds = YES;
        _codeBtn.layer.borderWidth = 1;
        _codeBtn.layer.borderColor = [UIColorFromHex(0xfb785a) CGColor];
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
    if (sender.tag == 11) {
        NSDictionary *dic;
        if (self.type ==  QQ) {
            dic = @{
                    @"login_type": @"1",
                    @"qq" : self.token,
                    @"nickanme" : self.nickName,
                    @"avatar_url" : self.headImage,
                    @"mobile" : self.mobile.text,
                    @"user_type" : self.userType
                    };
        }else if (self.type == WeChat){
            dic = @{
                    @"login_type": @"2",
                    @"wechat" : self.token,
                    @"nickanme" : self.nickName,
                    @"avatar_url" : self.headImage,
                    @"mobile" : self.mobile.text,
                    @"user_type" : self.userType
                    };
        }
        
        
        
        [HttpRequest postPath:@"_login_001" params:dic resultBlock:^(id responseObject, NSError *error) {
            if([error isEqual:[NSNull null]] || error == nil){
                NSLog(@"success");
            }
            NSDictionary *datadic = responseObject;
            if ([datadic[@"error"] intValue] == 0) {
                
            }else {
                NSString *str = datadic[@"info"];
                [ConfigModel mbProgressHUD:str andView:nil];
            }
        }];
        
        return;
    }
    
    
    NSDictionary *dic = @{
                          @"mobile" : self.mobile.text
                          };
    
    [HttpRequest postPath:@"_sms_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        
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
                        
                        [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [self.codeBtn setTitle:@"重获验证码" forState:UIControlStateNormal];
                        self.codeBtn .userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        
                        [self.codeBtn setTitleColor:RGBColor(0, 109, 227) forState:UIControlStateNormal];
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
        _loginBtn = [[UIButton alloc] initWithFrame:FRAME(40, SizeHeigh(215), kScreenW - 80, SizeHeigh(43))];
        _loginBtn.backgroundColor = UIColorFromHex(0xfb785a);
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = SizeHeigh(5);
        [_loginBtn setTitle:@"安全绑定" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.tag = 11;
        
        [_loginBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.titleLabel.font = NormalFont(15);
    }
    return _loginBtn;
}


@end
