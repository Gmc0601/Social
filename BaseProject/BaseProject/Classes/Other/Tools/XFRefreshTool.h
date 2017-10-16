//
//  XFRefreshTool.h
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFRefreshTool : NSObject

+ (MJRefreshNormalHeader *)xf_header:(id)target action:(SEL)action;
+ (MJRefreshAutoNormalFooter *)xf_footer:(id)target action:(SEL)action;

@end
