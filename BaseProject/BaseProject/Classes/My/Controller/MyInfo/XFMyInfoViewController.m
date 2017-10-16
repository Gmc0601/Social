//
//  XFMyInfoViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/19.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFMyInfoViewController.h"
#import "XFSelectItemView.h"
#import "XFNickNameViewController.h"
#import "XFAssetViewController.h"
#import "XFAssetVerifyViewController.h"
#import "XFSelectInterestView.h"

@interface XFMyInfoViewController ()<XFSelectItemViewDelegate, XFSelectInterestViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) XFSelectItemView *selectItem;

@end

@implementation XFMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_navView:@"个人信息"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navView.bottom, kScreenWidth, kScreenHeight - XFNavHeight)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    UIView *paddingView1 = [UIView xf_createPaddingView];
    paddingView1.frame = CGRectMake(0, 0, kScreenWidth, 5);
    [self.scrollView addSubview:paddingView1];
    
    UIView *sectionOneView = [self createRightEmptyView:@"基本信息"];
    sectionOneView.top = paddingView1.bottom;
    
    UIView *avatarView = [self createRightIconView:@"头像"];
    avatarView.tag = 100;
    avatarView.top = sectionOneView.bottom;
    
    UIView *ageView = [self createRightLabelView:@"年龄" andInfo:@"18" hiddenSplit:NO];
    ageView.tag = 101;
    ageView.top = avatarView.bottom;
    
    UIView *nickNameView = [self createRightLabelView:@"昵称" andInfo:@"里尔" hiddenSplit:NO];
    nickNameView.tag = 102;
    nickNameView.top = ageView.bottom;
    
    UIView *genderView = [self createRightLabelView:@"性别" andInfo:@"女" hiddenSplit:NO];
    genderView.tag = 103;
    genderView.top = nickNameView.bottom;
    
    UIView *addressView = [self createRightLabelView:@"居住地" andInfo:@"浙江 杭州 西湖区" hiddenSplit:YES];
    addressView.tag = 104;
    addressView.top = genderView.bottom;
    
    UIView *paddingView2 = [UIView xf_createPaddingView];
    paddingView2.frame = CGRectMake(0, addressView.bottom, kScreenWidth, 5);
    [self.scrollView addSubview:paddingView2];
    
    UIView *sectionTwoView = [self createRightEmptyView:@"个人信息"];
    sectionTwoView.top = paddingView2.bottom;
    
    UIView *heightView = [self createRightLabelView:@"身高" andInfo:nil hiddenSplit:NO];
    heightView.tag = 200;
    heightView.top = sectionTwoView.bottom;
    
    UIView *weightView = [self createRightLabelView:@"体重" andInfo:nil hiddenSplit:NO];
    weightView.tag = 201;
    weightView.top = heightView.bottom;
    
    UIView *educationView = [self createRightLabelView:@"学历" andInfo:nil hiddenSplit:NO];
    educationView.tag = 202;
    educationView.top = weightView.bottom;
    
    UIView *interestView = [self createRightLabelView:@"兴趣爱好" andInfo:nil hiddenSplit:NO];
    interestView.tag = 203;
    interestView.top = educationView.bottom;
    
    UIView *feelingView = [self createRightLabelView:@"感情状况" andInfo:nil hiddenSplit:NO];
    feelingView.tag = 204;
    feelingView.top = interestView.bottom;
    
    UIView *standardView = [self createRightLabelView:@"择偶标准" andInfo:nil hiddenSplit:YES];
    standardView.tag = 205;
    standardView.top = feelingView.bottom;
    
    UIView *paddingView3 = [UIView xf_createPaddingView];
    paddingView3.frame = CGRectMake(0, standardView.bottom, kScreenWidth, 5);
    [self.scrollView addSubview:paddingView3];
    
    UIView *sectionThreeView = [self createRightEmptyView:@"详细信息"];
    sectionThreeView.top = paddingView3.bottom;
    
    UIView *workViewView = [self createRightLabelView:@"工作" andInfo:nil hiddenSplit:NO];
    workViewView.tag = 300;
    workViewView.top = sectionThreeView.bottom;
    
    UIView *incomeView = [self createRightLabelView:@"收入" andInfo:nil hiddenSplit:NO];
    incomeView.tag = 301;
    incomeView.top = workViewView.bottom;
    
    UIView *houseView = [self createRightLabelView:@"房产" andInfo:nil hiddenSplit:NO];
    houseView.tag = 302;
    houseView.top = incomeView.bottom;
    
    UIView *carView = [self createRightLabelView:@"车产" andInfo:nil hiddenSplit:NO];
    carView.tag = 303;
    carView.top = houseView.bottom;
    
    UIButton *saveBtn = [UIButton xf_bottomBtnWithTitle:@"保存"
                                                 target:self
                                                 action:@selector(saveBtnClick)];
    saveBtn.frame = CGRectMake(10, carView.bottom + 10, kScreenWidth - 20, 44);
    [self.scrollView addSubview:saveBtn];
    
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, saveBtn.bottom + 10)];
}

- (void)loadData {
    
}

#pragma mark ----------<XFSelectItemViewDelegate>----------
- (void)selectItemView:(XFSelectItemView *)itemView selectInfo:(NSString *)info {
    FFLog(@"%@", info);
    UILabel *label = [self.selectItem viewWithTag:100];
    label.text = info;
}

#pragma mark ----------<XFSelectInterestViewDelegate>----------
- (void)selectInterestView:(XFSelectInterestView *)view didselectItem:(NSArray *)array {
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < array.count; i++) {
        [str appendFormat:@"%@", array[i]];
        if (i != array.count - 1) {
            [str appendFormat:@" "];
        }
    }
    UILabel *label = [self.selectItem viewWithTag:100];
    label.text = str.copy;
}

#pragma mark ----------Action----------
- (void)iconBtnClick {
    FFLogFunc
}

- (void)saveBtnClick {
    FFLogFunc
}

- (void)rightLabelViewTap:(UITapGestureRecognizer *)ges {
    FFLog(@"%zd", ges.view.tag);
    self.selectItem = (XFSelectItemView *)ges.view;
    NSInteger tag = ges.view.tag;
    if (tag == 100) {
        // 头像
        
    } else if (tag == 101) {
        // 年龄
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i <= 100; i++) {
            [arrayM addObject:[NSString stringWithFormat:@"%d", i]];
        }
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"年龄"
                                                                     dataArray:arrayM
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (tag == 102) {
        // 昵称
        XFNickNameViewController *controller = [[XFNickNameViewController alloc] init];
        controller.nickName = @"里尔";
        controller.saveBtnClick = ^(NSString *nickName) {
            UIView *view = [self.view viewWithTag:102];
            UILabel *label =  (UILabel *)[view viewWithTag:100];
            label.text = nickName;
        };
        [self pushController:controller];
    } else if (tag == 103) {
        // 性别
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"性别"
                                                                     dataArray:@[@"男", @"女"]
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (tag == 104) {
        // 居住地
        
    } else if (tag == 200) {
        // 身高
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 50; i <= 200; i++) {
            [arrayM addObject:[NSString stringWithFormat:@"%d", i]];
        }
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"身高(cm)"
                                                                     dataArray:arrayM
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (tag == 201) {
        // 体重
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 10; i <= 100; i++) {
            [arrayM addObject:[NSString stringWithFormat:@"%d", i]];
        }
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"体重(kg)"
                                                                     dataArray:arrayM.copy
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (tag == 202) {
        // 学历
        NSArray *array = @[@"中专及以下", @"高中", @"大专", @"本科", @"硕士", @"博士"];
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"感情状况"
                                                                     dataArray:array
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (tag == 203) {
        // 兴趣爱好
        XFSelectInterestView *selectView = [[XFSelectInterestView alloc] initWithSelectArray:@[@"听音乐"]];
        selectView.delegate = self;
        [self.view addSubview:selectView];
    } else if (tag == 204) {
        // 感情状况
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"感情状况"
                                                                     dataArray:@[@"未婚", @"已婚", @"离异"]
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (tag == 205) {
        // 择偶标准
    } else if (tag == 300) {
        
        // 工作
    } else if (tag == 301) {
        // 收入
        
    } else if (tag == 302) {
        // 房产
        XFAssetViewController *controller = [[XFAssetViewController alloc] init];
        controller.type = AssetType_House;
        [self pushController:controller];
    } else if (tag == 303) {
        // 车产
        XFAssetViewController *controller = [[XFAssetViewController alloc] init];
        controller.type = AssetType_Car;
        [self pushController:controller];
        
//        XFAssetVerifyViewController *controller = [[XFAssetVerifyViewController alloc] init];
//        controller.status = AssetVerifyStatus_Procress;
//        [self pushController:controller];
    }
}

- (void)rightIconViewTap:(UITapGestureRecognizer *)ges {
    FFLog(@"%zd", ges.view.tag);
}

- (UIView *)createRightEmptyView:(NSString *)info {
    UIView *view = [UIView xf_createWhiteView];
    view.size = CGSizeMake(kScreenWidth, 45);
    
    UILabel *label = [UILabel xf_labelWithFont:Font(15)
                                     textColor:BlackColor
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
    label.text = info;
    label.frame = CGRectMake(15, 0, view.width - 30, view.height);
    [view addSubview:label];
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(10, view.height - 0.5, view.width - 20, 0.5);
    [view addSubview:splitView];
    
    [self.scrollView addSubview:view];
    return view;
}

- (UIView *)createRightIconView:(NSString *)info {
    UIView *view = [UIView xf_createWhiteView];
    view.size = CGSizeMake(kScreenWidth, 45);
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightIconViewTap:)]];
    [self.scrollView addSubview:view];
    
    UILabel *label = [UILabel xf_labelWithFont:Font(12)
                                     textColor:RGBGray(102)
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
    label.text = info;
    label.frame = CGRectMake(15, 0, view.width - 30, view.height);
    [view addSubview:label];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:Image(@"icon_gd")];
    arrowView.centerY = view.height * 0.5;
    arrowView.right = view.width - 15;
    [view addSubview:arrowView];
    
    UIButton *iconBtn = [UIButton xf_imgButtonWithImgName:@"bg_tj_tx"
                                                   target:self
                                                   action:@selector(iconBtnClick)];
    iconBtn.size = CGSizeMake(34, 34);
    iconBtn.centerY = view.height * 0.5;
    iconBtn.right = arrowView.left - 10;
    iconBtn.tag = 100;
    [view addSubview:iconBtn];
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(10, view.height - 0.5, view.width - 20, 0.5);
    [view addSubview:splitView];
    
    return view;
}

- (UIView *)createRightLabelView:(NSString *)title andInfo:(NSString *)info hiddenSplit:(BOOL) hidden {
    UIView *view = [UIView xf_createWhiteView];
    view.size = CGSizeMake(kScreenWidth, 50);
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightLabelViewTap:)]];
    [self.scrollView addSubview:view];
    
    UILabel *label = [UILabel xf_labelWithFont:Font(12)
                                     textColor:RGBGray(102)
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
    label.text = title;
    label.frame = CGRectMake(15, 0, 100, view.height);
    [view addSubview:label];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:Image(@"icon_gd")];
    arrowView.centerY = view.height * 0.5;
    arrowView.right = view.width - 15;
    [view addSubview:arrowView];
    
    UILabel *rightLabel = [UILabel xf_labelWithFont:Font(15)
                                          textColor:BlackColor
                                      numberOfLines:1
                                          alignment:NSTextAlignmentRight];
    if (info.length) rightLabel.text = info;
    rightLabel.width = 150;
    rightLabel.top = 0;
    rightLabel.height = view.height;
    rightLabel.right = arrowView.left - 10;
    [view addSubview:rightLabel];
    rightLabel.tag = 100;
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(10, view.height - 0.5, view.width - 20, 0.5);
    [view addSubview:splitView];
    splitView.hidden = hidden;
    
    return view;
}

@end
