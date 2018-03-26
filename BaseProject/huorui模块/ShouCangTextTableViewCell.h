//
//  ShouCangTextTableViewCell.h
//  BaseProject
//
//  Created by 王文利 on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^kEasyBlock) (void);
@interface ShouCangTextTableViewCell : UITableViewCell
/** block */
@property(nonatomic, copy) kEasyBlock easyBlock;
- (void)cellFunctionText: (NSString *)textValue andTime: (NSString *)timeString andBlock: (kEasyBlock)easyBock;
@end
