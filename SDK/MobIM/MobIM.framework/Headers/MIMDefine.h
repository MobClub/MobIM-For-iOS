//
//  MIMDefine.h
//  MobIM
//
//  Created by Sands_Lee on 2017/11/15.
//  Copyright © 2017年 MOB. All rights reserved.
//

#ifndef MIMDefine_h
#define MIMDefine_h

#import <Foundation/Foundation.h>

/**
 用户类型
 
 - MIMUserTypeNormal: 普通用户
 - MIMUserTypeNoticer: 提醒号
 */
typedef NS_ENUM(NSUInteger, MIMUserType)
{
    MIMUserTypeNormal = 1,
    MIMUserTypeNoticer,
};

/**
 消息体类型枚举
 
 - MIMMessageBodyTypeText: 文字
 - MIMMessageBodyTypeImage: 图片
 - MIMMessageBodyTypeVoice: 语音
 - MIMMessageBodyTypeVideo: 视频
 - MIMMessageBodyTypeLocation: 位置
 - MIMMessageBodyTypeFile: 文件
 - MIMMessageBodyTypeAction: 透传(用于服务器下发指令,通知等)
 */
typedef NS_ENUM(NSUInteger, MIMMessageBodyType)
{
    MIMMessageBodyTypeText = 1,
    MIMMessageBodyTypeImage,
    MIMMessageBodyTypeVoice,
    MIMMessageBodyTypeVideo,
    MIMMessageBodyTypeLocation,
    MIMMessageBodyTypeFile,
    MIMMessageBodyTypeAction,
};

/**
 消息的方向枚举
 
 - MIMMessageDirectionSend: 发送
 - MIMMessageDirectionReceive: 接收
 */
typedef NS_ENUM(NSUInteger, MIMMessageDirection) {
    MIMMessageDirectionSend = 0,
    MIMMessageDirectionReceive,
};

/**
 消息发送状态枚举
 
 - MIMMessageStatusPending: 待发送
 - MIMMessageStatusDelivering: 发送中
 - MIMMessageStatusSucceed: 发送成功
 - MIMMessageStatusFailed: 发送失败
 */
typedef NS_ENUM(NSUInteger, MIMMessageStatus) {
    MIMMessageStatusPending = 0,
    MIMMessageStatusDelivering,
    MIMMessageStatusSucceed,
    MIMMessageStatusFailed,
};

/**
 会话类型枚举
 
 - MIMConversationTypeSystem: 提醒号
 - MIMConversationTypeSingle: 1v1会话,单聊
 - MIMConversationTypeGroup: 群聊会话
 - MIMConversationTypeAction: 推送
 - MIMConversationTypeNotice: 通知
 */
typedef NS_ENUM(NSUInteger, MIMConversationType) {
    MIMConversationTypeSystem = 1,
    MIMConversationTypeSingle,
    MIMConversationTypeGroup,
    MIMConversationTypeAction,
    MIMConversationTypeNotice
};


/**
 群组状态枚举

 - MIMGroupStatusNormal: 正常
 - MIMGroupStatusNotAvailable: 不可用
 */
typedef NS_ENUM(NSUInteger, MIMGroupStatus) {
    MIMGroupStatusNormal = 0,
    MIMGroupStatusNotAvailable,
};

/**
 通知消息的类型枚举

 - MIMNoticeTypeCreateGroup: 创建群组,此类型是创建群组后，推送给所有群成员的信息
 - MIMNoticeTypeUpdateGroupName: 修改群名称,此类型是群主修改群名称后，推送给所有群成员的信息
 - MIMNoticeTypeUpdateGroupNoti: 修改群公告,此类型是群主修改群公告后，推送给所有群成员的信息
 - MIMNoticeTypeGroupTransfer: 转让群组,此类型是群主将群转让给群成员后，推送给所有群成员的信息
 - MIMNoticeTypeGroupDisbanded: 群组被解散,此类型是群主解散群后，推送给所有群成员的信息
 - MIMNoticeTypeJoinGroup: 加入群组,此类型是用户主动加入群，推送给除去该用户外的所有群成员
 - MIMNoticeTypeInvitedToGroup: 邀请入群,此类型是有用户邀请其他用户进入群，之后推送给群成员通知信息
 - MIMNoticeTypeExitGroup: 退出群组,此类型是群成员主动退出群之后推送给其他群成员通知信息
 - MIMNoticeTypeRemoveMembers: 移除群成员,此类型是群主移除群成员之后推送给其他群成员通知信息
 - MIMNoticeTypeMemberRemoved: 群成员被移除,成员被群主移除后,推送给被移除成员的信息
 */
typedef NS_ENUM(NSUInteger, MIMNoticeType) {
    MIMNoticeTypeCreateGroup = 2,
    MIMNoticeTypeUpdateGroupName,
    MIMNoticeTypeUpdateGroupNoti,
    MIMNoticeTypeGroupTransfer,
    MIMNoticeTypeGroupDisbanded,
    MIMNoticeTypeJoinGroup,
    MIMNoticeTypeInvitedToGroup,
    MIMNoticeTypeExitGroup,
    MIMNoticeTypeRemoveMembers,
    MIMNoticeTypeMemberRemoved
};


/**
 获取群组信息选项
 
 - MIMGroupInfoOptionDescription: 群信息
 - MIMGroupInfoOptionMembers: 群成员列表
 */
typedef NS_OPTIONS(NSUInteger, MIMGroupInfoOption) {
    MIMGroupInfoOptionDescription = 1 << 0,
    MIMGroupInfoOptionMembers = 1 << 1,
};

/**
 文件下载状态枚举
 
 - MIMDownloadStatusPending: 等待下载
 - MIMDownloadStatusDownloading: 下载中
 - MIMDownloadStatusSucceed: 下载成功
 - MIMDownloadStatusFailed: 下载失败
 */
typedef NS_ENUM(NSUInteger, MIMDownloadStatus)
{
    MIMDownloadStatusPending = 0,
    MIMDownloadStatusDownloading,
    MIMDownloadStatusSucceed,
    MIMDownloadStatusFailed,
};


#endif /* MIMDefine_h */
