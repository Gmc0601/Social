//
//  XFFriendCell.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/22.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFFriendCell.h"

@interface XFFriendCell ()

@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UILabel *cityLabel;

@end

@implementation XFFriendCell

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
    self.picView.width = self.width;
    self.picView.height = self.picView.width * 143 / 180;
    
    self.nameLabel.frame = CGRectMake(10, self.picView.bottom, self.width - 20, 40);
    self.idLabel.frame = CGRectMake(10, self.nameLabel.bottom, self.width - 20, 12);
    self.cityLabel.frame = CGRectMake(10, self.idLabel.bottom, self.width - 20, 20);
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
