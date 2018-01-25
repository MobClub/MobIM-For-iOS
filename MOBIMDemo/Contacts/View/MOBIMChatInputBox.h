//
//  MOBIMChatInputBox.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOBIMGConst.h"
#import "MOBIMTextView.h"






@class MOBIMChatInputBox;
@protocol MOBIMChatInputBoxDelegate<NSObject>

@optional
//发送文字
- (void)chatInputBox:(MOBIMChatInputBox *)chatInputBox sendTextMessage:(NSString*)message;

- (void)chatInputBox:(MOBIMChatInputBox *)chatInputBox sendAudioMessage:(NSString*)audioPath;

- (void)chatInputBox:(MOBIMChatInputBox *)chatInputBox didMoreViewSelectItem:(MOBIMChatInputBoxMoreViewItemType)itemType;

- (void)chatInputBox:(MOBIMChatInputBox *)chatInputBox didChangeChatBoxHeight:(CGFloat)height;

- (void)chatInputBox:(MOBIMChatInputBox *)chatBox changeStatusFrom:(MOBIMChatInputBoxStatus)fromStatus to:(MOBIMChatInputBoxStatus)toStatus;

- (void)chatInputBox:(MOBIMChatInputBox *)chatBox textViewShouldBeginEditing:(UITextView *)textView;

//开始录音
- (void)didStartRecordingVoiceAction;
//手指向上滑动取消录音
- (void)didCancelRecordingVoiceAction;
//松开手指完成录音
- (void)didFinishRecoingVoiceAction;
//当手指离开按钮的范围内时，主要为了通知外部的HUD
- (void)didDragOutsideAction;
//当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
- (void)didDragInsideAction;

//时间太短了
- (void) audioDateTooShort;

@end




@class MOBIMEmotion;
@interface MOBIMChatInputBox : UIView


@property (nonatomic, strong) MOBIMTextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;


//音频与文本切换按钮
@property (strong, nonatomic) UIButton *voiceButton;
@property (strong, nonatomic) UIButton *voicePressBtn;

@property (nonatomic, strong) UIButton *faceButton;

@property (strong, nonatomic) UIButton *plusBtn;

@property (nonatomic, strong) UIView *backGroundView;


@property (assign, nonatomic) MOBIMChatInputBoxStatus chatInputBoxStatus;


@property (weak, nonatomic) id<MOBIMChatInputBoxDelegate> delegate;

@property (nonatomic, assign) BOOL myResignFirstResponder;


//- (void)emotionDidSelected:(MOBIMEmotion *)emotion isDelete:(BOOL)isDelete;


@end

