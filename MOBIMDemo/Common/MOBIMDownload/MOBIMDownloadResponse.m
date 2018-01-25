//
//  MOBIMDownloadResponse.m
//  TYDownloadManagerDemo
//
//  Created by hower on 2017/10/17.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMDownloadResponse.h"
#import <CommonCrypto/CommonDigest.h>


#define MOBIMDownloadCacheFolderName  @"MOBIMDownloadCache"


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

static unsigned long long fileSizeForPath(NSString *path) {
    
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

@implementation MOBIMDownloadResponse


#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.URLString forKey:NSStringFromSelector(@selector(URLString))];
    [aCoder encodeObject:self.filePath forKey:NSStringFromSelector(@selector(filePath))];
    [aCoder encodeObject:@(self.state) forKey:NSStringFromSelector(@selector(state))];
    [aCoder encodeObject:self.fileName forKey:NSStringFromSelector(@selector(fileName))];
    [aCoder encodeObject:@(self.totalBytesWritten) forKey:NSStringFromSelector(@selector(totalBytesWritten))];
    [aCoder encodeObject:@(self.totalBytesExpectedToWrite) forKey:NSStringFromSelector(@selector(totalBytesExpectedToWrite))];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.URLString = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(URLString))];
        self.filePath = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(filePath))];
        self.state = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(state))] unsignedIntegerValue];
        self.fileName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fileName))];
        self.totalBytesWritten = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(totalBytesWritten))] unsignedIntegerValue];
        self.totalBytesExpectedToWrite = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(totalBytesExpectedToWrite))] unsignedIntegerValue];
        
    }
    return self;
}




- (NSProgress *)progress {
    if (_progress == nil) {
        _progress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    }
    @try {
        _progress.totalUnitCount = self.totalBytesExpectedToWrite;
        _progress.completedUnitCount = self.totalBytesWritten;
    } @catch (NSException *exception) {
        
    }
    return _progress;
}

- (long long)totalBytesWritten {
    
    return fileSizeForPath(self.filePath);
}

- (NSString *)filePath
{
    if (!_filePath) {
        _filePath = [cacheFolder() stringByAppendingPathComponent:self.fileName];
    }
    return _filePath;
}

- (NSString *)fileName
{
    if (!_fileName) {
        _fileName = _URLString.lastPathComponent;
    }
    return _fileName;
}


- (instancetype)initWithURLString:(NSString *)URLString filePath:(NSString *)filePath
{
    if (self = [super init]) {
        _URLString = URLString;
        _filePath = filePath;
        _fileName = filePath.lastPathComponent;
    }
    return self;
}
@end
