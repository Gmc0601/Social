//
//  XFCircleSuggestCell.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/21.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFCircleSuggestCell.h"

@interface XFCircleSuggestItemCell : UICollectionViewCell

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation XFCircleSuggestItemCell

+ (CGFloat)cellHeight {
    return 70 + 40;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconView.size = CGSizeMake(70, 70);
    self.iconView.centerX = self.width * 0.5;
    self.iconView.top = 0;
    
    self.nameLabel.top = self.iconView.bottom;
    self.nameLabel.left = 5;
    self.nameLabel.width = self.width - 10;
    self.nameLabel.height = 40;
}

- (void)setUser:(User *)user {
    _user = user;
    [self.iconView setImageURL:[NSURL URLWithString:user.avatar_url]];
    self.nameLabel.text = user.nickname;
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        [_iconView xf_cornerCut:35];
        _iconView.backgroundColor = [UIColor lightGrayColor];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [UILabel xf_labelWithFont:Font(13)
                                     textColor:BlackColor
                                 numberOfLines:1
                                     alignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

@end

@interface XFCircleSuggestCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation XFCircleSuggestCell

+ (CGFloat)cellHeight {
    return 170;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.infoLabel.frame = CGRectMake(15, 0, self.width - 30, 45);
    self.closeBtn.size = CGSizeMake(13, 13);
    self.closeBtn.centerY = self.infoLabel.centerY;
    self.closeBtn.right = kScreenWidth - 17;
    self.collectionView.frame = CGRectMake(0, self.infoLabel.bottom + 10, self.width, [XFCircleSuggestItemCell cellHeight]);
}

- (void)setSuggestArray:(NSArray *)suggestArray {
    _suggestArray = suggestArray;
    self.infoLabel.text = @"可能认识他们";
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.suggestArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XFCircleSuggestItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFCircleSuggestItemCell" forIndexPath:indexPath];
    cell.user = self.suggestArray[indexPath.item];
    return cell;
}

#pragma mark - -------------------Action-------------------
- (void)closeBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleSuggestCellClickCloseBtn:)]) {
        [self.delegate circleSuggestCellClickCloseBtn:self];
    }
}

#pragma mark ----------Lazy----------
- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [UILabel xf_labelWithFont:Font(13)
                                     textColor:BlackColor
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_infoLabel];
    }
    return _infoLabel;
}

- (UIButton *)closeBtn {
    if (_closeBtn == nil) {
        _closeBtn = [UIButton xf_imgButtonWithImgName:@"icon_yfq_gb" target:self action:@selector(closeBtnClick)];
        [self.contentView addSubview:_closeBtn];
    }
    return _closeBtn;
}

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(100, [XFCircleSuggestItemCell cellHeight]);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 55, kScreenWidth, self.layout.itemSize.height)
                                             collectionViewLayout:self.layout];
        [_collectionView registerClass:[XFCircleSuggestItemCell class] forCellWithReuseIdentifier:@"XFCircleSuggestItemCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

@end

