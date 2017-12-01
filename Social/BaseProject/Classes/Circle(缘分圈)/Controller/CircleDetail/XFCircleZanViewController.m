//
//  XFCircleZanViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleZanViewController.h"

@interface XFCircleZanViewController ()

@property (nonatomic, strong) YYLabel *zanLabel;

@end

@implementation XFCircleZanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setZanArray:(NSArray *)zanArray {
    _zanArray = zanArray;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < zanArray.count; i++) {
        NSString *name = zanArray[i];
        if ([name isKindOfClass:[NSString class]]) {
            NSMutableAttributedString *nameAttr = [[NSMutableAttributedString alloc] initWithString:name];
            [attrStr appendAttributedString:nameAttr];
            
            if (i != zanArray.count - 1) {
                NSMutableAttributedString *rightAttr = [[NSMutableAttributedString alloc] initWithString:@"、"];
                [attrStr appendAttributedString:rightAttr];
            }
        }
    }
    attrStr.font = FontB(15);
    attrStr.color = BlackColor;
    attrStr.lineSpacing = 8;
    self.zanLabel.attributedText = attrStr;
    self.zanLabel.numberOfLines = 0;
    self.zanLabel.textAlignment = NSTextAlignmentLeft;
    self.zanLabel.left = 17;
    self.zanLabel.top = 17;
    self.zanLabel.width = kScreenWidth - 17 * 2;
    CGFloat height = [YYTextLayout layoutWithContainerSize:CGSizeMake(self.zanLabel.width, CGFLOAT_MAX)
                                                      text:attrStr.copy].textBoundingSize.height;
    self.zanLabel.height = height;
}

- (CGFloat)scrollOffset {
    return 0;
}

- (YYLabel *)zanLabel {
    if (_zanLabel == nil) {
        _zanLabel = [YYLabel new];
        [self.view addSubview:_zanLabel];
    }
    return _zanLabel;
}

@end
