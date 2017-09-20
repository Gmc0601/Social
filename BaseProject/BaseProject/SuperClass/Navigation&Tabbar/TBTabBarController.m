//
//  TBTabBarController.m
//  BaseProject
//
//  Created by cc on 2017/6/22.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "TBTabBarController.h"
#import "MyCenterViewController.h"
#import "MessageListViewController.h"
#import "ContactViewController.h"
#import "MomentsViewController.h"
#import "ViewController.h"
#import "TBNavigationController.h"
#import "TBTabBar.h"

@interface TBTabBarController ()

@end

@implementation TBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化所有控制器
    [self setUpChildVC];
    
}


#pragma mark -初始化所有控制器 

- (void)setUpChildVC {

    MessageListViewController *newsVc = [[MessageListViewController alloc] init];
    [self setChildVC:newsVc title:@"消息" image:@"icon_xx_tab-拷贝" selectedImage:@"icon_xx_tab"];

    ContactViewController *investment = [[ContactViewController alloc] init];
    [self setChildVC:investment title:@"有缘人" image:@"icon_yyr_tab_pre" selectedImage:@"icon_yyr_tab"];
    
    MomentsViewController *moment = [[MomentsViewController alloc] init];
    [self setChildVC:moment title:@"缘分圈" image:@"icon_yfq_tab" selectedImage:@"icon_yfq_tab_pre"];
    
    MyCenterViewController *myVC = [[MyCenterViewController alloc] init];
    [self setChildVC:myVC title:@"我" image:@"icon_wd_tab_pre" selectedImage:@"icon_wd_tab"];

}

- (void) setChildVC:(UIViewController *)childVC title:(NSString *) title image:(NSString *) image selectedImage:(NSString *) selectedImage {
    
    childVC.tabBarItem.title = title;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVC.tabBarItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    TBNavigationController *nav = [[TBNavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"item name = %@", item.title);
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];
}
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer] 
     addAnimation:pulse forKey:nil]; 
}

@end
