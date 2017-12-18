//
//  XFCircleContentCellModel.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//  缘分圈内容Cell模型

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CircleContentModelType) {
    CircleContentModelType_Home, // 缘分圈首页
    CircleContentModelType_Friend, // 有缘人的缘分圈
    CircleContentModelType_My, // 我的缘分圈
    CircleContentModelType_Detail // 缘分圈详情
};

@interface XFCircleContentCellModel : NSObject

@property (nonatomic, strong) Circle *circle;
@property (nonatomic, assign) CircleContentModelType type;
@property (nonatomic, assign) CGRect paddingViewFrame;
@property (nonatomic, assign) CGRect iconViewFrame;
@property (nonatomic, assign) CGRect nameLabelFrame;
@property (nonatomic, assign) CGRect timeLabelFrame;
@property (nonatomic, assign) CGRect followBtnFrame;

@property (nonatomic, assign) CGRect descLabelFrame;
@property (nonatomic, assign) CGRect picViewFrame;
@property (nonatomic, strong) NSArray *picFArray;
@property (nonatomic, assign) CGRect videoFrame;
@property (nonatomic, assign) CGRect circleContentFrame;

@property (nonatomic, assign) CGRect rewardBtnFrame;
@property (nonatomic, assign) CGRect shareBtnFrame;
@property (nonatomic, assign) CGRect zanBtnFrame;
@property (nonatomic, assign) CGRect commentBtnFrame;

@property (nonatomic, assign) CGRect deleteBtnFrame;

@property (nonatomic, assign) CGFloat cellH;

- (instancetype)initWithCircle:(Circle *)circle andType:(CircleContentModelType)type;

@end
