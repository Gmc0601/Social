//
//  RedPagAlter.m
//  BaseProject
//
//  Created by cc on 2017/11/30.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "RedPagAlter.h"

@implementation RedPagClass


@end

@implementation RedPagAlter

- (instancetype)initWithFrame:(CGRect)frame withModel:(RedPagClass *)model {
    if (self ==  [super initWithFrame:frame]) {
        self.model = model;
        [self createView];
    }
    return self;
}

- (void)createView {
    if (self.model.get) {
        self.backimgView.image = [UIImage imageNamed:@"bg_hbxq_yk"];
        [self addSubview:self.backView];
        [self.backView addSubview:self.backimgView];
        [self.backimgView addSubview:self.headImage];
        [self.backimgView addSubview:self.nickname];
        self.nickname.textColor = UIColorFromHex(0xdb4d4c);
        [self.backimgView addSubview:self.countLab];
        [self.backimgView addSubview:self.jifen];
        [self.backView addSubview:self.closeBtn];
    }else {
        self.backimgView.image = [UIImage imageNamed:@"bg_hbxq_wk"];
        [self addSubview:self.backView];
        [self.backView addSubview:self.backimgView];
        [self.backimgView addSubview:self.headImage];
        [self.backimgView addSubview:self.nickname];
        [self.backimgView addSubview:self.countLab];
        [self.backimgView addSubview:self.jifen];
        self.countLab.hidden = YES;
        self.jifen.hidden = YES;
        [self.backView addSubview:self.closeBtn];
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = FRAME(kScreenW/2 - SizeWidth(31), kScreenH/2 + SizeHeigh(10), SizeWidth(62), SizeHeigh(80));
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
        self.btn = btn;
        [self addSubview:btn];
    }
}

- (void)open {
    
    NSDictionary *dic = @{
                          @"id" : self.model.id
                          };
    
    [HttpRequest postPath:@"_bring_integral_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            self.backimgView.image = [UIImage imageNamed:@"bg_hbxq_yk"];
            self.nickname.textColor = UIColorFromHex(0xdb4d4c);
            self.countLab.hidden = NO;
            self.jifen.hidden = NO;
            self.btn.hidden = YES;
            if (self.openBlock) {
                self.openBlock();
            }
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
    
    
}


- (void)pop {
    
  
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    self.backimgView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    self.backView.alpha = 1;
    [UIView animateWithDuration:.35 animations:^{
        self.backimgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backView.alpha = 1;
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:.35 animations:^{
        self.backimgView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (UIImageView *)backimgView {
    if (!_backimgView) {
        _backimgView = [[UIImageView alloc] initWithFrame:FRAME((kScreenW - SizeWidth(315))/2,(kScreenH - SizeHeigh(425))/2, SizeWidth(315), SizeHeigh(425))];
        _backimgView.backgroundColor = [UIColor clearColor];
    }
    return _backimgView;
}


- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _backView.backgroundColor = RGBColorAlpha(74, 73, 74, 0.6);
    }
    return _backView;
}

- (UIImageView *)headImage {
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:FRAME((SizeWidth(315) - SizeWidth(62))/2, SizeHeigh(35), SizeWidth(62), SizeWidth(62))];
        _headImage.backgroundColor = [UIColor clearColor];
        [_headImage sd_setImageWithURL:[NSURL URLWithString:self.model.head] placeholderImage:nil];
    }
    return _headImage;
}

- (UILabel *)nickname {
    if (!_nickname) {
        _nickname = [[UILabel alloc] initWithFrame:FRAME(0, self.headImage.bottom + SizeHeigh(5), SizeWidth(315), SizeHeigh(40))];
        _nickname.numberOfLines = 2;
        _nickname.backgroundColor = [UIColor clearColor];
        _nickname.font = [UIFont systemFontOfSize:12];
        _nickname.textColor = UIColorFromHex(0xf8df9e);
        _nickname.textAlignment = NSTextAlignmentCenter;
        NSString *title = [NSString stringWithFormat:@"%@\n%@",self.model.nick , @"给你发了一个红包"];
        _nickname.text = title;
    }
    return _nickname;
        
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW - (kScreenW - SizeWidth(315))/2  - SizeWidth(37), (kScreenH - SizeHeigh(425))/2 +15, SizeWidth(17), SizeWidth(17))];
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn setTitle:@"X" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:UIColorFromHex(0xdb4d4c) forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)countLab {
    if (!_countLab) {
        _countLab = [[UILabel alloc] initWithFrame:FRAME(0, self.nickname.bottom + SizeHeigh(20), SizeWidth(330)/2 + 20, SizeHeigh(37))];
        _countLab.textAlignment = NSTextAlignmentRight;
        _countLab.font = ArialBoldMTFont(40);
        _countLab.textColor =UIColorFromHex(0xdb4d4c);
        _countLab.text = self.model.count;
        _countLab.backgroundColor = [UIColor clearColor];
    }
    return _countLab;
}


- (UILabel *)jifen {
    if (!_jifen) {
        _jifen = [[UILabel alloc] initWithFrame:FRAME(self.countLab.right + 2, self.nickname.bottom + SizeHeigh(37), 40, SizeHeigh(15))];
        _jifen.text = @"积分";
        _jifen.font = [UIFont systemFontOfSize:12];
        _jifen.textColor = UIColorFromHex(0xdb4d4c);
    }
    return _jifen;
}


@end
