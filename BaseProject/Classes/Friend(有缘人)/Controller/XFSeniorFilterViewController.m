//
//  XFSeniorFilterViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/22.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFSeniorFilterViewController.h"
#import "XFSelectItemView.h"
#import "XFSelectAddressView.h"

#define SeniorFilterBaseTag     100
@interface XFSeniorFilterViewController ()<XFSelectItemViewDelegate, XFSelectAddressViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *currentTapView;

@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *homeLabel;
//@property (nonatomic, strong) UILabel *heightLabel;
//@property (nonatomic, strong) UILabel *weightLabel;
//@property (nonatomic, strong) UILabel *educationLabel;
//@property (nonatomic, strong) UILabel *incomeLabel;
//@property (nonatomic, strong) UILabel *houseLabel;
//@property (nonatomic, strong) UILabel *carLabel;
@property (nonatomic, strong) UILabel *cityLabel;
//ageLabel\homeLabel\cityLabel

@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation XFSeniorFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    self.dict = [NSMutableDictionary dictionary];
    UIView *navView = [UIView xf_navView:@"高级筛选"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navView.bottom, kScreenWidth, kScreenHeight - XFNavHeight - 64)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    UIView *paddingView = [UIView xf_createPaddingView];
    paddingView.frame = CGRectMake(0, 0, kScreenWidth, 5);
    [self.scrollView addSubview:paddingView];
    
    UIView *ageView = [self createRightLabelView:@"年龄" andInfo:nil];
    ageView.tag = SeniorFilterBaseTag;
    ageView.top = paddingView.bottom;
    
//    UIView *heightView = [self createRightLabelView:@"身高" andInfo:nil];
//    heightView.tag = SeniorFilterBaseTag + 1;
//    heightView.top = ageView.bottom;
//
//    UIView *weightView = [self createRightLabelView:@"体重" andInfo:nil];
//    weightView.tag = SeniorFilterBaseTag + 2;
//    weightView.top = heightView.bottom;
//
//    UIView *educationView = [self createRightLabelView:@"学历" andInfo:nil];
//    educationView.tag = SeniorFilterBaseTag + 3;
//    educationView.top = weightView.bottom;
//
//    UIView *incomeView = [self createRightLabelView:@"收入" andInfo:nil];
//    incomeView.tag = SeniorFilterBaseTag + 4;
//    incomeView.top = educationView.bottom;

//    UIView *houseView = [self createRightLabelView:@"车产" andInfo:nil];
//    houseView.tag = SeniorFilterBaseTag + 5;
//    houseView.top = incomeView.bottom;
//
//    UIView *carView = [self createRightLabelView:@"房产" andInfo:nil];
//    carView.tag = SeniorFilterBaseTag + 6;
//    carView.top = houseView.bottom;

    UIView *cityView = [self createRightLabelView:@"所在城市" andInfo:nil];
    cityView.tag = SeniorFilterBaseTag + 7;
    cityView.top = ageView.bottom;
//    if (cityView.bottom > scrollView.height) {
//        self.scrollView.contentSize = CGSizeMake(kScreenWidth, cityView.bottom);
//    }

    UIView *homeTowmView = [self createRightLabelView:@"故乡" andInfo:nil];
    homeTowmView.tag = SeniorFilterBaseTag + 7;
    homeTowmView.top = cityView.bottom;
    if (homeTowmView.bottom > scrollView.height) {
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, homeTowmView.bottom);
    }


    
    UILabel *ageLabel = (UILabel *)[ageView viewWithTag:300];
    self.ageLabel = ageLabel;
//    UILabel *heightLabel = (UILabel *)[heightView viewWithTag:300];
//    self.heightLabel = heightLabel;
//    UILabel *weightLabel = (UILabel *)[weightView viewWithTag:300];
//    self.weightLabel = weightLabel;
//    UILabel *educationLabel = (UILabel *)[educationView viewWithTag:300];
//    self.educationLabel = educationLabel;
//    UILabel *incomeLabel = (UILabel *)[incomeView viewWithTag:300];
//    self.incomeLabel = incomeLabel;
//    UILabel *houseLabel = (UILabel *)[houseView viewWithTag:300];
//    self.houseLabel = houseLabel;
//    UILabel *carLabel = (UILabel *)[carView viewWithTag:300];
//    self.carLabel = carLabel;
    UILabel *cityLabel = (UILabel *)[cityView viewWithTag:300];
    self.cityLabel = cityLabel;

    UILabel *hhomeLabel = (UILabel *)[homeTowmView viewWithTag:300];
    self.homeLabel = hhomeLabel;
    
    if (self.orignDict) {
        NSString *ageLeftStr = self.orignDict[@"age1"];
        NSString *ageRightStr = self.orignDict[@"age2"];
        NSMutableString *ageStr = [NSMutableString string];
        if (ageLeftStr.length) {
            [ageStr appendString:ageLeftStr];
            [ageStr appendString:@"-"];
            [ageStr appendString:ageRightStr];
            self.dict[@"age1"] = ageLeftStr;
            self.dict[@"age2"] = ageRightStr;
        } else {
            if (ageRightStr.length) {
                [ageStr appendString:@"不限-"];
                [ageStr appendString:ageRightStr];
                self.dict[@"age2"] = ageRightStr;
            }
        }
        if (ageStr.length) {
            [self setupRightLabel:ageLabel info:ageStr];
        }
        NSString *hometown = self.orignDict[@"hometown"];
        if (hometown.length != 0) {
            self.dict[@"hometown"] = hometown;
        }
        //
        
        
        NSString *heightLeftStr = self.orignDict[@"height1"];
        NSString *heightRightStr = self.orignDict[@"height2"];
        NSMutableString *heightStr = [NSMutableString string];
        if (heightLeftStr.length) {
            [heightStr appendString:heightLeftStr];
            [heightStr appendString:@"-"];
            [heightStr appendString:heightRightStr];
            self.dict[@"height1"] = heightLeftStr;
            self.dict[@"height2"] = heightRightStr;
        } else {
            if (heightRightStr.length) {
                [heightStr appendString:@"不限-"];
                [heightStr appendString:heightRightStr];
                self.dict[@"height2"] = heightRightStr;
            }
        }
//        if (heightStr.length) {
//            [self setupRightLabel:heightLabel info:heightStr];
//        }

        
        NSString *weightLeftStr = self.orignDict[@"weight1"];
        NSString *weightRightStr = self.orignDict[@"weight2"];
        NSMutableString *weightStr = [NSMutableString string];
        if (weightLeftStr.length) {
            [weightStr appendString:weightLeftStr];
            [weightStr appendString:@"-"];
            [weightStr appendString:weightRightStr];
            self.dict[@"weight1"] = weightLeftStr;
            self.dict[@"weight2"] = weightRightStr;
        } else {
            if (weightRightStr.length) {
                [weightStr appendString:@"不限-"];
                [weightStr appendString:weightRightStr];
                self.dict[@"weight2"] = weightRightStr;
            }
        }
//        if (weightStr.length) {
//            [self setupRightLabel:weightLabel info:weightStr];
//        }
        
        
//        NSString *educationStr = self.orignDict[@"education"];
//        if ([educationStr isEqualToString:@"1"]) {
//            [self setupRightLabel:educationLabel info:@"中专"];
//        } else if ([educationStr isEqualToString:@"2"]) {
//            [self setupRightLabel:educationLabel info:@"大专"];
//        } else if ([educationStr isEqualToString:@"3"]) {
//            [self setupRightLabel:educationLabel info:@"本科"];
//        } else if ([educationStr isEqualToString:@"4"]) {
//            [self setupRightLabel:educationLabel info:@"硕士"];
//        } else if ([educationStr isEqualToString:@"5"]) {
//            [self setupRightLabel:educationLabel info:@"博士"];
//        }

        
//        NSString *incomeStr = self.orignDict[@"income"];
//        if ([incomeStr isEqualToString:@"1"]) {
//            [self setupRightLabel:incomeLabel info:@"3000以下"];
//        } else if ([incomeStr isEqualToString:@"2"]) {
//            [self setupRightLabel:incomeLabel info:@"3000-5000"];
//        } else if ([incomeStr isEqualToString:@"3"]) {
//            [self setupRightLabel:incomeLabel info:@"5000-10000"];
//        } else if ([incomeStr isEqualToString:@"4"]) {
//            [self setupRightLabel:incomeLabel info:@"10000-20000"];
//        } else if ([incomeStr isEqualToString:@"5"]) {
//            [self setupRightLabel:incomeLabel info:@"50000以上"];
//        }

//        NSString *houseStr = self.orignDict[@"house"];
//        if ([houseStr isEqualToString:@"1"]) {
//            [self setupRightLabel:houseLabel info:@"有"];
//        } else if ([houseStr isEqualToString:@"2"]) {
//            [self setupRightLabel:houseLabel info:@"无"];
//        }

//        NSString *carStr = self.orignDict[@"car"];
//        if ([carStr isEqualToString:@"1"]) {
//            [self setupRightLabel:carLabel info:@"无"];
//        } else if ([carStr isEqualToString:@"2"]) {
//            [self setupRightLabel:carLabel info:@"无"];
//        }

        NSString *cityStr = self.orignDict[@"address"];
        if (cityStr.length) {
            [self setupRightLabel:cityLabel info:cityStr];
        }
    }
    
    UIButton *resetbtn = [UIButton xf_titleButtonWithTitle:@"重置"
                                                titleColor:BlackColor
                                                 titleFont:Font(15)
                                                    target:self
                                                    action:@selector(resetBtnClick)];
    resetbtn.backgroundColor = RGBGray(242);
    [resetbtn xf_cornerCut:5];
    [self.view addSubview:resetbtn];
    
    UIButton *confirmBtn = [UIButton xf_titleButtonWithTitle:@"确定"
                                                  titleColor:WhiteColor
                                                   titleFont:Font(15)
                                                      target:self
                                                      action:@selector(confirmBtnClick)];
    confirmBtn.backgroundColor = ThemeColor;
    [confirmBtn xf_cornerCut:5];
    [self.view addSubview:confirmBtn];
    
    CGFloat itemW = (kScreenWidth - 15 * 3) * 0.5;
    resetbtn.size = confirmBtn.size = CGSizeMake(itemW, 44);
    resetbtn.bottom = confirmBtn.bottom = kScreenHeight - 10;
    resetbtn.left = 15;
    confirmBtn.left = resetbtn.right + 15;
};

#pragma mark ----------<XFSelectItemViewDelegate>----------
- (void)selectItemView:(XFSelectItemView *)itemView selectLeftInfo:(NSString *)leftInfo rightInfo:(NSString *)rightInfo {
    
    if (self.currentTapView.tag == SeniorFilterBaseTag) {
        if ([self isNoLimit:leftInfo]) {
            self.dict[@"age1"] = leftInfo;
        }
        if ([self isNoLimit:rightInfo]) {
            self.dict[@"age2"] = rightInfo;
        }
    } else if (self.currentTapView.tag == SeniorFilterBaseTag + 1) {
        if ([self isNoLimit:leftInfo]) {
            self.dict[@"height1"] = leftInfo;
        }
        if ([self isNoLimit:rightInfo]) {
            self.dict[@"height2"] = rightInfo;
        }
    } else if (self.currentTapView.tag == SeniorFilterBaseTag + 2) {
        if ([self isNoLimit:leftInfo]) {
            self.dict[@"weight1"] = leftInfo;
        }
        if ([self isNoLimit:rightInfo]) {
            self.dict[@"weight2"] = rightInfo;
        }
    }
    UILabel *label = (UILabel *)[self.currentTapView viewWithTag:300];
    [self setupRightLabel:label info:[NSString stringWithFormat:@"%@-%@", leftInfo, rightInfo]];
}

- (BOOL)isNoLimit:(NSString *)text {
    return ![text isEqualToString:@"不限"];
}

- (void)selectItemView:(XFSelectItemView *)itemView selectInfo:(NSString *)info {
    UILabel *label = (UILabel *)[self.currentTapView viewWithTag:300];
    [self setupRightLabel:label info:info];
    
    if (self.currentTapView.tag == SeniorFilterBaseTag + 3) {
        if ([self isNoLimit:info]) {
            if ([info containsString:@"中专"]) {
                self.dict[@"education"] = @"1";
            } else if ([info containsString:@"大专"]) {
                self.dict[@"education"] = @"2";
            } else if ([info containsString:@"本科"]) {
                self.dict[@"education"] = @"3";
            } else if ([info containsString:@"硕士"]) {
                self.dict[@"education"] = @"4";
            } else if ([info containsString:@"博士"]) {
                self.dict[@"education"] = @"5";
            }
        }
    } else if (self.currentTapView.tag == SeniorFilterBaseTag + 4) {
        if ([self isNoLimit:info]) {
            if ([info containsString:@"以下"]) {
                self.dict[@"income"] = @"1";
            } else if ([info containsString:@"3000-5"]) {
                self.dict[@"income"] = @"2";
            } else if ([info containsString:@"5000-1"]) {
                self.dict[@"income"] = @"3";
            } else if ([info containsString:@"10000-2"]) {
                self.dict[@"income"] = @"4";
            } else if ([info containsString:@"50000以上"]) {
                self.dict[@"income"] = @"5";
            }
        }
        
    } else if (self.currentTapView.tag == SeniorFilterBaseTag + 5) {
        if ([self isNoLimit:info]) {
            if ([info containsString:@"有"]) {
                self.dict[@"house"] = @"1";
            } else if ([info containsString:@"无"]) {
                self.dict[@"house"] = @"2";
            }
        }
        
    } else if (self.currentTapView.tag == SeniorFilterBaseTag + 6) {
        if ([self isNoLimit:info]) {
            if ([info containsString:@"有"]) {
                self.dict[@"car"] = @"1";
            } else if ([info containsString:@"无"]) {
                self.dict[@"car"] = @"2";
            }
        }
    }
}

#pragma mark - -------------------<XFSelectAddressViewDelegate>-------------------
- (void)selectAddressView:(XFSelectAddressView *)itemView
           selectProvince:(NSString *)province
                     city:(NSString *)city
                  address:(NSString *)area {
    NSString *info = [NSString stringWithFormat:@"%@%@%@", province, city, area];
    UILabel *label = (UILabel *)[self.currentTapView viewWithTag:300];
    [self setupRightLabel:label info:info];
    self.dict[@"address"] = info;
}

#pragma mark ----------Action----------
- (void)itemViewTap:(UITapGestureRecognizer *)ges {
    self.currentTapView = ges.view;
    switch (ges.view.tag - SeniorFilterBaseTag) {
        case 0: {
            NSMutableArray *array = [NSMutableArray array];
            [array appendObject:@"不限"];
            for (int i = 18; i <= 100; i++) {
                [array appendObject:[NSString stringWithFormat:@"%d", i]];
            }
            XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"年龄"
                                                                         leftArray:array
                                                                        rightArray:array];
            selectItem.delegate = self;
            [self.view addSubview:selectItem];
        }
            break;
        case 1: {
            NSMutableArray *array = [NSMutableArray array];
            [array appendObject:@"不限"];
            for (int i = 151; i <= 200; i++) {
                [array appendObject:[NSString stringWithFormat:@"%d", i]];
            }
            XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"身高(cm)"
                                                                         leftArray:array
                                                                        rightArray:array];
            selectItem.delegate = self;
            [self.view addSubview:selectItem];
        }
            break;
        case 2: {
            NSMutableArray *array = [NSMutableArray array];
            [array appendObject:@"不限"];
            for (int i = 41; i <= 200; i++) {
                [array appendObject:[NSString stringWithFormat:@"%d", i]];
            }
            XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"体重(kg)"
                                                                         leftArray:array
                                                                        rightArray:array];
            selectItem.delegate = self;
            [self.view addSubview:selectItem];
        }
            break;
        case 3: {
            XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"学历"
                                                                         dataArray:@[@"不限", @"中专及以下", @"大专", @"本科", @"硕士", @"博士及以上"]
                                                                        selectText:nil];
            selectItem.delegate = self;
            [self.view addSubview:selectItem];
        }
            break;
        case 4: {
            XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"收入"
                                                                         dataArray:@[@"不限", @"3000以下", @"3000-5000", @"5000-10000", @"10000-20000", @"50000以上"]
                                                                        selectText:nil];
            selectItem.delegate = self;
            [self.view addSubview:selectItem];
        }
            break;
        case 5: {
            XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"车产情况"
                                                                         dataArray:@[@"不限", @"有车产", @"无车产"]
                                                                        selectText:nil];
            selectItem.delegate = self;
            [self.view addSubview:selectItem];
        }
            break;
        case 6: {
            XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"房产情况"
                                                                         dataArray:@[@"不限", @"有房产", @"无房产"]
                                                                        selectText:nil];
            selectItem.delegate = self;
            [self.view addSubview:selectItem];
        }
            break;
        case 7: {
            XFSelectAddressView *addressView = [[XFSelectAddressView alloc] init];
            addressView.delegate = self;
            [self.view addSubview:addressView];
        }
            break;
            
        default:
            break;
    }
}

- (void)resetBtnClick {
    [self setupRightLabel:self.ageLabel info:@"不限"];
//    [self setupRightLabel:self.heightLabel info:@"不限"];
//    [self setupRightLabel:self.weightLabel info:@"不限"];
//    [self setupRightLabel:self.educationLabel info:@"不限"];
//    [self setupRightLabel:self.incomeLabel info:@"不限"];
//    [self setupRightLabel:self.houseLabel info:@"不限"];
//    [self setupRightLabel:self.carLabel info:@"不限"];
    [self setupRightLabel:self.cityLabel info:@"不限"];
    [self setupRightLabel:self.homeLabel info:@"不限"];
    self.dict = [NSMutableDictionary dictionary];
}

- (void)confirmBtnClick {
    if (self.confirmBack) {
        self.confirmBack(self.dict);
    }
    [self backBtnClick];
}

- (UIView *)createRightLabelView:(NSString *)title andInfo:(NSString *)info {
    UIView *view = [UIView xf_createWhiteView];
    view.size = CGSizeMake(kScreenWidth, 50);
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewTap:)]];
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
                                      numberOfLines:0
                                          alignment:NSTextAlignmentRight];
    [self setupRightLabel:rightLabel info:info];
    
    rightLabel.width = 200;
    rightLabel.top = 0;
    rightLabel.height = view.height;
    rightLabel.right = arrowView.left - 10;
    rightLabel.tag = 300;
    [view addSubview:rightLabel];
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(10, view.height - 0.5, view.width - 20, 0.5);
    [view addSubview:splitView];
    
    return view;
}

- (void)setupRightLabel:(UILabel *)label info:(NSString *)info {
    if (info.length == 0 || [info isEqualToString:@"不限"]) {
        label.text = @"不限";
        label.textColor = RGBGray(204);
    } else {
        label.text = info;
        label.textColor = BlackColor;
    }
}

@end

