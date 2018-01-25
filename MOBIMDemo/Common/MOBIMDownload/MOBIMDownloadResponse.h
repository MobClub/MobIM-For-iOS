//
//  MOBIMDownloadResponse.h
//  TYDownloadManagerDemo
//
//  Created by hower on 2017/10/17.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOBIMDownloadManager.h"


NS_ASSUME_NONNULL_BEGIN

//下载响应类
@interface MOBIMDownloadResponse : NSObject<NSCoding>

//网络地址
@property (nonatomic, copy , nonnull) NSString *URLString;

//本地存储文件名
@property (nonatomic, copy , nullable) NSString *fileName;

//本地存储文件地址
@property (nonatomic, copy , nonnull) NSString *filePath;

//下载状态
@property (nonatomic, assign) MOBIMDownloadState state;

//下载进度
@property (nonatomic, copy, nonnull) NSProgress *progress;

//已经下载文件的字节数
@property (assign, nonatomic) long long totalBytesWritten;

//文件总字节数
@property (assign, nonatomic) long long totalBytesExpectedToWrite;

//统计时间，用于统计流量
@property (nonatomic, strong) NSDate *date;

//一段时间内读取的长度
@property (nonatomic, assign) NSUInteger totalRead;
@property (nonatomic, copy) NSString *speed;  // KB/s

//ssl 认证相关
@property (nonatomic, strong) NSURLCredential *credential;


//成功回调
@property (nonatomic, copy) MOBIMDownloadSucessBlock successBlock;

//失败回调
@property (nonatomic, copy) MOBIMDownloadFailureBlock failureBlock;

//进度回调
@property (nonatomic, copy) MOBIMDownloadProgressBlock progressBlock;


/***
* @param    URLString    文件网络地址
* @param   filePath    下载文件本地存储地址
 **/
- (instancetype)initWithURLString:(NSString *)URLString filePath:(NSString *)filePath;


@end

NS_ASSUME_NONNULL_END
