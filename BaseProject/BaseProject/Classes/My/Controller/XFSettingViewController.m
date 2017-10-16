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

@end

@implementation XFSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
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

#pragma mark ----------<XFSelectItemViewDelegate>----------
- (void)selectItemView:(XFSelectItemView *)itemView selectInfo:(NSString *)info {
    FFLog(@"%@", info);
}

#pragma mark ----------Action----------
- (void)logoutBtnClick {
    
}

- (void)viewTap:(UIGestureRecognizer *)ges {
    FFLog(@"%zd", ges.view.tag);
    if (ges.view.tag == 0) {
        NSArray *array = @[@"不延迟推送", @"延迟1小时", @"延迟24消失"];
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"推送设置"
                                                                     dataArray:array
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (ges.view.tag == 3) {
        XFUserAgreementViewController *controller = [[XFUserAgreementViewController alloc] init];
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
    label.frame = CGRectMake(15, 0, view.width - 30, view.height);
    [view addSubview:label];
    
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
