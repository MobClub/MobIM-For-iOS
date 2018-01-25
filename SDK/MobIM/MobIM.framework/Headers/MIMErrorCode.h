//
//  MIMErrorCode.h
//  MobIM
//
//  Created by youzu on 2017/9/20.
//  Copyright © 2017年 MOB. All rights reserved.
//

/**
 SDK错误类型定义
 */
typedef NS_ENUM(NSUInteger, MIMErrorCode) {
    // 请求参数错误
    MIMErrorParamsError = 1,
    // 网络不可用
    MIMErrorNetworkUnavailable,
    // 用户未登录
    MIMErrorNotLogin = 50,
    
    // 消息发送相关错误
    MIMErrorMessageSendFailed = 100,
    MIMErrorMessageSendReceiptNull,
    
    // socket相关错误
    MIMErrorSocketConnectFailed = 200,
    MIMErrorSocketServiceResponseNull,
    MIMErrorSocketHeartBeatFailed,
    
    // 数据解密失败
    MIMErrorDataDecryptionFailed = 4110004,
    // 会话过期
    MIMErrorSessionExpired = 4110006,
    // 密钥实效
    MIMErrorSecretKeyFailure = 4110008,
    // 接口请求频率过高
    MIMErrorRequestTooOften = 4110111,
    
    // 登录失败
    MIMErrorLoginFailed = 5110203,
    // Token非法
    MIMErrorTokenIllegal = 5110204,
    // Token不存在,获取新token后重新连接
    MIMErrorTokenNotExist = 5110206,
    // 伪造用户
    MIMErrorFakeUsers = 5110207,
    // 用户拥有的群组数量超过上线
    MIMErrorOwnedGroupsLimit = 5110218,
    // 群成员达到上限
    MIMErrorGroupMembersUpperLimit = 5110219,
    // 群组不存在
    MIMErrorGroupNotExists = 5110212,
    // Token 信息错误
    MIMErrorTokenDataFailed = 5110223,
};
