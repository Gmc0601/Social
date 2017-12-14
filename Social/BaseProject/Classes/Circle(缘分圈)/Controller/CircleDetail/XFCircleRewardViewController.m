//
//  XFCircleRewardViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleRewardViewController.h"
#import "XFFriendHomeViewController.h"

@interface XFCircleRewardViewController ()

@property (nonatomic, strong) YYLabel *rewardLabel;

@end

@implementation XFCircleRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < self.rewardArray.count; i++) {
        User *user = self.rewardArray[i];
        if ([user.nickname isKindOfClass:[NSString class]]) {
            NSMutableAttributedString *nameAttr = [[NSMutableAttributedString alloc] initWithString:user.nickname];
            WeakSelf
            [nameAttr setTextHighlightRange:nameAttr.rangeOfAll
                                      color:BlackColor
                            backgroundColor:[UIColor clearColor]
                                  tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                      XFFriendHomeViewController *controller = [[XFFriendHomeViewController alloc] init];
                                      controller.friendId = user.user_id;;
                                      [weakSelf pushController:controller];
                                  }];
            
            [attrStr appendAttributedString:nameAttr];
            if (i != self.rewardArray.count - 1) {
                NSMutableAttributedString *rightAttr = [[NSMutableAttributedString alloc] initWithString:@"、"];
                [attrStr appendAttributedString:rightAttr];
            }
        }
    }
    attrStr.font = FontB(15);
    attrStr.color = BlackColor;
    attrStr.lineSpacing = 8;
    self.rewardLabel.attributedText = attrStr;
    self.rewardLabel.numberOfLines = 0;
    self.rewardLabel.textAlignment = NSTextAlignmentLeft;
    self.rewardLabel.left = 17;
    self.rewardLabel.top = 17;
    self.rewardLabel.width = kScreenWidth - 17 * 2;
    CGFloat height = [YYTextLayout layoutWithContainerSize:CGSizeMake(self.rewardLabel.width, CGFLOAT_MAX)
                                                      text:attrStr.copy].textBoundingSize.height;
    self.rewardLabel.height = height;
}

- (void)resetLabel:(NSArray *)rewardArray {
    self.rewardArray = rewardArray;
    [self setupUI];
}


- (CGFloat)scrollOffset {
    return 0;
}

- (YYLabel *)rewardLabel {
    if (_rewardLabel == nil) {
        _rewardLabel = [YYLabel new];
        [self.view addSubview:_rewardLabel];
    }
    return _rewardLabel;
}

@end
