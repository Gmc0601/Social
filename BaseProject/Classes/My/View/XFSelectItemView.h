//
//  XFSelectItemView.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/19.
//  Copyright © 2017年 王文利. All rights reserved.
//  个人信息选择

#import <UIKit/UIKit.h>

@class XFSelectItemView;
@protocol XFSelectItemViewDelegate <NSObject>

@optional
- (void)selectItemView:(XFSelectItemView *)itemView selectInfo:(NSString *)info;
- (void)selectItemView:(XFSelectItemView *)itemView selectLeftInfo:(NSString *)leftInfo rightInfo:(NSString *)rightInfo;

@end

@interface XFSelectItemView : UIView

- (instancetype)initWithTitle:(NSString *)title
                    dataArray:(NSArray *)dataArray
                   selectText:(NSString *)selectText;

- (instancetype)initWithTitle:(NSString *)title
                    leftArray:(NSArray *)leftArray
                   rightArray:(NSArray *)rightArray;

@property (nonatomic, weak) id<XFSelectItemViewDelegate> delegate;

@end

