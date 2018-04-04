//
//  AddGroupMemberTableViewCell.h
//  BaseProject
//
//  Created by cc on 2018/2/27.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsModel.h"


@interface AddGroupMemberTableViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *clickimg, * headImage;

@property (nonatomic, retain) UILabel *nickLab, *line;

@property (nonatomic, retain) UIButton *clickBtn;

@property (nonatomic, copy) void(^clickBlock)(BOOL click);

@property (nonatomic) BOOL Click;

- (void)update:(ContactsModel *)model;

@end
