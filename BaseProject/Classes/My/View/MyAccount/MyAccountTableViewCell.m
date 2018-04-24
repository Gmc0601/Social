//
//  MyAccountTableViewCell.m
//  BaseProject
//
//  Created by 王文利 on 2018/4/22.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyAccountTableViewCell.h"
@implementation MyAccountTableViewCell
{
    __weak IBOutlet UIImageView *bgImgView;
    __weak IBOutlet UILabel *lbTitle;
    __weak IBOutlet UILabel *lbValue;
    
    __weak IBOutlet UILabel *lbTips;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (CGFloat)standardHeight {
    return (KScreenWidth - 16) * 138 / 362;
}


- (void)selectedWay: (AccountEnum)typeValue {
    UIColor* standardColor = [UIColor blackColor];
    NSString* titleValue = @"";
    NSString* btnTitle = @"";
    NSString* imgName = @"zhanghu_chongzhi";
    switch (typeValue) {
        case AccountEnumFirst:
            //充值
            standardColor = [UIColor colorWithRed:0.99 green:0.78 blue:0.23 alpha:1.00];
            titleValue = @"充值账户";
            btnTitle = @"充值";
            imgName = @"zhanghu_chongzhi";
            break;

        case AccountEnumSecond:
            standardColor = [UIColor colorWithRed:0.54 green:0.78 blue:0.42 alpha:1.00];
            titleValue = @"充值账户";
            btnTitle = @"提现";
            imgName = @"zhanghu_tixian";
            break;

        case AccountEnumThird:
            standardColor = [UIColor colorWithRed:0.56 green:0.24 blue:0.55 alpha:1.00];
            titleValue = @"赠送账户";
            btnTitle = @"";
            imgName = @"zhanghu_zengsong";
            break;

        default:
            break;
    }

    lbTitle.text = titleValue;
    lbTitle.textColor = standardColor;
    lbTips.text = btnTitle;
    [bgImgView setImage:[UIImage imageNamed:imgName]];
}

/**
 Cell获取参数
 */
- (void)cell_InitWithfirstValue: (NSString*)firstValue
                       andForth: (AccountEnum)forthValue {
    [self selectedWay:forthValue];
    [lbValue setText:firstValue];
}


@end
