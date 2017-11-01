//
//  XFSettingViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/19.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFSettingViewController.h"
#import "XFSelectItemView.h"
#import "XFUserAgreementViewController.h"

@interface XFSettingViewController ()<XFSelectItemViewDelegate>

@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) XFSelectItemView *selectItemView;
@property (nonatomic, strong) NSArray *pushArray;
@property (nonatomic, strong) NSString *pushStr;

@end

@implementation XFSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    self.pushArray = @[@"不延迟推送", @"延迟1小时", @"延迟3小时", @"延迟6小时", @"延迟12小时", @"延迟24小时"];
    UIView *navView = [UIView xf_navView:@"设置"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, navView.bottom, kScreenWidth, 5);
    [self.view addSubview:paddingView];
    
    UIView *pushView = [self createItemView:@"推送设置" tag:0];
    pushView.top = paddingView.bottom;
    [self.view addSubview:pushView];
    
    UIView *cacheView = [self createItemView:@"清除缓存" tag:1];
    cacheView.top = pushView.bottom;
    [self.view addSubview:cacheView];
    
    UIView *aboutView = [self createItemView:@"关于我们" tag:2];
    aboutView.top = cacheView.bottom;
    [self.view addSubview:aboutView];
    
    UIView *agreementView = [self createItemView:@"用户协议" tag:3];
    agreementView.top = aboutView.bottom;
    [self.view addSubview:agreementView];
    
    UIButton *logoutBtn = [UIButton xf_titleButtonWithTitle:@"退出登录"
                                                 titleColor:RGBGray(102)
                                                  titleFont:Font(15)
                                                     target:self
                                                     action:@selector(logoutBtnClick)];
    logoutBtn.backgroundColor = RGBGray(242);
    [logoutBtn xf_cornerCut:5];
    logoutBtn.size = CGSizeMake(kScreenWidth - 20, 44);
    logoutBtn.left = 10;
    logoutBtn.bottom = kScreenHeight - 10;
    [self.view addSubview:logoutBtn];
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFPushSettingUrl
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          NSDictionary *infoDict = responseObject[@"info"];
                          if ([infoDict isKindOfClass:[NSDictionary class]] && infoDict.allKeys.count) {
                              
                             
                              NSString *xianshi = infoDict[@"xianshi"];
                              if([xianshi isEqual:[NSNull null]] || xianshi == nil){
                                  [ConfigModel mbProgressHUD:@"xianshi  >>   null" andView:nil];
                                  return ;
                              }
                              if (self.pushArray.count > xianshi.integerValue) {
                                  self.selectItemView = self.pushArray[xianshi.integerValue];
                                  [weakSelf setupPushSettingItem:[self.pushArray objectAtIndex:xianshi.integerValue]];
                              }
                          }
                          
                      }
                  }
              }];
}

- (void)setupPushSettingItem:(NSString *)xianshi {
    if (xianshi.length) {
        UILabel *label = [[self.view viewWithTag:0] viewWithTag:100];
        label.text = xianshi;
        label.hidden = NO;
    }
}

#pragma mark ----------<XFSelectItemViewDelegate>----------
- (void)selectItemView:(XFSelectItemView *)itemView selectInfo:(NSString *)info {
    [self setupPushSettingItem:info];
    NSInteger index = [self.pushArray indexOfObject:info];
    [HttpRequest postPath:XFResetPushSettingUrl
                   params:@{@"delay_time" : [NSString stringWithFormat:@"%zd", index]}
              resultBlock:^(id responseObject, NSError *error) {
              }];
}

#pragma mark ----------Action----------
- (void)logoutBtnClick {
    WeakSelf
    [HttpRequest postPath:@"_logout_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            [ConfigModel mbProgressHUD:@"退出成功" andView:nil];
            [ConfigModel saveBoolObject:NO forKey:IsLogin];
            [ConfigModel saveString:@"" forKey:UserToken];
            [ConfigModel saveString:@"" forKey:UserId];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}

- (void)viewTap:(UIGestureRecognizer *)ges {
    if (ges.view.tag == 0) {
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"推送设置"
                                                                     dataArray:self.pushArray
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (ges.view.tag == 1) {
        
    } else if (ges.view.tag == 2) {
        XFUserAgreementViewController *controller = [[XFUserAgreementViewController alloc] init];
        controller.agreementType = AgreementType_About;
        [self pushController:controller];
    } else if (ges.view.tag == 3) {
        XFUserAgreementViewController *controller = [[XFUserAgreementViewController alloc] init];
        controller.agreementType = AgreementType_Agree;
        [self pushController:controller];
    }
}

#pragma mark ----------Private----------
- (UIView *)createItemView:(NSString *)text tag:(NSInteger)tag {
    UIView *view = [UIView xf_createWhiteView];
    view.size = CGSizeMake(kScreenWidth, 50);
    view.tag = tag;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)]];
    
    UILabel *label = [UILabel xf_labelWithFont:Font(12)
                                     textColor:RGBGray(102)
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
    label.text = text;
    label.frame = CGRectMake(15, 0, 100, view.height);
    [view addSubview:label];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:Image(@"icon_gd-拷贝")];
    arrowView.centerY = label.centerY;
    arrowView.right = kScreenWidth - 17;
    [view addSubview:arrowView];
    
    UILabel *rightLabel = [UILabel xf_labelWithFont:Font(12)
                                          textColor:RGBGray(102)
                                      numberOfLines:0
                                          alignment:NSTextAlignmentRight];
    rightLabel.width = 150;
    rightLabel.right = arrowView.left - 10;
    rightLabel.top = 0;
    rightLabel.height = view.height;
    rightLabel.tag = 100;
    rightLabel.hidden = YES;
    [view addSubview:rightLabel];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:Image(@"icon_gd")];
    imgView.centerY = view.height * 0.5;
    imgView.right = view.width - 15;
    [view addSubview:imgView];
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(10, view.height - 0.5, view.width - 20, 0.5);
    [view addSubview:splitView];
    
    return view;
}

@end

