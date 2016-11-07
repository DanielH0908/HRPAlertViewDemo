//
//  MyAlertView.h
//  MyAlertViewDemo
//
//  Created by DanielH on 16/10/24.
//  Copyright © 2016年 DanielH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyAlertViewDelegate;

@interface MyAlertView : UIView

@property (strong, nonatomic) UIView *contentView;//自定义内容View
@property (strong, nonatomic) UIImage *icon;//提示框图片
@property (strong, nonatomic) NSString *title;//提示框标题
@property (strong, nonatomic) NSString *message;//提示框内容
@property (weak, nonatomic) id<MyAlertViewDelegate> delegate;//代理

/***
 **初始化提示框样式
 **/
- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon message:(NSString *)message delegate:(id<MyAlertViewDelegate>)delegate buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/***
 **显示提示框
 **/
- (void)show;

/***
 **隐藏提示框
 **/
- (void)hide;

/***
 **设置标题的颜色和字体大小，默认为黑色，大小15
 **/
- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size;

/***
 **设置内容的颜色和字体大小，默认为黑色，大小13
 **/
- (void)setMessageColor:(UIColor *)color fontSize:(CGFloat)size;

/***
 **设置按钮的字体颜色和字体大小，默认为黑色，大小16
 **/
- (void)setButtonTitleColor:(UIColor *)color fontSize:(CGFloat)size atIndex:(NSInteger)index;

@end

@protocol MyAlertViewDelegate <NSObject>

- (void)alertView:(MyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
