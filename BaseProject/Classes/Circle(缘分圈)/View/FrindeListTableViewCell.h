//
//  FrindeListTableViewCell.h
//  BaseProject
//
//  Created by cc on 2018/2/5.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface FrindeListTableViewCell : UITableViewCell

@property (nonatomic, retain) UIView *back;

@property (nonatomic, retain) UIImageView *head;

@property (nonatomic, retain) UILabel *nameLab, *IdLab, *locaLab;

@property (nonatomic,retain) User *user;

@end


