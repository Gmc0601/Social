//
//  SetTagViewController.h
//  BaseProject
//
//  Created by cc on 2018/3/12.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

typedef enum SetType {
    GroupSet= 0,   //  设置群公告
    TagSet = 1,    //  设置标签 
}SetType;

@interface SetTagViewController : CCBaseViewController

@property (nonatomic, assign) SetType type;

@end
