//
//  XFCirclePicView.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCirclePicView.h"
#import "XFCircleContentCellModel.h"

#define CirclePicBaseTag    100
@interface XFCirclePicView ()

@end

@implementation XFCirclePicView

- (instancetype)init {
    if ([super init]) {
        for (int i = 0; i < 9; i++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.backgroundColor = [UIColor lightGrayColor];
            imgView.tag = i + CirclePicBaseTag;
            [self addSubview:imgView];
        }
    }
    return self;
}

- (void)setModel:(XFCircleContentCellModel *)model {
    _model = model;
    for (int i = 0; i < 9; i++) {
        UIImageView *imgView = [self viewWithTag:i + CirclePicBaseTag];
        if (i < model.picFArray.count) {
            imgView.hidden = NO;
            [imgView setImageURL:[NSURL URLWithString:model.circle.image[i]]];
            imgView.frame = ((NSValue *)model.picFArray[i]).CGRectValue;
        } else {
            imgView.hidden = YES;
        }
    }
}

@end
