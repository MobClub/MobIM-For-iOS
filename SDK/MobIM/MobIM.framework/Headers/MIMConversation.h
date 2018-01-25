//
//  MIMConversation.h
//  MobIM
//
//  Created by youzu on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MIMDefine.h"

NS_ASSUME_NONNULL_BEGIN

@class MIMMessage, MIMUser, MIMGroup;

@interface MIMConversation : NSManagedObject

/**
 会话ID
 */
@property (nullable, nonatomic, copy, readonly) NSString *conversationId;

/**
 会话创建时间
 */
@property (nonatomic, readonly) int64_t createAt;

/**
 会话更新时间
 */
@property (nonatomic, readonly) int64_t updateAt;

/**
 会话类型
 */
@property (nonatomic, assign, readonly) MIMConversationType conversationType;

/**
 用户信息,单聊
 */
@property (nonatomic, strong, readonly) MIMUser *fromUserInfo;

/**
 群组信息,群聊
 */
@property (nonatomic, strong, readonly) MIMGroup *fromGroupInfo;

/**
 该会话的最后一条消息
 */
@property (nullable, nonatomic, readonly) MIMMessage *lastMessage;

/**
 该会话的未读消息数
 */
@property (nonatomic, readonly) int64_t unreadCount;


@end

NS_ASSUME_NONNULL_END
