//
//  MOBIMEmotionButton.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMEmotionButton.h"
#import "NSString+MOBIMExtension.h"

@implementation MOBIMEmotionButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}


- (void)setup
{
    self.titleLabel.font             = [UIFont systemFontOfSize:32.0];
    self.adjustsImageWhenHighlighted = NO;
}

- (void)setEmotion:(MOBIMEmotion *)emotion
{
    _emotion               = emotion;
    if (emotion.code)
    {
        [self setTitle:self.emotion.code.emoji forState:UIControlStateNormal];
    } else if (emotion.face_name) {
        [self setImage:[UIImage imageNamed:self.emotion.face_name] forState:UIControlStateNormal];
    }
}

@end
