//
//  MOBIMVideoManager.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMVideoManager.h"
#import "MOBIMGConst.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NSString+MOBIMExtension.h"

@implementation MOBIMVideoManager

+ (instancetype)sharedManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (NSUInteger)durationWithVideoPath:(NSURL *)videoUrl
{
    AVURLAsset * asset = [AVURLAsset assetWithURL:videoUrl];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    
//    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return seconds;
}

- (NSString *)receiveVideoPathWithURLString:(NSString*)URLString
{
    return [[MOBIMVideoManager sharedManager] receiveVideoPathWithFileKey:[NSString md5:URLString]];
}

// 接收到的视频保存路径(文件以fileKey为名字)
- (NSString *)receiveVideoPathWithFileKey:(NSString *)fileKey
{
    return [self videoPathWithFileName:fileKey];
}

// video的路径
- (NSString *)videoPathWithFileName:(NSString *)videoName
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:KMOBIMChatMessageVideoPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreatDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreatDir) {
            //MOBIMLog(@"create folder failed");
            return nil;
        }
    }
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",videoName,KMOBIMChatMessageVideoType]];
}


- (NSString *)videoPathForMP4:(NSString *)namePath
{
    NSString *videoPath   = [[MOBIMVideoManager sharedManager] videoPathWithFileName:[[namePath lastPathComponent] stringByDeletingPathExtension]];
    NSString *mp4Path     = [[videoPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"mp4"];
    return mp4Path;
}

- (NSString *)videoPathWithFileName:(NSString *)videoName fileDir:(NSString *)fileDir {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreatDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreatDir) {
            //MOBIMLog(@"create folder failed");
            return nil;
        }
    }
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",videoName,KMOBIMChatMessageVideoType]];
}



@end
