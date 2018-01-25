//
//  MIMActionMessageBody.h
//  MobIM
//
//  Created by Sands_Lee on 2017/11/8.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MIMMessageBody.h"

NS_ASSUME_NONNULL_BEGIN

/**
 命令消息体类
 */
@interface MIMActionMessageBody : MIMMessageBody

/**
 命令内容
 */
@property (nullable, nonatomic, copy) NSString *action;

/**
 初始化命令消息体类
 
 @param aAction 命令内容
 @return 命令消息体实例
 */
+ (instancetype)bodyWithAction:(NSString *)action;

@end

NS_ASSUME_NONNULL_END
