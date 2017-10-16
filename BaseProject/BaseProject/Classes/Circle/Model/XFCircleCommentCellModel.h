//
//  XFCircleCommentCellModel.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//  缘分圈详情评论Cell模型

#import <Foundation/Foundation.h>

@interface XFCircleCommentCellModel : NSObject

@property (nonatomic, strong) CircleComment *comment;
@property (nonatomic, assign) CGRect nameLabelFrame;
@property (nonatomic, assign) CGRect timeLabelFrame;
@property (nonatomic, assign) CGRect commentLabelFrame;
@property (nonatomic, assign) CGRect splitViewFrame;

@property (nonatomic, assign) CGFloat cellH;

- (instancetype)initWithComment:(CircleComment *)comment;

@end
