//
//  MOBIMRecordHUD.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMRecordHUD.h"
#import "Masonry.h"
#import "MOBIMGConst.h"
#import "MOBIMAudioManager.h"

@interface MOBIMRecordHUD ()

{
    NSArray *_images;
}
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *startDate;


@end

@implementation MOBIMRecordHUD



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _images                   = @[
                                      [UIImage imageNamed:@"voice_1"],
                                      [UIImage imageNamed:@"voice_2"],
                                      [UIImage imageNamed:@"voice_3"],
                                      [UIImage imageNamed:@"voice_4"],
                                      [UIImage imageNamed:@"voice_5"],
                                      [UIImage imageNamed:@"voice_6"]
                                      ];
        
        [self loadUI];
    }
    return self;
}


- (void)loadUI
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    MOBIMWEAKSELF
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    [self addSubview:_imageView];
    
    if (!_dateLabel)
    {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font=[UIFont systemFontOfSize:36];
        _dateLabel.backgroundColor=[UIColor clearColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = [UIColor whiteColor];
    }
    [self addSubview:_dateLabel];
    
    
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font=[UIFont systemFontOfSize:14];
        _titleLabel.backgroundColor=[UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"手指上滑取消发送";
    }
    [self addSubview:_titleLabel];

    
    _imageView.animationDuration    = 0.5;
    _imageView.animationRepeatCount = -1;
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(30);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.mas_offset(64);
        make.height.mas_offset(56);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(46);
        make.height.mas_offset(36);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.mas_width);
        make.height.mas_offset(22);
        make.bottom.mas_offset(-15);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    
}

- (NSTimer *)timer
{
    if (!_timer)
    {
        _timer =[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)progressChange
{
    
    NSDate *curDate = [NSDate date];
    NSTimeInterval timeInterval = [curDate timeIntervalSinceDate:_startDate];
    
    MOBIMLog(@"-----%f",timeInterval);
    if (timeInterval >= KMOBIMMaxAudioSeconds)
    {
        //停止录音，开始发送
        if (self.maxTimeBlock) {
            self.maxTimeBlock(self);
        }
        
        [self voiceDidSend];
        return;
    }
    else if ((timeInterval + KMOBIMAudioCountdownSeconds) > KMOBIMMaxAudioSeconds)
    {
        self.dateLabel.hidden = NO;
        self.dateLabel.text = [NSString stringWithFormat:@"%.0fS",KMOBIMMaxAudioSeconds - timeInterval];
        self.imageView.hidden = YES;
        _titleLabel.text = @"剩余时间倒计时";
    }else{
        self.dateLabel.hidden = YES;
        self.dateLabel.text = [NSString stringWithFormat:@"%.0fS",KMOBIMMaxAudioSeconds - timeInterval];
        self.imageView.hidden = NO;
        _titleLabel.text = @"手指上滑取消发送";
    }
    
    
    AVAudioRecorder *recorder = [[MOBIMAudioManager sharedManager] recorder] ;
    [recorder updateMeters];
    float power= [recorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0,声音越大power绝对值越小
    CGFloat progress = (1.0/160)*(power + 160);
    self.progress = progress;
    

}



- (void)setProgress:(CGFloat)progress
{
    _progress         = MIN(MAX(progress, 0.f),1.f);
    [self updateImages];
}


- (void)updateImages
{
    if (_progress == 0)
    {
        _imageView.animationImages = nil;
        [_imageView stopAnimating];
        return;
    }
    if (_progress >= 0.8 )
    {
        _imageView.animationImages = @[_images[3],_images[4],_images[5],_images[4],_images[3]];
    } else {
        _imageView.animationImages = @[_images[0],_images[1],_images[2],_images[1]];
    }
    [_imageView startAnimating];
}

- (void) voiceRecordSoShort
{
    [self timerInvalue];
    self.imageView.animationImages = nil;
    self.imageView.image = [UIImage imageNamed:@"voice_1"];
    _titleLabel.text = @"时间太短";

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}

- (void) voiceWillDragout:(BOOL)inside
{
    if (inside)
    {
        [_timer setFireDate:[NSDate distantPast]];
        _imageView.image  = [UIImage imageNamed:@"voice_1"];
        
        _titleLabel.text = @"手指上滑取消发送";

    } else {
        [_timer setFireDate:[NSDate distantFuture]];
        self.imageView.animationImages  = nil;
        self.imageView.image = [UIImage imageNamed:@"voice_1"];
        
        _titleLabel.text = @"松开即可结束发送";

    }
}

- (void) voiceDidCancelRecording
{
    [self timerInvalue];
    self.hidden = YES;
}

- (void) voiceDidStartRecording
{
    _startDate = [NSDate date];
    
    [self timerInvalue];
    
    self.hidden = NO;
    
    [self timer];
}


- (void) voiceDidSend
{
    [self timerInvalue];
    self.hidden = YES;
}

- (void)timerInvalue
{
    if (_timer && [_timer isKindOfClass:[NSTimer class]] && [_timer isValid])
    {
        [_timer invalidate];
    }
    _timer  = nil;
}


@end
