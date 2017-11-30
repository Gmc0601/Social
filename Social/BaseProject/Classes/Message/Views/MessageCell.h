//
//  MessageCell.h
//  SimpleLife
//
//  Created by angle yan on 17/4/20.
//  Copyright © 2017年 高砚祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChatType) {
    ChatTypeMineMsg = 1,
    ChatTypeFriendMsg,
    ChatTypeMineImg,
    ChatTypeFriendImg,
    ChatTypeSystem
};




@interface MessageCell : UITableViewCell




@property (nonatomic) BOOL  haveTime;
@property (nonatomic) BOOL  haveHeader;

@property (nonatomic, strong) EMMessage *message;





+ (instancetype)cellWithTableView:(UITableView *)tableView;




@end
