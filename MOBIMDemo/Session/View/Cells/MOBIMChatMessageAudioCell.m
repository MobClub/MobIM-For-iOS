//
//  MOBIMChatMessageAudioCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatMessageAudioCell.h"
#import "MOBIMChatMessageFrame.h"
#import "MOBIMAudioManager.h"
#import <UIKit/UIKit.h>
#import "MOBIMGConst.h"

@interface MOBIMChatMessageAudioCell ()
{
    
}
@property (nonatomic, strong) UIButton    *voiceButton;
@property (nonatomic, strong) UILabel     *durationLabel;
@property (nonatomic, strong) UIImageView *audioIcon;
@property (nonatomic, strong) UIView      *redView;

@end

@implementation MOBIMChatMessageAudioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self loadUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadUI];

    }
    return self;
}

- (void)loadUI
{
    [self.contentView addSubview:self.audioIcon];
    [self.contentView addSubview:self.durationLabel];
    [self.contentView addSubview:self.voiceButton];
    [self.contentView addSubview:self.redView];
    
}

- (void)setModelFrame:(MOBIMChatMessageFrame *)modelFrame
{
    [super setModelFrame:modelFrame];
    
    
    if (modelFrame.modelNew) {
        MIMMessage *message = modelFrame.modelNew;
        MIMVoiceMessageBody *body = (MIMVoiceMessageBody*)message.body;

        if (message.direction == MIMMessageDirectionSend) {
            self.audioIcon.image = [UIImage imageNamed:@"right-3"];
            UIImage *image1 = [UIImage imageNamed:@"right-1"];
            UIImage *image2 = [UIImage imageNamed:@"right-2"];
            UIImage *image3 = [UIImage imageNamed:@"right-3"];
            self.audioIcon.animationImages = @[image1, image2, image3];
            
            self.durationLabel.text  = [NSString stringWithFormat:@"%d" , body.duration];

            
        }else{
            self.audioIcon.image = [UIImage imageNamed:@"left-3"];
            UIImage *image1 = [UIImage imageNamed:@"left-1"];
            UIImage *image2 = [UIImage imageNamed:@"left-2"];
            UIImage *image3 = [UIImage imageNamed:@"left-3"];
            self.audioIcon.animationImages = @[image1, image2, image3];
            self.durationLabel.text  = [NSString stringWithFormat:@"%d" , body.duration];

        }
        self.audioIcon.animationDuration = 0.8;
        
        if (body.isListened == YES) {
            self.redView.hidden  = YES;

        }else{
            self.redView.hidden  = NO;
        }
        
        
    }
   
    self.durationLabel.frame = modelFrame.durationLabelF;
    self.audioIcon.frame     = modelFrame.voiceIconF;
    self.voiceButton.frame   = modelFrame.bubbleViewF;
    self.redView.frame       = modelFrame.redViewF;
    
//    self.redView.hidden = NO;
//    self.durationLabel.backgroundColor = [UIColor redColor];
    
}

// 文件路径
- (NSString *)mediaPath:(NSString *)originPath
{
    // 这里文件路径重新给，根据文件名字来拼接
    NSString *name = [[originPath lastPathComponent] stringByDeletingPathExtension];
    return [[MOBIMAudioManager sharedManager] receiveVoicePathWithFileKey:name];
}


#pragma mark - respond Method

- (void)voiceButtonClicked:(UIButton *)voiceBtn
{
//    voiceBtn.selected = !voiceBtn.selected;
//    [self routerEventWithName:GXRouterEventVoiceTapEventName
//                     userInfo:@{MessageKey : self.modelFrame,
//                                VoiceIcon  : self.voiceIcon,
//                                RedView    : self.redView
//                                }];

    if (self.audioClickCompletion)
    {
        self.audioClickCompletion(self.modelFrame, self.audioIcon, self.redView);
    }
}


#pragma mark - Getter

- (UIButton *)voiceButton
{
    if (nil == _voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceButton addTarget:self action:@selector(voiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (UILabel *)durationLabel
{
    if (nil == _durationLabel ) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.textColor = KMOBIMDateColor;
        _durationLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _durationLabel;
}

- (UIImageView *)audioIcon
{
    if (nil == _audioIcon) {
        _audioIcon = [[UIImageView alloc] init];
    }
    return _audioIcon;
}

- (UIView *)redView
{
    if (nil == _redView) {
        _redView = [[UIView alloc] init];
        _redView.layer.masksToBounds = YES;
        _redView.layer.cornerRadius = 4;
        _redView.backgroundColor = MOBIMRGB(0xFF513A);
    }
    return _redView;
}


@end
