//
//  XFCircleContentCellModel.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleContentCellModel.h"
#import "XFCirclePicView.h"

@implementation XFCircleContentCellModel

- (instancetype)initWithCircle:(Circle *)circle andType:(CircleContentModelType)type {
    _circle = circle;
    _type = type;
    CGRect rect = CGRectZero;
    
    
    if (type == CircleContentModelType_Home || type == CircleContentModelType_Detail) {
        self.paddingViewFrame = CGRectMake(0, 0, kScreenWidth, 5);
        self.iconViewFrame = CGRectMake(15, CGRectGetMaxY(self.paddingViewFrame) + 15, 50, 50);
        rect.size = CGSizeMake(55, 22);
        rect.origin.y = 13 + CGRectGetMaxY(self.paddingViewFrame);
        rect.origin.x = kScreenWidth - 15 - rect.size.width;
        self.followBtnFrame = rect;
        
        rect.origin.x = CGRectGetMaxX(self.iconViewFrame) + 20;
        rect.origin.y = CGRectGetMinY(self.iconViewFrame) + 2;
        CGSize timeSize = [circle.upload_time xf_sizeWithFont:Font(12)];
        CGFloat nameMaxW = CGRectGetMinX(self.followBtnFrame) - 5 - timeSize.width - 5 - rect.origin.x;
        if (circle.nickname.length == 0) {
            circle.nickname = @"服务器没名字";
        }
        rect.size = [circle.nickname xf_sizeWithFont:Font(15) maxW:nameMaxW];
        self.nameLabelFrame = rect;
        
        rect.size = timeSize;
        rect.origin.x = CGRectGetMaxX(self.nameLabelFrame) + 5;
        rect.origin.y = CGRectGetMidY(self.nameLabelFrame) - rect.size.height * 0.5;
        self.timeLabelFrame = rect;
        
        CGFloat contentLeft = CGRectGetMaxX(self.iconViewFrame) + 20;
        rect.origin.x = contentLeft;
        CGFloat descW = CGRectGetMaxX(self.followBtnFrame) - rect.origin.x;
        rect.size = [circle.talk_content xf_sizeWithFont:Font(14) maxW:descW];
        rect.origin.y = CGRectGetMaxY(self.iconViewFrame) - 15;
        self.descLabelFrame = rect;
    } else {
        self.timeLabelFrame = CGRectMake(0, 25, 85, 15);
        CGRect rect = CGRectZero;
        rect.origin.x = CGRectGetMaxX(self.timeLabelFrame);
        rect.origin.y = 25;
        rect.size.width = kScreenWidth - 20 - rect.origin.x;
        rect.size.height = [circle.talk_content xf_sizeWithFont:Font(14) maxW:rect.size.width].height;
        self.descLabelFrame = rect;
    }
    
    CGFloat maxContentH = CGRectGetMaxY(self.descLabelFrame) + 20;
    CGFloat contentLeft = CGRectGetMinX(self.descLabelFrame);
    if (circle.upload_type.integerValue == 1) {
        // 图片
        NSArray *picArray = circle.image;
        int itemCount = picArray.count == 4 ? 2 : 3;
        CGFloat itemWH = 87;
        CGFloat padding = 7;
        CGFloat picViewH = 0;
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i < picArray.count; i++) {
            int col = i % itemCount;
            int row = i / itemCount;
            
            CGFloat itemX = col * (itemWH + padding);
            CGFloat itemY = row * (itemWH + padding);
            rect = CGRectMake(itemX, itemY, itemWH, itemWH);
            [arrayM addObject:[NSValue valueWithCGRect:rect]];
            picViewH = CGRectGetMaxY(rect);
        }
        self.picFArray = arrayM.copy;
        
        rect.origin.x = contentLeft;
        rect.origin.y = maxContentH;
        rect.size.height = picViewH;
        rect.size.width = kScreenWidth - rect.origin.x;
        self.picViewFrame = rect;
        maxContentH = CGRectGetMaxY(self.picViewFrame);
    } else if (circle.upload_type.integerValue == 2) {
        self.videoFrame = CGRectMake(contentLeft, maxContentH, 87, 87);
        maxContentH = CGRectGetMaxY(self.videoFrame);
    }
    
    self.circleContentFrame = CGRectMake(0, 0, kScreenWidth, maxContentH);
    
    if (type != CircleContentModelType_My) {
        CGFloat bottomItemH = 55;
        CGFloat rewardW = [[NSString stringWithFormat:@" %d", circle.reward_num.intValue] xf_sizeWithFont:Font(12)].width + 20;
        rect.size.height = bottomItemH;
        rect.size.width = rewardW;
        rect.origin.x = contentLeft;
        rect.origin.y = maxContentH;
        self.rewardBtnFrame = rect;
        
        CGFloat shareW = [[NSString stringWithFormat:@" %d", circle.transmit_num.intValue] xf_sizeWithFont:Font(12)].width + 20;
        rect.origin.x = CGRectGetMaxX(rect) + 20;
        rect.size.width = shareW;
        self.shareBtnFrame = rect;
        
        CGFloat zanW = [[NSString stringWithFormat:@" %d", circle.like_num.intValue] xf_sizeWithFont:Font(12)].width + 20;
        rect.origin.x = CGRectGetMaxX(rect) + 20;
        rect.size.width = zanW;
        self.zanBtnFrame = rect;
        
        CGFloat commentW = [[NSString stringWithFormat:@" %d", circle.comment_num.intValue] xf_sizeWithFont:Font(12)].width + 20;
        rect.origin.x = CGRectGetMaxX(rect) + 20;
        rect.size.width = commentW;
        self.commentBtnFrame = rect;
        
        self.cellH = CGRectGetMaxY(self.commentBtnFrame);
    } else {
        self.deleteBtnFrame = CGRectMake(kScreenWidth - 50, maxContentH, 50, 50);
        self.cellH = CGRectGetMaxY(self.deleteBtnFrame);
    }
    
    return self;
}

@end
