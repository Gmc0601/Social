//
//  XFMyFollowUserCell.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/19.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFMyFollowUserCell;
@protocol XFMyFollowUserCellDelegate <NSObject>

@optional
- (void)myFollowUserCell:(XFMyFollowUserCell *)cell didClickUserBtn:(NSInteger)index;
- (void)myFollowUserCell:(XFMyFollowUserCell *)cell didClickFollowBtn:(NSInteger)index;
@end

typedef NS_ENUM(NSInteger, MyFollowUserType) {
    MyFollowUserType_Follow,
    MyFollowUserType_Fans,
    MyFollowUserType_Friends
};

@interface XFMyFollowUserCell : UITableViewCell

+ (CGFloat)cellHeight;

@property (nonatomic, assign) MyFollowUserType type;
@property (nonatomic, weak) id<XFMyFollowUserCellDelegate> delegate;
@property (nonatomic, strong) User *user;

@end
