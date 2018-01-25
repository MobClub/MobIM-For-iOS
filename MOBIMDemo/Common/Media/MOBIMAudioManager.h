//
//  MOBIMAudioManager.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>



@protocol MOBIMAudioManagerDelegate <NSObject>

- (void)audioDidPlayFinished;

@end

@interface MOBIMAudioManager : NSObject<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

+ (id)sharedManager;

@property (nonatomic, weak) id <MOBIMAudioManagerDelegate> audioPlayDelegate;
@property (nonatomic, strong, readonly) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;



//公共
// 获取语音时长
- (NSUInteger)durationWithAudioPath:(NSURL *)audioUrl;


- (void)removeCurrentRecordFile;
- (void)removeCurrentRecordFile:(NSString *)fileName;


- (NSString *)receiveVoicePathWithFileKey:(NSString *)fileKey;


//录音
- (void)startRecordingWithPath:(NSString*)audioPath completion:(void(^)(NSError *error))completion;

- (void)startRecordingWithFileName:(NSString*)audioPath completion:(void(^)(NSError *error))completion;

- (void)stopRecordingWithCompletion:(void(^)(NSString *recordPath))completion;

- (BOOL)canRecord;



//播放
- (void)startPlayAudio:(NSString*)audioPath;
- (void)stopPlayAudio:(NSString*)audioPath;
- (void)pause;

//通过本地地址映射本地文件存储地址
- (NSString *)audioLocalPathWithAudioURLString:(NSString*)URLString;
- (NSString *)audioLocalPathWithExtention:(NSString*)extention URLString:(NSString*)URLString;

@end
