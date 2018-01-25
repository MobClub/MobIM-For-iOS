//
//  MIMUserManager.h
//  MobIM
//
//  Created by Sands_Lee on 2017/11/21.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIMUser, MIMError, MIMVCard;

@interface MIMUserManager : NSObject

/**
 获取单例对象
 
 @return 单例对象
 */
+ (instancetype)defaultManager;

/**
 获取本地提醒号列表

 @return 提醒号列表
 */
- (NSArray<MIMUser *> *)getLocalNoticers;

/**
 获取用户名片
 
 @param userId 用户id
 @return 名片
 */
- (MIMVCard *)getVCardWithUserId:(NSString *)userId;


/**
 设置用户是否免打扰

 @param userId 用户id
 @param isDisturb 是否免打扰
 @return 是否设置成功
 */
- (BOOL)setUserToDisturbWithUserId:(NSString *)userId isDisturb:(BOOL)isDisturb;

/**
 添加到黑名单
 
 @param userId 要添加的人的appUserId
 @param resultHandler 回调,添加成功则返回被添加到黑名单的用户信息
 */
- (void)addToBlackListWithUserId:(NSString *)userId resultHandler:(void (^)(MIMUser *user, MIMError *error))resultHandler;

/**
 删除黑名单
 
 @param userId 要删除的人的appUserId
 @param resultHandler 回调,删除成功则返回从黑名单中删除的用户信息
 */
- (void)deleteBlackListWithUserId:(NSString *)userId resultHandler:(void (^)(MIMUser *user, MIMError *error))resultHandler;

/**
 获取当前用户的黑名单列表
 
 @param resultHandler 回调
 */
- (void)getBlackListWithResultHandler:(void (^)(NSArray<MIMUser *> *blackList, MIMError *error))resultHandler;

/**
 查找用户
 
 @param userId 要查找的用户的appUserId
 @param resultHandler 回调
 */
- (void)findUserWith:(NSString *)userId resultHandler:(void (^)(MIMUser *user, MIMError *error))resultHandler;

@end
