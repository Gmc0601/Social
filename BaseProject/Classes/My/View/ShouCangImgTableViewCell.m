//
//  ShouCangImgTableViewCell.m
//  BaseProject
//
//  Created by 王文利 on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ShouCangImgTableViewCell.h"

@interface ShouCangImgTableViewCell ()


@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *timeLabel;

@end
@implementation ShouCangImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)cellFunctionIMGText: (NSString *)textValue
                    andTime: (NSString *)timeString {

    [self.imgView sd_setImageWithURL:[NSURL URLWithString:textValue]
              placeholderImage:[UIImage imageNamed:@"bg_tj_tx"]
                       options:SDWebImageCacheMemoryOnly];
    self.timeLabel.text = timeString;
}

#pragma mark ----------Lazy----------
- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
        [_imgView setImage:[UIImage imageNamed:@"bg_tj_tx"]];
        [_imgView setBackgroundColor:[UIColor whiteColor]];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imgView];
    }
    return _imgView;
}


- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [UILabel xf_labelWithFont:Font(13)
                                     textColor:BlackColor
                                 numberOfLines:1
                                     alignment:NSTextAlignmentLeft];
        _timeLabel.text = @"2018-02-25 20:30:20";
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

//1.添加longpress事件
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        //单元格文字

        if (!self.imgView.layer.masksToBounds) {
            [self.imgView.layer setMasksToBounds:YES];
        }
        [self.imgView.layer setCornerRadius:4];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(8);
            make.left.mas_equalTo(self.contentView).offset(8);
            make.width.mas_lessThanOrEqualTo(100);
            make.height.mas_lessThanOrEqualTo(100);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(17);
            make.bottom.mas_equalTo(self.contentView).offset(-8);
            make.left.mas_equalTo(self.contentView).offset(8);
            make.right.mas_equalTo(self.contentView).offset(8);
            make.top.mas_equalTo(self.imgView.mas_bottom).offset(8);

        }];
    }

    return self;

}

@end
