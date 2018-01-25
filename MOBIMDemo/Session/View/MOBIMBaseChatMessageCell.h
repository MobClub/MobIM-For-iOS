//
//  MOBIMBaseChatMessageCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOBIMChatMessageFrame.h"

@class MOBIMBaseChatMessageCell;


//操作相关事件代理
@protocol MOBIMBaseChatMessageCellDelegate <NSObject>

- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer;
- (void)headImageClicked:(NSString *)userId;
- (void)retrySendMessage:(MOBIMBaseChatMessageCell *)messageCell;

@end


@interface MOBIMBaseChatMessageCell : UITableViewCell


@property (nonatomic, weak) id<MOBIMBaseChatMessageCellDelegate> delegate;

// 消息模型
@property (nonatomic, strong) MOBIMChatMessageFrame *modelFrame;
// 头像
@property (nonatomic, strong) UIImageView *headImageView;
// 内容气泡视图
@property (nonatomic, strong) UIImageView *bubbleView;
// 菊花视图所在的view
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
// 重新发送
@property (nonatomic, strong) UIButton *retryButton;

//顶部时间
@property (nonatomic, strong) UILabel *topDateLabel;

@end
