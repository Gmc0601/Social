//
//  MessageListViewController.m
//  BaseProject
//
//  Created by cc on 2017/9/20.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MessageListViewController.h"
#import "ChatViewController.h"
@interface MessageListViewController ()

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"消息"];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 200, 100)];
    [btn setTitle:@"aaaa" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)click {
    [self.navigationController pushViewController:[ChatViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
