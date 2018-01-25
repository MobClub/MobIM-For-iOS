//
//  MOBIMDownloadManager.m
//  TYDownloadManagerDemo
//
//  Created by hower on 2017/10/17.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMDownloadManager.h"
#import <UIKit/UIKit.h>
#import "MOBIMDownloadResponse.h"



NSString * const MOBIMDownloadCacheFolderName = @"MOBIMDownloadCache";

#define KMOBIMBufferMaxLen 1024

static NSString * cacheFolder() {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    static NSString *cacheFolder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cacheFolder) {
            NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
            cacheFolder = [cacheDir stringByAppendingPathComponent:MOBIMDownloadCacheFolderName];
        }
        NSError *error = nil;
        if (![filemgr createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
            MOBIMLog(@"Failed to create cache directory at %@", cacheFolder);
            cacheFolder = nil;
        }
    });
    return cacheFolder;
}

static NSString * LocalResponsesPath() {
    return [cacheFolder() stringByAppendingPathComponent:@"mobimresponses.data"];
}


@interface MOBIMDownloadManager()<NSURLSessionDataDelegate>

@property (nonatomic, strong) dispatch_queue_t synchronizationQueue;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *allDownloadResponses;
@property (nonatomic, strong) NSMutableDictionary *downloadTasks;
@property (nonatomic, strong) NSMutableArray *queuedTasks;

@property (nonatomic, assign) NSInteger maximumActiveDownloads;
@property (nonatomic, assign) NSInteger activeRequestCount;

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;


@end


@implementation MOBIMDownloadManager

+ (instancetype)instance {
    static  MOBIMDownloadManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
        sharedInstance.allowInvalidSSLCertificates = YES;
    });
    return sharedInstance;
}


- (NSURLSessionConfiguration *)defaultSessionConfiguration
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    configuration.HTTPShouldSetCookies = YES;
    configuration.HTTPShouldUsePipelining = NO;
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    configuration.allowsCellularAccess = YES;
    configuration.timeoutIntervalForRequest = 60.0;
    configuration.HTTPMaximumConnectionsPerHost = 10;
    configuration.discretionary = YES;
    return configuration;
}


- (NSMutableDictionary *)allDownloadResponses {
    if (_allDownloadResponses == nil) {
        NSDictionary *responses = [NSKeyedUnarchiver unarchiveObjectWithFile:LocalResponsesPath()];
        _allDownloadResponses = responses != nil ? responses.mutableCopy : [NSMutableDictionary dictionary];
    }
    return _allDownloadResponses;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        NSURLSessionConfiguration *defaultSessionConfiguration = [self defaultSessionConfiguration];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
        NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration delegate:self delegateQueue:queue];
        self.session = session;
        
        self.downloadTasks = [[NSMutableDictionary alloc] init];
        self.queuedTasks = [[NSMutableArray alloc] init];
        
        self.maximumActiveDownloads = 4;

        //串行队列
        NSString *synName = [NSString stringWithFormat:@"com.mob.downloadManager.synchronizationqueue-%@", [MOBIMDownloadManager class]];
        self.synchronizationQueue = dispatch_queue_create([synName cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    }
    
    return self;

}

- (void)downloadFileWithURLString:(NSString *)URLString
                destination:(NSString *)destination
                   progress:(MOBIMDownloadProgressBlock)progressBlock
                    success:(MOBIMDownloadSucessBlock)successBlock
                   faillure:(MOBIMDownloadFailureBlock)failureBlock
{
    
    
    //文件路径为空错误处理
//    dispatch_sync(self.synchronizationQueue, ^{
//
//    });
    
    if (!URLString) {
        if (failureBlock) {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(nil,nil,error);
            });
        }
        
        return;
    }
    
    __block MOBIMDownloadResponse *response = [self downloadResponseForURLString:URLString destination:destination];
    response.successBlock = successBlock;
    response.progressBlock = progressBlock;
    response.failureBlock = failureBlock;
    
    //缓存过,直接取
    if (response.state == MOBIMDownloadStateStateCompleted && response.totalBytesExpectedToWrite == response.totalBytesWritten) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.successBlock) {
                response.successBlock(nil,nil,[NSURL URLWithString:response.URLString]);
            }
        });
        return;
    }
    
    if (response.state == MOBIMDownloadStateStateDowning  && response.totalBytesExpectedToWrite != response.totalBytesWritten) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.progressBlock) {
                response.progressBlock(response.progress,response);
            }
        });
        
        return;
    }
    
    
    NSURLSessionDataTask *task = self.downloadTasks[response.URLString];
    if (!task || ((task.state != NSURLSessionTaskStateRunning) && (task.state != NSURLSessionTaskStateSuspended)))
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:response.URLString]];
        
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", response.totalBytesWritten];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
        task.taskDescription = response.URLString;
        self.downloadTasks[response.URLString] = task;
        [self.queuedTasks addObject:task];
    }
    
    
    //恢复下载
    [self resumeWithDownloadResponse:response];
}



- (void)enqueueTask:(NSURLSessionDataTask *)task {
    
    [self.queuedTasks addObject:task];
    
}


- (BOOL)isActiveRequestCountBelowMaximumLimit {
    return self.activeRequestCount < self.maximumActiveDownloads;
}



- (MOBIMDownloadResponse *)downloadResponseForURLString:(NSString*)URLString
{
    if (!URLString) {
        return nil;
    }
    
    MOBIMDownloadResponse *response =self.allDownloadResponses[URLString];
    if (response) {
        return response;
    }
    
    return nil;
}


- (MOBIMDownloadResponse *)downloadResponseForURLString:(NSString*)URLString destination:(NSString*)destination
{
    if (!URLString) {
        return nil;
    }
    
    MOBIMDownloadResponse *response =self.allDownloadResponses[URLString];
    
    if (!response) {
        response = [[MOBIMDownloadResponse alloc] initWithURLString:URLString filePath:destination];
        response.state = MOBIMDownloadStateNone;
        response.totalBytesExpectedToWrite = 1;
        dispatch_sync(self.synchronizationQueue, ^{
            [self.allDownloadResponses setObject:response forKey:URLString];
            [self saveResponses:self.allDownloadResponses];
        });
    }
    
    if (self.urlCredential) {
        response.credential = self.urlCredential;
    } else if (self.username && self.password) {
        response.credential = [NSURLCredential credentialWithUser:self.username password:self.password persistence:NSURLCredentialPersistenceForSession];
    }
    
    return response;
}


//- (MOBIMDownloadResponse *)downloadResponseForURLString:(NSString*)URLString destination:(NSString*)destination
//{
//    if (!URLString) {
//        return nil;
//    }
//
//    MOBIMDownloadResponse *response =self.allDownloadResponses[URLString];
//    if (response) {
//        return response;
//    }
//
//    response = [[MOBIMDownloadResponse alloc] initWithURLString:URLString filePath:destination];
//    response.state = MOBIMDownloadStateNone;
//    response.totalBytesExpectedToWrite = 1;
//    dispatch_sync(self.synchronizationQueue, ^{
//        [self.allDownloadResponses setObject:response forKey:URLString];
//        [self saveResponses:self.allDownloadResponses];
//    });
//
//    return response;
//}




- (void)startTask:(NSURLSessionDataTask*)task
{
    [task resume];
    ++self.activeRequestCount;
    [self updateResponseWithURLString:task.taskDescription state:MOBIMDownloadStateStateDowning];
}

- (MOBIMDownloadResponse *)updateResponseWithURLString:(NSString*)URLString state:(MOBIMDownloadState)state
{
    MOBIMDownloadResponse *response = [self downloadResponseForURLString:URLString];
    response.state = state;
    [self saveResponses:self.allDownloadResponses];
    
    return response;
}

- (void)saveResponses:(NSDictionary *)responses {
    [NSKeyedArchiver archiveRootObject:responses toFile:LocalResponsesPath()];

}


- (NSURLSessionDataTask*)safelyRemoveTaskWithURLIdentifier:(NSString *)URLIdentifier {
    __block NSURLSessionDataTask *task = nil;
    dispatch_sync(self.synchronizationQueue, ^{
        task = [self removeTaskWithURLIdentifier:URLIdentifier];
    });
    return task;
}

//This method should only be called from safely within the synchronizationQueue
- (NSURLSessionDataTask *)removeTaskWithURLIdentifier:(NSString *)URLIdentifier {
    NSURLSessionDataTask *task = self.downloadTasks[URLIdentifier];
    [self.downloadTasks removeObjectForKey:URLIdentifier];
    return task;
}

- (void)safelyDecrementActiveTaskCount {
    dispatch_sync(self.synchronizationQueue, ^{
        if (self.activeRequestCount > 0) {
            self.activeRequestCount -= 1;
        }
    });
}

- (void)safelyStartNextTaskIfNecessary {
    dispatch_sync(self.synchronizationQueue, ^{
        if ([self isActiveRequestCountBelowMaximumLimit])
        {
            while (self.queuedTasks.count > 0)
            {
                NSURLSessionDataTask *task = [self dequeueTask];
                MOBIMDownloadResponse *response = [self downloadResponseForURLString:task.taskDescription];
                if (task.state == NSURLSessionTaskStateSuspended && response.state == MOBIMDownloadStateStateReadying)
                {
                    [self startTask:task];
                    break;
                }
            }
        }
    });
}

- (NSURLSessionDataTask *)dequeueTask
{
    NSURLSessionDataTask *task = nil;
    task = [self.queuedTasks firstObject];
    [self.queuedTasks removeObject:task];
    
    return task;
}


- (void)suspendAll {

    for (NSURLSessionDataTask *task in self.queuedTasks) {
        MOBIMDownloadResponse *response = [self downloadResponseForURLString:task.taskDescription];
        response.state = MOBIMDownloadStateStateSuspended;
        [task suspend];
        
        [self safelyDecrementActiveTaskCount];
    }
    
    
    
}


- (void)removeWithDownloadResponse:(MOBIMDownloadResponse *)response {
    
    NSURLSessionDataTask *task = self.downloadTasks[response.URLString];
    if (task) {
        [task cancel];
    }
    
    [self.queuedTasks removeObject:task];
    [self safelyRemoveTaskWithURLIdentifier:response.URLString];
    
    dispatch_sync(self.synchronizationQueue, ^{
        [self.allDownloadResponses removeObjectForKey:response.URLString];
        [self saveResponses:self.allDownloadResponses];
    });
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:response.filePath error:nil];
    
}

#pragma mark -  UIApplicatoin NSNotification 处理挂起操作
- (void)applicationWillTerminate:(NSNotification *)notification {
    [self suspendAll];

}

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)notification {
    [self suspendAll];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    /// 捕获到失去激活状态后
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
    if (hasApplication ) {
        __weak __typeof__ (self) wself = self;
        UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
        self.backgroundTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
            __strong __typeof (wself) sself = wself;
            
            if (sself) {
                [sself suspendAll];
                
                [app endBackgroundTask:sself.backgroundTaskId];
                sself.backgroundTaskId = UIBackgroundTaskInvalid;
            }
        }];
    }
}



- (void)applicationDidBecomeActive:(NSNotification *)notification {
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if (!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        UIApplication * app = [UIApplication performSelector:@selector(sharedApplication)];
        [app endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
}

#pragma mark -相关操作

- (void)suspendWithDownloadResponse:(MOBIMDownloadResponse*)response
{
    if (!response) {
        return;
    }
    
    [self updateResponseWithURLString:response.URLString state:MOBIMDownloadStateStateSuspended];
    NSURLSessionDataTask *task = self.downloadTasks[response.URLString];
    if (task) {
        [task suspend];
        [self safelyDecrementActiveTaskCount];
        [self safelyStartNextTaskIfNecessary];
    }
}


- (void)resumeWithDownloadResponse:(MOBIMDownloadResponse*)response
{
    if (!response) {
        return;
    }
    
    if ([self isActiveRequestCountBelowMaximumLimit]) {
        NSURLSessionDataTask *task = self.downloadTasks[response.URLString];
        if (!task || ((task.state != NSURLSessionTaskStateRunning) && (task.state != NSURLSessionTaskStateSuspended)))
        {
            [self downloadFileWithURLString:response.URLString destination:response.filePath progress:response.progressBlock success:response.successBlock faillure:response.failureBlock];
        }else{
            [self startTask:self.downloadTasks[response.URLString]];
            response.date = [NSDate date];
            
        }
        
    }else{
        response.state = MOBIMDownloadStateStateReadying;
        [self saveResponses:self.allDownloadResponses];
        [self enqueueTask:self.downloadTasks[response.URLString]];
    }
    
}

- (void)cancelWithDownloadResponse:(MOBIMDownloadResponse*)response
{
    if (!response) {
        return;
    }
    NSURLSessionDataTask *task = self.downloadTasks[response.URLString];
    
    if (!task && response.state == MOBIMDownloadStateStateReadying) {
        
        [self.queuedTasks removeObject:task];
        [self safelyRemoveTaskWithURLIdentifier:response.URLString];

        dispatch_sync(self.synchronizationQueue, ^{
            [self.allDownloadResponses removeObjectForKey:response.URLString];
            [self updateResponseWithURLString:response.URLString state:MOBIMDownloadStateNone];
        });
        
        return;
    }
        
        
    if (response.state != MOBIMDownloadStateStateCompleted && response.state != MOBIMDownloadStateStateFailed) {
        [task cancel];
    }
}

- (void)deleteWithDownloadResponse:(MOBIMDownloadResponse*)response
{
    [self removeWithDownloadResponse:response];
}

#pragma mark - <NSURLSessionDataDelegate>
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    MOBIMDownloadResponse *curResponse = [self downloadResponseForURLString:dataTask.taskDescription];
    curResponse.totalBytesExpectedToWrite = curResponse.totalBytesWritten + dataTask.countOfBytesExpectedToReceive;
    curResponse.state = MOBIMDownloadStateStateDowning;
    
    [self saveResponses:self.allDownloadResponses];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    dispatch_sync(self.synchronizationQueue, ^{
        
        __block NSError *error = nil;
        MOBIMDownloadResponse *response = [self downloadResponseForURLString:dataTask.taskDescription];
        
        response.totalRead += data.length;
        NSDate *currentDate = [NSDate date];
        if ([currentDate timeIntervalSinceDate:response.date] >= 1) {
            double time = [currentDate timeIntervalSinceDate:response.date];
            long long speed = response.totalRead/time;
            response.speed = [NSByteCountFormatter stringFromByteCount:speed countStyle:NSByteCountFormatterCountStyleFile];
            response.totalRead = 0.0;
            response.date = currentDate;
        }
        
        
        //开始写入文件操作
        NSString *outFilePath = response.filePath;
        NSInputStream *inputStream = [[NSInputStream alloc] initWithData:data];
        NSOutputStream *outputStream = [[NSOutputStream alloc] initWithURL:[NSURL fileURLWithPath:outFilePath] append:YES];
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inputStream open];
        [outputStream open];
        
        while ([inputStream hasBytesAvailable] && [outputStream hasSpaceAvailable]) {
            u_int8_t buffer[KMOBIMBufferMaxLen];
            NSInteger bytesRead = [inputStream read:buffer maxLength:KMOBIMBufferMaxLen];
            if (inputStream.streamError || bytesRead < 0) {
                error = inputStream.streamError;
                break;
            }
            
            NSInteger byteswritten = [outputStream write:buffer maxLength:(NSUInteger)bytesRead];
            if (outputStream.streamError || byteswritten < 0) {
                error = outputStream.streamError;
                break;
            }
            
            if (byteswritten ==0 && bytesRead ==0) {
                break;
            }
        }
        
        [inputStream close];
        [outputStream close];
        
        response.progress.totalUnitCount = response.totalBytesExpectedToWrite;
        response.progress.completedUnitCount = response.totalBytesWritten;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.progressBlock) {
                response.progressBlock(response.progress, response);
            }
        });
        
        
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    MOBIMDownloadResponse *response = [self downloadResponseForURLString:task.taskDescription];
    if (error) {
        response.state = MOBIMDownloadStateStateFailed;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.failureBlock) {
                response.failureBlock(task.originalRequest, (NSHTTPURLResponse*)task.response, error);
            }
        });
    }else{
        
        response.state = MOBIMDownloadStateStateCompleted;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.successBlock) {
                response.successBlock(task.originalRequest, (NSHTTPURLResponse*)task.response,task.originalRequest.URL);
            }
        });
    }
    
    [self saveResponses:self.allDownloadResponses];
    [self safelyDecrementActiveTaskCount];
    [self safelyStartNextTaskIfNecessary];
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    MOBIMDownloadResponse *response = [self downloadResponseForURLString:task.taskDescription];

    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (!self.allowInvalidSSLCertificates) {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        } else {
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            disposition = NSURLSessionAuthChallengeUseCredential;
        }
    } else {
        if ([challenge previousFailureCount] == 0) {
            if (response.credential) {
                credential = response.credential;
                disposition = NSURLSessionAuthChallengeUseCredential;
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}



@end
