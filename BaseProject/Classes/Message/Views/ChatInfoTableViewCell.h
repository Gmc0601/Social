//
//  ChatInfoTableViewCell.h
//  BaseProject
//
//  Created by cc on 2017/11/9.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChatRequestModel.h"

@interface ChatInfoTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

- (void)updateChatRequest:(ChatRequestModel *)model;

@end
