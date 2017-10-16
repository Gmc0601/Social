//
//  XFSelectItemView.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/19.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFSelectItemView.h"

typedef NS_ENUM(NSInteger, SelectItemType) {
    SelectItemType_Normal,
    SelectItemType_More
};

@interface XFSelectItemView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) SelectItemType type;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *overBtn;

@property (nonatomic, copy) NSString *selectText;

@end

@implementation XFSelectItemView

- (instancetype)initWithTitle:(NSString *)title
                    dataArray:(NSArray *)dataArray
                   selectText:(NSString *)selectText {
    if (self == [super init]) {
        self.dataArray = dataArray;
        self.type = SelectItemType_Normal;
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self initSubviews:title];
        if (selectText.length && [self.dataArray containsObject:selectText]) {
            NSInteger index = [self.dataArray indexOfObject:selectText];
            self.selectText = selectText;
            [self.pickView selectRow:index inComponent:0 animated:YES];
        }
        [self show];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                    leftArray:(NSArray *)leftArray
                   rightArray:(NSArray *)rightArray {
    if (self == [super init]) {
        self.leftArray = leftArray;
        self.rightArray = rightArray;
        self.type = SelectItemType_More;
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self initSubviews:title];
        [self show];
    }
    return self;
}

- (void)initSubviews:(NSString *)title {
    UIButton *bgBtn = [UIButton xf_emptyButtonWithTarget:self action:@selector(dismiss)];
    bgBtn.backgroundColor = MaskColor;
    bgBtn.frame = self.bounds;
    [self addSubview:bgBtn];
    _topView = [UIView xf_createViewWithColor:RGBA(246, 246, 246, 0.9)];
    _topView.size = CGSizeMake(self.width, 44);
    _topView.top = kScreenHeight;
    _cancelBtn = [UIButton xf_titleButtonWithTitle:@"取消"
                                        titleColor:RGB(21, 126, 251)
                                         titleFont:Font(15)
                                            target:self
                                            action:@selector(cancelBtnClick)];
    _cancelBtn.frame = CGRectMake(0, 0, _topView.height, _topView.height);
    [_topView addSubview:_cancelBtn];
    
    _overBtn = [UIButton xf_titleButtonWithTitle:@"完成"
                                      titleColor:RGB(21, 126, 251)
                                       titleFont:Font(15)
                                          target:self
                                          action:@selector(overBtnClick)];
    _overBtn.frame = CGRectMake(_topView.width - _topView.height, 0, _topView.height, _topView.height);
    [_topView addSubview:_overBtn];
    
    _titleLabel = [UILabel xf_labelWithFont:Font(17)
                                  textColor:BlackColor
                              numberOfLines:1
                                  alignment:NSTextAlignmentCenter];
    _titleLabel.text = title;
    _titleLabel.frame = CGRectMake(_cancelBtn.right, 0, _overBtn.left - _cancelBtn.right, _topView.height);
    [_topView addSubview:_titleLabel];
    [self addSubview:_topView];
    
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _topView.bottom, self.width, 215)];
    _pickView.backgroundColor = WhiteColor;
    _pickView.delegate = self;
    [self addSubview:_pickView];
    [self.pickView reloadAllComponents];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.type == SelectItemType_Normal) {
        return 1;
    } else {
        return 3;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.type == SelectItemType_Normal) {
        return self.dataArray.count;
    } else {
        if (component == 0) {
            return self.leftArray.count;
        } else if (component == 1) {
            return 1;
        } else {
            return self.rightArray.count;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.type == SelectItemType_Normal) {
        return self.dataArray[row];
    } else {
        if (component == 0) {
            return self.leftArray[row];
        } else if (component == 1) {
            return @"至";
        } else {
            return self.rightArray[row];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.type == SelectItemType_Normal) {
        self.selectText = self.dataArray[row];
    } else {
        
    }
}

#pragma mark ----------Action----------
- (void)cancelBtnClick {
    [self dismiss];
}

- (void)overBtnClick {
    if (self.selectText.length == 0) {
        self.selectText = self.dataArray[0];
    }
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectItemView:selectInfo:)]) {
        [self.delegate selectItemView:self selectInfo:self.selectText];
    }
}

- (void)show {
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.pickView.bottom = kScreenHeight;
        self.topView.bottom = self.pickView.top;
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.topView.top = kScreenHeight;
        self.pickView.top = self.topView.bottom;
    } completion:^(BOOL finished) {
        self.alpha = 0;
        [self removeFromSuperview];
    }];
}

@end
