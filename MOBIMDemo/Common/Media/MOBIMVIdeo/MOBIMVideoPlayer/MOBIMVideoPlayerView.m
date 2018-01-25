//
//  MOBIMVideoPlayerView.m
//  MOBIMVideoPlayerView
//
//  Created by hower on 2017/10/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMVideoPlayerView.h"
#import "MOBIMVideoPlayerControl.h"
#import "MOBIMDownloadManager.h"
#import "MOBIMVideoManager.h"

static NSInteger count = 0;

@interface MOBIMPlayerLayerView : UIView

@end

@implementation MOBIMPlayerLayerView

+ (Class)layerClass{
    return [AVPlayerLayer class];
}
@end



@interface MOBIMVideoPlayerView()<UIGestureRecognizerDelegate>
{
    id playbackTimerObserver;
}
//视频url
@property (nonatomic, strong) NSURL *url;

//加载动画
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

//底部控制视图
@property (nonatomic, strong) MOBIMVideoPlayerControl *videoPlayerControl;

//播放layer
@property (nonatomic, strong, readonly) AVPlayerLayer *playerLayer;

@property (nonatomic, strong ) UIImage *thumbnailImage;
@property (nonatomic, strong ) UIImageView *thumbnailImageView;
@property (nonatomic, strong ) MOBIMPlayerLayerView *playerLayerView;
@property (nonatomic, assign) BOOL isLocalUrl;
@property (nonatomic, assign) BOOL hasFinishedVideo;


@property (nonatomic, strong) UIButton* backButton;

@property (nonatomic, strong) UIButton *moreImageButton;

@end

@implementation MOBIMVideoPlayerView


//+ (Class)layerClass{
//    return [AVPlayerLayer class];
//}
//MARK: Get方法和Set方法
- (AVPlayer *)player{
    return self.playerLayer.player;
}
- (void)setPlayer:(AVPlayer *)player{
    self.playerLayer.player = player;
}
- (AVPlayerLayer *)playerLayer{
    return (AVPlayerLayer *)self.playerLayerView.layer;
}
- (CGFloat)rate{
    return self.player.rate;
}
- (void)setRate:(CGFloat)rate{
    self.player.rate = rate;
}


- (UIButton *)moreImageButton
{
    if (!_moreImageButton) {
        _moreImageButton = [[UIButton alloc] init];
        [_moreImageButton setBackgroundImage:[UIImage imageNamed:@"chat_morephotos"] forState:UIControlStateNormal];
    }
    return _moreImageButton;
}


- (MOBIMVideoPlayerView *)initWithUrl:(NSURL*)url thumbnail:(UIImage*)thumbnail isLocalUrl:(BOOL)isLocalUrl
{
    if (self = [super init]) {
        
        [self loadUI];
        _thumbnailImage = thumbnail;
        _isLocalUrl = isLocalUrl;
        if (isLocalUrl) {
            _hasFinishedVideo = YES;
        }
        
        _url = url;
        if (!_url) {
            MOBIMLog(@"url 不能为空");
        }
        
        if (_hasFinishedVideo == YES) {
            [self assetWithURL:url];
        }
        [self loadData];
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect {
    [self loadUI];
}

- (void)loadUI
{
    [self addGestureEvent];
    
    
    if (![self.playerLayerView superview]) {
        [self addSubview:self.playerLayerView];
    }

    if (![self.videoPlayerControl superview]) {
        [self addSubview:self.videoPlayerControl];

    }
    
    if (![self.thumbnailImageView superview]) {
        [self addSubview:self.thumbnailImageView];
    }
    
    
    if (![self.activityView superview]) {
        [self addSubview:self.activityView];
    }
    
    if (![self.backButton superview]) {
        [self addSubview:self.backButton];

    }

    if (![self.moreImageButton superview]) {
        [self addSubview:self.moreImageButton];
    }
    
    self.thumbnailImageView.image = self.thumbnailImage;
    
    //布局
    
    MOBIMWEAKSELF
    
    [self.videoPlayerControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(@44);
        make.bottom.mas_equalTo(-MOBIM_TabbarSafeBottomMargin);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15+ (MOBIM_iPhoneX?(MOBIM_StatusBarHeight):0));
        make.leading.mas_equalTo(25);
        make.height.mas_equalTo(30);
    }];
    
    if ([self.thumbnailImageView superview]) {
        [self.thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.leading.mas_equalTo(0);
            make.bottom.mas_equalTo(-MOBIM_TabbarSafeBottomMargin);
            make.top.mas_equalTo(MOBIM_iPhoneX?MOBIM_StatusBarHeight:0);
        }];
    }
    
    if ([self.playerLayerView superview]) {
        [self.playerLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.leading.mas_equalTo(0);
            make.bottom.mas_equalTo(-MOBIM_TabbarSafeBottomMargin);
            make.top.mas_equalTo(MOBIM_iPhoneX?MOBIM_StatusBarHeight:0);
        }];
    }
    
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@80);
        make.center.mas_equalTo(self);
    }];
    
    [self.moreImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.mas_equalTo(-25);
        make.top.mas_equalTo(15+ (MOBIM_iPhoneX?MOBIM_StatusBarHeight:0));
        make.width.height.mas_equalTo(30);
    }];

    

    self.videoPlayerControl.currentTime = @"00:00";
    
    if (_hasFinishedVideo == YES) {
        self.videoPlayerControl.hidden = NO;
        self.thumbnailImageView.hidden = YES;
        self.activityView.hidden = YES;
    }else{
        self.videoPlayerControl.hidden = YES;
        self.thumbnailImageView.hidden = NO;
        self.activityView.hidden = NO;
        if (![self.activityView isAnimating]) {
            [self.activityView startAnimating];
        }
        
    }

    

    
    [self setNeedsLayout];
}

- (void)loadData
{
    if (!_isLocalUrl && _url.absoluteString) {
        
        NSString *destination = [[MOBIMVideoManager sharedManager] receiveVideoPathWithURLString:_url.absoluteString];

        MOBIMWEAKSELF
        [[MOBIMDownloadManager instance] downloadFileWithURLString:_url.absoluteString destination:destination progress:^(NSProgress * _Nonnull progress, MOBIMDownloadResponse * _Nonnull response) {
            
        } success:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull url) {
            
            _hasFinishedVideo = YES;
            
            [weakSelf loadUI];
            [weakSelf assetWithURL:url];
            
        } faillure:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
    }
}

- (void)assetWithURL:(NSURL *)url{
    
    if (!url) {
        return;
    }
    NSDictionary *options = @{ AVURLAssetPreferPreciseDurationAndTimingKey : @YES };
    self.anAsset = [[AVURLAsset alloc]initWithURL:url options:options];
    NSArray *keys = @[@"duration"];
    
    [self.anAsset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        NSError *error = nil;
        AVKeyValueStatus tracksStatus = [self.anAsset statusOfValueForKey:@"duration" error:&error];
        switch (tracksStatus) {
            case AVKeyValueStatusLoaded:
            {
                MOBIMWEAKSELF
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!CMTIME_IS_INDEFINITE(self.anAsset.duration)) {
                        CGFloat second = self.anAsset.duration.value / self.anAsset.duration.timescale;
                        weakSelf.videoPlayerControl.totalTime = [self convertTime:second];
                        weakSelf.videoPlayerControl.minValue = 0;
                        weakSelf.videoPlayerControl.maxValue = second;
                        
                        [weakSelf.videoPlayerControl startPlayVideo];
                    }
                });
            }
                break;
            case AVKeyValueStatusFailed:
            {
                //MOBIMLog(@"AVKeyValueStatusFailed失败,请检查网络,或查看plist中是否添加App Transport Security Settings");
            }
                break;
            case AVKeyValueStatusCancelled:
            {
                MOBIMLog(@"AVKeyValueStatusCancelled取消");
            }
                break;
            case AVKeyValueStatusUnknown:
            {
                MOBIMLog(@"AVKeyValueStatusUnknown未知");
            }
                break;
            case AVKeyValueStatusLoading:
            {
                MOBIMLog(@"AVKeyValueStatusLoading正在加载");
            }
                break;
        }
    }];
    [self setupPlayerWithAsset:self.anAsset];
    
}

- (void)setupPlayerWithAsset:(AVURLAsset *)asset{
    self.item = [[AVPlayerItem alloc]initWithAsset:asset];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.item];
    [self.playerLayer displayIfNeeded];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self addPeriodicTimeObserver];
    //添加KVO
    [self addKVO];
    //添加消息中心
    [self addNotificationCenter];
}


//添加点击事件
- (void)addGestureEvent{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

//屏幕单击事件
- (void)handleTapAction:(UITapGestureRecognizer *)gesture{
    [self setSubViewsIsHide:NO];
    count = 0;
}


//FIXME: Tracking time,跟踪时间的改变
- (void)addPeriodicTimeObserver{
    __weak typeof(self) weakSelf = self;
    playbackTimerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.f, 1.f) queue:NULL usingBlock:^(CMTime time) {
        weakSelf.videoPlayerControl.value = weakSelf.item.currentTime.value/weakSelf.item.currentTime.timescale;
        if (!CMTIME_IS_INDEFINITE(self.anAsset.duration)) {
            weakSelf.videoPlayerControl.currentTime = [weakSelf convertTime:weakSelf.videoPlayerControl.value];
        }
        if (count >= 5) {
            [weakSelf setSubViewsIsHide:YES];
        }else{
            [weakSelf setSubViewsIsHide:NO];
        }
        count += 1;
    }];
}
//TODO: KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus itemStatus = [[change objectForKey:NSKeyValueChangeNewKey]integerValue];
        
        switch (itemStatus) {
            case AVPlayerItemStatusUnknown:
            {
                _status = MOBIMVideoPlayerStatusUnknown;
                MOBIMLog(@"MOBIMVideoPlayerStatusUnknown");
            }
                break;
            case AVPlayerItemStatusReadyToPlay:
            {
                _status = MOBIMVideoPlayerStatusReadyToPlay;
                MOBIMLog(@"MOBIMVideoPlayerStatusReadyToPlay");
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                _status = MOBIMVideoPlayerStatusFailed;
                MOBIMLog(@"MOBIMVideoPlayerStatusFailed");
            }
                break;
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {  //监听播放器的下载进度
        NSArray *loadedTimeRanges = [self.item loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
        CMTime duration = self.item.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        //缓存值
        self.videoPlayerControl.bufferValue=timeInterval / totalDuration;
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { //监听播放器在缓冲数据的状态
        _status = MOBIMVideoPlayerStatusBuffering;
        if (!self.activityView.isAnimating) {
            [self.activityView startAnimating];
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        MOBIMLog(@"缓冲达到可播放");
        [self.activityView stopAnimating];
    } else if ([keyPath isEqualToString:@"rate"]){//当rate==0时为暂停,rate==1时为播放,当rate等于负数时为回放
        if ([[change objectForKey:NSKeyValueChangeNewKey]integerValue]==0) {
            _isPlaying=false;
            _status = MOBIMVideoPlayerStatusPlaying;
        }else{
            _isPlaying=true;
            _status = MOBIMVideoPlayerStatusStopped;
        }
    }
    
}
//添加KVO
- (void)addKVO{
    //监听状态属性
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听网络加载情况属性
    [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //监听播放的区域缓存是否为空
    [self.item addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    //缓存可以播放的时候调用
    [self.item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    //监听暂停或者播放中
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
}
//MARK:添加消息中心
- (void)addNotificationCenter{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SBPlayerItemDidPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}
//MARK: NotificationCenter
- (void)SBPlayerItemDidPlayToEndTimeNotification:(NSNotification *)notification{
    [self.item seekToTime:kCMTimeZero];
    [self setSubViewsIsHide:NO];
    count = 0;
    [self pause];
    [self.videoPlayerControl.playPauseButton setSelected:NO];
    
}

- (void)willResignActive:(NSNotification *)notification{
    if (_isPlaying) {
        [self setSubViewsIsHide:NO];
        count = 0;
        [self pause];
        [self.videoPlayerControl.playPauseButton setSelected:NO];
    }
}

//控制相关试图
- (MOBIMVideoPlayerControl *)videoPlayerControl{
    if (!_videoPlayerControl)
    {
        _videoPlayerControl = [[MOBIMVideoPlayerControl alloc]init];
        _videoPlayerControl.delegate = self;
        _videoPlayerControl.backgroundColor = [UIColor clearColor];
//        [_videoPlayerControl.tapGesture requireGestureRecognizerToFail:self.pauseOrPlayView.imageBtn.gestureRecognizers.firstObject];
    }
    return _videoPlayerControl;
}


- (UIButton *)backButton
{
    if (!_backButton)
    {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"video_close"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(onCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButton;
}

- (void)onCancelAction:(UIButton *)sender {
    [self stop];
    
    [self removeFromSuperview];
}

//UIActivityIndicatorView
- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.hidesWhenStopped = YES;
    }
    return _activityView;
}

- (UIImageView *)thumbnailImageView{
    if (!_thumbnailImageView) {
        _thumbnailImageView = [[UIImageView alloc] init];
        _thumbnailImageView.userInteractionEnabled = YES;
    }
    return _thumbnailImageView;
}

- (UIView *)playerLayerView{
    if (!_playerLayerView) {
        _playerLayerView = [[MOBIMPlayerLayerView alloc] init];
        _playerLayerView.userInteractionEnabled = YES;
    }
    return _playerLayerView;
}


//将数值转换成时间
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}


//设置子视图是否隐藏
- (void)setSubViewsIsHide:(BOOL)isHide{
    self.videoPlayerControl.hidden = isHide;
    self.backButton.hidden = isHide;
}

#pragma mark - control 控制点击
- (void)videoPlayerControl:(MOBIMVideoPlayerControl*)playerControl playStateChanged:(BOOL)isPlay
{
    count = 0;
    if (isPlay) {
        [self play];
    }else{
        [self pause];
    }
}

- (void)videoPlayerControl:(MOBIMVideoPlayerControl*)playerControl pointSliderLocationWithCurrentValue:(CGFloat)value
{
    
    count = 0;
    CMTime pointTime = CMTimeMake(value * self.item.currentTime.timescale, self.item.currentTime.timescale);
    [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)videoPlayerControl:(MOBIMVideoPlayerControl*)playerControl draggedPositionWithSlider:(UISlider*)slider
{
    count = 0;
    CMTime pointTime = CMTimeMake(playerControl.value * self.item.currentTime.timescale, self.item.currentTime.timescale);
    [self.item seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark 操作
- (void)play{
    if (self.player) {
        [self.player play];
    }
}

- (void)stop{
    [self.item removeObserver:self forKeyPath:@"status"];
    [self.player removeTimeObserver:playbackTimerObserver];
    [self.item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.item removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.player removeObserver:self forKeyPath:@"rate"];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    if (self.player) {
        [self pause];
        self.anAsset = nil;
        self.item = nil;
        self.videoPlayerControl.value = 0;
        self.videoPlayerControl.currentTime = @"00:00";
        self.videoPlayerControl.totalTime = @"00:00";
        self.player = nil;
        self.activityView = nil;
        [self removeFromSuperview];
    }
    
    
}

- (void)pause{
    if (self.player) {
        [self.player pause];
    }
}

@end
