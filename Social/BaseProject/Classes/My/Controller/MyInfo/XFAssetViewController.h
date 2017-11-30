//
//  XFAssetViewController.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//  资产

#import "XFViewController.h"

typedef NS_ENUM(NSInteger, AssetType)  {
    AssetType_House,
    AssetType_Car
};

@interface XFAssetViewController : XFViewController

@property (nonatomic, assign) AssetType type;

@end
