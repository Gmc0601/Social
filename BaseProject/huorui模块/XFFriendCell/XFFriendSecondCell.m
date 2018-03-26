//
//  XFFriendSecondCell.m
//  BaseProject
//
//  Created by 王文利 on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "XFFriendSecondCell.h"

@interface XFFriendSecondCell ()

@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UILabel *cityLabel;

@end

@implementation XFFriendSecondCell

- (void)setUser:(User *)user {
    _user = user;
    self.picView.backgroundColor = [UIColor lightGrayColor];
    if (user.avatar_url) {
        [self.picView setImageURL:[NSURL URLWithString:user.avatar_url]];
    }
    self.nameLabel.text = user.nickname;
    if (user.nickname.length == 0) {
        self.nameLabel.text = @"名字(服务器没数据)";
    }
    self.idLabel.text = [NSString stringWithFormat:@"ID:%@", user.id.stringValue];
    self.cityLabel.text = [NSString stringWithFormat:@"%@km", user.distance];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self.picView setFrame:CGRectMake(8, 8, self.height - 16, self.height - 16)];
    [self.picView.layer setMasksToBounds:YES];
    [self.picView.layer setCornerRadius:(self.height - 16) * 0.5];
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).with.mas_offset(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.width.mas_equalTo(self.height - 16);
    }];

    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.picView.mas_top);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-8);
        make.width.mas_greaterThanOrEqualTo(10);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.picView.mas_top);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.picView.mas_right).with.offset(8);
        make.right.mas_equalTo(self.cityLabel.mas_left).with.offset(-8);
    }];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.picView.mas_bottom);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.picView.mas_right).with.offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-8);
    }];


}

#pragma mark ----------Lazy----------
- (UIImageView *)picView {
    if (_picView == nil) {
        _picView = [[UIImageView alloc] init];
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        _picView.clipsToBounds = YES;
        [self.contentView addSubview:_picView];
    }
    return _picView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [UILabel xf_labelWithFont:FontB(15)
                                     textColor:BlackColor
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)idLabel {
    if (_idLabel == nil) {
        _idLabel = [UILabel xf_labelWithFont:Font(13)
                                   textColor:RGBGray(102)
                               numberOfLines:0
                                   alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_idLabel];
    }
    return _idLabel;
}

- (UILabel *)cityLabel {
    if (_cityLabel == nil) {
        _cityLabel = [UILabel xf_labelWithFont:FontB(12)
                                     textColor:RGBGray(153)
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_cityLabel];
    }
    return _cityLabel;
}

@end
