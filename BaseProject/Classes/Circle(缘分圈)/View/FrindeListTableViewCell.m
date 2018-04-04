//
//  FrindeListTableViewCell.m
//  BaseProject
//
//  Created by cc on 2018/2/5.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "FrindeListTableViewCell.h"
#import <YYKit.h>
#import <UIImageView+WebCache.h>

@implementation FrindeListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.back];
        [self.back addSubview:self.head];
        [self.back addSubview:self.nameLab];
        [self.back addSubview:self.locaLab];
        [self.back addSubview:self.IdLab];
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;
//    self.picView.backgroundColor = [UIColor lightGrayColor];
    if (user.avatar_url) {
        [self.head setImageURL:[NSURL URLWithString:user.avatar_url]];
    }
    self.nameLab.text = user.nickname;
    if (user.nickname.length == 0) {
        self.nameLab.text = @"名字(服务器没数据)";
    }
    self.IdLab.text = [NSString stringWithFormat:@"ID:%@", user.id.stringValue];
    self.locaLab.text = [NSString stringWithFormat:@"%@km", user.distance];
}


- (UIView *)back {
    if (!_back ) {
        _back = [[UIView alloc] initWithFrame:FRAME(SizeWidth(5), SizeHeigh(2.5),kScreenW  - SizeWidth(10) , SizeHeigh(70))];
        _back.backgroundColor = [UIColor whiteColor];
    }
    return _back;
}

- (UIImageView *)head {
    if (!_head) {
        _head = [[UIImageView alloc] initWithFrame:FRAME(SizeWidth(10), SizeHeigh(10), SizeHeigh(50), SizeHeigh(50))];
        _head.layer.masksToBounds = YES;
        _head.layer.cornerRadius = SizeHeigh(25);
        _head.backgroundColor = [UIColor clearColor];
        _head.image = [UIImage imageNamed:@""];
    }
    return _head;
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:FRAME(self.head.right + SizeWidth(10), SizeHeigh(15), kScreenW/2, SizeHeigh(20))];
        _nameLab.font = BOLDSYSTEMFONT(15);
    }
    return _nameLab;
}

- (UILabel *)IdLab {
    if (!_IdLab) {
        _IdLab = [[UILabel alloc] initWithFrame:FRAME(self.head.right + SizeWidth(10), self.nameLab.bottom + SizeHeigh(10), kScreenW/2, SizeHeigh(20))];
        _IdLab.font = [UIFont systemFontOfSize:13];
        
    }
    return _IdLab;
}


- (UILabel *)locaLab {
    if (!_locaLab) {
        _locaLab = [[UILabel alloc] initWithFrame:FRAME(self.back.width - kScreenW/ 2, SizeHeigh(15), kScreenW/2 - SizeWidth(10), SizeHeigh(20))];
        _locaLab.font = [UIFont systemFontOfSize:13];
        _locaLab.textAlignment = NSTextAlignmentRight;
        _locaLab.textColor = UIColorHex(0x666666);
    }
    return _locaLab;
}

@end
