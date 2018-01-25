//
//  MOBIMGroupManager.h
//  MOBIMDemo
//
//  Created by hower on 2017/10/20.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MOBIMSearchGroupsGetSucessBlock)(NSMutableArray<MOBIMGroupModel*> *groups);
typedef void (^MOBIMModifyGroupNameCompletionBlock)(NSString *groupId,NSString *groupName, NSError *error);
typedef void (^MOBIMModifyGroupIntroductionCompletionBlock)(NSString *groupId,NSString *introduction, NSError *error);
typedef void (^MOBIMModifyGroupNoticeCompletionBlock)(NSString *groupId,NSString *notice, NSError *error);
typedef void (^MOBIMUserModifyNicknameInGroupNoticeCompletionBlock)(NSString *groupId,NSString *nickName, NSError *error);
typedef void (^MOBIMModifyGroupDisturbCompletionBlock)(NSString *groupId,BOOL disturb, NSError *error);
typedef void (^MOBIMDisbandGroupCompletionBlock)(NSString *groupId , NSError *error);
typedef void (^MOBIMQuitGroupCompletionBlock)(NSString *groupId , NSError *error);
typedef void (^MOBIMTranferGroupCompletionBlock)(NSString *groupId , NSString *owerId, NSError *error);




//群组信息的管理工作
@interface MOBIMGroupManager : NSObject

//单例
+ (instancetype)sharedManager;

/**
 *修改群名
 *
 **/
- (void)modifyGroupName:(NSString*)groupName groupId:(NSString*)groupId completion:(MOBIMModifyGroupNameCompletionBlock)completion;

/**
 *修改群简介
 *
 **/
- (void)modifyGroupIntroduction:(NSString*)introduction groupId:(NSString*)groupId completion:(MOBIMModifyGroupIntroductionCompletionBlock)completion;


/**
 *修改群公告
 *
 **/
- (void)modifyGroupNotice:(NSString*)notice groupId:(NSString*)groupId completion:(MOBIMModifyGroupNoticeCompletionBlock)completion;

/**
 *用户自己修改用户在群中的昵称
 *
 **/
- (void)userModifyNicknameInGroup:(NSString*)nickName groupId:(NSString*)groupId completion:(MOBIMUserModifyNicknameInGroupNoticeCompletionBlock)completion;


/**
 *群名片修改 (消息免打扰)
 *
 **/
- (void)modifyGroupDisturb:(BOOL)disturb groupId:(NSString*)groupId completion:(MOBIMModifyGroupDisturbCompletionBlock)completion;


/**
 *解散群组
 *
 **/
- (void)disbandGroup:(NSString*)groupId completion:(MOBIMDisbandGroupCompletionBlock)completion;


/**
 *退出群组
 *
 **/
- (void)quitGroup:(NSString*)groupId completion:(MOBIMQuitGroupCompletionBlock)completion;

/**
 *转让
 *
 **/
- (void)transferGroup:(NSString*)groupId toUser:(NSString*)userId completion:(MOBIMTranferGroupCompletionBlock)completion;




@end
