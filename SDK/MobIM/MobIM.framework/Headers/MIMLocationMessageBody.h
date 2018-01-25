//
//  MIMLocationMessageBody+CoreDataClass.h
//  MobIM
//
//  Created by youzu on 2017/9/12.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMMessageBody.h"

NS_ASSUME_NONNULL_BEGIN
/**
 位置消息体类
 */
@interface MIMLocationMessageBody : MIMMessageBody

/**
 纬度
 */
@property (nonatomic) double latitude;

/**
 经度
 */
@property (nonatomic) double longitude;

/**
 初始化位置消息体
 
 @param latitude 纬度
 @param longitude 经度
 @return 位置消息体实例
 */
+ (instancetype)bodyWithLatitude:(double)latitude
                       longitude:(double)longitude;

@end

NS_ASSUME_NONNULL_END
