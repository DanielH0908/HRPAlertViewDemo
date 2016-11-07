//
//  ViewController.m
//  HRPAlertViewDemo
//
//  Created by DanielH on 16/10/24.
//  Copyright © 2016年 DanielH. All rights reserved.
//

#import "ViewController.h"
#import "MyAlertView.h"

@interface ViewController ()<MyAlertViewDelegate>
{
    MyAlertView *_myAlertV;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *titleArray = @[@"普通样式",@"小图标的样式",@"小图标和标题样式",@"设置标题和内容的字体颜色、大小",@"设置按钮字体颜色和大小",@"自定义样式"];
    
    for (int i = 0; i < titleArray.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(50, 80 + 60 * i, 200, 40);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.tag = i + 1;
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 1:
        {
            //@"一般样式"
            MyAlertView *myAlertV = [[MyAlertView alloc] initWithTitle:@"一般样式" icon:nil message:@"一般样式一般样式一般样式" delegate:self buttonTitles:@"取消",@"确定", nil];
            [myAlertV show];
        }
            break;
        
        case 2:
        {
            //@"只有小图标的样式"
            MyAlertView *myAlertV = [[MyAlertView alloc] initWithTitle:nil icon:[UIImage imageNamed:@"My_alert_icon"] message:@"只有小图标的样式只有小图标的样式只有小图标的样式" delegate:self buttonTitles:@"取消",@"确定", nil];
            [myAlertV show];
        }
            break;
        
        case 3:
        {
            //@"有小图标和标题的样式"
            MyAlertView *myAlertV = [[MyAlertView alloc] initWithTitle:@"有小图标和标题的样式" icon:[UIImage imageNamed:@"My_alert_icon"] message:@"有小图标和标题的样式有小图标和标题的样式有小图标和标题的样式" delegate:self buttonTitles:@"取消",@"修改",@"删除", nil];
            [myAlertV show];
        }
            break;
        
        case 4:
        {
            //@"设置标题和内容的字体颜色、大小"
            MyAlertView *myAlertV = [[MyAlertView alloc] initWithTitle:@"设置标题和内容的字体颜色、大小" icon:[UIImage imageNamed:@"My_alert_icon"] message:@"设置标题和内容的字体颜色、大小设置标题和内容的字体颜色、大小" delegate:self buttonTitles:@"取消",@"修改",@"删除", nil];
            //设置标题和内容的字体颜色、大小
            [myAlertV setTitleColor:[UIColor redColor] fontSize:17];
            [myAlertV setMessageColor:[UIColor cyanColor] fontSize:12];
            
            [myAlertV show];
        }
            break;
        
        case 5:
        {
            //@"设置按钮字体的颜色和大小"
            MyAlertView *myAlertV = [[MyAlertView alloc] initWithTitle:@"设置按钮字体的颜色和大小" icon:[UIImage imageNamed:@"My_alert_icon"] message:@"设置按钮字体的颜色和大小设置按钮字体的颜色和大小" delegate:self buttonTitles:@"取消",@"修改",@"删除", nil];
            //设置标题和内容的字体颜色、大小
            [myAlertV setTitleColor:[UIColor redColor] fontSize:17];
            [myAlertV setMessageColor:[UIColor cyanColor] fontSize:12];
            //设置按钮字体的颜色和大小
            [myAlertV setButtonTitleColor:[UIColor orangeColor] fontSize:15 atIndex:0];
            [myAlertV setButtonTitleColor:[UIColor blueColor] fontSize:17 atIndex:1];
            [myAlertV setButtonTitleColor:[UIColor purpleColor] fontSize:19 atIndex:2];
            
            [myAlertV show];
        }
            break;
        
        case 6:
        {
            //@"自定义视图的样式"
            _myAlertV = [[MyAlertView alloc] init];
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 300)];
            bgView.backgroundColor = [UIColor whiteColor];
            bgView.layer.borderWidth = 1;
            bgView.layer.cornerRadius = 5;
            bgView.layer.borderColor = [UIColor redColor].CGColor;
            
            UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 40)];
            infoLabel.text = @"姓名";
            [bgView addSubview:infoLabel];
            UITextField *nameTextF = [[UITextField alloc] initWithFrame:CGRectMake(10, 70, 100, 40)];
            nameTextF.placeholder = @"请输入姓名";
            nameTextF.layer.borderWidth = 1;
            [bgView addSubview:nameTextF];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10, 250, 250, 40);
            [btn setTitle:@"关闭" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor lightGrayColor]];
            [bgView addSubview:btn];
            [btn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            _myAlertV.contentView = bgView;
            [_myAlertV show];
        }
            break;
            
        default:
            break;
    }
}

- (void)closeBtnClick:(UIButton *)btn
{
    [_myAlertV hide];
}

#pragma mark ----- MyAlertViewDelegate
- (void)alertView:(MyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"输出此时点击的按钮索引值......%ld", (long)buttonIndex);
}

- (void)touchesBegan:(NSSet < UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end