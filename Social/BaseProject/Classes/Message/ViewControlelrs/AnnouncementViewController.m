//
//  AnnouncementViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AnnouncementViewController.h"


@interface MessageDetailModle : NSObject

@property (nonatomic, copy) NSString *id, *title, *content, *create_time;

@end

@implementation MessageDetailModle

@end

@interface AnnouncementViewController ()<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (nonatomic, retain) UILabel *titleLabel, *timeLab;

@property (nonatomic, retain) UIWebView *webview;

@property (nonatomic, retain) UITableView *noUseTableView;

@property (nonatomic, retain) MessageDetailModle *model;

@end

@implementation AnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"公告详情";
    self.rightBtn.hidden= YES;
    
    [self.view addSubview:self.noUseTableView];
    
    NSDictionary *dic = @{
                          @"id": self.id
                          };
    
    [HttpRequest postPath:@"_notice_particulars_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            NSDictionary *info = datadic[@"info"];
            self.model = [[MessageDetailModle alloc] init];
            self.model.id = [NSString stringWithFormat:@"%@", info[@"id"]];
            self.model.title = [NSString stringWithFormat:@"%@", info[@"title"]];
            self.model.create_time = [NSString stringWithFormat:@"%@", info[@"create_time"]];
            self.model.content = [NSString  stringWithFormat:@"%@", info[@"content"]];
            self.titleLabel.text = self.model.title;
            self.timeLab.text = self.model.create_time;
            NSString *strHTML = self.model.content;
            [self.webview loadHTMLString:strHTML baseURL:nil];
            [self.noUseTableView reloadData];
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
    
    /*
     NSString *strHTML = @"<p>你好</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;这是一个例子，请显示</p><p>外加一个table</p><table><tbody><tr class=\"firstRow\"><td valign=\"top\" width=\"261\">aaaa</td><td valign=\"top\" width=\"261\">bbbb</td><td valign=\"top\" width=\"261\">cccc</td></tr></tbody></table><p></p>";
     
     UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bonus];
     [self.view addSubview:webView];
     
     [webView loadHTMLString:strHTML baseURL:nil];
     */
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
//    self.webview.frame = FRAME(15, self.titleLabel.bottom + 10, kScreenW - 30, webView.scrollView.height);
    [self fourAutoHeight:webView];
    self.timeLab.frame = FRAME(15, self.webview.bottom + 10, kScreenW - 30, 15);
    
}

-(void)fourAutoHeight:(UIWebView*)webView{
    /* 设置新的高度*/
    CGFloat WebViewHeight = 0.0;
    /* 判断是否有内容存在*/
    //  NSLog(@"%@",[webView subviews]);
    /*
     2016-10-08 14:35:19.057 获取UIWebview的高度[2456:1247177] (
     "<_UIWebViewScrollView: 0x7ff84383b600; frame = (0 0; 355 200); clipsToBounds = YES; autoresize = H; gestureRecognizers = <NSArray: 0x618000054760>; layer = <CALayer: 0x61800003ff40>; contentOffset: {0, 0}; contentSize: {355, 439}>"
     )
     */
    if ([webView subviews].count >0) {
        /* 获取最后一个div*/
        UIScrollView * WebViewLastView = [[webView subviews] lastObject];
        NSLog(@"%@",[WebViewLastView subviews]);
        /*
         输出内容：
         2016-10-08 14:36:47.795 获取UIWebview的高度[2473:1255283] (
         "<UIWebBrowserView: 0x7fbc8980ee00; frame = (0 0; 355 439); text = ' \n\U56fd\U6709\U80cc\U666f \U5b9e\U529b\U4fdd\U969c\n\U8d85\U5f3a\U6297\U98ce\U9669\U80fd\U529b\n \n\U4e13\U4e1a\U7684...'; gestureRecognizers = <NSArray: 0x608000059410>; layer = <UIWebLayer: 0x61800002c680>>",
         "<UIImageView: 0x7fbc8b10d680; frame = (3 194.5; 349 2.5); alpha = 0; opaque = NO; autoresize = TM; userInteractionEnabled = NO; layer = <CALayer: 0x6000000309a0>> - (null)",
         "<UIImageView: 0x7fbc8b10edf0; frame = (349.5 3; 2.5 194); alpha = 0; opaque = NO; autoresize = LM; userInteractionEnabled = NO; layer = <CALayer: 0x600000030ba0>> - (null)"
         )
         */
        /* 下面有两个方法*/
        /*****************************************************/
        /*
         /- 第一个 -/
         if ([WebViewLastView isKindOfClass:[NSClassFromString(@"_UIWebViewScrollView") class]]) {
         WebViewHeight = WebViewLastView.contentSize.height;
         }
         /- 获取网页现有的frame -/
         CGRect WebViewRect = webView.frame;
         /- 改版WebView的高度 -/
         WebViewRect.size.height = WebViewHeight;
         /- 重新设置网页的frame -/
         webView.frame = WebViewRect;
         */
        /*****************************************************/
        /* 第二种*/
        if ([WebViewLastView isKindOfClass:[NSClassFromString(@"_UIWebViewScrollView") class]]) {
            UIView * WebViewLastViewB = [WebViewLastView.subviews firstObject];
            if ([WebViewLastViewB isKindOfClass:[NSClassFromString(@"UIWebBrowserView") class]]) {
                WebViewHeight = WebViewLastViewB.frame.size.height;
            }
        }
        /* 获取网页现有的frame*/
        CGRect WebViewRect = webView.frame;
        /* 改版WebView的高度*/
        WebViewRect.size.height = WebViewHeight;
        /* 重新设置网页的frame*/
        webView.frame = WebViewRect;
        self.timeLab.frame = FRAME(15, self.webview.bottom + 10, kScreenW - 30, 15);
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return nil;
}

- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64)];
            
            [view addSubview:self.titleLabel];
            
            [view addSubview:self.webview];
            
            [view addSubview:self.timeLab];
            
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeigh(0))];
            view;
        });
    }
    return _noUseTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:FRAME(15, 20, kScreenW, 20)];
        _titleLabel.font = NormalFont(20);
    }
    return _titleLabel;
}

- (UIWebView *)webview {
    if (!_webview) {
        _webview = [[UIWebView alloc] initWithFrame:FRAME(15, self.titleLabel.bottom + 10, kScreenW - 30, 20)];
        NSString *strHTML = self.model.content;
        _webview.delegate = self;
        _webview.backgroundColor = [UIColor clearColor];
        [_webview loadHTMLString:strHTML baseURL:nil];
    }
    return _webview;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:FRAME(15, self.webview.bottom + 10, kScreenW - 30, 15)];
        _timeLab.font = NormalFont(13);
        _timeLab.textColor = UIColorFromHex(0x666666);
    }
    return _timeLab;
}


@end
