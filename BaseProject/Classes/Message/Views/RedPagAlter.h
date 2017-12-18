//
//  RedPagAlter.h
//  BaseProject
//
//  Created by cc on 2017/11/30.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPagClass : NSObject

@property (nonatomic, retain) NSString *head, *nick, *count, *id;
@property (nonatomic) BOOL get;

@end


@interface RedPagAlter : UIView

- (instancetype)initWithFrame:(CGRect)frame withModel:(RedPagClass *)model;

@property (nonatomic, retain) RedPagClass *model;

@property (nonatomic, retain) UIView *backView;

@property (nonatomic, retain) UIImageView *backimgView, *headImage;

@property (nonatomic, retain) UILabel *nickname, *countLab, *jifen;

@property (nonatomic, retain) UIButton *closeBtn, *btn;

@property (nonatomic, copy) void(^openBlock)();

- (void)pop;

- (void)dismiss;

@end
