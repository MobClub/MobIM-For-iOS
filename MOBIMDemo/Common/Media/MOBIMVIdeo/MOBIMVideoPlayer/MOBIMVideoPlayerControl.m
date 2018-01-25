//
//  MOBIMVideoPlayerControl.m
//  MOBIMVideoPlayerView
//
//  Created by hower on 2017/10/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMVideoPlayerControl.h"
#import "Masonry.h"
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

static NSInteger padding = 15;

@interface MOBIMVideoPlayerControl ()
//当前时间
@property (nonatomic, strong) UILabel *timeLabel;
//总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
//进度条
@property (nonatomic, strong) UISlider *slider;
//缓存进度条
//@property (nonatomic, strong) UISlider *bufferSlier;
@end


@implementation MOBIMVideoPlayerControl
//懒加载
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return _timeLabel;
}
- (UILabel *)totalTimeLabel{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.textAlignment = NSTextAlignmentLeft;
        _totalTimeLabel.font = [UIFont systemFontOfSize:12];
        _totalTimeLabel.textColor = [UIColor whiteColor];
    }
    return _totalTimeLabel;
}
- (UISlider *)slider{
    if (!_slider) {
        _slider = [[UISlider alloc]init];
        [_slider setThumbImage:[UIImage imageNamed:@"knob"] forState:UIControlStateNormal];
        _slider.continuous = YES;
        self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [_slider addTarget:self action:@selector(handleSliderPosition:) forControlEvents:UIControlEventValueChanged];
        [_slider addGestureRecognizer:self.tapGesture];
        _slider.maximumTrackTintColor = [UIColor grayColor];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
    }
    return _slider;
}



- (UIButton *)playPauseButton{
    if (!_playPauseButton) {
        _playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playPauseButton.contentMode = UIViewContentModeScaleToFill;
        [_playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [_playPauseButton addTarget:self action:@selector(hanlePlayPauseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playPauseButton;
}


- (void)drawRect:(CGRect)rect {
    [self setupUI];
    
}
- (void)setupUI{
    [self addSubview:self.timeLabel];
    [self addSubview:self.slider];
    [self addSubview:self.totalTimeLabel];
    [self addSubview:self.playPauseButton];

    //添加约束
    [self addConstraintsForSubviews];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)deviceOrientationDidChange{
    //添加约束
    //[self addConstraintsForSubviews];
}
- (void)addConstraintsForSubviews{
    
    
    MOBIMWEAKSELF
    [self.playPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf).offset(-padding);
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(@30);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.playPauseButton.mas_right).offset(10);
        
        make.bottom.mas_equalTo(weakSelf).offset(-padding);
        make.right.mas_equalTo(weakSelf.slider).offset(-padding).priorityLow();
        make.width.mas_equalTo(@50);
        make.centerY.mas_equalTo(@[weakSelf.timeLabel, weakSelf.slider, weakSelf.totalTimeLabel, weakSelf.playPauseButton]);
    }];
    
    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.timeLabel.mas_right).offset(padding);
        make.right.mas_equalTo(weakSelf.totalTimeLabel.mas_left).offset(-padding);
        
        /*
        if (kScreenWidth<kScreenHeight) {
            //后面的几个常数分别是各个控件的间隔和控件的宽度  添加自定义控件需在此修改参数
            make.width.mas_equalTo(kScreenWidth - padding - 50 - 50 - 30 - padding - padding);
        }
         */
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.slider.mas_right).offset(padding);
        make.right.mas_equalTo(weakSelf).offset(-padding);
        make.bottom.mas_equalTo(weakSelf).offset(-padding);
        make.width.mas_equalTo(@50).priorityHigh();
    }];

    
    [self layoutIfNeeded];
}
- (void)hanlePlayPauseBtn:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(videoPlayerControl:playStateChanged:)]) {
        
        button.selected = !button.selected;
        [self.delegate videoPlayerControl:self playStateChanged:button.selected];
    }
}
- (void)handleSliderPosition:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(videoPlayerControl:draggedPositionWithSlider:)]) {
        [self.delegate videoPlayerControl:self draggedPositionWithSlider:self.slider];
    }
}
- (void)handleTap:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self.slider];
    CGFloat pointX = point.x;
    CGFloat sliderWidth = self.slider.frame.size.width;
    CGFloat currentValue = pointX/sliderWidth * self.slider.maximumValue;
    if ([self.delegate respondsToSelector:@selector(videoPlayerControl:pointSliderLocationWithCurrentValue:)]) {
        [self.delegate videoPlayerControl:self pointSliderLocationWithCurrentValue:currentValue];
    }
}

//setter 和 getter方法
- (void)setValue:(CGFloat)value{
    self.slider.value = value;
}
- (CGFloat)value{
    return self.slider.value;
}
- (void)setMinValue:(CGFloat)minValue{
    self.slider.minimumValue = minValue;
}
- (CGFloat)minValue{
    return self.slider.minimumValue;
}
- (void)setMaxValue:(CGFloat)maxValue{
    self.slider.maximumValue = maxValue;
}
- (CGFloat)maxValue{
    return self.slider.maximumValue;
}
- (void)setCurrentTime:(NSString *)currentTime{
    self.timeLabel.text = currentTime;
}
- (NSString *)currentTime{
    return self.timeLabel.text;
}
- (void)setTotalTime:(NSString *)totalTime{
    self.totalTimeLabel.text = totalTime;
}
- (NSString *)totalTime{
    return self.totalTimeLabel.text;
}

- (void)startPlayVideo
{
    [self hanlePlayPauseBtn:self.playPauseButton];
}

@end
