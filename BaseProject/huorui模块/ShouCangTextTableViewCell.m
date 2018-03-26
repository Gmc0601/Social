//
//  ShouCangTextTableViewCell.m
//  BaseProject
//
//  Created by 王文利 on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ShouCangTextTableViewCell.h"
@interface ShouCangTextTableViewCell ()


@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end
@implementation ShouCangTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code


}

- (void)cellFunctionText: (NSString *)textValue andTime: (NSString *)timeString andBlock: (kEasyBlock)easyBock {



    self.contentLabel.text = textValue;
    self.timeLabel.text = timeString;

    if (!IsNULL(easyBock)) {
        self.easyBlock = easyBock;
    }
}

#pragma mark ----------Lazy----------
- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [UILabel xf_labelWithFont:Font(17)
                                     textColor:BlackColor
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}


- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [UILabel xf_labelWithFont:Font(13)
                                        textColor:BlackColor
                                    numberOfLines:1
                                        alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}


//1.添加longpress事件
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 给单元格cell 添加长按手势并绑定方法
        [self addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];
        //单元格文字
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView).offset(-8);
            make.left.mas_equalTo(self.contentView).offset(8);
            make.right.mas_equalTo(self.contentView).offset(8);
            make.height.mas_equalTo(17);
        }];

        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(8);
            make.left.mas_equalTo(self.contentView).offset(8);
            make.right.mas_equalTo(self.contentView).offset(-8);
            make.bottom.mas_equalTo(self.timeLabel.mas_top).offset(-4);
        }];
    }

    return self;

}

//2.处理长按事件

-(void)longTap:(UILongPressGestureRecognizer *)longRecognizer

{
    //判断 如果当前是长按状态
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //cell 作为第一响应控件
        [self becomeFirstResponder];
        //创建一个菜单控制器  单例
        UIMenuController *menu=[UIMenuController sharedMenuController];
        //创建两个菜单按钮
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(delItemClicked:)];


        //添加到控制器上
        [menu setMenuItems:[NSArray arrayWithObjects:copyItem,nil]];
        //菜单的位置  在cell 的边界
        [menu setTargetRect:self.bounds inView:self];
        //菜单的显示
        [menu setMenuVisible:YES animated:YES];

    }

}

//3.实现默认方法

#pragma mark 处理action事件

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{

    if(action ==@selector(delItemClicked:)){
        return YES;
    }

    return [super canPerformAction:action withSender:sender];

}

#pragma mark 实现成为第一响应者方法

-(BOOL)canBecomeFirstResponder{

    return YES;

}

//4.处理item点击事件

#pragma mark method



-(void)delItemClicked:(id)sender{
    NSLog(@"删除");
    // 通知代理
    self.easyBlock();
}

@end
