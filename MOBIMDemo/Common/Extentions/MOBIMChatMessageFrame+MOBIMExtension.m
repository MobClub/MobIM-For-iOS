//
//  MOBIMChatMessageFrame+Extension.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatMessageFrame+MOBIMExtension.h"
#import "MOBIMChatMessageModel.h"
#import "NSString+MOBIMExtension.h"
#import "MOBIMAudioManager.h"
#import "MOBIMImageManager.h"
#import "MOBIMVideoManager.h"

@implementation MOBIMChatMessageFrame(MOBIMExtension)

+ (MOBIMChatMessageFrame *)createMessageNewFrame:(MIMConversationType )type
                                        bodyType:(MIMMessageBodyType)bodyType
                                         content:(NSString *)content
                                            path:(NSString *)path
                                            from:(NSString *)from
                                              to:(NSString *)to
                                         fileKey:(NSString *)fileKey
                                        isSender:(BOOL)isSender
                        receivedSenderByYourself:(BOOL)receivedSenderByYourself
{
    
   
    
    NSString *localPath = path;
    NSString *localPath2 = nil;

    MIMMessageBody *body = nil;

    if (bodyType == MIMMessageBodyTypeText) {
        body = [MIMTextMessageBody bodyWithText:content];
    }else if (bodyType == MIMMessageBodyTypeVoice){

        //获取语音时长
        int16_t duration = [[MOBIMAudioManager sharedManager] durationWithAudioPath:[NSURL fileURLWithPath:path]];
        
        body = [MIMVoiceMessageBody bodyWithLocalPath:path duration:duration];
    }else if (bodyType == MIMMessageBodyTypeImage){

        body = [MIMImageMessageBody bodyWithLocalPath:localPath];
        

    }else if (bodyType == MIMMessageBodyTypeVideo){
//        int16_t duration = [[MOBIMVideoManager sharedManager] durationWithVideoPath:[NSURL fileURLWithPath:path]];
        
        MOBIMImageManager *manager = [MOBIMImageManager sharedManager];
        UIImage *image = [manager videoConverPhotoWithVideoPath:path isSender:isSender];
        body = [MIMVideoMessageBody bodyWithThumbnailImage:image localPath:path];


    }else if (bodyType == MIMMessageBodyTypeFile){

        body = [MIMFileMessageBody bodyWithLocalPath:path];
    }

    body.type = bodyType;
    MIMMessage *message = [MIMMessage messageWithConversationType:type to:to body:body];
    
    
    //ext
    MOBIMChatMessageExt *ext = [[MOBIMChatMessageExt alloc] init];
    ext.day = [NSString dayFromDateInt:message.timestamp];
    ext.localFilePath1 = localPath;
    ext.localFilePath2 = localPath2;




    MOBIMChatMessageFrame *modelF = [[MOBIMChatMessageFrame alloc] init];
    modelF.messageExt = ext;
    modelF.modelNew = message;

    return modelF;

}


+ (MOBIMChatMessageFrame *)createMessageNewFrame:(MIMConversationType )type
                                        bodyType:(MIMMessageBodyType)bodyType
                                         content:(NSString *)content
                                            path:(NSString *)path
                                            from:(NSString *)from
                                              to:(NSString *)to
                                         fileKey:(NSString *)fileKey
                                        isSender:(BOOL)isSender
                        receivedSenderByYourself:(BOOL)receivedSenderByYourself
                                        filedata:(NSData*)data
{
    
    
    
    NSString *localPath = path;
    NSString *localPath2 = nil;
    
    MIMMessageBody *body = nil;
    
    if (bodyType == MIMMessageBodyTypeText) {
        body = [MIMTextMessageBody bodyWithText:content];
    }else if (bodyType == MIMMessageBodyTypeVoice){
        
        //获取语音时长
        int16_t duration = [[MOBIMAudioManager sharedManager] durationWithAudioPath:[NSURL fileURLWithPath:path]];
        
        body = [MIMVoiceMessageBody bodyWithLocalPath:path duration:duration];
    }else if (bodyType == MIMMessageBodyTypeImage){
        
        body = [MIMImageMessageBody bodyWithLocalPath:localPath];
        
        
    }else if (bodyType == MIMMessageBodyTypeVideo){
        //        int16_t duration = [[MOBIMVideoManager sharedManager] durationWithVideoPath:[NSURL fileURLWithPath:path]];
        
        MOBIMImageManager *manager = [MOBIMImageManager sharedManager];
        UIImage *image = [manager videoConverPhotoWithVideoPath:path isSender:isSender];
        body = [MIMVideoMessageBody bodyWithThumbnailImage:image localPath:path];
        
        
    }else if (bodyType == MIMMessageBodyTypeFile){
        
        if (data)
        {
            body = [MIMFileMessageBody bodyWithData:data extension:path.pathExtension];
        }
        else
        {
            body = [MIMFileMessageBody bodyWithLocalPath:path];
        }
    }
    
    body.type = bodyType;
    MIMMessage *message = [MIMMessage messageWithConversationType:type to:to body:body];
    
    
    //ext
    MOBIMChatMessageExt *ext = [[MOBIMChatMessageExt alloc] init];
    ext.day = [NSString dayFromDateInt:message.timestamp];
    ext.localFilePath1 = localPath;
    ext.localFilePath2 = localPath2;
    
    
    
    
    MOBIMChatMessageFrame *modelF = [[MOBIMChatMessageFrame alloc] init];
    modelF.messageExt = ext;
    modelF.modelNew = message;
    
    return modelF;
    
}


@end
