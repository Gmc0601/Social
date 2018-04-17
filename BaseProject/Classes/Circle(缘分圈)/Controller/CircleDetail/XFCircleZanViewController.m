//
//  XFCircleZanViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleZanViewController.h"
#import "XFFriendHomeViewController.h"
#import "XFOriginTableViewCell.h"

@interface XFCircleZanViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentPage;



@end

@implementation XFCircleZanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (CGFloat)scrollOffset {
    return _tableView.contentOffset.y;
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - XFNavHeight - XFCircleTabHeight - XFCircleDetailBottomHeight);

    [self.tableView reloadData];
}

- (void)reloadTheData {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.zanArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFOriginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFOriginTableViewCell" forIndexPath:indexPath];
    
    User *user = self.zanArray[indexPath.row];
    [cell becomeValue:user];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    User *user = self.zanArray[indexPath.row];
    XFFriendHomeViewController *controller = [[XFFriendHomeViewController alloc] init];
    controller.friendId = user.user_id;
    [self pushController:controller];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = WhiteColor;

        [_tableView registerNib:[UINib nibWithNibName:@"XFOriginTableViewCell" bundle:nil] forCellReuseIdentifier:@"XFOriginTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
/*
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setZanArray:(NSArray *)zanArray {
    _zanArray = zanArray;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < zanArray.count; i++) {
        User *user = zanArray[i];
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
*/
