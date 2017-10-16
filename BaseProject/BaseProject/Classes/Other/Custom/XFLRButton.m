//
//  XFLRButton.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFLRButton.h"

@implementation XFLRButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize imgSize = [self.imageView sizeThatFits:CGSizeZero];
    CGSize labelSize = [self.titleLabel sizeThatFits:CGSizeZero];
    
    CGFloat totalW = imgSize.width + self.padding + labelSize.width;
    self.titleLabel.top = 0;
    self.titleLabel.height = self.height;
    if (totalW <= self.width) {
        self.titleLabel.left = (self.width - totalW) * 0.5;
        self.titleLabel.width = labelSize.width;
    } else {
        self.titleLabel.width = totalW;
        self.titleLabel.left = 0;
    }
    
    self.imageView.size = imgSize;
    self.imageView.left = self.titleLabel.right + self.padding;
    self.imageView.centerY = self.titleLabel.centerY;
}

@end
