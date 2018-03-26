//
//  ShouCangAlert.h
//  BaseProject
//
//  Created by 王文利 on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^kComBlock)(int numValue);
@interface ShouCangAlert : UIView
/** block */
@property(nonatomic, copy) kComBlock contentBlock;
/**  文字 */
@property(nonatomic, copy) NSString* textString;

- (void)function_ShowLeftBtnValue:(NSString *)leftValue
                 andRightBtnValue: (NSString *)rightValue
                         andBlock: (kComBlock)easyBlock;
@end
