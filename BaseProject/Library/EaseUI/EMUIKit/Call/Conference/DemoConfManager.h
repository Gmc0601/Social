//
//  DemoConfManager.h
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 23/11/2016.
//  Copyright © 2016 XieYajie. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KNOTIFICATION_CONFERENCE @"conference"

@class EaseMessageViewController;
@interface DemoConfManager : NSObject

#if DEMO_CALL == 1

@property (strong, nonatomic) EaseMessageViewController *mainController;

+ (instancetype)sharedManager;

- (void)createConferenceWithType:(EMCallType)aType;

#endif

@end
