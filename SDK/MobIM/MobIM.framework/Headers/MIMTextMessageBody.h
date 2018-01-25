//
//  MIMTextMessageBody+CoreDataClass.h
//  MobIM
//
//  Created by youzu on 2017/9/12.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMMessageBody.h"

NS_ASSUME_NONNULL_BEGIN
/**
 文本消息体类
 */
@interface MIMTextMessageBody : MIMMessageBody

/**
 文字内容
 */
@property (nullable, nonatomic, copy) NSString *text;

/**
 初始化文字消息体
 
 @param text 文字内容
 @return 文字消息体实例
 */
+ (instancetype)bodyWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
