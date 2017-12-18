//
//  ChatInfoTableViewCell.m
//  BaseProject
//
//  Created by cc on 2017/11/9.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ChatInfoTableViewCell.h"

@implementation ChatInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 25;
    
}

- (void)updateChatRequest:(ChatRequestModel *)model {
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:nil];
    self.nameLab.text = model.nickname;
    self.infoLab.text = @"发来聊天请求";
    self.timeLab.text = model.request_time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
