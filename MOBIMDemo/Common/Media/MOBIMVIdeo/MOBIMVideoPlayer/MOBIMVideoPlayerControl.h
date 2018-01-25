//
//  MOBIMVideoPlayerControl.h
//  MOBIMVideoPlayerView
//
//  Created by hower on 2017/10/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MOBIMVideoPlayerControl;
@protocol MOBIMVideoPlayerControlDelegate<NSObject>

- (void)videoPlayerControl:(MOBIMVideoPlayerControl*)playerControl playStateChanged:(BOOL)isPlay;
- (void)videoPlayerControl:(MOBIMVideoPlayerControl*)playerControl pointSliderLocationWithCurrentValue:(CGFloat)value;
- (void)videoPlayerControl:(MOBIMVideoPlayerControl*)playerControl draggedPositionWithSlider:(UISlider*)slider;


@end


@interface MOBIMVideoPlayerControl : UIView

//操作代理方法
@property (nonatomic, weak) id<MOBIMVideoPlayerControlDelegate> delegate;

//进度条当前值
@property (nonatomic, assign) CGFloat value;
//最小值
@property (nonatomic, assign) CGFloat minValue;
//最大值
@property (nonatomic, assign) CGFloat maxValue;
//当前时间
@property (nonatomic, copy) NSString *currentTime;
//总时间
@property (nonatomic, copy) NSString *totalTime;
//缓存条当前值
@property (nonatomic, assign) CGFloat bufferValue;

//播放暂停按钮
@property (nonatomic, strong) UIButton *playPauseButton;


//UISlider手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

- (void)startPlayVideo;
@end
