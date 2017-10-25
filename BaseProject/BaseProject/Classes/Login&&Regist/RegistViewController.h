//
//  RegistViewController.h
//  BaseProject
//
//  Created by cc on 2017/10/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "BaseViewController.h"

typedef enum RegistType{
    Regist,
    Forget,
}RegistType;

@interface RegistViewController : BaseViewController

@property (nonatomic, assign) RegistType type;

@property (nonatomic, assign) BOOL person;

@end
