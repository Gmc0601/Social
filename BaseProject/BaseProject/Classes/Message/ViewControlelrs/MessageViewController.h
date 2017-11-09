//
//  MessageViewController.h
//  BaseProject
//
//  Created by cc on 2017/11/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCMessageViewController.h"

typedef enum MessageType {
    NormalMessage,
    PredestinationMessage,
}MessageType;

@interface MessageViewController : CCMessageViewController

@property (nonatomic, assign) MessageType type;

@end
