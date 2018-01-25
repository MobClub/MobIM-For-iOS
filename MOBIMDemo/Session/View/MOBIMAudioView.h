//
//  MOBIMAudioView.h
//  XZ_WeChat
//
//  Created by Hower on 17-9-27.
//  Copyright (c) 2017年 gxz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOBIMAudioView : UIView

@property (nonatomic, copy) NSString *audioName;

@property (nonatomic, copy) NSString *audioPath;

- (void)releaseTimer;

@end
