//
//  XFRefreshTool.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFRefreshTool.h"

@implementation XFRefreshTool

+ (MJRefreshNormalHeader *)xf_header:(id)target action:(SEL)action {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    return header;
}

+ (MJRefreshAutoNormalFooter *)xf_footer:(id)target action:(SEL)action {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    footer.refreshingTitleHidden = YES;
    return footer;
}

@end
