//
//  MOBIMBaseViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOBIMBaseViewController : UIViewController

//表试图数据
@property (nonatomic, strong) NSMutableArray *dataArray;

//加载数据
- (void)loadData;

//加载试图
- (void)loadUI;

//点击返回南牛
- (void)backCLick:(UIButton*)button;

//弹窗
- (void)showAlertWithText:(NSString*)text;

//当前屏幕顶部状态栏高度
- (float)currentStatusBarHeight;

//当前屏幕导航栏高度
- (float)currentNavBarHeight;

//考虑iphone x 屏幕地址的高度
- (float)safeBottomHeight;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
//主线程执行的block
- (void)performMainBlock:(void(^)())block;

#pragma clang diagnostic pop

//设置返回按钮自定义
- (void)setupNavBack;

- (void)setCustomTitle:(NSString*)title;

//是否返回主界面
- (BOOL)willBackToRootWithAlertTag:(NSInteger)tag;
@end

