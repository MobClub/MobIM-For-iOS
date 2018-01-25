//
//  MOBIMMessageManager.h
//  MOBIMDemo
//
//  Created by hower on 2017/10/20.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOBIMChatMessageFrame.h"

//个人对话消息缓存
typedef void (^MOBIMCacheUserMessagesCompletionBlock)(NSString *userId , NSUInteger pageIndex, NSUInteger pageSize, NSError *error);

//消息相关的管理工作
@interface MOBIMMessageManager : NSObject

//单例
+ (instancetype)sharedManager;

- (void)registerDownMessageAudioFile;

- (NSString *)contentStringWithGroupExt:(MIMMessage*)message;

@end
