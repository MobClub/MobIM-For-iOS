//
//  MOBIMMagnifierView.m
//  YHExpressionKeyBoard
//
//  Created by hower on 2017/10/18.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMMagnifierView.h"
#import "UIView+MOBIMExtention.h"
#import "NSString+MOBIMExtension.h"
#import "MOBIMEmotion.h"

@interface MOBIMMagnifierView()

//@property (nonatomic, strong) UIImageView *magnifierImageView;
@property (nonatomic, strong) UIButton *emotionButton;

@end

@implementation MOBIMMagnifierView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}


- (void)setEmotion:(MOBIMEmotion *)emotion
{
    _emotion = emotion;
    [self updateContent];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_emotionButton == nil) {
        _emotionButton = [UIButton new];
        [self addSubview:_emotionButton];
    }
    

    _emotionButton.size = CGSizeMake(40, 40);
    _emotionButton.centerX = self.width / 2;
}

- (void)updateContent {
    
    if (_emotion.code) {
        [self.emotionButton setTitle:self.emotion.code.emoji forState:UIControlStateNormal];
    } else if (_emotion.face_name) {
        [self.emotionButton setImage:[UIImage imageNamed:self.emotion.face_id] forState:UIControlStateNormal];
    }
    
    _emotionButton.top = 20;
    
    [_emotionButton.layer removeAllAnimations];
    NSTimeInterval dur = 0.1;
    [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _emotionButton.top = 3;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _emotionButton.top = 6;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _emotionButton.top = 5;
            } completion:^(BOOL finished) {
            }];
        }];
    }];
    
}

@end
