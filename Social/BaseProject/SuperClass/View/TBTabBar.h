//
//  TBTabBar.h
//  BaseProject
//
//  Created by cc on 2017/6/22.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBTabBar : UITabBar

//@property(nonatomic,strong)UIButton *publishBtn;

@property (nonatomic,copy) void(^didClickPublishBtn)();

@end
