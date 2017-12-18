//
//  XFTradeRecordCell.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TradeRecord;

@interface XFTradeRecordCell : UITableViewCell

@property (nonatomic, strong) TradeRecord *record;
+ (CGFloat)cellHeight;
@end
