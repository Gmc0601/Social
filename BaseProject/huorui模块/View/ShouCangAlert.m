//
//  ShouCangAlert.m
//  BaseProject
//
//  Created by 王文利 on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ShouCangAlert.h"

@implementation ShouCangAlert {
    UIView* allView;
    UIButton* cancelBtn;
    UIButton* sureBtn;
}

- (instancetype)init {
    if (self = [super init]) {
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:8];
        [self function_UI];
    }
    return self;
}


#pragma mark - UI
- (void)function_UI {
    allView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [allView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];

//    [allView setUserInteractionEnabled:YES];
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(function_Dismiss)];
//    [allView addGestureRecognizer:tap];
}


#pragma mark - 显示
- (void)function_ShowLeftBtnValue:(NSString *)leftValue
                 andRightBtnValue: (NSString *)rightValue
                         andBlock: (kComBlock)easyBlock {
    //Code
    [self setBackgroundColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication].keyWindow addSubview:allView];

    self.frame = CGRectMake(0, 0, KScreenWidth - 32, 200);
    self.center = allView.center;
    if (!IsNULL(easyBlock)) {
        self.contentBlock = easyBlock;
    }

    cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:leftValue forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [cancelBtn addTarget:self action:@selector(function_Dismiss) forControlEvents:UIControlEventTouchUpInside];

    sureBtn = [[UIButton alloc] init];
    sureBtn.backgroundColor = [UIColor colorWithRed:0.57 green:0.22 blue:0.55 alpha:1.00];
    [sureBtn setTitle:rightValue forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureFunction) forControlEvents:UIControlEventTouchUpInside];



    [sureBtn.layer setMasksToBounds:YES];
    [sureBtn.layer setCornerRadius:4];

    [cancelBtn.layer setMasksToBounds:YES];
    [cancelBtn.layer setCornerRadius:4];


    [self addSubview:cancelBtn];
    [self addSubview:sureBtn];

    CGFloat btnWidth = (KScreenWidth - 32 - 40) * 0.5;
    CGFloat btnHeight = 44;


    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).with.offset(16);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-16);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(btnHeight);
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-16);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-16);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(btnHeight);
    }];



    UILabel* lbCode = [[UILabel alloc]init];
    if (IsNULL(self.textString)) {
        [lbCode setText:@"确定删除该收藏吗?"];
    } else {
        [lbCode setText:self.textString];
    }

    [lbCode setTextColor: [UIColor blackColor]];
    [lbCode setFont:[UIFont systemFontOfSize:17]];
    [lbCode setNumberOfLines:0];
    [lbCode setTextAlignment:NSTextAlignmentCenter];

    [self addSubview:lbCode];
    [lbCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.mas_offset(-16);
        make.left.mas_equalTo(self.mas_left).with.mas_offset(16);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-48);
    }];

    [[UIApplication sharedApplication].keyWindow addSubview:self];


}


#pragma mark - 消失
- (void)function_Dismiss {

    if (!IsNULL(self.contentBlock) && [cancelBtn.titleLabel.text isEqualToString:@"确认注销"]) {
        self.contentBlock(1);
    }
    [allView removeFromSuperview];
    allView = nil;
    [self removeFromSuperview];
}




- (void)sureFunction {
    [allView removeFromSuperview];
    allView = nil;
    [self removeFromSuperview];
    if (!IsNULL(self.contentBlock) && ![sureBtn.titleLabel.text isEqualToString:@"取消"]) {
        self.contentBlock(1);
    }
}

@end
