//
//  CCTextField.h
//  BaseProject
//
//  Created by cc on 2017/10/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseTextFieldDelegate <NSObject>

@optional

-(void)textFieldTextChange:(UITextField *)textField;

@end

@interface CCTextField : UITextField

@property (nonatomic, assign) BOOL isChangeKeyBoard;

@property (nonatomic, weak) id<BaseTextFieldDelegate> textDelegate;

- (id)initWithFrame:(CGRect)frame PlaceholderStr:(NSString *)placeholderStr isBorder:(BOOL)isBorder withLeftImage:(NSString *)imgstr;

@end
