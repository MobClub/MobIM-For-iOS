//
//  MOBIMChatInputBoxViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatInputBoxViewController.h"
#import "UIColor+MOBIMExtentions.h"
#import "Masonry.h"
#import "MOBIMGConst.h"
#import "MOBIMChatInputBoxMoreView.h"
//#import "MOBIMEmoticonsView.h"
#import "MOBIMFileManager.h"
#import "MOBIMAudioManager.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMShortVideoViewController.h"
#import "MOBIMDocumentViewController.h"
#import "MOBIMNavigationController.h"
#import "UIImage+MOBIMExtension.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMImageManager.h"
#import "MOBIMAudioManager.h"
#import "MOBIMChatInputBoxFaceView.h"
#import "MOBIMGConfigManager.h"
#import "TZImagePickerController.h"
#import "UIViewController+MOBIMToast.h"

@interface MOBIMChatInputBoxViewController ()<MOBIMChatInputBoxMoreViewDelegate,MOBIMDocumentViewControllerDelegate,MOBIMChatInputBoxDelegate,TZImagePickerControllerDelegate,UIDocumentPickerDelegate>


@property (nonatomic, strong) MOBIMChatInputBox *chatInputBox;
@property (nonatomic, strong) MOBIMChatInputBoxMoreView *inputBoxmoreView;
@property (nonatomic, strong) MOBIMChatInputBoxFaceView * faceView;


@property (assign, nonatomic) CGFloat keyboardHeight;

@property (nonatomic, assign) CGRect keyboardFrame;

@property (nonatomic, assign) BOOL animation;


@property (nonatomic, strong) MOBIMShortVideoViewController *shortVideoController;
@property (nonatomic, copy) NSString *recordName;

- (void)registerTextViewNotifications;
- (void)removeTextViewNotifications;
@end

@implementation MOBIMChatInputBoxViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.animation = YES;
    [self loadUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.chatInputBox.chatInputBoxStatus == MOBIMChatInputBoxStatusTextViewShow && self.animation == YES) {
        [self.chatInputBox.textView becomeFirstResponder];
    }
    [self registerTextViewNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeTextViewNotifications];

}

- (void)loadData
{
    self.keyboardHeight = 258;
}

- (void)loadUI
{
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor=[UIColor redColor];
    [self.view addSubview:self.chatInputBox];
    
    self.inputBoxmoreView.y = KMOBIMHEIGHT_TABBAR+KMOBIMHEIGHT_CHATBOXVIEW;
    self.inputBoxmoreView.backgroundColor = KMOBIMCommonKeyboardColor;
    [self.view addSubview:self.inputBoxmoreView];
    
    self.faceView.y = KMOBIMHEIGHT_TABBAR+KMOBIMHEIGHT_CHATBOXVIEW+[self safeBottomHeight];
    self.faceView.backgroundColor = KMOBIMCommonKeyboardColor;
    [self.view addSubview:self.faceView];
    
    self.chatInputBox.delegate = self;
    
    self.view.backgroundColor = KMOBIMCommonKeyboardColor;
}

//考虑iphone x 屏幕地址的高度
- (float)safeBottomHeight
{
    if ([UIScreen mainScreen].bounds.size.height == 812) {
        return 32;
    }
    return 0;
}

- (void)registerTextViewNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeTextViewNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

#pragma mark - Public Methods

- (BOOL)resignFirstResponder
{
    //    if (self.chatInputBox.chatInputBoxStatus == MOBIMChatInputBoxStatus) { // 录制视频状态
    //        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
    //            [UIView animateWithDuration:0.3 animations:^{
    //                [_delegate chatInputBox:self didChangeChatBoxHeight:KMOBIMHEIGHT_TABBAR];
    //            } completion:^(BOOL finished) {
    //                [self.videoView removeFromSuperview]; // 移除video视图
    //                self.chatBox.status = ICChatBoxStatusNothing;//同时改变状态
    //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //                    [[ICVideoManager sharedManager] exit];  // 防止内存泄露
    //                });
    //            }];
    //        }
    //        return [super resignFirstResponder];
    //    }
    if (self.chatInputBox.chatInputBoxStatus != MOBIMChatInputBoxStatusTextViewDefault && self.chatInputBox.chatInputBoxStatus != MOBIMChatInputBoxStatusAudio) {
        {
            [self.chatInputBox resignFirstResponder];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
            
            if (self.animation)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [_delegate chatBoxViewController:self didChangeChatBoxHeight:KMOBIMHEIGHT_TABBAR+[MOBIMGConfigManager safeBottomHeight]];
                } completion:^(BOOL finished) {
                    [self.faceView removeFromSuperview];
                    [self.inputBoxmoreView removeFromSuperview];
                    // 状态改变
                    self.chatInputBox.chatInputBoxStatus = MOBIMChatInputBoxStatusTextViewDefault;
                }];
            }
            else
            {
                [_delegate chatBoxViewController:self didChangeChatBoxHeight:KMOBIMHEIGHT_TABBAR+[MOBIMGConfigManager safeBottomHeight]];
                [self.faceView removeFromSuperview];
                [self.inputBoxmoreView removeFromSuperview];
                // 状态改变
                self.chatInputBox.chatInputBoxStatus = MOBIMChatInputBoxStatusTextViewDefault;
            }

        }
        
    }
    return [super resignFirstResponder];
    
    
    
    //return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}


- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //    self.isEditing =  NO;
    self.keyboardFrame = CGRectZero;
    
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        
        if (self.chatInputBox.myResignFirstResponder == YES && self.chatInputBox.chatInputBoxStatus == MOBIMChatInputBoxStatusFace) {
            
            return;
        }
        [_delegate chatBoxViewController:self didChangeChatBoxHeight:49+[MOBIMGConfigManager safeBottomHeight]];
        self.chatInputBox.chatInputBoxStatus=MOBIMChatInputBoxStatusTextViewShow;
    }
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (self.chatInputBox.chatInputBoxStatus == MOBIMChatInputBoxStatusTextViewShow && self.keyboardFrame.size.height <= KMOBIMHEIGHT_CHATBOXVIEW) {
        return;
    }
    else if ((self.chatInputBox.chatInputBoxStatus == MOBIMChatInputBoxStatusFace || self.chatInputBox.chatInputBoxStatus == MOBIMChatInputBoxStatusMoreView) && self.keyboardFrame.size.height <= KMOBIMHEIGHT_CHATBOXVIEW) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        if (self.chatInputBox.myResignFirstResponder == YES && self.chatInputBox.chatInputBoxStatus == MOBIMChatInputBoxStatusFace) {

            return;
        }
        [_delegate chatBoxViewController:self didChangeChatBoxHeight: self.keyboardFrame.size.height + KMOBIMHEIGHT_TABBAR];
        self.chatInputBox.chatInputBoxStatus = MOBIMChatInputBoxStatusTextViewShow ;
        
    }
}


#pragma mark -MOBIMChatInputBoxMoreViewDelegate
- (void)chatBoxMoreView:(MOBIMChatInputBox *)chatInputBox didSelectItem:(MOBIMChatInputBoxMoreViewItemType)itemType
{
    if (itemType == MOBIMChatInputBoxMoreViewItemTypePhoto) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
            imagePickerVc.showSelectBtn = NO;
            imagePickerVc.isStatusBarDefault = YES;
            imagePickerVc.allowTakePicture = NO;
            
            imagePickerVc.oKButtonTitleColorDisabled = [UIColor blackColor];
            imagePickerVc.oKButtonTitleColorNormal = [UIColor blackColor];
            imagePickerVc.navigationBar.translucent = NO;
            imagePickerVc.barItemTextColor = [UIColor blackColor];
            imagePickerVc.naviTitleColor = [UIColor blackColor];
            imagePickerVc.navigationBar.barTintColor = [UIColor whiteColor];
            
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                
            }];
            
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            
            
            /*
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
             */
        } else {
        }
    }
    else if (itemType == MOBIMChatInputBoxMoreViewItemTypeCamera)
    {
        
        MOBIMWEAKSELF
        MOBIMShortVideoViewController *shortVideoController = [MOBIMShortVideoViewController new];
        //最长时间
        shortVideoController.maxSeconds = 10;
        shortVideoController.takeBlock = ^(id item) {
            //完成后的处理
            if ([weakSelf.delegate respondsToSelector:@selector(chatBoxViewController:sendVideoMessage:)]) {
                
                //发送视频
                if ([item isKindOfClass:[NSString class]]) {
                    
                    [weakSelf.delegate chatBoxViewController:weakSelf sendVideoMessage:item];
                }else if ([item isKindOfClass:[UIImage class]]){
                //发送图片
                
                    // 图片压缩
                    UIImage *simpleImg = [UIImage simpleImage:item];
                    // 保存路径
                    NSString *filePath = [[MOBIMImageManager sharedManager] saveImage:simpleImg];
                    
                    CGFloat size = [MOBIMFileManager fileSizeWithPath:filePath];
                    if (size >= KMOBIMMaxImageLength)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"所选文件已超出最大文件限制无法进行发送，请重新进行选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alertView show];
                        item = nil;
                    }
                    
                    
                    //通知聊天页面发送
                    [self.delegate chatBoxViewController:self sendImageMessage:item imagePath:filePath];
                }
            }
        };
        [self presentViewController:shortVideoController animated:YES completion:nil];
        
        
    }
    else if (itemType == MOBIMChatInputBoxMoreViewItemTypeFile)
    {
        
        if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 11, .minorVersion = 0, .patchVersion = 0}])
        {
            UIDocumentPickerViewController *importMenu = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:self.documentTypes inMode:UIDocumentPickerModeOpen];
            if (@available(iOS 11.0, *))
            {
                importMenu.allowsMultipleSelection = NO;
            }
            importMenu.delegate = self;
            [self presentViewController:importMenu animated:YES completion:nil];

        }
        else
        {
            MOBIMDocumentViewController *documentViewController=[[MOBIMDocumentViewController alloc] init];
            documentViewController.delegate=self;
            
            
            MOBIMNavigationController *navViewController = [[MOBIMNavigationController alloc] initWithRootViewController:documentViewController];
            [self presentViewController:navViewController animated:YES completion:nil];
        }
        

    }
}

- (NSArray*)documentTypes
{
    return @[
             @"public.image",
             @"public.audio",
             @"public.movie",
             @"public.text",
             @"public.item",
             @"public.content",
             @"public.source-code",
             @"com.apple.iwork.pages.pages",
             @"com.apple.iwork.numbers.numbers",
             @"com.apple.iwork.keynote.key"
             ];
}


#pragma mark - UIImagePickerControllerDelegate


/*
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 图片压缩后再上传服务器
    // 保存路径
    UIImage *simpleImg = [UIImage simpleImage:orgImage];
    NSString *filePath = [[MOBIMImageManager sharedManager] saveImage:simpleImg];
    
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendImageMessage:imagePath:)]) {
        [_delegate chatBoxViewController:self sendImageMessage:simpleImg imagePath:filePath];
    }
}
 */

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (UIImage *orgImage in photos) {
            
            // 图片压缩后再上传服务器
            // 保存路径
            UIImage *simpleImg = [UIImage simpleImage:orgImage];
            NSString *filePath = [[MOBIMImageManager sharedManager] saveImage:simpleImg];
            
            if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendImageMessage:imagePath:)]) {
                [_delegate chatBoxViewController:self sendImageMessage:simpleImg imagePath:filePath];
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [picker dismissViewControllerAnimated:YES completion:nil];
        });
        
    });
   


}


- (void)chatInputBox:(MOBIMChatInputBox *)chatBox changeStatusFrom:(MOBIMChatInputBoxStatus)fromStatus to:(MOBIMChatInputBoxStatus)toStatus
{
    self.animation = YES;
    if (toStatus == MOBIMChatInputBoxStatusTextViewShow) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.faceView removeFromSuperview];
            [self.inputBoxmoreView removeFromSuperview];
        });
        return;
    }
    else if (toStatus == MOBIMChatInputBoxStatusAudio)
    {
        
        [UIView animateWithDuration:0.3 animations:^{
            if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                [_delegate chatBoxViewController:self didChangeChatBoxHeight:KMOBIMHEIGHT_TABBAR + [MOBIMGConfigManager safeBottomHeight]];
            }
        } completion:^(BOOL finished) {
            [self.faceView removeFromSuperview];
            [self.inputBoxmoreView removeFromSuperview];
        }];
    }
    else if (toStatus == MOBIMChatInputBoxStatusFace)
    {
//        self.faceView.backgroundColor = [UIColor redColor];
        if (fromStatus == MOBIMChatInputBoxStatusAudio || fromStatus == MOBIMChatInputBoxStatusTextViewDefault) {
            self.faceView.y = KMOBIMHEIGHT_TABBAR;
            [self.view addSubview:self.faceView];
            [UIView animateWithDuration:0.3 animations:^{
                if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_delegate chatBoxViewController:self didChangeChatBoxHeight:KMOBIMHEIGHT_TABBAR + KMOBIMHEIGHT_CHATBOXVIEW+[MOBIMGConfigManager safeBottomHeight]];
                }
            }];
        } else {  // 表情高度变化
            
            if (fromStatus == MOBIMChatInputBoxStatusTextViewShow) {
                self.faceView.y = KMOBIMHEIGHT_TABBAR + KMOBIMHEIGHT_CHATBOXVIEW;

                [self.view addSubview:self.faceView];
                [UIView animateWithDuration:0.3 animations:^{
                    self.faceView.y = KMOBIMHEIGHT_TABBAR;
                    
                    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        [_delegate chatBoxViewController:self didChangeChatBoxHeight:KMOBIMHEIGHT_TABBAR + KMOBIMHEIGHT_CHATBOXVIEW + [MOBIMGConfigManager safeBottomHeight]];
                        
                    }
                } completion:^(BOOL finished) {
                    [self.inputBoxmoreView removeFromSuperview];
                    self.chatInputBox.myResignFirstResponder = NO;

                }];
                
                return;
            }
            self.faceView.y = KMOBIMHEIGHT_TABBAR + KMOBIMHEIGHT_CHATBOXVIEW;
            [self.view addSubview:self.faceView];
            [UIView animateWithDuration:0.3 animations:^{
                self.faceView.y = KMOBIMHEIGHT_TABBAR;
            } completion:^(BOOL finished) {
                [self.inputBoxmoreView removeFromSuperview];
            }];
            if (fromStatus != MOBIMChatInputBoxStatusMoreView) {
                [UIView animateWithDuration:0.2 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        [_delegate chatBoxViewController:self didChangeChatBoxHeight:KMOBIMHEIGHT_TABBAR + KMOBIMHEIGHT_CHATBOXVIEW + [MOBIMGConfigManager safeBottomHeight]];
                        
                    }
                } completion:^(BOOL finished) {
                    self.chatInputBox.myResignFirstResponder = NO;
                }];
            }
        }
        
    }else if (toStatus == MOBIMChatInputBoxStatusMoreView)
    {
        
        if (fromStatus == MOBIMChatInputBoxStatusAudio || fromStatus == MOBIMChatInputBoxStatusTextViewDefault) {
            self.inputBoxmoreView.y = KMOBIMHEIGHT_TABBAR;
            [self.view addSubview:self.inputBoxmoreView];
            [UIView animateWithDuration:0.3 animations:^{
                if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_delegate chatBoxViewController:self didChangeChatBoxHeight:KMOBIMHEIGHT_TABBAR + KMOBIMHEIGHT_CHATBOXVIEW+[MOBIMGConfigManager safeBottomHeight]];
                }
            }];
        } else {
            self.inputBoxmoreView.y = KMOBIMHEIGHT_TABBAR + KMOBIMHEIGHT_CHATBOXVIEW;
            [self.view addSubview:self.inputBoxmoreView];
            [UIView animateWithDuration:0.3 animations:^{
                self.inputBoxmoreView.y = KMOBIMHEIGHT_TABBAR;
            } completion:^(BOOL finished) {
                [self.faceView removeFromSuperview];
            }];
            
            [UIView animateWithDuration:0.2 animations:^{
                if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_delegate chatBoxViewController:self didChangeChatBoxHeight:KMOBIMHEIGHT_TABBAR + KMOBIMHEIGHT_CHATBOXVIEW+[MOBIMGConfigManager safeBottomHeight]];
                }
            }];
        }
    }
    
}

- (void)chatInputBox:(MOBIMChatInputBox *)chatInputBox sendTextMessage:(NSString*)message
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendTextMessage:)]) {
        [_delegate chatBoxViewController:self sendTextMessage:message];
    }
}


- (void)chatInputBox:(MOBIMChatInputBox *)chatInputBox didChangeChatBoxHeight:(CGFloat)height
{
    self.faceView.y = height;
    self.inputBoxmoreView.y = height;
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        float h = (self.chatInputBox.chatInputBoxStatus == MOBIMChatInputBoxStatusFace ? KMOBIMHEIGHT_CHATBOXVIEW : self.keyboardFrame.size.height ) + height;
        [_delegate chatBoxViewController:self didChangeChatBoxHeight: h];
    }
}


- (NSString *)currentRecordFileName
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    return fileName;
}


- (void)chatInputBox:(MOBIMChatInputBox *)chatBox textViewShouldBeginEditing:(UITextView *)textView
{
    self.animation = YES;
}
//开始录音
- (void)didStartRecordingVoiceAction
{
    self.recordName = [self currentRecordFileName];
    //    if ([_delegate respondsToSelector:@selector(voiceDidStartRecording)]) {
    //        [_delegate voiceDidStartRecording];
    //    }
    [[MOBIMAudioManager sharedManager] startRecordingWithFileName:self.recordName completion:^(NSError *error) {
        if (error) {   // 加了录音权限的判断
        } else {
            if ([_delegate respondsToSelector:@selector(voiceDidStartRecording)]) {
                [_delegate voiceDidStartRecording];
            }
        }
    }];
    
}


//手指向上滑动取消录音
- (void)didCancelRecordingVoiceAction
{
    if ([_delegate respondsToSelector:@selector(voiceDidCancelRecording)]) {
        [_delegate voiceDidCancelRecording];
    }
    [[MOBIMAudioManager sharedManager] removeCurrentRecordFile:self.recordName];
}


//松开手指完成录音
- (void)didFinishRecoingVoiceAction
{
    MOBIMWEAKSELF
    [[MOBIMAudioManager sharedManager] stopRecordingWithCompletion:^(NSString *recordPath) {
        if ([recordPath isEqualToString:KMOBIMToshortRecord]) {
            if ([_delegate respondsToSelector:@selector(voiceRecordSoShort)]) {
                [_delegate voiceRecordSoShort];
            }
            [[MOBIMAudioManager sharedManager] removeCurrentRecordFile:weakSelf.recordName];
        } else {    // send voice message
            if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendAudioMessage:)]) {
                [_delegate chatBoxViewController:weakSelf sendAudioMessage:recordPath];
            }
        }
    }];
    
}

//当手指离开按钮的范围内时，主要为了通知外部的HUD
- (void)didDragOutsideAction
{
    if ([_delegate respondsToSelector:@selector(voiceWillDragout:)]) {
        [_delegate voiceWillDragout:NO];
    }
    
}


//当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
- (void)didDragInsideAction
{
    if ([_delegate respondsToSelector:@selector(voiceWillDragout:)]) {
        [_delegate voiceWillDragout:YES];
    }
}

- (void)selectedFileName:(NSString *)fileName
{
    
    CGFloat size = [MOBIMFileManager fileSizeWithPath:fileName];
    if (size >= KMOBIMMaxFileLength)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"所选文件已超出最大文件限制无法进行发送，请重新进行选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        //return;
        
        fileName = nil;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(chatBoxViewController:sendFileMessage:data:)]) {
        [self.delegate chatBoxViewController:self sendFileMessage:fileName data:nil];
    }
}


//时间太短了
//- (void) audioDateTooShort;


- (MOBIMChatInputBoxFaceView *)faceView
{
    if (_faceView == nil) {
        _faceView=[[MOBIMChatInputBoxFaceView alloc] initWithFrame:CGRectMake(0, KMOBIMHEIGHT_TABBAR, MOIMDevice_Width, KMOBIMHEIGHT_CHATBOXVIEW)];
        
    }
    
    return _faceView;
}

- (MOBIMChatInputBoxMoreView *)inputBoxmoreView
{
    if (_inputBoxmoreView==nil) {
        _inputBoxmoreView=[[MOBIMChatInputBoxMoreView alloc] initWithFrame:CGRectMake(0, KMOBIMHEIGHT_TABBAR, MOIMDevice_Width, KMOBIMHEIGHT_CHATBOXVIEW)];
        _inputBoxmoreView.delegate=self;
        _inputBoxmoreView.backgroundColor =KMOBIMCommonKeyboardColor;
        
        
        NSMutableArray *moreViewItemArray=[NSMutableArray new];
        {
            NSMutableDictionary *moreViewitemDict=[NSMutableDictionary new];
            [moreViewitemDict setObject:@"moreviewphoto" forKey:@"imageName"];
            [moreViewitemDict setObject:@"图片" forKey:@"name"];
            [moreViewitemDict setObject:[NSNumber numberWithInt:MOBIMChatInputBoxMoreViewItemTypePhoto] forKey:@"MOBIMChatInputBoxMoreViewItemType"];
            
            [moreViewItemArray addObject:moreViewitemDict];
        }
        
        
        {
            NSMutableDictionary *moreViewitemDict=[NSMutableDictionary new];
            [moreViewitemDict setObject:@"moreviewcamera" forKey:@"imageName"];
            [moreViewitemDict setObject:@"拍照" forKey:@"name"];
            [moreViewitemDict setObject:[NSNumber numberWithInt:MOBIMChatInputBoxMoreViewItemTypeCamera] forKey:@"MOBIMChatInputBoxMoreViewItemType"];
            
            [moreViewItemArray addObject:moreViewitemDict];
            
        }
        
        //ios 11 以后才能用
//        if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 11, .minorVersion = 0, .patchVersion = 0}])
//        {
            NSMutableDictionary *moreViewitemDict=[NSMutableDictionary new];
            [moreViewitemDict setObject:@"moreviewfile" forKey:@"imageName"];
            [moreViewitemDict setObject:@"文件" forKey:@"name"];
            [moreViewitemDict setObject:[NSNumber numberWithInt:MOBIMChatInputBoxMoreViewItemTypeFile] forKey:@"MOBIMChatInputBoxMoreViewItemType"];
            
            [moreViewItemArray addObject:moreViewitemDict];
            
//        }
        
        
        [_inputBoxmoreView setItems:moreViewItemArray];
        
    }
    
    return _inputBoxmoreView;
}


- (MOBIMChatInputBox *) chatInputBox
{
    if (_chatInputBox == nil) {
        _chatInputBox = [[MOBIMChatInputBox alloc] initWithFrame:CGRectMake(0, 0, MOIMDevice_Width, KMOBIMHEIGHT_TABBAR)];
//        _chatInputBox.delegate = self;
    }
//    _chatInputBox.backgroundColor=[UIColor redColor];

    return _chatInputBox;
}



- (void)openFile:(NSURL *)url
{
    //1.获取文件安全访问权限
    BOOL accessing = [url startAccessingSecurityScopedResource];
    
    if (accessing){
        //[activityView startAnimating];
        [self showToastWithStatus:@"数据处理中..."];
        
        //2.通过文件协调器读取文件地址
        MOBIMWEAKSELF
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        [fileCoordinator coordinateReadingItemAtURL:url
                                            options:NSFileCoordinatorReadingWithoutChanges
                                              error:nil
                                         byAccessor:^(NSURL * _Nonnull newURL) {
                                             
                                             //[activityView stopAnimating];
                                             
                                             //3.读取文件协调器提供的新地址里的数据
                                             NSData *data = [NSData dataWithContentsOfURL:newURL];
                                             
                                             if (data.length >= KMOBIMMaxFileLength)
                                             {
                                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"所选文件已超出最大文件限制无法进行发送，请重新进行选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                                 [alertView show];
                                                 
                                                 if ([weakSelf.delegate respondsToSelector:@selector(chatBoxViewController:sendFileMessage:data:)]) {
                                                     [weakSelf.delegate chatBoxViewController:self sendFileMessage:nil data:data];
                                                 }
                                                 
                                             }
                                             else
                                             {
                                                 
                                                 if ([weakSelf.delegate respondsToSelector:@selector(chatBoxViewController:sendFileMessage:data:)]) {
                                                     [weakSelf.delegate chatBoxViewController:self sendFileMessage:newURL.lastPathComponent data:data];
                                                 }
                                                 
                                             }
                                             [weakSelf dismissToast];

                                         }];
        
    }
   
    
    //6.停止安全访问权限
    [url stopAccessingSecurityScopedResource];
}

#pragma mark -- UIDocumentPickerDelegate
// Required
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls
{
    for (NSURL *url in urls) {
        [self openFile:url];
    }
}

// called if the user dismisses the document picker without selecting a document (using the Cancel button)
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    
}


- (void)resetToBottomWithNoAnimation:(BOOL)animation
{
    if ([self.chatInputBox.textView isFirstResponder])
    {
        self.animation = animation;
        [self.chatInputBox.textView resignFirstResponder];
    }
}
@end
