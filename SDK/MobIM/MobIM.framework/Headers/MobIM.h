//
//  MobIM.h
//  MobIM
//
//  Created by Sands_Lee on 2017/11/5.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIMChatManager, MIMGroupManager, MIMUserManager, MIMUser, MIMError;

@interface MobIM : NSObject

/**
 获取聊天管理对象
 
 @return 聊天管理对象
 */
+ (MIMChatManager *_Nonnull)getChatManager;

/**
 获取群组管理对象
 
 @return 群组管理对象
 */
+ (MIMGroupManager *_Nonnull)getGroupManager;

/**
 获取用户管理对象

 @return 用户管理对象
 */
+ (MIMUserManager *_Nonnull)getUserManager;

/**
 获取当前用户信息
 
 @return 当前用户
 */
+ (MIMUser * _Nullable)getCurrentUser;

/**
 退出MobIM
 */
+ (void)logoutMobIM;

/**
 正在连接服务器
 
 @param connectingHandler 进行连接时回调
 */
+ (void)onConnecting:(void (^_Nullable)(MIMUser * _Nonnull currentUser))connectingHandler;

/**
 连接服务器成功
 
 @param connectedHandler 连接成功时回调
 */
+ (void)onConnected:(void (^_Nullable)(MIMUser * _Nonnull currentUser))connectedHandler;

/**
 断开连接

 @param disconnectedHandler 断开连接时回调
 */
+ (void)onDisConnected:(void (^_Nullable)(MIMError * _Nullable error))disconnectedHandler;

@end
