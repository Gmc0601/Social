//
//  XFFriendTopView.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/26.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFFriendTopView.h"

@interface XFFriendTopView ()

@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *signLabel;

@end

@implementation XFFriendTopView

- (instancetype)init {
    if (self == [super init]) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.frame = CGRectMake(0, 0, kScreenWidth, 430);
        _picView = [[UIImageView alloc] init];
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        _picView.frame = self.bounds;
        _picView.clipsToBounds = YES;
        [self addSubview:_picView];
        
        _signLabel = [UILabel xf_labelWithFont:Font(13)
                                     textColor:WhiteColor
                                 numberOfLines:1
                                     alignment:NSTextAlignmentCenter];
        _signLabel.left = 20;
        _signLabel.height = 14;
        _signLabel.width = kScreenWidth - 40;
        _signLabel.bottom = self.height - 15;
        [self addSubview:_signLabel];
        
        _infoLabel = [UILabel xf_labelWithFont:Font(14)
                                     textColor:BlueColor
                                 numberOfLines:1
                                     alignment:NSTextAlignmentCenter];
        _infoLabel.left = 0;
        _infoLabel.height = 20;
        _infoLabel.width = kScreenWidth;
        _infoLabel.bottom = _signLabel.top - 25;
        [self addSubview:_infoLabel];
        
        _nameLabel = [YYLabel new];
        _nameLabel.height = 35;
        _nameLabel.left = 20;
        _nameLabel.width = kScreenWidth - 40;
        _nameLabel.bottom = _infoLabel.top;
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;
    if (user.avatar_url.length) {
        [self.picView setImageURL:[NSURL URLWithString:user.avatar_url]];
    }
    self.signLabel.text = user.sdf;
    if (user.sdf.length == 0) {
        self.signLabel.text = @"还没有个性签名";
    }
    
    if (user.nickname.length) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:user.nickname];
        attrStr.font = FontB(18);
        attrStr.color = WhiteColor;
        [attrStr appendString:@" "];
        [attrStr appendAttributedString:[NSAttributedString attachmentStringWithEmojiImage:Image([user.sex isEqualToString:@"1"] ? @"icon_boy" : @"icon_girl")
                                                                                  fontSize:16]];
        self.nameLabel.attributedText = attrStr.copy;
    }
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    NSMutableString *str = [NSMutableString string];
    [str appendString:[NSString stringWithFormat:@"ID：%@", user.id.stringValue]];
    [str appendString:@"  |  "];
    [str appendString:[NSString stringWithFormat:@"魅力分：%@", [NSString stringWithFormat:@"%d", user.coolpoint.intValue]]];
    if ([user.sex isEqualToString:@"1"]) {
        [str appendString:@"  |  "];
        [str appendString:[NSString stringWithFormat:@"金龟分：%@", [NSString stringWithFormat:@"%d", user.beetlepoint.intValue]]];
    }
    self.infoLabel.text = str.copy;
}

@end
