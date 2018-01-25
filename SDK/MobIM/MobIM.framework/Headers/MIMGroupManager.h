//
//  MIMGroupManager.h
//  MobIM
//
//  Created by Sands_Lee on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMDefine.h"

@class MIMGroup, MIMUser, MIMError, MIMSDKService, MIMVCard;

@interface MIMGroupManager : NSObject

/**
 获取单例对象

 @return 单例对象
 */
+ (instancetype)defaultManager;

/**
 根据群组id查询群名片
 
 @param groupId 群组id
 @return 群名片
 */
- (MIMVCard *)getVCardWithGroupId:(NSString *)groupId;

/**
 设置群组消息免打扰
 
 @param groupId 群组id
 @return 是否设置成功
 */
- (BOOL)setGroupToDisturbByGroupId:(NSString *)groupId isDisturb:(BOOL)isDisturb;


/**
 创建群组

 @param groupName 群组名称
 @param groupDesc 群组简介
 @param groupNoti 群组公告
 @param groupMembers 群成员
 @param resultHandler 回调处理
 */
- (void)createGroupWithGroupName:(NSString *)groupName
                       groupDesc:(NSString *)groupDesc
                       groupNoti:(NSString *)groupNoti
                    groupMembers:(NSArray<NSString *> *)groupMembers
                   resultHandler:(void (^)(MIMGroup *group, MIMError *error))resultHandler;

/**
 修改群名称

 @param groupName 群名称
 @param groupId 群id
 @param resultHandler 回调
 */
- (void)updateGroupName:(NSString *)groupName
            withGroupId:(NSString *)groupId
          resultHandler:(void (^)(MIMGroup *group, MIMError *error))resultHandler;

/**
 修改群简介

 @param groupDesc 群简介
 @param groupId 群id
 @param resultHandler 回调
 */
- (void)updateGroupDesc:(NSString *)groupDesc
            withGroupId:(NSString *)groupId
          resultHandler:(void (^)(MIMGroup *group, MIMError *error))resultHandler;

/**
 修改群公告

 @param groupNoti 群公告
 @param groupId 群id
 @param resultHandler 回调
 */
- (void)updateGroupNotice:(NSString *)groupNoti
              withGroupId:(NSString *)groupId
            resultHandler:(void (^)(MIMGroup *group, MIMError *error))resultHandler;


/**
 修改群昵称

 @param nickname 要修改的昵称
 @param groupId 群组ID
 @param resultHandler 回调处理
 */
- (void)updateGroupNickname:(NSString *)nickname
                    inGroup:(NSString *)groupId
              resultHandler:(void (^)(MIMVCard *card, MIMError *error))resultHandler;

/**
 增加群成员
 
 @param members 被添加人的id集合
 @param groupId 要添加到的群组ID
 @param resultHandler 回调处理
 */
- (void)addGroupMembers:(NSArray<NSString *> *)members
                toGroup:(NSString *)groupId
          resultHandler:(void (^)(MIMGroup *group, MIMError *error))resultHandler;

/**
 删除群成员
 
 @param members 要删除的群成员MobUserId集合
 @param groupId 群组id
 @param resultHandler 回调处理
 */
- (void)deleteGroupMembers:(NSArray<NSString *> *)members
                   inGroup:(NSString *)groupId
             resultHandler:(void (^)(MIMGroup *group, MIMError *error))resultHandler;

/**
 退出群组

 @param groupId 要退出的群组ID
 @param resultHandler 回调处理
 */
- (void)exitGroupWithGroupId:(NSString *)groupId resultHandler:(void (^)(MIMGroup *group, MIMError *error))resultHandler;

/**
 转让群组

 @param groupId 要转让的群组ID
 @param toId 被转让人(群成员)的appUid
 @param resultHandler 回调处理
 */
- (void)transferGroup:(NSString *)groupId
                   to:(NSString *)toId
        resultHandler:(void (^)(MIMGroup *group, MIMError *error))resultHandler;

/**
 获取群组信息
 
 @param options 选项,可以选择群组信息,群成员列表,或者群信息+群成员
 @param groupId 群组ID
 @param resultHandler 回调处理
 */
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                        options:(MIMGroupInfoOption)options
                  resultHandler:(void (^)(MIMGroup *group, MIMError *error))resultHandler;

/**
 加入群组

 @param groupId 群组id
 @param resultHandler 回调处理
 */
- (void)joinToGroup:(NSString *)groupId resultHandler:(void (^)(MIMGroup *group, MIMError *error))resultHandler;

/**
 获取当前用户的群组列表

 @param resultHandler 回调
 */
- (void)getUserGroupsWithResultHandler:(void (^)(NSArray<MIMGroup *> *groupList, MIMError *error))resultHandler;

/**
 查找群组
 
 @param groupId 群组id
 @param resultHandler 回调
 */
- (void)findGroupBy:(NSString *)groupId resultHandler:(void (^)(MIMGroup *group, MIMError *error))resultHandler;

@end
