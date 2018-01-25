//
//  MIMMessage+CoreDataClass.h
//  MobIM
//
//  Created by youzu on 2017/9/12.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MIMDefine.h"

@class MIMMessageBody, MIMUser;

/**
 消息模型类
 */
@interface MIMMessage : NSManagedObject

/**
 消息ID,消息的唯一标识符
 */
@property (nullable, nonatomic, copy, readonly) NSString *messageId;

/**
 所属会话ID,该消息所属会话的唯一标识符
 */
@property (nullable, nonatomic, copy, readonly) NSString *conversationId;

/**
 时间戳
 */
@property (nonatomic, readonly) int64_t timestamp;

/**
 发送方
 */
@property (nullable, nonatomic, copy) NSString *from;

/**
 接收方
 */
@property (nullable, nonatomic, copy) NSString *to;

/**
 是否已读
 */
@property (nonatomic, readonly) BOOL isRead;

/**
 消息体
 */
@property (nullable, nonatomic) MIMMessageBody *body;

/**
 消息发送方对象
 */
@property (nullable, nonatomic, readonly) MIMUser *fromUserInfo;

# pragma mark - Transient Property

/**
 消息的方向
 */
@property (nonatomic, assign) MIMMessageDirection direction;

/**
 会话类型(系统,单聊,群聊)
 */
@property (nonatomic, assign) MIMConversationType conversationType;

/**
 消息状态
 */
@property (nonatomic, assign, readonly) MIMMessageStatus status;

/**
 扩展信息
 */
@property (nullable, nonatomic, readonly) NSDictionary *ext;


/**
 初始化消息对象

 @param type 会话类型
 @param toId 接收人的appUid
 @param body 消息体
 @return 消息对象
 */
+ (instancetype _Nullable )messageWithConversationType:(MIMConversationType)type to:(NSString *_Nullable)toId body:(MIMMessageBody *_Nullable)body;

@end

