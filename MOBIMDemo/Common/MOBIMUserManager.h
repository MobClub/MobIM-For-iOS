//
//  MOBIMUserManager.h
//  MOBIMDemo
//
//  Created by hower on 2017/10/18.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOBIMUserModel.h"
#import "MOBIMUser.h"
#import "MOBIMGroupModel.h"
#import "MOBIMVCard.h"

typedef void (^MOBIMUserGetCompletionBlock)(MOBIMUser *user,NSError *error);
typedef void (^MOBIMContactsGetCompletionBlock)(NSMutableArray<MOBIMUser*> *contacts,NSError *error);
typedef void (^MOBIMSearchContactsGetCompletionBlock)(NSMutableArray<MOBIMUserModel*> *users,NSError *error);
typedef void (^MOBIMModifyCurrentUserAvatarCompletionBlock)(NSString *avatarPath,NSError *error);
typedef void (^MOBIMModifyCurrentUserNicknameCompletionBlock)(NSString *nickName,NSError *error);
typedef void (^MOBIMRemoveBlackUserCompletionBlock)(MOBIMVCard *vcard,MIMError *error);
typedef void (^MOBIMAddBlackUserCompletionBlock)(MOBIMVCard *vcard,MIMError *error);
typedef void (^MOBIMBlackListCompletionBlock)(NSArray<MIMUser*> *blackUsers,MIMError *error);
typedef void (^MOBIMAddUserDisturbCompletionBlock)(MOBIMVCard *vcard,NSError *error);
typedef void (^MOBIMRemoveUserDisturbCompletionBlock)(MOBIMVCard *vcard,NSError *error);
typedef void (^MOBIMTipUsersGetCompletionBlock)(NSArray<MOBIMUser*> *tipUsers,NSError *error);


//用户信息的管理工作
@interface MOBIMUserManager : NSObject

//单例
+ (instancetype)sharedManager;


#pragma mark -当前用户
//当前登录用户
@property (nonatomic, strong) MOBIMUser *currentUser;

+ (NSString *)currentUserId;


/**
 *数据结构转换  app MOBIMUser 转 MOBIMUserModel
 *
 **/
+ (MOBIMUserModel*)userToUserModel:(MOBIMUser *)user;

/**
 *数据结构转换  app MOBIMUser 转 MOBIMUserModel
 *
 **/
+ (MOBIMUser *)userModelToUser:(MOBIMUserModel *)user;


/**
 *数据结构转换  sdk MIMUser 转 MOBIMUserModel
 *
 **/
+ (MOBIMUserModel*)userSdkToUserModel:(MIMUser *)user;


/**
 *数据结构转换  sdk MIMUser 转 app MOBIMUser
 *
 **/
+ (MOBIMUser *)userToAppUser:(MIMUser *)user;


/**
 *数据结构转换  sdk MIMUser 转 app MOBIMUser (提醒号)
 *
 **/
+ (MOBIMUser *)saveUserToAppTipUser:(MIMUser *)user;


/**
 查找或创建
 **/
- (MOBIMVCard *)fetchOrCreateUserVcardWithUserId:(NSString *)userId;


/**
 名片相关 更新黑名单状态
 **/
- (MOBIMVCard *)updateBalackStatus:(NSString *)userId black:(BOOL)isBlack;




/**
 *负责用户信息的数据库加载
 *
 **/
- (MOBIMUser *)usserInfoWithId:(NSString *)userId;


/**
 *负责用户信息的下载与加载
 *
 **/
- (void)fetchUserInfo:(NSString *)userId needNetworkFetch:(BOOL)needNetworkFetch completion:(MOBIMUserGetCompletionBlock)completion;
- (void)fethNetUserInfo:(NSString *)userId completion:(MOBIMUserGetCompletionBlock)completion;


/**
 *网络获取用户信息
 *
 **/
- (void)fetchUserInfo:(NSString *)userId completion:(MOBIMUserGetCompletionBlock)completion;


/**
 *获取好友列表
 *
 **/
- (void)fetchContacts:(MOBIMContactsGetCompletionBlock)completion;

/**
 *获取提醒号好列表
 *
 **/
- (void)fetchTipUsers:(MOBIMTipUsersGetCompletionBlock)sucessBlock;


/**
 *本地缓存查找用户，没有就添加并且保存
 *
 **/
- (MOBIMUser *)userFindFirstOrCreateWithUserModel:(MOBIMUserModel *)userModel;


/**
 *移除黑名单
 *
 **/
- (void)removeBlackUser:(NSString *)userId completion:(MOBIMRemoveBlackUserCompletionBlock)completion;

/**
 *添加黑名单
 *
 **/
- (void)addBlackUser:(NSString *)userId completion:(MOBIMAddBlackUserCompletionBlock)completion;

/**
 *添加黑名单
 *
 **/
- (void)fetchBlackList:(MOBIMBlackListCompletionBlock)completion;

/**
 *设置用户消息免打扰
 *
 **/
- (void)addUserDisturb:(NSString *)userId completion:(MOBIMAddUserDisturbCompletionBlock)completion;

/**
 *移除用户消息免打扰
 *
 **/
- (void)removeUserDisturb:(NSString *)userId completion:(MOBIMRemoveUserDisturbCompletionBlock)completion;

/**
 *修改用户头像
 *
 **/
- (void)modifyCurrentUserAvatarPath:(NSString *)avatarPath completion:(MOBIMModifyCurrentUserAvatarCompletionBlock)completion;


/**
 *修改用户昵称
 *
 **/
- (void)modifyCurrentUserNickname:(NSString*)nickName completion:(MOBIMModifyCurrentUserNicknameCompletionBlock)completion;


@end
