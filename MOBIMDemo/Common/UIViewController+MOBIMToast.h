//
//  UIViewController+MOBIMToast.h
//  MOBIMDemo
//
//  Created by hower on 2017/10/18.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

typedef void (^MOBIMToastCompletionBlock)();

#pragma clang diagnostic pop

@interface UIViewController(MOBIMToast)

/** 正在展示浮层 */
@property (nonatomic, assign, getter=isShowingToast, readonly) BOOL showingToast;

/**
 只显示一个 UIActivityIndicatorView，需要主动调用 dismissToast 使其消失。
 */
- (void)showToastWithIndeterminateHUDMode;

/**
 显示一个纯文字浮层，自动会消失。
 
 @param message 显示的浮层文字
 */
- (void)showToastMessage:(NSString *)message;

/**
 显示一个纯文字浮层，自动会消失。
 
 @param message 显示的浮层文字
 @param completion 显示完成后
 */
- (void)showToastMessage:(NSString *)message completion:(MOBIMToastCompletionBlock)completion;

/**
 显示一个纯文字浮层，需要主动调用 dismissToast 使其消失。
 
 @param status 显示的浮层文字
 */
- (void)showToastWithStatus:(NSString *)status;

- (void)dismissToast;

- (void)showToastSucessMessage:(NSString *)message;

- (void)showAllTextDialog:(UIView *)view  Text:(NSString *)text;

@end
