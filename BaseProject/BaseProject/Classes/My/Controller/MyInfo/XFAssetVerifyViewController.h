//
//  XFAssetVerifyViewController.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//  资产审核

#import "XFViewController.h"

typedef NS_ENUM(NSInteger, AssetVerifyStatus) {
    AssetVerifyStatus_Fail,
    AssetVerifyStatus_Procress,
    AssetVerifyStatus_Success
};

@interface XFAssetVerifyViewController : XFViewController

@property (nonatomic, assign) AssetVerifyStatus status;

@end
