//
//  MOBIMFileButton.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MOBIMChatMessageModel.h"

@interface MOBIMFileButton : UIButton

@property (nonatomic, strong) MOBIMChatMessageFrame *modelFrame;

@property (nonatomic, strong) UILabel *identLabel;

@property (nonatomic, strong) UIProgressView *progressView;
@end
