//
//  MOBIMAudioView.m
//  XZ_WeChat
//
//  Created by Hower on 17-9-27.
//  Copyright (c) 2017年 gxz. All rights reserved.
//

#import "MOBIMAudioView.h"
#import "MOBIMChatMessageTools.h"
#import "MOBIMAudioManager.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMGConst.h"
#import "UIColor+MOBIMExtentions.h"

@interface MOBIMAudioView ()<AVAudioPlayerDelegate,MOBIMAudioManagerDelegate>
{
    UILabel * _nameLabel;
    UILabel * _endTimeLabel;
    AVAudioPlayer *_player;
    NSTimer * _timer;
    UIProgressView * _progressV;
    UIButton * _playBtn;
}

@end



@implementation MOBIMAudioView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setSubView:frame];
    }
    return self;
}


- (void)setSubView:(CGRect)frame
{
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-luyin"]];
    imageV.frame = CGRectMake(150, 105, 99, 143);
    imageV.centerX = frame.size.width*0.5;
    [self addSubview:imageV];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, imageV.bottom+27, 250, 20)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    nameLabel.centerX = frame.size.width*0.5;
    nameLabel.font    = [UIFont systemFontOfSize:15.0];
    nameLabel.textColor = MOBIMRGB(0x535f62);
    nameLabel.text    = _audioName;
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-kaishianniu"] forState:UIControlStateNormal];
    playBtn.frame = CGRectMake(25,nameLabel.bottom+200, 50, 50);
    [self addSubview:playBtn];
    [playBtn addTarget:self action:@selector(beginPlay:) forControlEvents:UIControlEventTouchUpInside];
    _playBtn = playBtn;
    /*
     UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(playBtn.right+16, playBtn.top, frame.size.width-playBtn.right-16-25, 10)];
     slider.centerY = playBtn.centerY;
     slider.thumbTintColor = IColor(13, 103, 135);
     slider.minimumTrackTintColor = IColor(13, 103, 135);
     slider.value = 0.5;
     [self addSubview:slider];
     */
    UIProgressView *progressV = [[UIProgressView alloc] initWithFrame:CGRectMake(playBtn.right+16, playBtn.top, frame.size.width-playBtn.right-16-25, 10)];
    progressV.centerY = playBtn.centerY;
    progressV.progressTintColor =  MOBIMColor(13, 103, 135);
    [self addSubview:progressV];
    _progressV = progressV;
    
    UILabel * endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(progressV.right-100, progressV.bottom+14, 100, 20)];
    endTimeLabel.textAlignment = NSTextAlignmentRight;
    endTimeLabel.font = [UIFont systemFontOfSize:14.0];
    endTimeLabel.textColor = MOBIMRGB(0x535f62);
    [self addSubview:endTimeLabel];
    _endTimeLabel = endTimeLabel;
    
}

- (void)setAudioName:(NSString *)audioName
{
    _audioName = audioName;
    _nameLabel.text = audioName;
}

- (void)setAudioPath:(NSString *)audioPath
{
    _audioPath = audioPath;
    NSUInteger durataion = [[MOBIMAudioManager sharedManager] durationWithAudioPath:[NSURL fileURLWithPath:audioPath]];
    _endTimeLabel.text = [MOBIMChatMessageTools timeDurationFormatter:durataion];
}

- (void)beginPlay:(UIButton *)playBtn
{
    MOBIMAudioManager *manager = [MOBIMAudioManager sharedManager];
    if (manager.player == nil)
    {
        [playBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-zhanting"] forState:UIControlStateNormal];
        manager.audioPlayDelegate = self;
        [manager startPlayAudio:_audioPath];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                                                selector:@selector(playProgress)
                                                userInfo:nil repeats:YES];
    } else if ([manager.player isPlaying])
    {
        [playBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-kaishianniu"] forState:UIControlStateNormal];
        [manager pause];
        [_timer setFireDate:[NSDate distantFuture]];
    } else {
        [playBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-zhanting"] forState:UIControlStateNormal];
        [manager.player play];
        [_timer setFireDate:[NSDate date]];
    }
    
}

- (void)playProgress
{
    MOBIMAudioManager *manager = [MOBIMAudioManager sharedManager];
    _progressV.progress = [[manager player] currentTime]/[[manager player]duration];
}

- (void)timerInvalid
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - delegate
// 释放
- (void)audioDidPlayFinished
{
    [self timerInvalid];
    [[MOBIMAudioManager sharedManager] stopPlayAudio:_audioPath];
    MOBIMAudioManager *manager = [MOBIMAudioManager sharedManager];
    [manager stopPlayAudio:_audioPath];
    manager.audioPlayDelegate = nil;
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-kaishianniu"] forState:UIControlStateNormal];
}

- (void)releaseTimer
{
    [self timerInvalid];
}

- (void)dealloc
{
    MOBIMAudioManager *manager = [MOBIMAudioManager sharedManager];
    [manager stopPlayAudio:_audioPath];
    manager.audioPlayDelegate = nil;
    [self timerInvalid];
}

@end
