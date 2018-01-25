//
//  MOBIMBaseChatMessageModel.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MOBIMGConst.h"

@interface MOBIMChatMessageModel : NSObject



// 消息来源用户名
@property (nonatomic, copy) NSString *senderName;
// 消息来源用户id
@property (nonatomic, copy) NSString *from;
// 消息目的地群组id
@property (nonatomic, copy) NSString *to;
// 消息ID
@property (nonatomic, copy) NSString *messageId;
// 消息发送状态
@property (nonatomic, assign) MOBIMChatMessageDeliveryState deliveryState;
// 消息时间
@property (nonatomic, assign) NSInteger date;
// 本地消息标识:(消息+时间)的MD5
@property (nonatomic, copy) NSString *localMsgId;
// 消息文本内容
@property (nonatomic, copy) NSString *content;
// 音频文件的fileKey
@property (nonatomic, copy) NSString *fileKey;
// 发送消息对应的type类型:1,2,3
@property (nonatomic, copy) NSString *type;
// 时长，宽高，首帧id
@property (nonatomic, strong) NSString *lnk;

// (0:未读 1:已读 2:撤回)
@property (nonatomic, assign) MOBIMChatMessageStatus status;


// 是否是发送者
@property (nonatomic, assign) BOOL isSender;


// 包含voice，picture，video的路径;有大图时就是大图路径
// 不用这些路径了，只用里面的名字重新组成路径
@property (nonatomic, copy) NSString *mediaPath;

@property (nonatomic, assign) MOBIMChatRoomType  chatRoomType;


@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *publishDate;

@property (nonatomic, copy) NSString *localMessageId;


@end

