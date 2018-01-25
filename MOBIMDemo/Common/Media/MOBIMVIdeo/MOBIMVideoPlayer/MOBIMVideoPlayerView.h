//
//  MOBIMVideoPlayerView.h
//  MOBIMVideoPlayerView
//
//  Created by hower on 2017/10/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



//播放状态枚举值
typedef NS_ENUM(NSInteger,MOBIMVideoPlayerStatus){
    MOBIMVideoPlayerStatusFailed,
    MOBIMVideoPlayerStatusReadyToPlay,
    MOBIMVideoPlayerStatusUnknown,
    MOBIMVideoPlayerStatusBuffering,
    MOBIMVideoPlayerStatusPlaying,
    MOBIMVideoPlayerStatusStopped
};

@interface MOBIMVideoPlayerView : UIView

//播放类
@property (nonatomic, strong) AVPlayer *player;

//AVPlayer的播放item
@property (nonatomic, strong) AVPlayerItem *item;

//资产AVURLAsset
@property (nonatomic, strong) AVURLAsset *anAsset;

//设置标题
@property (nonatomic, copy) NSString *title;

//总时长
@property (nonatomic, assign) CMTime totalTime;
//当前时间
@property (nonatomic, assign) CMTime currentTime;

//播放器Playback Rate
@property (nonatomic, assign) CGFloat rate;

//是否正在播放
@property (nonatomic, assign, readonly) BOOL isPlaying;
//是否全屏
@property (nonatomic, assign, readonly) BOOL isFullScreen;


@property (nonatomic, assign) MOBIMVideoPlayerStatus status;


/**
 *param url  本地播放地址或者网络地址
 *param thumbnail  视频缩略图
 **/
- (MOBIMVideoPlayerView *)initWithUrl:(NSURL*)url thumbnail:(UIImage*)thumbnail isLocalUrl:(BOOL)isLocalUrl;

#pragma mark 操作相关

//播放
- (void)play;

//停止
- (void)stop;

//暂停
- (void)pause;


@end
