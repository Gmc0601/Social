//
//  AddGroupMemberTableViewCell.m
//  BaseProject
//
//  Created by cc on 2018/2/27.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "AddGroupMemberTableViewCell.h"
#import <YYKit.h>
#import <UIImageView+EMWebCache.h>

@implementation AddGroupMemberTableViewCell
//   65
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.Click = NO;
        [self.contentView addSubview:self.clickimg];
        [self.clickimg setCenterY:self.clickBtn.centerY];
        [self.contentView addSubview:self.headImage];
        [self.headImage setCenterY:self.clickBtn.centerY];
        [self.contentView addSubview:self.nickLab];
        [self.nickLab setCenterY:self.clickBtn.centerY];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.clickBtn];
    }
    return self;
}

- (void)update:(ContactsModel *)model {
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:nil];
    if (IsNULL(model.nickname)) {
        [ConfigModel mbProgressHUD:@"nickname -->  null" andView:nil];
    }else {
        self.nickLab.text = model.nickname;
    }
}

- (UIImageView *)clickimg {
    if (!_clickimg) {
        _clickimg = [[UIImageView alloc] initWithFrame:FRAME(SizeWidth(10), 0, SizeWidth(20), SizeWidth(20))];
        _clickimg.backgroundColor = [UIColor clearColor];
        _clickimg.layer.masksToBounds = YES;
        _clickimg.image = [UIImage imageNamed:@"icon_xz"];
        _clickimg.layer.cornerRadius = SizeWidth(10);
    }
    return _clickimg;
}

- (UIImageView *)headImage {
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:FRAME(self.clickimg.right + SizeWidth(10), 0, SizeWidth(45), SizeWidth(45))];
        _headImage.backgroundColor = [UIColor clearColor];
        
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = SizeWidth(45/2);
    }
    return _headImage;
}

- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(10), SizeHeigh(65) - 1, kScreenW - SizeWidth(20), 1)];
        _line.backgroundColor = RGB(239, 240, 241);
    }
    return _line;
}

- (UILabel *)nickLab {
    if (!_nickLab) {
        _nickLab = [[UILabel alloc] initWithFrame:FRAME(self.headImage.right + SizeWidth(10), 0, kScreenW /2, SizeHeigh(20))];
        _nickLab.font = [UIFont systemFontOfSize:14];
        _nickLab.textColor = UIColorFromHex(0x666666);
        _nickLab.text = @"昵称";
    }
    return _nickLab;
}
- (UIButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, kScreenW, SizeHeigh(65))];
        _clickBtn.backgroundColor = [UIColor clearColor];
        [_clickBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickBtn;
}

- (void)btnClick {
    
    self.Click = !self.Click;
    
    if (self.Click) {
        //  选中
        self.clickimg.image = [UIImage imageNamed:@"icon_xz_pre"];
    }else {
        //  未选中
        self.clickimg.image = [UIImage imageNamed:@"icon_xz"];
    }
    
    if (self.clickBlock) {
        self.clickBlock(self.Click);
    }
}

@end
