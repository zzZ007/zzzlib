//
//  UIViewController+BackButtonHandler.h
//  HotCommunity
//
//  Created by zzz on 16/10/2.
//  Copyright © 2016年 zzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (BackButtonHandler)<BackButtonHandlerProtocol>

@end
