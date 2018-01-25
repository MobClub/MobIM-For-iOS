//
//  MOBIMDownloadManager.h
//  TYDownloadManagerDemo
//
//  Created by hower on 2017/10/17.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class MOBIMDownloadResponse;

// 下载状态
typedef NS_ENUM(NSUInteger, MOBIMDownloadState) {
    MOBIMDownloadStateNone,        // 未下载 或 下载删除了
    MOBIMDownloadStateStateDowning,     // 正在下载
    MOBIMDownloadStateStateCompleted,   // 下载完成
    MOBIMDownloadStateStateFailed,       // 下载失败
    MOBIMDownloadStateStateReadying,    // 等待下载
    MOBIMDownloadStateStateSuspended   // 下载暂停
    
};


typedef void (^MOBIMDownloadSucessBlock)(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull url);
typedef void (^MOBIMDownloadFailureBlock)(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response,  NSError * _Nonnull error);
typedef void (^MOBIMDownloadProgressBlock)(NSProgress * _Nonnull progress,MOBIMDownloadResponse * response);


/**
 文件下载管理类
 **/
@interface MOBIMDownloadManager : NSObject

//初始化唯一单例
+ (instancetype)instance;

@property (strong, nonatomic) NSURLCredential *urlCredential;

/**
 * Set username
 */
@property (strong, nonatomic) NSString *username;

/**
 * Set password
 */
@property (strong, nonatomic) NSString *password;

//
@property (nonatomic, assign) BOOL allowInvalidSSLCertificates;


//下载接口
- (void)downloadFileWithURLString:(NSString*)URLString destination:(NSString*)destination progress:(MOBIMDownloadProgressBlock)progressBlock success:(MOBIMDownloadSucessBlock)successBlock faillure:(MOBIMDownloadFailureBlock)failureBlock;

- (MOBIMDownloadResponse *)downloadResponseForURLString:(NSString*)URLString;

//暂停下载
- (void)suspendWithDownloadResponse:(MOBIMDownloadResponse*)response;

//取消下载
- (void)cancelWithDownloadResponse:(MOBIMDownloadResponse*)response;

//恢复下载
- (void)resumeWithDownloadResponse:(MOBIMDownloadResponse*)response;

//删除下载
- (void)deleteWithDownloadResponse:(MOBIMDownloadResponse*)response;

//是否完成下载
//- (void)hasDownloadCompletedWithDownloadResponse:(MOBIMDownloadResponse*)response;

@end

NS_ASSUME_NONNULL_END

