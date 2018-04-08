//
//  XFFriendFilterView.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/22.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFFriendFilterView.h"

@interface XFFriendFilterView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) FriendFilterType type;

@property (nonatomic, weak) UIView *charmProgressView;
@property (nonatomic, weak) UIView *charmSlider;
@property (nonatomic, weak) UILabel *charmCountLabel;
@property (nonatomic, weak) UIView *tortoiseProgressView;
@property (nonatomic, weak) UIView *tortoiseSlider;
@property (nonatomic, weak) UILabel *tortoiseCountLabel;

@property (nonatomic, strong) UILabel *topLeftLabel;
@property (nonatomic, strong) UILabel *topRightLabel;
@property (nonatomic, strong) UIView *topBlueView;
@property (nonatomic, strong) UIImageView *topLeftView;
@property (nonatomic, strong) UIImageView *topRightView;

@property (nonatomic, strong) UILabel *bottomLeftLabel;
@property (nonatomic, strong) UILabel *bottomRightLabel;
@property (nonatomic, strong) UIView *bottomBlueView;
@property (nonatomic, strong) UIImageView *bottomLeftView;
@property (nonatomic, strong) UIImageView *bottomRightView;

@end

@implementation XFFriendFilterView

- (instancetype)initWithDataArray:(NSArray *)dataArray
                      selectIndex:(NSInteger)index {
    if (self == [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.dataArray = dataArray;
        self.selectIndex = index;
        self.type = FriendFilterType_Normal;
        UIButton *topBtn = [UIButton xf_emptyButtonWithTarget:self action:@selector(dismiss)];
        topBtn.frame = CGRectMake(0, 0, kScreenWidth, XFNavHeight + XFFriendFilterHeight);
        [self addSubview:topBtn];

        UIButton *maskBtn = [UIButton xf_emptyButtonWithTarget:self action:@selector(dismiss)];
        maskBtn.frame = CGRectMake(0, topBtn.bottom, kScreenWidth, kScreenHeight - topBtn.bottom);
        maskBtn.backgroundColor = MaskColor;
        maskBtn.clipsToBounds = YES;
        [self addSubview:maskBtn];

        CGFloat realH = self.dataArray.count * 44;
        CGFloat maxH = maskBtn.height;
        self.tableView.frame = CGRectMake(0, -(MIN(realH, maxH)), maskBtn.width, MIN(realH, maxH));
        [self.tableView reloadData];
        [maskBtn addSubview:self.tableView];
        [self show];
    }
    return self;
}

- (instancetype)initWithCharmCount:(CGFloat)charmCount
                     tortoiseCount:(CGFloat)tortoiseCount {
    if (self == [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.type = FriendFilterType_Charm;
        UIButton *topBtn = [UIButton xf_emptyButtonWithTarget:self action:@selector(dismiss)];
        topBtn.frame = CGRectMake(0, 0, kScreenWidth, XFNavHeight + XFFriendFilterHeight);
        [self addSubview:topBtn];

        UIButton *maskBtn = [UIButton xf_emptyButtonWithTarget:self action:@selector(dismiss)];
        maskBtn.frame = CGRectMake(0, topBtn.bottom, kScreenWidth, kScreenHeight - topBtn.bottom);
        maskBtn.backgroundColor = MaskColor;
        maskBtn.clipsToBounds = YES;
        [self addSubview:maskBtn];

        UIView *contentView = [UIView xf_createViewWithColor:RGBGray(249)];
        self.contentView = contentView;
        [maskBtn addSubview:contentView];

        UILabel *charmLabel = [self createContentLabel:@"魅力分"];
        charmLabel.textAlignment = NSTextAlignmentLeft;
        charmLabel.frame = CGRectMake(20, 0, 100, 60);
        [contentView addSubview:charmLabel];

        UILabel *topLeftLabel = [UILabel xf_labelWithFont:Font(13)
                                                textColor:BlueColor
                                            numberOfLines:1
                                                alignment:NSTextAlignmentCenter];
        self.topLeftLabel = topLeftLabel;
        topLeftLabel.text = @"1";
        topLeftLabel.size = CGSizeMake(20, 20);
        topLeftLabel.top = charmLabel.bottom;
        topLeftLabel.centerX = 20;
        [contentView addSubview:topLeftLabel];

        UILabel *topRightLabel = [UILabel xf_labelWithFont:Font(13)
                                                 textColor:BlueColor
                                             numberOfLines:1
                                                 alignment:NSTextAlignmentCenter];
        self.topRightLabel = topRightLabel;
        topRightLabel.size = CGSizeMake(20, 20);
        topRightLabel.top = charmLabel.bottom;
        topRightLabel.centerX = KScreenWidth - 20;
        topRightLabel.text = @"10";
        [contentView addSubview:topRightLabel];

        UIView *topBgView = [self createProgressView:CGRectMake(20, topLeftLabel.bottom + 10, KScreenWidth - 40, 10)];
        [contentView addSubview:topBgView];

        UIView *topBlueView = [[UIView alloc] init];
        self.topBlueView = topBlueView;
        topBlueView.backgroundColor = BlueColor;
        topBlueView.frame = topBgView.bounds;
        [topBgView addSubview:topBlueView];

        UIImageView *topLeftView = [[UIImageView alloc] init];
        self.topLeftView = topLeftView;
        topLeftView.size = CGSizeMake(20, 20);
        topLeftView.top = topBgView.bottom + 5;
        topLeftView.centerX = 20;
        [topLeftView setImage:[UIImage imageNamed:@"xf_touch"]];
        //        topLeftView.backgroundColor = [UIColor redColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTopMin:)];
        topLeftView.userInteractionEnabled = YES;
        [topLeftView addGestureRecognizer:pan];
        [contentView addSubview:topLeftView];


        UIImageView *topRightView = [[UIImageView alloc] init];
        self.topRightView = topRightView;
        topRightView.size = CGSizeMake(20, 20);
        topRightView.top = topBgView.bottom + 5;
        topRightView.centerX = KScreenWidth - 20;
        [topRightView setImage:[UIImage imageNamed:@"xf_touch"]];
        UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTopMax:)];
        topRightView.userInteractionEnabled = YES;
        [topRightView addGestureRecognizer:pan1];
        [contentView addSubview:topRightView];


        UILabel *tortoiseLabel = [[UILabel alloc] init];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"金龟分"];
        attrStr.font = Font(13);
        attrStr.color = BlackColor;
        NSMutableAttributedString *rightStr = [[NSMutableAttributedString alloc] initWithString:@"(仅适用于男士)"];
        rightStr.font = Font(12);
        rightStr.color = RGBGray(153);
        [attrStr appendAttributedString:rightStr];
        tortoiseLabel.attributedText = attrStr;
        tortoiseLabel.frame = CGRectMake(20, topRightView.bottom + 40, 200, 60);
        [contentView addSubview:tortoiseLabel];

        UILabel *bottomLeftLabel = [UILabel xf_labelWithFont:Font(13)
                                                   textColor:BlueColor
                                               numberOfLines:1
                                                   alignment:NSTextAlignmentCenter];
        self.bottomLeftLabel = bottomLeftLabel;
        bottomLeftLabel.text = @"1";
        bottomLeftLabel.size = CGSizeMake(20, 20);
        bottomLeftLabel.top = tortoiseLabel.bottom;
        bottomLeftLabel.centerX = 20;
        [contentView addSubview:bottomLeftLabel];

        UILabel *bottomRightLabel = [UILabel xf_labelWithFont:Font(13)
                                                    textColor:BlueColor
                                                numberOfLines:1
                                                    alignment:NSTextAlignmentCenter];
        self.bottomRightLabel = bottomRightLabel;
        bottomRightLabel.size = CGSizeMake(20, 20);
        bottomRightLabel.top = tortoiseLabel.bottom;
        bottomRightLabel.centerX = KScreenWidth - 20;
        bottomRightLabel.text = @"10";
        [contentView addSubview:bottomRightLabel];

        UIView *bottomBgView = [self createProgressView:CGRectMake(20, bottomRightLabel.bottom + 10, KScreenWidth - 40, 10)];
        [contentView addSubview:bottomBgView];

        UIView *bottomBlueView = [[UIView alloc] init];
        self.bottomBlueView = bottomBlueView;
        bottomBlueView.backgroundColor = BlueColor;
        bottomBlueView.frame = bottomBgView.bounds;
        [bottomBgView addSubview:bottomBlueView];

        UIImageView *bottomLeftView = [[UIImageView alloc] init];
        self.bottomLeftView = bottomLeftView;
        bottomLeftView.size = CGSizeMake(20, 20);
        bottomLeftView.top = bottomBgView.bottom + 5;
        bottomLeftView.centerX = 20;
        [bottomLeftView setImage:[UIImage imageNamed:@"xf_touch"]];
        //        bottomLeftView.backgroundColor = [UIColor redColor];
        UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panBottomMin:)];
        bottomLeftView.userInteractionEnabled = YES;
        [bottomLeftView addGestureRecognizer:pan2];
        [contentView addSubview:bottomLeftView];


        UIImageView *bottomRightView = [[UIImageView alloc] init];
        self.bottomRightView = bottomRightView;
        bottomRightView.size = CGSizeMake(20, 20);
        bottomRightView.top = bottomBgView.bottom + 5;
        bottomRightView.centerX = KScreenWidth - 20;
        [bottomRightView setImage:[UIImage imageNamed:@"xf_touch"]];
        UIPanGestureRecognizer *pan3 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panBottomMax:)];
        bottomRightView.userInteractionEnabled = YES;
        [bottomRightView addGestureRecognizer:pan3];
        [contentView addSubview:bottomRightView];



        contentView.height = bottomRightView.bottom + 40;
        contentView.width = self.width;
        contentView.left = 0;
        contentView.bottom = 0;
        [self show];
    }
    return self;
}

- (instancetype)initWitiTopMin:(NSInteger)topMin
                        topMax:(NSInteger)topMax
                     bottomMin:(NSInteger)bottomMin
                     bottomMax:(NSInteger)bottomMax {
    if (self == [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.type = FriendFilterType_Charm;
        UIButton *topBtn = [UIButton xf_emptyButtonWithTarget:self action:@selector(dismiss)];
        topBtn.frame = CGRectMake(0, 0, kScreenWidth, XFNavHeight + XFFriendFilterHeight);
        [self addSubview:topBtn];

        UIButton *maskBtn = [UIButton xf_emptyButtonWithTarget:self action:@selector(dismiss)];
        maskBtn.frame = CGRectMake(0, topBtn.bottom, kScreenWidth, kScreenHeight - topBtn.bottom);
        maskBtn.backgroundColor = MaskColor;
        maskBtn.clipsToBounds = YES;
        [self addSubview:maskBtn];

        UIView *contentView = [UIView xf_createViewWithColor:RGBGray(249)];
        self.contentView = contentView;
        [maskBtn addSubview:contentView];

        UILabel *charmLabel = [self createContentLabel:@"魅力分"];
        charmLabel.textAlignment = NSTextAlignmentLeft;
        charmLabel.frame = CGRectMake(20, 0, 100, 60);
        [contentView addSubview:charmLabel];

        UILabel *topLeftLabel = [UILabel xf_labelWithFont:Font(13)
                                                textColor:BlueColor
                                            numberOfLines:1
                                                alignment:NSTextAlignmentCenter];
        self.topLeftLabel = topLeftLabel;
        topLeftLabel.text = @"1";
        topLeftLabel.size = CGSizeMake(20, 20);
        topLeftLabel.top = charmLabel.bottom;
        topLeftLabel.centerX = 20;
        [contentView addSubview:topLeftLabel];

        UILabel *topRightLabel = [UILabel xf_labelWithFont:Font(13)
                                                 textColor:BlueColor
                                             numberOfLines:1
                                                 alignment:NSTextAlignmentCenter];
        self.topRightLabel = topRightLabel;
        topRightLabel.size = CGSizeMake(20, 20);
        topRightLabel.top = charmLabel.bottom;
        topRightLabel.centerX = KScreenWidth - 20;
        topRightLabel.text = @"10";
        [contentView addSubview:topRightLabel];

        UIView *topBgView = [self createProgressView:CGRectMake(20, topLeftLabel.bottom + 10, KScreenWidth - 40, 10)];
        [contentView addSubview:topBgView];

        UIView *topBlueView = [[UIView alloc] init];
        self.topBlueView = topBlueView;
        topBlueView.backgroundColor = BlueColor;
        topBlueView.frame = topBgView.bounds;
        [topBgView addSubview:topBlueView];

        UIImageView *topLeftView = [[UIImageView alloc] init];
        topLeftView.image = Image(@"xf_touch");
        self.topLeftView = topLeftView;
        topLeftView.size = CGSizeMake(33, 36);
        topLeftView.top = topBgView.bottom - 5;
        topLeftView.centerX = 20;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTopMin:)];
        topLeftView.userInteractionEnabled = YES;
        [topLeftView addGestureRecognizer:pan];
        [contentView addSubview:topLeftView];


        UIImageView *topRightView = [[UIImageView alloc] init];
        topRightView.image = Image(@"xf_touch");
        self.topRightView = topRightView;
        topRightView.size = CGSizeMake(33, 36);
        topRightView.top = topBgView.bottom - 5;
        topRightView.centerX = KScreenWidth - 20;
        UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTopMax:)];
        topRightView.userInteractionEnabled = YES;
        [topRightView addGestureRecognizer:pan1];
        [contentView addSubview:topRightView];

        CGFloat itemW = topBgView.width * 0.1;
        CGFloat left = 0;
        CGFloat right = 0;
        if (topMin == 1) {
            left = 0;
        } else {
            left = itemW * topMin - itemW * 0.5;
        }

        if (topMax == 10) {
            right = topBgView.width;
        } else {
            right = itemW * topMax - itemW * 0.5;
        }

        self.topBlueView.left = left;
        self.topBlueView.width = right - left;
        self.topLeftLabel.text = [NSString stringWithFormat:@"%zd", topMin];
        self.topRightLabel.text = [NSString stringWithFormat:@"%zd", topMax];


        UILabel *tortoiseLabel = [[UILabel alloc] init];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"金龟分"];
        attrStr.font = Font(13);
        attrStr.color = BlackColor;
        NSMutableAttributedString *rightStr = [[NSMutableAttributedString alloc] initWithString:@"(仅适用于男士)"];
        rightStr.font = Font(12);
        rightStr.color = RGBGray(153);
        [attrStr appendAttributedString:rightStr];
        tortoiseLabel.attributedText = attrStr;
        tortoiseLabel.frame = CGRectMake(20, topRightView.bottom + 40, 200, 60);
        [contentView addSubview:tortoiseLabel];

        UILabel *bottomLeftLabel = [UILabel xf_labelWithFont:Font(13)
                                                   textColor:BlueColor
                                               numberOfLines:1
                                                   alignment:NSTextAlignmentCenter];
        self.bottomLeftLabel = bottomLeftLabel;
        bottomLeftLabel.text = @"1";
        bottomLeftLabel.size = CGSizeMake(20, 20);
        bottomLeftLabel.top = tortoiseLabel.bottom;
        bottomLeftLabel.centerX = 20;
        [contentView addSubview:bottomLeftLabel];

        UILabel *bottomRightLabel = [UILabel xf_labelWithFont:Font(13)
                                                    textColor:BlueColor
                                                numberOfLines:1
                                                    alignment:NSTextAlignmentCenter];
        self.bottomRightLabel = bottomRightLabel;
        bottomRightLabel.size = CGSizeMake(20, 20);
        bottomRightLabel.top = tortoiseLabel.bottom;
        bottomRightLabel.centerX = KScreenWidth - 20;
        bottomRightLabel.text = @"10";
        [contentView addSubview:bottomRightLabel];

        UIView *bottomBgView = [self createProgressView:CGRectMake(20, bottomRightLabel.bottom + 10, KScreenWidth - 40, 10)];
        [contentView addSubview:bottomBgView];

        UIView *bottomBlueView = [[UIView alloc] init];
        self.bottomBlueView = bottomBlueView;
        bottomBlueView.backgroundColor = BlueColor;
        bottomBlueView.frame = bottomBgView.bounds;
        [bottomBgView addSubview:bottomBlueView];

        UIImageView *bottomLeftView = [[UIImageView alloc] init];
        bottomLeftView.image = Image(@"xf_touch");
        self.bottomLeftView = bottomLeftView;
        bottomLeftView.size = CGSizeMake(33, 36);
        bottomLeftView.top = bottomBgView.bottom - 5;
        bottomLeftView.centerX = 20;
        UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panBottomMin:)];
        bottomLeftView.userInteractionEnabled = YES;
        [bottomLeftView addGestureRecognizer:pan2];
        [contentView addSubview:bottomLeftView];


        UIImageView *bottomRightView = [[UIImageView alloc] init];
        bottomRightView.image = Image(@"xf_touch");
        self.bottomRightView = bottomRightView;
        bottomRightView.size = CGSizeMake(33, 36);
        bottomRightView.top = bottomBgView.bottom - 5;
        bottomRightView.centerX = KScreenWidth - 20;
        UIPanGestureRecognizer *pan3 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panBottomMax:)];
        bottomRightView.userInteractionEnabled = YES;
        [bottomRightView addGestureRecognizer:pan3];
        [contentView addSubview:bottomRightView];

        if (bottomMin == 1) {
            left = 0;
        } else {
            left = itemW * bottomMin - itemW * 0.5;
        }

        if (bottomMax == 10) {
            right = bottomBgView.width;
        } else {
            right = itemW * bottomMax - itemW * 0.5;
        }

        self.bottomBlueView.left = left;
        self.bottomBlueView.width = right - left;
        self.bottomLeftLabel.text = [NSString stringWithFormat:@"%zd", bottomMin];
        self.bottomRightLabel.text = [NSString stringWithFormat:@"%zd", bottomMax];
        [self setupInitLabelAndView];


        contentView.height = bottomRightView.bottom + 40;
        contentView.width = self.width;
        contentView.left = 0;
        contentView.bottom = 0;
        [self show];
    }
    return self;
}

- (void)setupInitLabelAndView {
    self.topLeftLabel.centerX = self.topLeftView.centerX = self.topBlueView.left + self.topBlueView.superview.left;
    self.topRightLabel.centerX = self.topRightView.centerX = self.topBlueView.right + self.topBlueView.superview.left;

    self.bottomLeftLabel.centerX = self.bottomLeftView.centerX = self.bottomBlueView.left + self.bottomBlueView.superview.left;
    self.bottomRightLabel.centerX = self.bottomRightView.centerX = self.bottomBlueView.right + self.bottomBlueView.superview.left;
}

- (void)panTopMin:(UIPanGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [ges translationInView:self];
        ges.view.centerX += point.x;
        if (ges.view.centerX < 20) {
            ges.view.centerX = 20;
        } else if (ges.view.right > self.topRightLabel.left) {
            ges.view.right = self.topRightLabel.left;
        }
        [ges setTranslation:CGPointZero inView:self];
        [self setupTopContent];
    }
}

- (void)setupTopContent {
    self.topLeftLabel.centerX = self.topLeftView.centerX;
    self.topRightLabel.centerX = self.topRightView.centerX;
    CGFloat itemW = self.topBlueView.superview.width * 0.1;
    self.topBlueView.left = self.topLeftView.centerX - self.topBlueView.superview.left;
    int leftIndex = self.topBlueView.left / itemW + 1;
    self.topBlueView.width = self.topRightView.centerX - self.topLeftView.centerX;
    int rightIndex = self.topBlueView.right / itemW + 1;
    if (leftIndex >= rightIndex) {
        leftIndex = rightIndex - 1;
    }
    if (rightIndex <= leftIndex) {
        rightIndex = leftIndex + 1;
    }

    if (rightIndex > 10) {
        rightIndex = 10;
        if (leftIndex > 9) {
            leftIndex = 9;
        }
    } else if (leftIndex < 1) {
        leftIndex = 1;
        if (rightIndex < 2) {
            rightIndex = 2;
        }
    }
    self.topLeftLabel.text = [NSString stringWithFormat:@"%d", leftIndex];
    self.topRightLabel.text = [NSString stringWithFormat:@"%d", rightIndex];
    FFLog(@"上边----%d----%d", leftIndex, rightIndex);
}

- (void)panTopMax:(UIPanGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [ges translationInView:self];
        ges.view.centerX += point.x;
        if (ges.view.centerX > KScreenWidth - 20) {
            ges.view.centerX = KScreenWidth - 20;
        } else if (ges.view.left < self.topLeftLabel.right) {
            ges.view.left = self.topLeftLabel.right;
        }
        [ges setTranslation:CGPointZero inView:self];
        [self setupTopContent];
    }
}

- (void)panBottomMin:(UIPanGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [ges translationInView:self];
        ges.view.centerX += point.x;
        if (ges.view.centerX < 20) {
            ges.view.centerX = 20;
        } else if (ges.view.right > self.bottomRightLabel.left) {
            ges.view.right = self.bottomRightLabel.left;
        }
        [ges setTranslation:CGPointZero inView:self];
        [self setupBottomContent];
    }
}

- (void)setupBottomContent {
    self.bottomLeftLabel.centerX = self.bottomLeftView.centerX;
    self.bottomRightLabel.centerX = self.bottomRightView.centerX;
    CGFloat itemW = self.bottomBlueView.superview.width * 0.1;
    self.bottomBlueView.left = self.bottomLeftView.centerX - self.bottomBlueView.superview.left;
    int leftIndex = self.bottomBlueView.left / itemW + 1;
    self.bottomBlueView.width = self.bottomRightView.centerX - self.bottomLeftView.centerX;
    int rightIndex = self.bottomBlueView.right / itemW + 1;
    if (leftIndex >= rightIndex) {
        leftIndex = rightIndex - 1;
    }
    if (rightIndex <= leftIndex) {
        rightIndex = leftIndex + 1;
    }

    if (rightIndex > 10) {
        rightIndex = 10;
        if (leftIndex > 9) {
            leftIndex = 9;
        }
    } else if (leftIndex < 1) {
        leftIndex = 1;
        if (rightIndex < 2) {
            rightIndex = 2;
        }
    }
    self.bottomLeftLabel.text = [NSString stringWithFormat:@"%d", leftIndex];
    self.bottomRightLabel.text = [NSString stringWithFormat:@"%d", rightIndex];
    FFLog(@"下边----%d----%d", leftIndex, rightIndex);
}

- (void)panBottomMax:(UIPanGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [ges translationInView:self];
        ges.view.centerX += point.x;
        if (ges.view.centerX > KScreenWidth - 20) {
            ges.view.centerX = KScreenWidth - 20;
        } else if (ges.view.left < self.bottomLeftLabel.right) {
            ges.view.left = self.bottomLeftLabel.right;
        }
        [ges setTranslation:CGPointZero inView:self];
        [self setupBottomContent];
    }
}

#pragma mark ----------<UITableViewDataSource>----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = Font(13);
    cell.textLabel.textColor = BlackColor;
    cell.backgroundColor = indexPath.row == self.selectIndex ? RGBGray(242) : WhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ----------<UITableViewDelegate>----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
    [self dismiss];
}

- (void)pressSlider:(UISlider *)slider {
    if (slider == self.charmSlider) {
        CGFloat rightW = self.charmProgressView.width * (1 - slider.value * 0.1);
        UIView *rightView = [self.charmProgressView viewWithTag:100];
        rightView.width = rightW;
        rightView.left = self.charmProgressView.width - rightView.width;
    } else {
        CGFloat rightW = self.tortoiseProgressView.width * (1 - slider.value * 0.1);
        UIView *rightView = [self.tortoiseProgressView viewWithTag:100];
        rightView.width = rightW;
        rightView.left = self.tortoiseProgressView.width - rightView.width;
    }
    [self resetCountLabel:slider];
}

- (void)resetCountLabel:(UISlider *)slider {
    CGFloat centerX = slider.width * slider.value * 0.1 + slider.left;
    if (slider.value > 5) {
        centerX -= (slider.value - 5) * 3.2;
    } else {
        centerX += (5 - slider.value) * 3.2;
    }
    NSString *text = [NSString stringWithFormat:@"%d", (int)slider.value];
    //    if ([text isEqualToString:@"0.0"]) text = @"0";
    //    if ([text isEqualToString:@"10.0"]) text = @"10";
    if (slider == self.charmSlider) {
        self.charmCountLabel.centerX = centerX;
        self.charmCountLabel.text = text;
    } else {
        self.tortoiseCountLabel.centerX = centerX;
        self.tortoiseCountLabel.text = text;
    }
}

- (void)show {
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        if (self.type == FriendFilterType_Normal) {
            self.tableView.top = 0;
        } else {
            self.contentView.top = 0;
        }
    }];
}
- (void)dismiss {
    if (self.type == FriendFilterType_Normal) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(friendFilterView:didSelect:)]) {
            [self.delegate friendFilterView:self didSelect:self.dataArray[self.selectIndex]];
        }
    } else if (self.type == FriendFilterType_Charm) {
        //        if (self.delegate && [self.delegate respondsToSelector:@selector(friendFilterView:didSelectCharm:tortoise:)]) {
        //            [self.delegate friendFilterView:self didSelectCharm:self.charmCountLabel.text tortoise:self.tortoiseCountLabel.text];
        //        }
        //------------- 上面的废弃
        if (self.delegate && [self.delegate respondsToSelector:@selector(friendFilterView:didSelectTopMin:topMax:bottomMin:bottomMax:)]) {
            [self.delegate friendFilterView:self didSelectTopMin:self.topLeftLabel.text.integerValue topMax:self.topRightLabel.text.integerValue bottomMin:self.bottomLeftLabel.text.integerValue bottomMax:self.bottomRightLabel.text.integerValue];
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        if (self.type == FriendFilterType_Normal) {
            self.tableView.bottom = 0;
        } else {
            self.contentView.bottom = 0;
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.backgroundColor = WhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UILabel *)createContentLabel:(NSString *)text {
    UILabel *label = [UILabel xf_labelWithFont:Font(13)
                                     textColor:BlackColor
                                 numberOfLines:1
                                     alignment:NSTextAlignmentCenter];
    label.text = text;
    return label;
}

- (UIView *)createProgressView:(CGRect)rect {
    UIView *bgView = [[UIView alloc] initWithFrame:rect];
    [bgView.layer addSublayer:[UIColor setGradualChangingColor:bgView fromColor:@"ffffff" toColor:@"4BDCC7"]];
    [bgView xf_cornerCut:6];
    bgView.layer.borderColor = RGBGray(204).CGColor;
    bgView.layer.borderWidth = 1;

    UIView *rightView = [UIView xf_createViewWithColor:RGBGray(238)];
    rightView.height = bgView.height;
    rightView.top = 0;
    rightView.width = bgView.width;
    rightView.left = bgView.width - rightView.width;
    rightView.tag = 100;
    [bgView addSubview:rightView];
    return bgView;
}

- (UISlider *)createSlider {
    UISlider *slider = [[UISlider alloc] init];
    [slider setThumbImage:Image(@"slider") forState:UIControlStateNormal];
    slider.maximumValue = 10;
    slider.minimumValue = 0;
    slider.minimumTrackTintColor = [UIColor clearColor];
    slider.maximumTrackTintColor = [UIColor clearColor];
    [slider addTarget:self action:@selector(pressSlider:) forControlEvents:UIControlEventValueChanged];
    return slider;
}

@end

