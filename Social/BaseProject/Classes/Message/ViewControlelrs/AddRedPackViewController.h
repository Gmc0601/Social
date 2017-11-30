//
//  AddRedPackViewController.h
//  BaseProject
//
//  Created by cc on 2017/11/28.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

@interface AddRedPackViewController : CCBaseViewController

@property (nonatomic, copy) void(^moneybackBlock)(NSString *money);

@property (nonatomic, copy) NSString *mobile;

@end
