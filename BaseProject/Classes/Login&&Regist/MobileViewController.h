//
//  MobileViewController.h
//  BaseProject
//
//  Created by cc on 2017/10/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    WeChat,
    Sina,
    QQ
}ThirdType;

@interface MobileViewController : BaseViewController

@property (nonatomic, assign) ThirdType type;

@property (nonatomic, copy) NSString *nickName, *headImage, *token , *userType;

@end
