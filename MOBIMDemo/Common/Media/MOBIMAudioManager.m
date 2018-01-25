//
//  MOBIMAudioManager.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMAudioManager.h"
#import <UIKit/UIKit.h>
#import "MOBIMVoiceConverter.h"
#import "MOBIMFileManager.h"
#import "MOBIMGConst.h"
#import "NSString+MOBIMExtension.h"


@interface  MOBIMAudioManager()
{
    void (^recordFinishCompletion)(NSString *recordPath);

}
@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSString *recordPath;


@end

@implementation MOBIMAudioManager



+ (id)sharedManager
{
    static id _instance ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


- (void)startRecordingWithFileName:(NSString*)fileName completion:(void(^)(NSError *error))completion
{
    
    NSString *path = [MOBIMFileManager createPathWithChildPath:KMOBIMChatMessageAudioRecordPath];
    
    [self startRecordingWithPath:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",fileName,KMOBIMChatMessageAudioType]] completion:completion];
}

- (void)startRecordingWithPath:(NSString*)audioPath completion:(void(^)(NSError *error))completion
{

    if (!audioPath) {
        return ;
    }
    
    self.recordPath = audioPath;
    
    NSError *error = nil;
    if (![[MOBIMAudioManager sharedManager] canRecord]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法录音" message:@"请在iPhone的“设置-隐私-麦克风”选项中，允许iCom访问你的手机麦克风。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        if (completion) {
            error = [NSError errorWithDomain:NSLocalizedString(@"error", @"没权限") code:122 userInfo:nil];
            completion(error);
        }
        
        return;
    }
    
    if ([self.recorder isRecording]) {
        
        [self.recorder stop];
        
        return;
    }
    
    NSURL *audioUrl=[NSURL URLWithString:audioPath];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&setCategoryError];
    if (setCategoryError){
        MOBIMLog(@"%@", [setCategoryError description]);
        
        completion(setCategoryError);
        
        return;
    }
    
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [NSNumber numberWithFloat:8000.0],AVSampleRateKey,
                      [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                      [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                      [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                      nil];

    self.recorder = [[AVAudioRecorder alloc] initWithURL:audioUrl settings:recordSetting error:&error];
    self.recorder.meteringEnabled = YES;
    if (!self.recorder || error) {
        self.recorder = nil;
        if (completion) {
            error = [NSError errorWithDomain:NSLocalizedString(@"error.initRecorderFail", @"Failed to initialize AVAudioRecorder") code:123 userInfo:nil];
            completion(error);
        }
        return;
    }
    self.startDate = [NSDate date];
    self.recorder.meteringEnabled = YES;
    self.recorder.delegate = self;
    [self.recorder record];
    if (completion) {
        completion(error);
    }

    

}

- (void)stopRecordingWithCompletion:(void(^)(NSString *recordPath))completion
{
    self.endDate=[NSDate date];
    if ([self.recorder isRecording])
    {
        if ([_endDate timeIntervalSinceDate:_startDate] < KMOBIMChatMessagMinRecordDuration) {
            
            [self.recorder stop];
            
            if (completion) {
                completion(KMOBIMToshortRecord);
            }
            
            [self.recorder stop];
            [self cancelCurrentRecording];
            sleep(1.0);
            
            return;
        }
        recordFinishCompletion = completion;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.recorder stop];
        });
    
    }
}

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    return bCanRecord;
}




- (void)cancelCurrentRecording
{
    _recorder.delegate = nil;
    if (_recorder.recording) {
        [_recorder stop];
    }
    _recorder = nil;
     recordFinishCompletion = nil;
}

- (void)startPlayAudio:(NSString*)audioPath
{
    

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;  // 加上这两句，否则声音会很小
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioPath] error:nil];
    self.player.numberOfLoops = 0;
    [self.player prepareToPlay];
    self.player.delegate = self;
    [self.player play];

}


- (void)stopPlayAudio:(NSString*)audioPath
{
    [self.player stop];
    self.player = nil;
    self.player.delegate = nil;
}


- (void)pause
{
    [self.player pause];

}

- (NSUInteger)durationWithAudioPath:(NSURL *)audioUrl
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:audioUrl options:opts]; // 初始化视频媒体文件
    NSUInteger second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    return second;
}

- (void)removeCurrentRecordFile
{
    if (self.recordPath) {
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:self.recordPath];
        if (isDirExist) {
            [[NSFileManager defaultManager] removeItemAtPath:self.recordPath error:nil];
        }
    }

}

- (void)removeCurrentRecordFile:(NSString *)fileName
{
    
    [self cancelCurrentRecording];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [self recorderPathWithFileName:fileName];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (isDirExist) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

- (NSString *)recorderPathWithFileName:(NSString *)fileName
{
    NSString *path = [self recorderMainPath];
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",fileName,KMOBIMChatMessageAudioType]];
}

- (NSString *)recorderMainPath
{
    return [MOBIMFileManager createPathWithChildPath:KMOBIMChatMessageAudioRecordPath];
}

- (NSString *)receiveVoicePathWithFileKey:(NSString *)fileKey
{
    NSString *path = [MOBIMFileManager createPathWithChildPath:KMOBIMChatMessageAudioRecordPath];
    if (fileKey && [fileKey hasSuffix:@".mp3"])
    {
        return [path stringByAppendingPathComponent:fileKey];
    }
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",fileKey,KMOBIMChatMessageAudioType]];

}


#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
    [self.player stop];
    self.player = nil;
    if (self.audioPlayDelegate && [self.audioPlayDelegate respondsToSelector:@selector(audioDidPlayFinished)]) {
        [self.audioPlayDelegate audioDidPlayFinished];
    }
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                           successfully:(BOOL)flag
{
    NSString *recordPath = [[_recorder url] path];
    // 音频转换
    NSString *amrPath = [[recordPath stringByDeletingPathExtension] stringByAppendingPathExtension:KMOBIMChatMessageAudioAMRType];
    
    //格式转换
    [MOBIMVoiceConverter ConvertWavToAmr:recordPath amrSavePath:amrPath];
    
    if (recordFinishCompletion) {
        if (!flag) {
            recordPath = nil;
        }
        recordFinishCompletion(recordPath);
    }
    _recorder = nil;
    recordFinishCompletion = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder
                                   error:(NSError *)error
{
    
}


- (NSString *)audioLocalPathWithAudioURLString:(NSString*)URLString
{
    NSString *path = [self receiveVoicePathWithFileKey:[NSString md5:URLString]];
 
    return path;
}

- (NSString *)audioLocalPathWithExtention:(NSString*)extention URLString:(NSString*)URLString
{
    NSString *path = [MOBIMFileManager createPathWithChildPath:KMOBIMChatMessageAudioRecordPath];
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[NSString md5:URLString],extention]];

}

@end
