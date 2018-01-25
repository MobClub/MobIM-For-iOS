//
//  MIMVoiceMessageBody+CoreDataClass.h
//  MobIM
//
//  Created by youzu on 2017/9/12.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMFileMessageBody.h"

NS_ASSUME_NONNULL_BEGIN

/**
 语音消息体类
 */
@interface MIMVoiceMessageBody : MIMFileMessageBody

/**
 语音时长,以秒为单位
 */
@property (nonatomic) int16_t duration;

/**
 语音是否已听
 */
@property (nonatomic) BOOL isListened;


/**
 初始化语音消息体

 @param localPath 语音文件本地路径
 @param duration 语音时长
 @return 语音消息体
 */
+ (instancetype)bodyWithLocalPath:(NSString *)localPath duration:(int16_t)duration;

@end

NS_ASSUME_NONNULL_END
