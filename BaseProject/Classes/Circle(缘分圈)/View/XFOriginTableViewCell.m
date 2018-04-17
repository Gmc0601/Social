//
//  XFOriginTableViewCell.m
//  BaseProject
//
//  Created by 王文利 on 2018/4/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "XFOriginTableViewCell.h"

@implementation XFOriginTableViewCell
{
    
    __weak IBOutlet UIImageView *userImageView;
    __weak IBOutlet UILabel *lbContent;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (!userImageView.layer.masksToBounds) {
        [userImageView.layer setMasksToBounds:YES];
    }
    [userImageView.layer setCornerRadius:userImageView.height * 0.5];
    [lbContent setNumberOfLines:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)becomeValue: (User *)user {
    [userImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar_url] placeholderImage:[UIImage imageNamed:@"bg_tj_tx"]];
    [lbContent setText:user.nickname];

}

@end
