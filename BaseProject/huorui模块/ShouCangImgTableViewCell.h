//
//  ShouCangImgTableViewCell.h
//  BaseProject
//
//  Created by 王文利 on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//  183

#import <UIKit/UIKit.h>
typedef void (^kEasyBlock) (void);
@interface ShouCangImgTableViewCell : UITableViewCell
/** block */
@property(nonatomic, copy) kEasyBlock easyBlock;

- (void)cellFunctionIMGText: (NSString *)textValue
                 andTime: (NSString *)timeString;
@end
