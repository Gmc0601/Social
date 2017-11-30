//
//  XFSelectAddressView.m
//  BaseProject
//
//  Created by artand on 2017/11/27.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "XFSelectAddressView.h"

@interface XFSelectAddressView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *overBtn;

@property(nonatomic,retain) NSArray *pickerArray;
@property(nonatomic,retain) NSArray *subPickerArray;
@property(nonatomic,retain) NSArray *thirdPickerArray;
@property(nonatomic,retain) NSArray *selectArray;
@property (nonatomic, strong) NSDictionary *tempDict;

@end

@implementation XFSelectAddressView

- (instancetype)init {
    if (self == [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self initSubviews:@"地址"];
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
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"XFAddress" ofType:@"plist"];
    NSArray *theArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    NSMutableArray *provinceArray = [NSMutableArray array];
    for (int i = 0; i < theArray.count; i++) {
        NSArray *array = [theArray objectAtIndex:i];
        NSString *province = [array firstObject];
        [provinceArray addObject:province];
    }
    _selectArray = theArray;
    _pickerArray = provinceArray;
    NSArray *firstArray = theArray.firstObject;
    NSDictionary *firstDict = firstArray.lastObject;
    self.tempDict = firstDict;
    _subPickerArray = [firstDict allKeys];
    NSArray *firstSubArray = firstDict[_subPickerArray.firstObject];
    _thirdPickerArray = firstSubArray;
    
    [self.pickView reloadAllComponents];
    [self show];
}

#pragma mark - -------------------<UIPickerViewDataSource>-------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_pickerArray count];
    }
    if (component == 1) {
        return [_subPickerArray count];
    }
    if (component == 2) {
        return [_thirdPickerArray count];
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *str = @"";
    if (component == 0) {
        str = [_pickerArray objectAtIndex:row];
    } else if (component == 1) {
        str = [_subPickerArray objectAtIndex:row];
    } else {
        str = [_thirdPickerArray objectAtIndex:row];
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    attrStr.font = Font(14);
    attrStr.color = [UIColor blackColor];
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.attributedText = attrStr;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSArray *theArray = [_selectArray objectAtIndex:row];
        NSDictionary *theDict = theArray.lastObject;
        self.tempDict = theDict;
        _subPickerArray = [theDict allKeys];
        NSString *city = [_subPickerArray objectAtIndex:0];
        NSArray *firstSubArray = self.tempDict[city];
        _thirdPickerArray = firstSubArray;
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 1) {
        NSString *city = [_subPickerArray objectAtIndex:row];
        NSArray *firstSubArray = self.tempDict[city];
        _thirdPickerArray = firstSubArray;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return kScreenWidth / 3;
}

#pragma mark ----------Action----------
- (void)cancelBtnClick {
    [self dismiss];
}

- (void)overBtnClick {
    [self dismiss];
    
    NSString *str1 = [_pickerArray objectAtIndex:[self.pickView selectedRowInComponent:0]];
    NSString *str2 = [_subPickerArray objectAtIndex:[self.pickView selectedRowInComponent:1]];
    NSString *str3 = [_thirdPickerArray objectAtIndex:[self.pickView selectedRowInComponent:2]];
    NSString *address = [NSString stringWithFormat:@"%@%@%@", str1, str2, str3];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAddressView:selectInfo:)]) {
        [self.delegate selectAddressView:self selectInfo:address];
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
