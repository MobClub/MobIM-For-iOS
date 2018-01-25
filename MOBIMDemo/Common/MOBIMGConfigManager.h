//
//  MOBIMGConfigManager.h
//  MOBIMDemo
//
//  Created by hower on 2017/10/18.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MOBIMBaseViewController;

@interface MOBIMGConfigManager : NSObject

@property (nonatomic, strong) UIImage *blueImage;
@property (nonatomic, strong) UIImage *whiteImage;

@property (nonatomic, weak) MOBIMBaseViewController *curViewController;


+ (id)sharedManager;

/** 判断是否是第一次打开*/
- (BOOL)isfirstLanch;
/** 设置已经打开过*/
- (void)setHasLanch;

+ (float)safeBottomHeight;

@end
