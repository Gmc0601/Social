//
//  RedPagCellTableViewCell.h
//  BaseProject
//
//  Created by cc on 2017/11/28.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseBaseMessageCell.h"

@interface RedPagCellTableViewCell : EaseBaseMessageCell


@property (nonatomic) BOOL sender;

@property (nonatomic, retain) UILabel *infoLab;

- (void)setupsubview:(id<IMessageModel>)model;

@end
