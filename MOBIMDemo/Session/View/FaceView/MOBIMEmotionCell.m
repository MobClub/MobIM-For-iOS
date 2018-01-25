//
//  MOBIMEmotionCell.m
//  YHExpressionKeyBoard
//
//  Created by hower on 2017/10/17.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMEmotionCell.h"
#import "UIView+MOBIMExtention.h"
#import "NSString+MOBIMExtension.h"
#import "MOBIMEmotion.h"

@implementation MOBIMEmotionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _emotionButton = [[UIButton alloc] initWithFrame:frame];
    _emotionButton.size = CGSizeMake(28, 28);
    _emotionButton.contentMode = UIViewContentModeScaleAspectFit;
    _emotionButton.titleLabel.font = [UIFont systemFontOfSize:26.0];
    _emotionButton.userInteractionEnabled = NO;
    [self.contentView addSubview:_emotionButton];
    return self;
}


- (void)setEmotion:(MOBIMEmotion *)emotion
{
    _emotion = emotion;
    [self updateContent];

}


- (void)setIsDelete:(BOOL)isDelete {
    if (_isDelete == isDelete) return;
    _isDelete = isDelete;
    [self updateContent];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayout];
}

- (void)updateContent {
    
    if (_isDelete) {
        
        [_emotionButton setBackgroundImage:[UIImage imageNamed:@"emotion_delete"] forState:UIControlStateNormal];
        [_emotionButton setTitle:@"" forState:UIControlStateNormal];

    } else if (_emotion) {
        if (_emotion.code) {
            [_emotionButton setTitle:self.emotion.code.emoji forState:UIControlStateNormal];
            [_emotionButton setBackgroundImage:nil forState:UIControlStateNormal];

        } else if (_emotion.face_name) {
            [_emotionButton setTitle:@"" forState:UIControlStateNormal];
            
            NSString *imagePath = [@"faces.bundle" stringByAppendingPathComponent:self.emotion.face_id];
            UIImage *image = [UIImage imageNamed:imagePath];
            [_emotionButton setBackgroundImage:image forState:UIControlStateNormal];
        }
    } else{
        [_emotionButton setBackgroundImage:nil forState:UIControlStateNormal];
        [_emotionButton setTitle:@"" forState:UIControlStateNormal];

    }
}

- (void)updateLayout {
    _emotionButton.center = CGPointMake(self.width / 2, self.height / 2);
}

- (BOOL)noEmotionImage
{
    return !(_emotion.code.length>0 || _emotion.face_id.length>0);
}

@end
