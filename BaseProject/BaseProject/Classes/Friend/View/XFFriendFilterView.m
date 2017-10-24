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
        
        UILabel *charmZeroLabel = [self createContentLabel:@"0"];
        charmZeroLabel.frame = CGRectMake(20, charmLabel.bottom, 30, 50);
        [contentView addSubview:charmZeroLabel];
        
        UILabel *charmTenLabel = [self createContentLabel:@"10"];
        charmTenLabel.frame = CGRectMake(self.width - 50, charmLabel.bottom, 50, 50);
        [contentView addSubview:charmTenLabel];
        
        CGRect rect = CGRectZero;
        rect.origin.x = charmZeroLabel.right;
        rect.size.width = charmTenLabel.left - rect.origin.x;
        rect.size.height = 12;
        rect.origin.y = charmZeroLabel.centerY - rect.size.height * 0.5;
        
        UIView *charmProgressView = [self createProgressView:rect];
        self.charmProgressView = charmProgressView;
        [contentView addSubview:self.charmProgressView];
        
        UISlider *charmSlider = [self createSlider];
        self.charmSlider = charmSlider;
        charmSlider.frame = charmProgressView.frame;
        charmSlider.left -= 5;
        charmSlider.width += 10;
        [contentView addSubview:charmSlider];
        
        UILabel *charmCountLabel = [UILabel xf_labelWithFont:Font(18)
                                                   textColor:BlueColor
                                               numberOfLines:0
                                                   alignment:NSTextAlignmentCenter];
        self.charmCountLabel = charmCountLabel;
        charmCountLabel.size = CGSizeMake(45, 45);
        charmCountLabel.bottom = charmProgressView.top;
        [contentView addSubview:charmCountLabel];
        
        UILabel *tortoiseLabel = [[UILabel alloc] init];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"金龟分"];
        attrStr.font = Font(13);
        attrStr.color = BlackColor;
        NSMutableAttributedString *rightStr = [[NSMutableAttributedString alloc] initWithString:@"(仅适用于男士)"];
        rightStr.font = Font(12);
        rightStr.color = RGBGray(153);
        [attrStr appendAttributedString:rightStr];
        tortoiseLabel.attributedText = attrStr;
        tortoiseLabel.frame = CGRectMake(20, charmZeroLabel.bottom, 200, 60);
        [contentView addSubview:tortoiseLabel];
        
        UILabel *tortoiseZeroLabel = [self createContentLabel:@"0"];
        tortoiseZeroLabel.frame = CGRectMake(20, tortoiseLabel.bottom, 30, 50);
        [contentView addSubview:tortoiseZeroLabel];
        
        UILabel *tortoiseTenLabel = [self createContentLabel:@"10"];
        tortoiseTenLabel.frame = CGRectMake(self.width - 50, tortoiseLabel.bottom, 50, 50);
        [contentView addSubview:tortoiseTenLabel];
        
        rect.origin.x = tortoiseZeroLabel.right;
        rect.size.width = tortoiseTenLabel.left - rect.origin.x;
        rect.size.height = 12;
        rect.origin.y = tortoiseZeroLabel.centerY - rect.size.height * 0.5;
        
        UIView *tortoiseProgressView = [self createProgressView:rect];
        self.tortoiseProgressView = tortoiseProgressView;
        [contentView addSubview:self.tortoiseProgressView];
        
        UISlider *tortoiseSlider = [self createSlider];
        self.tortoiseSlider = tortoiseSlider;
        tortoiseSlider.frame = tortoiseProgressView.frame;
        tortoiseSlider.left -= 5;
        tortoiseSlider.width += 10;
        [contentView addSubview:tortoiseSlider];
        
        UILabel *tortoiseCountLabel = [UILabel xf_labelWithFont:Font(18)
                                                      textColor:BlueColor
                                                  numberOfLines:0
                                                      alignment:NSTextAlignmentCenter];
        self.tortoiseCountLabel = tortoiseCountLabel;
        tortoiseCountLabel.size = CGSizeMake(45, 45);
        tortoiseCountLabel.bottom = tortoiseProgressView.top;
        [contentView addSubview:tortoiseCountLabel];
        
        charmSlider.value = charmCount;
        [self pressSlider:charmSlider];
        tortoiseSlider.value = tortoiseCount;
        [self pressSlider:tortoiseSlider];
        
        contentView.height = tortoiseTenLabel.bottom + 15;
        contentView.width = self.width;
        contentView.left = 0;
        contentView.bottom = 0;
        [self show];
    }
    return self;
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
    NSString *text = [NSString stringWithFormat:@"%.1f", slider.value];
    if ([text isEqualToString:@"0.0"]) text = @"0";
    if ([text isEqualToString:@"10.0"]) text = @"10";
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(friendFilterView:didSelectCharm:tortoise:)]) {
            [self.delegate friendFilterView:self didSelectCharm:self.charmCountLabel.text tortoise:self.tortoiseCountLabel.text];
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

