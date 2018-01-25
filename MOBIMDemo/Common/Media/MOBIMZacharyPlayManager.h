//
//  MOBIMZacharyPlayManager.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "MOBIMVideoPlayOperation.h"


@interface MOBIMZacharyPlayManager : NSObject
{
    NSOperationQueue *videoQueue;
    NSMutableDictionary *videoDecode;
    
    
}

@property (nonatomic, strong) NSMutableDictionary *videoDecode;
@property (nonatomic, strong) NSOperationQueue *videoQueue;


+ (MOBIMZacharyPlayManager*) sharedInstance;
// 本地 videoPath   block中播放的imageview
- (void)startWithLocalPath:(NSString *)filePath WithVideoBlock:(VideoCode)videoImage;
- (void)reloadVideo:(VideoStop) stop withFile:(NSString *)filePath;
- (void)cancelVideo:(NSString *)filePath;
- (void)cancelAllVideo;
@end
