//
//  RedPagCellTableViewCell.m
//  BaseProject
//
//  Created by cc on 2017/11/28.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "RedPagCellTableViewCell.h"

@implementation RedPagCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model {
    if ( self == [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self setupsubview:model];
    return self;
}

- (void)setupsubview:(id<IMessageModel>)model {
    //  添加子空间
    self.infoLab = [[UILabel alloc] initWithFrame:FRAME(0, 0, kScreenW, 25)];
    self.infoLab.backgroundColor = [UIColor clearColor];
    self.infoLab.textColor = UIColorFromHex(0x999999);
    self.infoLab.textAlignment = NSTextAlignmentCenter;
    self.infoLab.font = [UIFont systemFontOfSize:12];
    
    
    NSString *str;
    if (model.isSender) {
        //  对方昵称
        str = [NSString stringWithFormat:@"您领取%@的红包",[ConfigModel getStringforKey:@"chatNick"]];
    }else {
        str = [NSString stringWithFormat:@"%@领取您的红包", model.nickname];
    }
    self.infoLab.text = str;
    
    [self.contentView addSubview:self.infoLab];
    
    
}


\

@end
