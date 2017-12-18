//
//  AppAlertViewController.h
//  easydoctor
//
//  Created by stone on 15/11/10.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sureBlock)();
typedef void(^cancelBlock)();

@interface AppAlertViewController : UIViewController


- (instancetype)initWithParentController:(UIViewController *)parent;

- (void)showAlert:(NSString *)title message:(NSString *)message sureTitle:(NSString *)sureTitle cancelTitle:(NSString *)cancelTitle sure:(sureBlock)sure cancel:(cancelBlock)cancel;

@end
