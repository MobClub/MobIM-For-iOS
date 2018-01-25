//
//  MOBIMChatInputBox.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatInputBox.h"
#import "UIColor+MOBIMExtentions.h"
#import "Masonry.h"
#import "MOBIMGConst.h"
#import "MOBIMChatInputBoxMoreView.h"
#import "MOBIMEmoticonsView.h"
#import "MOBIMFileManager.h"
#import "MOBIMAudioManager.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMEmotion.h"
#import "NSString+MOBIMExtension.h"
#import "UIColor+MOBIMExtentions.h"
#import "MOBIMGConfigManager.h"
#import "MOBIMFaceManager.h"

@interface MOBIMChatInputBox ()<UITextViewDelegate,UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat currentTextViewH;
@property (assign, nonatomic) BOOL isTextMaxH; //当文字大于限定高度之后的状态

@property (assign, nonatomic) BOOL isRecording;
@property (assign, nonatomic) BOOL isCancleRecord;




@property (assign, nonatomic) MOBIMChatInputBoxStatus lastChatInputBoxStatus;

@end


@implementation MOBIMChatInputBox

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        
//        self.backgroundColor=[UIColor redColor];
        
        [self loadData];
        [self loadUI];
        
    }
    
    return self;
}

- (void)loadData
{

}

- (void)loadUI
{
    
    self.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:KMOBIMEmotionDidSelectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnClicked) name:KMOBIMEmotionDidDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessage) name:KMOBIMEmotionDidSendNotification object:nil];
    
    self.chatInputBoxStatus = MOBIMChatInputBoxStatusTextViewDefault;
    self.lastChatInputBoxStatus=self.chatInputBoxStatus;
    
    
    [self addSubview:self.backGroundView];
    [self.backGroundView addSubview:self.plusBtn];


//    self.backgroundColor=[UIColor redColor];
    [self.backGroundView addSubview:self.voiceButton];
    [self.backGroundView addSubview:self.voicePressBtn];
    [self.backGroundView addSubview:self.faceButton];
    [self.backGroundView addSubview:self.textView];
    [self.backGroundView addSubview:self.placeholderLabel];

    
    MOBIMWEAKSELF
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.centerY.equalTo(weakSelf.backGroundView.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.centerY.equalTo(weakSelf.textView.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.plusBtn.mas_left).offset(-16);
        make.centerY.equalTo(weakSelf.textView.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    
    
//    self.textView.backgroundColor=[UIColor redColor];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.voiceButton.mas_right).offset(10);
        make.top.mas_equalTo(6);
        make.bottom.equalTo(weakSelf.backGroundView.mas_bottom).offset(-6);
        make.right.equalTo(weakSelf.faceButton.mas_left).offset(-15);
    }];
    
    [self.voicePressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.textView.mas_left).offset(0);
        make.top.equalTo(weakSelf.textView.mas_top).offset(0);
        make.right.equalTo(weakSelf.textView.mas_right);
        make.bottom.equalTo(weakSelf.textView.mas_bottom);
    }];
    
//    self.placeholderLabel.backgroundColor =[UIColor redColor];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.equalTo(weakSelf.textView.mas_left).offset(8);
        make.height.mas_equalTo(39);
    }];
    
    


}

- (UIButton*)voiceButton
{
    if (_voiceButton == nil)
    {
        _voiceButton = [[UIButton alloc] init];
//        _voiceButton.titleLabel.textColor = RGB(0x666666);
        _voiceButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voiceButton setImage:[UIImage imageNamed:@"audio_btn"] forState:UIControlStateNormal];
//        [_voiceButton setImage:[UIImage imageNamed:@"input_word"] forState:UIControlStateSelected];
        [_voiceButton addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _voiceButton;
}



- (UIButton *)voicePressBtn {
    if (_voicePressBtn == nil)
    {
        _voicePressBtn = [[UIButton alloc]init];
        [_voicePressBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [_voicePressBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        _voicePressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _voicePressBtn.layer.borderColor = [UIColor colorWithHex:0x00C59C].CGColor;
        _voicePressBtn.layer.borderWidth = 0.1;
        _voicePressBtn.layer.cornerRadius = 20;
        [_voicePressBtn setTitle:@"正在说话" forState:UIControlStateHighlighted];
        //[_voicePressBtn setBackgroundImage:[UIImage imageNamed:@"im_input_voice_normal"] forState:UIControlStateNormal];
        _voicePressBtn.hidden = YES;
        _voicePressBtn.backgroundColor = [UIColor colorWithHex:0x00C59C];
        
        [_voicePressBtn addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_voicePressBtn addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_voicePressBtn addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_voicePressBtn addTarget:self action:@selector(holdDownDragOutside) forControlEvents:UIControlEventTouchDragOutside];
        [_voicePressBtn addTarget:self action:@selector(holdDownDragInside) forControlEvents:UIControlEventTouchDragInside];
    }
    return _voicePressBtn;
}


- (UITextView *)textView{
    if (!_textView) {
        _textView = [[MOBIMTextView alloc] init];
        [_textView setFont:[UIFont systemFontOfSize:16.0f]];
//        [_textView.layer setMasksToBounds:YES];
//        [_textView.layer setCornerRadius:4.0f];
//        [_textView.layer setBorderWidth:0.5f];
        [_textView.layer setBorderColor:MOBIMColor(165, 165, 165).CGColor];
        [_textView setScrollsToTop:NO];
        [_textView setReturnKeyType:UIReturnKeySend];
        [_textView setDelegate:self];
    }
    return _textView;
}

- (UIButton*)faceButton
{
    if (_faceButton == nil)
    {
        _faceButton = [[UIButton alloc] init];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_faceButton addTarget:self action:@selector(faceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}

- (UIButton *)plusBtn
{
    if (_plusBtn == nil) {
        _plusBtn = [[UIButton alloc]init];
        [_plusBtn setImage:[UIImage imageNamed:@"keyboard_plus"] forState:UIControlStateNormal];
        [_plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusBtn;
}

- (UIView *)backGroundView
{
    if (!_backGroundView)
    {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MOIMDevice_Width, 49)];
        [self addSubview:_backGroundView];
        _backGroundView.backgroundColor = [UIColor whiteColor];
//        _backGroundView.backgroundColor = [UIColor colorWithHex:0xf6f6f6];
    }
    return _backGroundView;
}

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel)
    {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.text = @"请输入消息...";
        _placeholderLabel.textColor = MOBIMColor(183, 183, 183);
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
    }
    return _placeholderLabel;
}


#pragma --mark 点击事件
- (void)voiceBtnClick:(UIButton *)sender
{
    MOBIMChatInputBoxStatus lastStatus = self.chatInputBoxStatus;

    if (lastStatus == MOBIMChatInputBoxStatusAudio)
    {
        
        self.chatInputBoxStatus = MOBIMChatInputBoxStatusTextViewShow;
        self.voicePressBtn.hidden = YES;
        self.textView.hidden = NO;
        [self setPlaceholderLabelHidden:self.textView.hidden];
        
        [self.textView becomeFirstResponder];
        [self.voiceButton setImage:[UIImage imageNamed:@"audio_btn"] forState:UIControlStateNormal];
    }
    else
    {
        [self.textView resignFirstResponder];
        self.voicePressBtn.hidden = NO;
        self.textView.hidden = YES;
        [self setPlaceholderLabelHidden:self.textView.hidden];
        
        [self.voiceButton setImage:[UIImage imageNamed:@"text_btn"] forState:UIControlStateNormal];
        self.chatInputBoxStatus = MOBIMChatInputBoxStatusAudio;

    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(chatInputBox:changeStatusFrom:to:)])
    {
        [_delegate chatInputBox:self changeStatusFrom:lastStatus to:self.chatInputBoxStatus];
    }
}


- (void)setPlaceholderLabelHidden:(BOOL)hidden
{
    if (hidden)
    {
        self.placeholderLabel.hidden = YES;
    }
    else
    {
        self.placeholderLabel.hidden =  (self.textView.text.length > 0);
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}



- (void)plusBtnClick {
    MOBIMChatInputBoxStatus lastStatus = self.chatInputBoxStatus;
    
    if (lastStatus == MOBIMChatInputBoxStatusMoreView)
    {
        
        self.chatInputBoxStatus = MOBIMChatInputBoxStatusTextViewShow;

        [self.textView becomeFirstResponder];

    }
    else
    {
        //self.chatInputBoxStatus = MOBIMChatInputBoxStatusFace;
        self.textView.hidden = NO;
        [self setPlaceholderLabelHidden:self.textView.hidden];

        self.voicePressBtn.hidden = YES;
        [self.voiceButton setImage:[UIImage imageNamed:@"audio_btn"] forState:UIControlStateNormal];

        self.chatInputBoxStatus = MOBIMChatInputBoxStatusMoreView;

        if (lastStatus == MOBIMChatInputBoxStatusTextViewShow)
        {

            [self.textView resignFirstResponder];
            
        }
        else if (lastStatus == MOBIMChatInputBoxStatusAudio)
        {

            
            self.voicePressBtn.hidden = YES;
            self.textView.hidden = NO;
            [self setPlaceholderLabelHidden:self.textView.hidden];

            
            [self.voiceButton setImage:[UIImage imageNamed:@"audio_btn"] forState:UIControlStateNormal];

        }
        else if (lastStatus == MOBIMChatInputBoxStatusFace)
        {
            [self.textView resignFirstResponder];

        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(chatInputBox:changeStatusFrom:to:)])
        {
            [_delegate chatInputBox:self changeStatusFrom:lastStatus to:self.chatInputBoxStatus];
        }
    }
}

- (void)faceButtonClick:(UIButton*)button
{
    MOBIMChatInputBoxStatus lastStatus = self.chatInputBoxStatus;

    if (self.chatInputBoxStatus== MOBIMChatInputBoxStatusFace)
    {
        
        self.chatInputBoxStatus = MOBIMChatInputBoxStatusTextViewShow;
        
        [self.textView becomeFirstResponder];
        [self.faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];

    }
    else
    {
        //self.chatInputBoxStatus = MOBIMChatInputBoxStatusFace;
        //self.textView.hidden = NO;
        //self.voiceButton.hidden = YES;
        
        
        self.textView.hidden = NO;
        [self setPlaceholderLabelHidden:self.textView.hidden];

        self.voicePressBtn.hidden = YES;
        
        [self.voiceButton setImage:[UIImage imageNamed:@"audio_btn"] forState:UIControlStateNormal];
        [self.faceButton setImage:[UIImage imageNamed:@"text_btn"] forState:UIControlStateNormal];
        _chatInputBoxStatus = MOBIMChatInputBoxStatusFace;

        
        if (lastStatus == MOBIMChatInputBoxStatusTextViewShow)
        {
            self.myResignFirstResponder = YES;
            [self.textView resignFirstResponder];
            _chatInputBoxStatus = MOBIMChatInputBoxStatusFace;

            
        }
        else if (lastStatus == MOBIMChatInputBoxStatusMoreView)
        {

        }
        else if (lastStatus == MOBIMChatInputBoxStatusAudio)
        {
            self.textView.hidden = NO;
            [self setPlaceholderLabelHidden:self.textView.hidden];

            self.voicePressBtn.hidden = YES;
            _chatInputBoxStatus = MOBIMChatInputBoxStatusFace;
            
            
        }
        else if (lastStatus == MOBIMChatInputBoxStatusTextViewDefault)
        {

//            self.lastChatInputBoxStatus=MOBIMChatInputBoxStatusTextViewDefault;
//            self.chatInputBoxStatus = MOBIMChatInputBoxStatusFace;

        }
        
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(chatInputBox:changeStatusFrom:to:)])
    {
        [_delegate chatInputBox:self changeStatusFrom:lastStatus to:self.chatInputBoxStatus];
    }
}


- (void)hidePicBtn {
//    self.picBtn.hidden = NO;
//    self.photoBtn.hidden =NO;
}






#pragma mark - 键盘各种状态
#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{

    
    self.placeholderLabel.text =  textView.text.length == 0 ? @"请输入消息...":@"";
    
    if (textView.text.length > 5000)
    { // 限制5000字内
        textView.text = [textView.text substringToIndex:5000];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        
        if (self.textView.text.length > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatInputBox:sendTextMessage:)])
            {
                [self.delegate chatInputBox:self sendTextMessage:self.textView.text];
            }
        }
        
        self.textView.text = @"";
        self.placeholderLabel.text = @"请输入消息...";
        
        /*
        self.frame = CGRectMake(0, MOIMDevice_Height-self.inputH-self.keyboardHeight, MOIMDevice_Width, self.inputH+self.keyboardHeight);
        self.backGroundView.frame = CGRectMake(0, 0, MOIMDevice_Width, self.inputH);
         */


        return NO;
    }
    else if ([text isEqualToString:@""])
    {
        //删除问题
        [self deleteBtnClicked];
        return NO;
    }
    return YES;
}


- (void) textViewDidBeginEditing:(UITextView *)textView
{
    self.chatInputBoxStatus = MOBIMChatInputBoxStatusTextViewShow;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatInputBox:textViewShouldBeginEditing:)])
    {
        [_delegate chatInputBox:self textViewShouldBeginEditing:self.textView];
    }
    return YES;
}

- (NSString*)audioRecordPath
{
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *randName = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    
    NSString *path = [MOBIMFileManager createPathWithChildPath:KMOBIMChatMessageAudioRecordPath];
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",randName,KMOBIMChatMessageAudioType]];
}

#pragma mark - 录音按钮各种点击状态
- (void)holdDownButtonTouchDown {
    
    
    
    if ([self.delegate respondsToSelector:@selector(didStartRecordingVoiceAction)])
    {
        [self.delegate didStartRecordingVoiceAction];
    }

}

- (void)holdDownButtonTouchUpOutside {
    
    if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction)])
    {
        [self.delegate didCancelRecordingVoiceAction];
    }
    

}

- (void)holdDownButtonTouchUpInside {
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(didFinishRecoingVoiceAction)])
    {
        [_delegate didFinishRecoingVoiceAction];
    }

    
}

- (void)holdDownDragOutside {
    if ([self.delegate respondsToSelector:@selector(didDragOutsideAction)])
    {
        [self.delegate didDragOutsideAction];
    }
}

- (void)holdDownDragInside {
    
    if ([self.delegate respondsToSelector:@selector(didDragInsideAction)])
    {
        [self.delegate didDragInsideAction];
    }
}

#pragma mark -MOBIMChatInputBoxMoreViewDelegate
- (void)chatBoxMoreView:(MOBIMChatInputBoxMoreView *)chatInputBoxMoreView didSelectItem:(MOBIMChatInputBoxMoreViewItemType)itemType
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatInputBox:didMoreViewSelectItem:)])
    {
        [_delegate chatInputBox:self didMoreViewSelectItem:itemType];
    }
}



/*
- (void)resetInutBoxDefaultStatus
{
    [self.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.voicePressBtn.hidden = YES;
        self.textView.hidden = NO;
        
        
        self.inputBoxmoreView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, KChatInputBoxMoreViewHeight);
        
        self.faceView.frame=CGRectMake(0,self.frame.size.height , self.frame.size.width, KChatInputBoxFaceViewHeight);
        
        self.frame=CGRectMake(0, MOIMDevice_Height - self.inputH, MOIMDevice_Width, self.inputH);
        
        _chatInputBoxStatus = MOBIMChatInputBoxStatusTextViewDefault;
        
    }];
}
 */

#pragma mark - Public Methods

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    [_plusBtn setImage:[UIImage imageNamed:@"keyboard_plus"] forState:UIControlStateNormal];
    [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
    return [super resignFirstResponder];
    
    

    //return [super resignFirstResponder];
}

- (void)emotionDidSelected:(NSNotification *)notifi
{
    if (notifi && notifi.userInfo && [notifi.userInfo isKindOfClass:[MOBIMEmotion class]])
    {
        MOBIMEmotion *emotion = (MOBIMEmotion*)notifi.userInfo;
        if (emotion.code)
        {
            [self.textView insertText:emotion.code.emoji];
            [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 0)];
        } else if (emotion.face_name)
        {
            [self.textView insertText:emotion.face_name];
        }
    }

}

// 删除
- (void)deleteBtnClicked
{
    //如果是表情的话就需要，删除
    NSRange range = [MOBIMFaceManager endCustomEmotionRange:self.textView.text];
    if (range.location != NSNotFound)
    {
        self.textView.text = [self.textView.text substringToIndex:range.location];
    }
    else
    {
        [self.textView deleteBackward];
    }
}

- (void)sendMessage
{
    if (self.textView.text.length > 0)
    {     // send Text
        if (_delegate && [_delegate respondsToSelector:@selector(chatInputBox:sendTextMessage:)])
        {
            [_delegate chatInputBox:self sendTextMessage:self.textView.text];
        }
    }
    [self.textView setText:@""];
    self.placeholderLabel.text =  self.textView.text.length == 0 ? @"请输入消息...":@"";

}

@end
