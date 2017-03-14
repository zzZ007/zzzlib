//
//  RGHudModular.m
//  FMTest
//
//  Created by RG-IOS-DEV－001 on 15/3/2.
//  Copyright (c) 2015年 Readygo. All rights reserved.
//

#import "RGHudModular.h"


static RGHudModular *RGHud;
@implementation RGHudModular
+ (RGHudModular *)getRGHud
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RGHud = [[RGHudModular alloc] init];
    });
    return RGHud;
}

/*****************************************************************************
 * 方法名称: - (void)showPopHudWithMessage:(NSString *)message
 * 功能描述: 弹出带文字的菊花框整体视图
 * 输入参数: message--弹出的文字;
 * 输出参数:
 * 返回值:
 * 其它说明:
 *****************************************************************************/
- (void)showPopHudWithMessage:(NSString *)message
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    if (message != nil) {
        hud.label.text = message;
    }
    
}

/*****************************************************************************
 * 方法名称: - (void)showPopHudWithMessage:(NSString *)message inView:(UIView *)containView
 * 功能描述: 弹出带文字的菊花框
 * 输入参数: message--弹出的文字;containView--父级视图
 * 输出参数:
 * 返回值:
 * 其它说明:
 *****************************************************************************/
- (void)showPopHudWithMessage:(NSString *)message inView:(UIView *)containView
{

}

/*****************************************************************************
 * 方法名称: - (void)hidePopHudInView:(UIView *)containView*)containView
 * 功能描述: 隐藏弹出框
 * 输入参数: containView--父级视图
 * 输出参数:
 * 返回值:
 * 其它说明:
 *****************************************************************************/
- (void)hidePopHudInView:(UIView *)containView
{

}

/*****************************************************************************
 * 方法名称: - (void)hidePopHudInWindow:(UIView *)containView
 * 功能描述: 隐藏弹出框
 * 输入参数: containView--父级视图
 * 输出参数:
 * 返回值:
 * 其它说明:
 *****************************************************************************/
- (void)hidePopHud
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

/*****************************************************************************
 * 方法名称:- (void)showAutoHudWithMessageDefault:(NSString *)message
 * 功能描述: 弹出只文字的提示并自动消失
 * 输入参数: message--弹出的文字;containView--父级视图
 * 输出参数:
 * 返回值:
 * 其它说明:
 *****************************************************************************/
- (void)showAutoErrorHudWithMessage:(NSString *)message
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
//    hud.square = YES;
    if (message != nil) {
        hud.label.text = message;
    }
    
    [hud hideAnimated:YES afterDelay:2.0];
}

/*****************************************************************************
 * 方法名称:- (void)showAutoErrorHudWithMessage:(NSString *)message
 * 功能描述: 弹出只文字的提示并自动消失
 * 输入参数: message--弹出的文字;containView--父级视图
 * 输出参数:
 * 返回值:
 * 其它说明:
 *****************************************************************************/
- (void)showAutoDoneHudWithMessage:(NSString *)message
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    //    hud.square = YES;
    if (message != nil) {
        hud.label.text = message;
    }
    
    [hud hideAnimated:YES afterDelay:2.0];
}
@end
