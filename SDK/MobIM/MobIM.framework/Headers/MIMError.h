//
//  MIMError.h
//  MobIM
//
//  Created by youzu on 2017/9/19.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMErrorCode.h"

/**
 SDK错误类
 */
@interface MIMError : NSObject

/**
 错误码
 */
@property (nonatomic, assign) MIMErrorCode errorCode;

/**
 错误描述
 */
@property (nonatomic, copy) NSString *errorDescription;
/**
 根据系统错误初始化错误实例
 
 @param error 系统错误
 @return 错误实例对象
 */
+ (instancetype)errorWithNSError:(NSError *)error;

/**
 初始化错误实例

 @param code 错误码
 @return 错误实例对象
 */
+ (instancetype)errorWithErrorCode:(MIMErrorCode)code;

/**
 初始化错误实例(用于创建不在MIMErrorCode枚举内的错误信息)

 @param description 错误描述
 @param code 错误码
 @return 错误实例对象
 */
+ (instancetype)errorWithDescription:(NSString *)description errorCode:(MIMErrorCode)code;

@end
