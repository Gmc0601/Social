//
//  XFSelectAddressView.h
//  BaseProject
//
//  Created by artand on 2017/11/27.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFSelectAddressView;
@protocol XFSelectAddressViewDelegate <NSObject>

@optional
- (void)selectAddressView:(XFSelectAddressView *)itemView selectInfo:(NSString *)info;

@end

@interface XFSelectAddressView : UIView

@property (nonatomic, weak) id<XFSelectAddressViewDelegate> delegate;

@end
