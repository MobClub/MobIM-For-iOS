//
//  MIMFileMessageBody+CoreDataClass.h
//  MobIM
//
//  Created by youzu on 2017/9/12.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMMessageBody.h"
#import "MIMDefine.h"

NS_ASSUME_NONNULL_BEGIN
/**
 文件消息体类
 */
@interface MIMFileMessageBody : MIMMessageBody

/**
 文件名
 */
@property (nullable, nonatomic, copy) NSString *fileName;

/**
 文件的本地路径
 */
@property (nullable, nonatomic, copy) NSString *localPath;

/**
 文件远程路径
 */
@property (nullable, nonatomic, copy) NSString *remotePath;

/**
 文件大小,以字节为单位
 */
@property (nonatomic) double fileLength;

/**
 文件下载状态
 */
@property (nonatomic) MIMDownloadStatus downloadStatus;


/**
 初始化文件消息体

 @param data 文件二进制数据
 @param extension 文件类型(即文件后缀名)
 @return 文件消息体实例
 */
+ (instancetype)bodyWithData:(NSData *)data extension:(NSString *)extension;

/**
 初始化文件消息体
 
 @param localPath 文件本地路径
 @return 文件消息体实例
 */
+ (instancetype)bodyWithLocalPath:(NSString *)localPath;

@end

NS_ASSUME_NONNULL_END
