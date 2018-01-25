//
//  MIMChatManager.h
//  MobIM
//
//  Created by Sands_Lee on 2017/9/22.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MIMDefine.h"

@class MIMMessage, MIMError, MIMConversation, MIMVCard;

@interface MIMChatManager : NSObject

/**
 获取聊天管理单例对象

 @return 单例对象
 */
+ (instancetype)defaultManager;


#pragma mark - 会话查询

/**
 获取本地会话列表

 @param resultHandler 会话列表回调
 */
- (void)getLocalConversationList:(void (^)(NSArray<MIMConversation *> *conversationList))resultHandler;

/**
 监听本地会话列表变更,当本地会话列表变化时通过block回调

 @param resultHandler 会话列表变更回调
 */
- (void)onLocalConversationListResultChanged:(void (^)(MIMConversation *changedConversation, NSFetchedResultsChangeType changeType))resultHandler;


/**
 获取所有创建过的会话列表
 
 @param completionHandler 完成回调
 */
- (void)getConversationListOnCompletion:(void (^)(NSArray<MIMConversation *> *conversationList, MIMError *error))completionHandler;

/**
 获取当前所有未读消息并监听变更,该方法会直接返回本地消息表中所有未读消息,并且当本地消息表中的未读消息变化时通过block回调

 @param resultHandler 未读消息变更回调
 @return 未读消息列表
 */
- (NSInteger)getAllUnreadMessagesOnResultChanged:(void (^)(NSInteger totalUnreadCount))resultHandler;

#pragma mark - 消息发送与接收

/**
 发送消息

 @param msg 消息对象
 @param completionHandler 发送完成回调
 */
- (void)sendMessage:(MIMMessage *)msg completion:(void (^)(MIMMessage *message, MIMError *error))completionHandler;

/**
 接收消息

 @param handlerIdentifier 接收消息回调的唯一标识符,该标识不能为空或空字符串
 @param messageHandler 处理接收到的消息block
 */
- (void)onMessageReceivedWithIdentifier:(NSString *)handlerIdentifier messageHandler:(void (^)(MIMMessage *message))messageHandler;

/**
 移除接收到消息的监听block

 @param handlerIdentifier block标识符
 */
- (void)removeMessageHandlerForIdentifier:(NSString *)handlerIdentifier;

#pragma mark - 删除消息

/**
 删除一条或多条消息

 @param messages 消息对象集合
 @return 是否删除成功
 */
- (BOOL)deleteMessages:(NSArray<MIMMessage *> *)messages;

/**
 根据会话删除某个会话所有消息

 @param conversation 会话
 @return 是否删除成功
 */
- (BOOL)deleteAllMessagesInConversation:(MIMConversation *)conversation;

#pragma mark - 删除会话

/**
 删除本地会话

 @param conversations 要删除的会话集合
 @return 是否删除成功
 */
- (BOOL)deleteLocalConversations:(NSArray<MIMConversation *> *)conversations;

/**
 删除本地会话
 
 @param conversationIds 要删除的会话id集合
 @return 是否删除成功
 */
- (BOOL)deleteLocalConversationsByIds:(NSArray<NSString *> *)conversationIds;



#pragma mark - 查询消息

/**
 根据对方id查询两个人单聊的所有本地消息

 @param otherId 对方AppUid
 @param lastMessage 最后一条消息
 @param pageSize 每次查询多少条,若传小于等于0时,默认每次查询10条,若传大于等于50时,默认只查50条
 @return 消息列表
 */
- (NSArray<MIMMessage *> *)fetchSingleChatMessagesByOtherId:(NSString *)otherId
                                                lastMessage:(MIMMessage *)lastMessage
                                                   pageSize:(NSInteger)pageSize;

/**
 根据群组id查询群组会话的所有本地消息

 @param groupId 群组id
 @param lastMessage 最后一条消息
 @param pageSize 每次查询多少条,若传小于等于0时,默认每次查询10条,若传大于等于50时,默认只查50条
 @return 消息列表
 */
- (NSArray<MIMMessage *> *)fetchGroupChatMessagesByGroupId:(NSString *)groupId
                                                lastMessage:(MIMMessage *)lastMessage
                                                   pageSize:(NSInteger)pageSize;


/**
 根据会话ID查询该会话的最后一条消息

 @param conversationId 会话id
 @return 该会话的最后一条消息
 */
- (MIMMessage*)fetchLastMessageByConversationId:(NSString *)conversationId;

/**
 根据会话ID查询该会话所有消息

 @param conversationId 会话id
 @param lastMessage 最后一条消息
 @param pageSize 每次查询多少条,若传小于等于0时,默认每次查询10条,若传大于等于50时,默认只查50条
 @return 消息列表
 */
- (NSArray<MIMMessage *> *)fetchAllMessagesByConversationId:(NSString *)conversationId
                                                lastMessage:(MIMMessage *)lastMessage
                                                   pageSize:(NSInteger)pageSize;

#pragma mark - 更新消息

/**
 更新Message为已读状态

 @param message 消息
 @return 是否更新成功
 */
- (BOOL)updateMessageToReaded:(MIMMessage *)message;

/**
 根据Conversation更新所有Message为已读状态

 @param conversation 会话
 @return 是否更新成功
 */
- (BOOL)updateMessagesToReadedInConversation:(MIMConversation *)conversation;

/**
 更新语音消息为已听取状态

 @param aVoiceMessage 语音消息
 @return 是否更新成功
 */
- (BOOL)updateVoiceMessageToListened:(MIMMessage *)aVoiceMessage;

/**
 更新附件消息下载状态

 @param newStatus 新下载状态
 @param message 附件消息
 @return 是否更新成功
 */
- (BOOL)updateAttachDownloadStatus:(MIMDownloadStatus)newStatus withMessage:(MIMMessage *)message;

@end
