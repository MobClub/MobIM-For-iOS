//
//  MIMNoticeMessageBody.h
//  MobIM
//
//  Created by Sands_Lee on 2017/11/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MIMMessageBody.h"

@class MIMUser;

/**
 通知消息体类
 */
@interface MIMNoticeMessageBody : MIMMessageBody

/**
 通知类型
 */
@property (nonatomic, assign) MIMNoticeType noticeType;

/**
 通知内容
 */
@property (nullable, nonatomic, copy) NSString *notice;

@property (nullable, nonatomic) MIMUser *ownerInfo;

@property (nullable, nonatomic) MIMUser *userInfo;

+ (instancetype _Nonnull )bodyWithNoticeType:(MIMNoticeType)type
                                     content:(NSString *_Nullable)notice
                                   ownerInfo:(MIMUser *_Nullable)owner
                                    userInfo:(MIMUser *_Nullable)user;

@end
