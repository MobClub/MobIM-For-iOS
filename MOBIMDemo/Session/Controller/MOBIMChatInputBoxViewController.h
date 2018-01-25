//
//  MOBIMChatInputBoxViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewController.h"
#import "MOBIMChatInputBox.h"

@class MOBIMChatInputBoxViewController;


@protocol MOBIMChatInputBoxViewControllerDelegate <NSObject>
- (void) chatBoxViewController:(MOBIMChatInputBoxViewController *)chatboxViewController
        didChangeChatBoxHeight:(CGFloat)height;


- (void) chatBoxViewController:(MOBIMChatInputBoxViewController *)chatboxViewController
               sendTextMessage:(NSString *)messageStr;
- (void) chatBoxViewController:(MOBIMChatInputBoxViewController *)chatboxViewController
              sendImageMessage:(UIImage *)image
                     imagePath:(NSString *)imgPath;
- (void) chatBoxViewController:(MOBIMChatInputBoxViewController *)chatboxViewController sendAudioMessage:(NSString *)voicePath;
- (void) chatBoxViewController:(MOBIMChatInputBoxViewController *)chatboxViewController sendVideoMessage:(NSString *)videoPath;

- (void) chatBoxViewController:(MOBIMChatInputBoxViewController *)chatboxViewController sendFileMessage:(NSString *)fileName data:(NSData*)data;


- (void) voiceDidStartRecording;
// voice太短
- (void) voiceRecordSoShort;

- (void) voiceWillDragout:(BOOL)inside;

- (void) voiceDidCancelRecording;

@end


@interface MOBIMChatInputBoxViewController : UIViewController

@property (nonatomic, weak) id<MOBIMChatInputBoxViewControllerDelegate> delegate;

@property (nonatomic, strong, readonly) MOBIMChatInputBox *chatInputBox;
@property (nonatomic, copy, readonly) NSString *recordName;

- (void)loadUI;

- (void)resetToBottomWithNoAnimation:(BOOL)animation;

@end
