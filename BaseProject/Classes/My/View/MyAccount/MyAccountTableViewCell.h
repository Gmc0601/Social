//
//  MyAccountTableViewCell.h
//  BaseProject
//
//  Created by 王文利 on 2018/4/22.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AccountEnumFirst,
    AccountEnumSecond,
    AccountEnumThird,
} AccountEnum;

@interface MyAccountTableViewCell : UITableViewCell


+ (CGFloat)standardHeight;
- (void)cell_InitWithfirstValue: (NSString*)firstValue
                       andForth: (AccountEnum)forthValue;
@end
