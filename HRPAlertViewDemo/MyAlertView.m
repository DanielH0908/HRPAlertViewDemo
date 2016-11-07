//
//  MyAlertView.m
//  MyAlertViewDemo
//
//  Created by DanielH on 16/10/24.
//  Copyright © 2016年 DanielH. All rights reserved.
//

#import "MyAlertView.h"

#define TITLE_FONT_SIZE 15
#define MESSAGE_FONT_SIZE 13
#define BUTTON_FONT_SIZE 16
#define MARGIN_TOP 20
#define MARGIN_LEFT_LARGE 30
#define MARGIN_LEFT_SMALL 15
#define MARGIN_RIGHT_LARGE 30
#define MARGIN_RIGHT_SMALL 15
#define SPACE_LARGE 20
#define SPACE_SMALL 5
#define MESSAGE_LINE_SPACE 5

#define RGBA(R, G, B, A) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]

@interface MyAlertView ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *buttonTitleArray;

@end

CGFloat contentViewWidth;
CGFloat contentViewHeight;

@implementation MyAlertView
//初始化
- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
    }
    return self;
}

//初始化样式
- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon message:(NSString *)message delegate:(id<MyAlertViewDelegate>)delegate buttonTitles:(NSString *)buttonTitles, ... {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _icon = icon;
        _title = title;
        _message = message;
        _delegate = delegate;
        _buttonArray = [NSMutableArray array];
        _buttonTitleArray = [NSMutableArray array];
        
        //在C中，当我们无法列出传递函数的所有实参的类型和数目时,可以用省略号指定参数表，下面就是为了实现方法中"..."的效果
        va_list args;
        va_start(args, buttonTitles);
        if (buttonTitles)
        {
            [_buttonTitleArray addObject:buttonTitles];
            while (1)
            {
                NSString *  otherButtonTitle = va_arg(args, NSString *);
                if(otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitleArray addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
        
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
        [self initContentView];
    }
    return self;
}

//设置各类数据
- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    _contentView.center = self.center;
    [self addSubview:_contentView];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self initContentView];
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    [self initContentView];
}

- (void)setMessage:(NSString *)message {
    _message = message;
    [self initContentView];
}
//初始化设计对应的视图样式

- (void)initContentView {
    contentViewWidth = 280 * self.frame.size.width / 320;
    contentViewHeight = MARGIN_TOP;
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 5.0;
    _contentView.layer.masksToBounds = YES;
    
    [self initTitleAndIcon];
    [self initMessage];
    [self initAllButtons];
    
    _contentView.frame = CGRectMake(0, 0, contentViewWidth, contentViewHeight);
    _contentView.center = self.center;
    [self addSubview:_contentView];
}

- (void)initTitleAndIcon {
    _titleView = [[UIView alloc] init];
    if (_icon != nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = _icon;
        _iconImageView.frame = CGRectMake(0, 0, 50, 50);
        [_titleView addSubview:_iconImageView];
    }
    
    CGSize titleSize = [self getTitleSize];
    if (_title != nil && ![_title isEqualToString:@""]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _title;
        _titleLabel.textColor = RGBA(28, 28, 28, 1.0);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.frame = CGRectMake(_iconImageView.frame.origin.x + _iconImageView.frame.size.width + SPACE_SMALL, 1, titleSize.width, 50);
        [_titleView addSubview:_titleLabel];
    }
    
    _titleView.frame = CGRectMake(0, MARGIN_TOP, _iconImageView.frame.size.width + SPACE_SMALL + titleSize.width, MAX(_iconImageView.frame.size.height, 50));
    _titleView.center = CGPointMake(contentViewWidth / 2, MARGIN_TOP + _titleView.frame.size.height / 2);
    [_contentView addSubview:_titleView];
    contentViewHeight += _titleView.frame.size.height;
}

- (void)initMessage {
    if (_message != nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = _message;
        _messageLabel.textColor = RGBA(120, 120, 120, 1.0);
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:MESSAGE_FONT_SIZE];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = MESSAGE_LINE_SPACE;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
        _messageLabel.attributedText = [[NSAttributedString alloc]initWithString:_message attributes:attributes];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        
        CGSize messageSize = [self getMessageSize];
        _messageLabel.frame = CGRectMake(MARGIN_LEFT_LARGE, _titleView.frame.origin.y + _titleView.frame.size.height + SPACE_LARGE, MAX(contentViewWidth - MARGIN_LEFT_LARGE - MARGIN_RIGHT_LARGE, messageSize.width), messageSize.height);
        [_contentView addSubview:_messageLabel];
        contentViewHeight += SPACE_LARGE + _messageLabel.frame.size.height;
    }
}

- (void)initAllButtons {
    if (_buttonTitleArray.count > 0) {
        contentViewHeight += SPACE_LARGE + 45;
        UIView *horizonSperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, _messageLabel.frame.origin.y + _messageLabel.frame.size.height + SPACE_LARGE, contentViewWidth, 1)];
        horizonSperatorView.backgroundColor = RGBA(218, 218, 222, 1.0);
        [_contentView addSubview:horizonSperatorView];
        
        CGFloat buttonWidth = contentViewWidth / _buttonTitleArray.count;
        for (NSString *buttonTitle in _buttonTitleArray) {
            NSInteger index = [_buttonTitleArray indexOfObject:buttonTitle];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(index * buttonWidth, horizonSperatorView.frame.origin.y + horizonSperatorView.frame.size.height, buttonWidth, 44)];
            button.titleLabel.font = [UIFont systemFontOfSize:BUTTON_FONT_SIZE];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            [button setTitleColor:RGBA(70, 130, 180, 1.0) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonWithPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonArray addObject:button];
            [_contentView addSubview:button];
            
            if (index < _buttonTitleArray.count - 1) {
                UIView *verticalSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x + button.frame.size.width, button.frame.origin.y, 1, button.frame.size.height)];
                verticalSeperatorView.backgroundColor = RGBA(218, 218, 222, 1.0);
                [_contentView addSubview:verticalSeperatorView];
            }
        }
    }
}

//获取各控件Size大小

- (CGSize)getTitleSize {
    UIFont *font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [_title boundingRectWithSize:CGSizeMake(contentViewWidth - (MARGIN_LEFT_SMALL + MARGIN_RIGHT_SMALL + _iconImageView.frame.size.width + SPACE_SMALL), 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    
    return size;
}

- (CGSize)getMessageSize {
    UIFont *font = [UIFont systemFontOfSize:MESSAGE_FONT_SIZE];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = MESSAGE_LINE_SPACE;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [_message boundingRectWithSize:CGSizeMake(contentViewWidth - (MARGIN_LEFT_LARGE + MARGIN_RIGHT_LARGE), 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    
    return size;
}

//按钮点击执行代理方法
- (void)buttonWithPressed:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        NSInteger index = [_buttonTitleArray indexOfObject:button.titleLabel.text];
        [_delegate alertView:self clickedButtonAtIndex:index];
    }
    [self hide];
}

//显示提示框
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSArray *windowViews = [window subviews];
    if(windowViews && [windowViews count] > 0){
        UIView *subView = [windowViews objectAtIndex:[windowViews count]-1];
        for(UIView *aSubView in subView.subviews)
        {
            [aSubView.layer removeAllAnimations];
        }
        [subView addSubview:self];
        [self showBackground];
        [self showAlertAnimation];
    }
}

//隐藏提示框
- (void)hide {
    _contentView.hidden = YES;
    [self hideAlertAnimation];
    [self removeFromSuperview];
}

//设置标题的颜色和字体大小，默认为黑色，大小15
- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size {
    if (color != nil) {
        _titleLabel.textColor = color;
    }
    
    if (size > 0) {
        _titleLabel.font = [UIFont systemFontOfSize:size];
    }
}

//设置内容的颜色和字体大小，默认为黑色，大小13
- (void)setMessageColor:(UIColor *)color fontSize:(CGFloat)size {
    if (color != nil) {
        _messageLabel.textColor = color;
    }
    
    if (size > 0) {
        _messageLabel.font = [UIFont systemFontOfSize:size];
    }
}

//设置按钮的字体颜色和字体大小，默认为黑色，大小16
- (void)setButtonTitleColor:(UIColor *)color fontSize:(CGFloat)size atIndex:(NSInteger)index {
    UIButton *button = _buttonArray[index];
    if (color != nil) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (size > 0) {
        button.titleLabel.font = [UIFont systemFontOfSize:size];
    }
}

//动画效果
- (void)showBackground
{
    _backgroundView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.6;
    [UIView commitAnimations];
}
- (void)showAlertAnimation
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_contentView.layer addAnimation:animation forKey:nil];
}
- (void)hideAlertAnimation {
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.0;
    [UIView commitAnimations];
}

@end
