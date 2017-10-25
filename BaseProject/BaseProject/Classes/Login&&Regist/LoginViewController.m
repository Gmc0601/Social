//
//  LoginViewController.m
//  BaseProject
//
//  Created by cc on 2017/10/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "LoginViewController.h"
#import "CCTextField.h"
#import "RegistViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "MobileViewController.h"

@interface LoginViewController ()<BaseTextFieldDelegate,UIGestureRecognizerDelegate>{
    BOOL person;
}

@property (nonatomic, retain) UIButton *personBtn, *storeBtn, *loginBtn, *forgetBtn, *weichatBtn, *qqBtn;

@property (nonatomic, retain) CCTextField *mobile, *pwd;

@property (nonatomic, retain) UILabel *thirdlab, *line1, *line2, *line3;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"登录";
    person = YES;
    self.line.hidden = YES;
    [self.leftBar setTitle:@"关闭" forState:UIControlStateNormal];
    [self.leftBar setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.leftBar.frame = FRAME(10, 25, 40, 30);
    [self.leftBar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightBar setTitle:@"注册" forState:UIControlStateNormal];
    self.leftBar.titleLabel.font = [UIFont systemFontOfSize:12];

    [self addview];
}

- (void)hidenKeyboard
{
    [self.mobile resignFirstResponder];
    [self.pwd resignFirstResponder];
}

- (void)addview {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    [self.view addSubview:self.line1];
    [self.view addSubview:self.line2];
    [self.view addSubview:self.line3];
    [self.view addSubview:self.thirdlab];
    [self.view addSubview:self.personBtn];
    [self.view addSubview:self.storeBtn];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.forgetBtn];
    [self.view addSubview:self.weichatBtn];
    [self.view addSubview:self.qqBtn];
    
    self.mobile = [[CCTextField alloc] initWithFrame:FRAME(40, 240 * k_screenH, kScreenW - 80, 50 *k_screenH) PlaceholderStr:@"手机号" isBorder:NO withLeftImage:@"icon_sjh"];
    
    [self.view addSubview:self.mobile];
    
    self.pwd = [[CCTextField alloc] initWithFrame:FRAME(40, 301 * k_screenH, kScreenW - 80, 50 * k_screenH) PlaceholderStr:@"请输入密码" isBorder:NO withLeftImage:@"icon_yzm"];
    
    [self.view addSubview:self.pwd];
    
    
    
}

- (void)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)more:(UIButton *)sender {
    [self.navigationController pushViewController:[RegistViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//   第三方登录
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        if([resp.uid isEqual:[NSNull null]] || resp.uid == nil){
            return ;
        }
        
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        NSDictionary *dic ;
        MobileViewController *vc = [[MobileViewController alloc] init];
        vc.nickName  = resp.name;
        vc.headImage = resp.iconurl;
        vc.token = resp.uid;
        
        NSString *type;
        if (person) {
            type = @"1";
        }else {
            type = @"2";
        }
        vc.userType = type;

        
        switch (platformType) {
            case UMSocialPlatformType_WechatSession:
                vc.type = WeChat;
                dic = @{
                        
                        @"wechat" : resp.uid,
                        @"user_type" : type
                        };
                break;
            case UMSocialPlatformType_QQ:
                vc.type = QQ;
                dic = @{
                        @"qq": resp.uid,
                        @"user_type" : type
                        };
                break;
            case UMSocialPlatformType_Sina:
                vc.type = Sina;
                dic =  @{
                         @"weibotoken" : resp.uid,
                         };
                break;
                
            default:
                break;
        }
        WeakSelf;
        [HttpRequest postPath:@"_login_001" params:dic resultBlock:^(id responseObject, NSError *error) {
            NSLog(@".....%@", responseObject);
            if([error isEqual:[NSNull null]] || error == nil){
                NSLog(@"success");
            }
            NSDictionary *datadic = responseObject;
            if ([datadic[@"error"] intValue] == 0) {

                NSDictionary *dic = datadic[@"info"];
                [ConfigModel saveBoolObject:YES forKey:IsLogin];

                NSString *usertoken = dic[@"userToken"];
                [ConfigModel saveString:usertoken forKey:UserToken];
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];

//                NSString *nickName = dic[@"nickname"];
//                [ConfigModel saveString:nickName forKey:NickName];
//                TBTabBarController  *tab = [[TBTabBarController alloc] init];
//                [weakself presentViewController:tab animated:YES completion:nil];

            }else {
                NSString *str = datadic[@"info"];
                if ([datadic[@"error"] intValue] == 1 && [str isEqualToString:@"请绑定手机号"]) {
                    
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else {
                    [ConfigModel mbProgressHUD:str andView:nil];
                }

            }
        }];
        
        
    }];
}

- (void)buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 110:{
            RegistViewController *vc = [[RegistViewController alloc] init];
            vc.type = Forget;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 11:{
            //  登录
            NSString *type;
            if (person) {
                type = @"1";
            }else {
                type = @"2";
            }
            
            NSDictionary *dic = @{
                                  @"mobile" : self.mobile.text,
                                  @"loginPass" : self.pwd.text,
                                  @"user_type" : type
                                  };
            
            [HttpRequest postPath:@"_login_001" params:dic resultBlock:^(id responseObject, NSError *error) {
                if([error isEqual:[NSNull null]] || error == nil){
                    NSLog(@"success");
                   
                    
                }
                NSDictionary *datadic = responseObject;
                if ([datadic[@"error"] intValue] == 0) {
                    NSDictionary *dic = datadic[@"info"];
                    [ConfigModel saveBoolObject:YES forKey:IsLogin];
                    NSString *usertoken = dic[@"userToken"];
                    [ConfigModel saveString:usertoken forKey:UserToken];
//                    if (person) {
//                        [ConfigModel saveBoolObject:YES forKey:PersonNow];
//                    }else {
//                        [ConfigModel saveBoolObject:NO forKey:PersonNow];
//                    }
                }else {
                    NSString *str = datadic[@"info"];
                    [ConfigModel mbProgressHUD:str andView:nil];
                }
            }];
            
            
        }
            break;
        case 12:{
            person = YES;
        }
            break;
        case 13:{
            person = NO;
        }
            break;
        case 104:{
            [self  getUserInfoForPlatform:UMSocialPlatformType_WechatSession];

        } break;
            
        case  105:{
            [self  getUserInfoForPlatform:UMSocialPlatformType_QQ];
        }  break;
            
        default:
            break;
    }
    
    if (person) {
        
        self.personBtn.layer.borderColor = [UIColorFromHex(0xfb785a) CGColor];
        [self.personBtn setTitleColor:UIColorFromHex(0xfb785a) forState:UIControlStateNormal];
        self.storeBtn.layer.borderColor = [UIColorFromHex(0xcccccc) CGColor];
        [self.storeBtn setTitleColor:UIColorFromHex(0xcccccc) forState:UIControlStateNormal];
        
    }else {
        
        self.storeBtn.layer.borderColor = [UIColorFromHex(0xfb785a) CGColor];
        [self.storeBtn setTitleColor:UIColorFromHex(0xfb785a) forState:UIControlStateNormal];
        self.personBtn.layer.borderColor = [UIColorFromHex(0xcccccc) CGColor];
        [self.personBtn setTitleColor:UIColorFromHex(0xcccccc) forState:UIControlStateNormal];
        
    }
    
}

- (UILabel *)thirdlab {
    if (!_thirdlab) {
        _thirdlab = [[UILabel alloc] initWithFrame:FRAME(kScreenW/2 - SizeWidth(45), SizeHeigh(493), SizeWidth(90), SizeHeigh(14))];
        _thirdlab.backgroundColor = [UIColor whiteColor];
        _thirdlab.textColor = UIColorFromHex(0x999999);
        _thirdlab.textAlignment = NSTextAlignmentCenter;
        _thirdlab.font = NormalFont(12);
        _thirdlab.text = @"第三方登录";
        
    }
    return _thirdlab;
}

//  570

- (UIButton *)weichatBtn {
    if (!_weichatBtn) {
        _weichatBtn = [[UIButton alloc] initWithFrame:FRAME(SizeWidth(85), SizeHeigh(570), SizeWidth(22), SizeHeigh(18))];
        _weichatBtn.backgroundColor = [UIColor clearColor];
        _weichatBtn .tag = 104;
        [_weichatBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_weichatBtn setImage:[UIImage imageNamed:@"icon_wx"] forState:UIControlStateNormal];
    }
    return _weichatBtn;
}

-(UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] initWithFrame:FRAME(40, SizeHeigh(375), kScreenW - 80, SizeHeigh(43))];
        _loginBtn.backgroundColor = UIColorFromHex(0xfb785a);
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = SizeHeigh(5);
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.tag = 11;
        [_loginBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.titleLabel.font = NormalFont(15);
    }
    return _loginBtn;
}

- (UIButton *)qqBtn {
    if (!_qqBtn) {
        _qqBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW - SizeWidth(85) - SizeWidth(22), SizeHeigh(570), SizeWidth(18), SizeHeigh(18))];
        _qqBtn.backgroundColor = [UIColor clearColor];
        _qqBtn .tag = 105;
        [_qqBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_qqBtn setImage:[UIImage imageNamed:@"icon_qq"] forState:UIControlStateNormal];
    }
    return _qqBtn;
}


- (UILabel *)line1 {
    if (!_line1) {
        _line1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 290 *k_screenH, kScreenW - 80, 1)];
        _line1.backgroundColor = UIColorFromHex(0xe0e0e0);
    }
    return _line1;
}

-(UIButton *)forgetBtn {
    if (!_forgetBtn) {
        _forgetBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW - 40 - SizeWidth(70), SizeHeigh(425), SizeWidth(70), SizeHeigh(30))];
        [_forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:UIColorFromHex(0xcccccc) forState:UIControlStateNormal];
        _forgetBtn.titleLabel.font = NormalFont(13);
        _forgetBtn.tag = 110;
        [_forgetBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetBtn;
}

- (UILabel *)line3 {
    if (!_line3) {
        _line3 = [[UILabel alloc] initWithFrame:CGRectMake(40, 500 *k_screenH, kScreenW - 80, 1)];
        _line3.backgroundColor = UIColorFromHex(0xe0e0e0);
    }
    return _line3;
}

- (UILabel *)line2 {
    if (!_line2) {
        _line2 = [[UILabel alloc] initWithFrame:CGRectMake(40, 351 *k_screenH, kScreenW - 80, 1)];
        _line2.backgroundColor = UIColorFromHex(0xe0e0e0);
    }
    return _line2;
}

- (UIButton *)personBtn {
    if (!_personBtn) {
        _personBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW/2 - SizeWidth(85), SizeHeigh(55) + 64, SizeWidth(75), SizeHeigh(30))];
        _personBtn.layer.masksToBounds = YES;
        _personBtn.layer.cornerRadius = SizeHeigh(15);
        _personBtn.layer.borderWidth = 1;
        _personBtn.layer.borderColor = [UIColorFromHex(0xfb785a) CGColor];
        [_personBtn setTitleColor:UIColorFromHex(0xfb785a) forState:UIControlStateNormal];
        [_personBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _personBtn.tag = 12;
        [_personBtn setTitle:@"个人" forState:UIControlStateNormal];
        _personBtn.titleLabel.font = NormalFont(15);
    }
    return _personBtn;
}

- (UIButton *)storeBtn {
    if (!_storeBtn) {
        _storeBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW/2 + SizeWidth(10), SizeHeigh(55) + 64, SizeWidth(75), SizeHeigh(30))];
        _storeBtn.layer.masksToBounds = YES;
        _storeBtn.layer.cornerRadius = SizeHeigh(15);
        _storeBtn.layer.borderWidth = 1;
        _storeBtn.layer.borderColor = [UIColorFromHex(0xcccccc) CGColor];
        [_storeBtn setTitleColor:UIColorFromHex(0xcccccc) forState:UIControlStateNormal];
        [_storeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _storeBtn.tag = 13;
        [_storeBtn setTitle:@"商家" forState:UIControlStateNormal];
        _storeBtn.titleLabel.font = NormalFont(15);
    }
    return _storeBtn;
    
}
@end
