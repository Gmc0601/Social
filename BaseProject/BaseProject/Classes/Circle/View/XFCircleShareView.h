//
//  XFCircleShareView.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFCircleShareView;

typedef NS_ENUM(NSInteger, CircleShareBtnType) {
    CircleShareBtnType_friendBtn = 0,
    CircleShareBtnType_wechatBtn = 1,
    CircleShareBtnType_qqBtn     = 2,
    CircleShareBtnType_qzoneBtn  = 3,
    CircleShareBtnType_weiboBtn  = 4
};

@protocol XFCircleShareViewDelegate <NSObject>

@optional
- (void)circleShareView:(XFCircleShareView *)view didClick:(CircleShareBtnType)type;

@end

@interface XFCircleShareView : UIView

@property (nonatomic, weak) id<XFCircleShareViewDelegate> delegate;

@end
