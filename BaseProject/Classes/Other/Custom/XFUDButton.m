//
//  XFUDButton.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFUDButton.h"

@implementation XFUDButton

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
    CGFloat totalH = imgSize.height + labelSize.height + self.padding;
    self.imageView.size = imgSize;
    self.imageView.top = (self.height - totalH) * 0.5;
    self.imageView.centerX = self.width * 0.5;
    
    self.titleLabel.size = labelSize;
    self.titleLabel.top = self.imageView.bottom + self.padding;
    self.titleLabel.centerX = self.width * 0.5;
}

@end
