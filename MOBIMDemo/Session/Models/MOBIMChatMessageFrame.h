//
//  MOBIMChatMessageFrame.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MOBIMChatMessageModel.h"
#import "MOBIMChatMessageExt.h"




@class YYTextLayout;
@interface MOBIMChatMessageFrame : NSObject

//聊天信息的背景图
@property (nonatomic, assign, readonly) CGRect bubbleViewF;

//聊天信息label
@property (nonatomic, assign, readonly) CGRect chatLabelF;

//发送的菊花视图
@property (nonatomic, assign, readonly) CGRect activityF;

// 头像
@property (nonatomic, assign, readonly) CGRect headImageViewF;

//计算总的高度
@property (nonatomic, assign) CGFloat cellHeight;

// 图片
@property (nonatomic, assign, readonly) CGRect picViewF;

/// 语音图标
@property (nonatomic, assign) CGRect voiceIconF;

/// 语音时长或视频数字
@property (nonatomic, assign) CGRect durationLabelF;

/// 语音未读红点
@property (nonatomic, assign) CGRect redViewF;

//针对系统标题名称
@property (nonatomic, assign, readonly) CGRect nameViewF;

//针对系统标题时间
@property (nonatomic, assign, readonly) CGRect dateViewF;

//重新发送按钮
@property (nonatomic, assign, readonly) CGRect retryButtonF;
// topView   /***第一版***/
@property (nonatomic, assign, readonly) CGRect topViewF;

//顶部时间视图
@property (nonatomic, assign, readonly) CGRect topDateF;


//消息模型
//@property (nonatomic, strong) MOBIMChatMessageModel *model;
@property (nonatomic, strong) MIMMessage *modelNew;

//受SDK模型限制，考虑建立扩展字段
@property (nonatomic, strong) MOBIMChatMessageExt *messageExt;

@property (nonatomic, strong) YYTextLayout *textLayout;


//启动计算各个视图的位置，宽高
- (CGFloat)calCellHeight:(int)style;


@end

