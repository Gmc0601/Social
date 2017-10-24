//
//  XFUserAgreementViewController.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//  用户协议 / 关于我们

#import "XFViewController.h"

typedef NS_ENUM(NSInteger, AgreementType) {
    AgreementType_Agree, // 协议
    AgreementType_About // 关于我们
};

@interface XFUserAgreementViewController : XFViewController

@property (nonatomic, assign) AgreementType agreementType;

@end

