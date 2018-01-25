//
//  MOBIMMessageManager.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/20.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMMessageManager.h"
#import "MOBIMAudioManager.h"
#import "MOBIMDownloadManager.h"

@implementation MOBIMMessageManager

+ (instancetype)sharedManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}



- (id)init
{
    if (self = [super init])
    {
      
    }
    return self;
}


- (void)registerDownMessageAudioFile
{
    MOBIMWEAKSELF
    [[MobIM getChatManager] onMessageReceivedWithIdentifier:@"GloabNum" messageHandler:^(MIMMessage *message) {
        if (message.body.type == MIMMessageBodyTypeVoice)
        {
            
            [weakSelf receiveVoiceMessage:(MIMVoiceMessageBody*)message.body];
        }
    }];

}




//当我们接收到消息时,如果为音频消息请下载
- (void)receiveVoiceMessage:(MIMVoiceMessageBody*)body
{
    NSString *audioUrl = body.remotePath;
    
    //网络下载 音频，缓存本地
    NSString *destination = nil;
    
    if (audioUrl)
    {
        destination = [[MOBIMAudioManager sharedManager] audioLocalPathWithExtention:audioUrl.pathExtension URLString:audioUrl];
    }
    
    if (destination && audioUrl)
    {
        //MOBIMself
        [[MOBIMDownloadManager instance] downloadFileWithURLString:audioUrl destination:destination progress:^(NSProgress * _Nonnull progress, MOBIMDownloadResponse * _Nonnull response) {
            
        } success:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull url) {
            
            
        } faillure:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
    }

}

- (NSString *)contentStringWithGroupExt:(MIMMessage*)message
{
    NSString *resultContent = @"";
    MIMNoticeMessageBody *messageBody = (MIMNoticeMessageBody*)message.body;
    if (!(messageBody && [messageBody isKindOfClass:[MIMNoticeMessageBody class]])) {
        return nil;
    }
    if ((messageBody.noticeType <= MIMNoticeTypeMemberRemoved) && (messageBody.noticeType >= MIMNoticeTypeCreateGroup)) {

        switch (messageBody.noticeType) {
            case MIMNoticeTypeCreateGroup:
            {
                if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:message.to]) {
                    
                    resultContent = @"群组创建成功";
                }
            }
                break;
            case MIMNoticeTypeUpdateGroupName:
            {
                if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:message.to]) {
                    
                    resultContent = [NSString stringWithFormat:@"%@修改群名称为: %@",[self nickNameWithUser:messageBody.ownerInfo],message.ext[@"name"]];
                    
                }
            }
                break;
            case MIMNoticeTypeUpdateGroupNoti:
            {
                if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:message.to]) {
                    resultContent = [NSString stringWithFormat:@"%@更新公告: %@",[self nickNameWithUser:messageBody.ownerInfo],message.ext[@"notice"]];
                    
                }
            }
                break;
            case MIMNoticeTypeGroupTransfer:
            {
                if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:message.to]) {
                    resultContent = [NSString stringWithFormat:@"%@转让群组给 %@",[self nickNameWithUser:messageBody.ownerInfo],[self nickNameWithUser:messageBody.userInfo]];
                    
                }
            }
                break;
            case MIMNoticeTypeGroupDisbanded:
            {
                if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:message.to]) {
                    resultContent = [NSString stringWithFormat:@"你所在的群组\"%@\"已被解散",message.ext[@"name"]];
                    
                }
            }
                break;
            case MIMNoticeTypeJoinGroup:
            {
                if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:message.to]) {
                    resultContent = [NSString stringWithFormat:@"%@加入群聊",[self nickNameWithUser:messageBody.userInfo]];
                    
                }
                
            }
                break;
            case MIMNoticeTypeInvitedToGroup:
            {
                if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:message.to]) {
                    
                    NSArray *users =message.ext[@"users"];
                    if (users) {
                        
                        NSMutableString *userStr = [NSMutableString new];
                        for (NSDictionary *userItem in users) {
                            NSString *nickname = [self nickNameWithDict:userItem];
                            [userStr appendFormat:@"%@,",nickname];
                        }
                        if ([userStr hasSuffix:@","]) {
                            [userStr deleteCharactersInRange:NSMakeRange(userStr.length-1, 1)];
                        }
                        resultContent = [NSString stringWithFormat:@"%@加入群聊",userStr];
                        
                    }
                    
                }
            }
                break;
            case MIMNoticeTypeExitGroup:
            {
                if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:message.to]) {
                    resultContent = [NSString stringWithFormat:@"%@退出该群聊",[self nickNameWithUser:messageBody.userInfo]];
                    
                }
            }
                break;
            case MIMNoticeTypeRemoveMembers:
            {
                if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:message.to]) {
                    
                    NSArray *users =message.ext[@"users"];
                    if (users) {
                        
                        NSMutableString *userStr = [NSMutableString new];
                        for (NSDictionary *userItem in users) {
                            NSString *nickname = [self nickNameWithDict:userItem];
                            [userStr appendFormat:@"%@,",nickname];
                        }
                        if ([userStr hasSuffix:@","]) {
                            [userStr deleteCharactersInRange:NSMakeRange(userStr.length-1, 1)];
                        }
                        resultContent = [NSString stringWithFormat:@"%@退出群聊",userStr];

                    }
                    
                    
                }
            }
                break;
            case MIMNoticeTypeMemberRemoved:
            {
                resultContent = [NSString stringWithFormat:@"你已被移除出群组: %@",message.ext[@"name"]];
                
            }
                break;
            default:
                break;
        }
        
    }
    
    return resultContent;
}

- (NSString *)nickNameWithDict:(NSDictionary*)userDict
{
    if (userDict[@"nickname"])
    {
        return userDict[@"nickname"];
    }
    
    MOBIMUser *appUser = [[MOBIMUserManager sharedManager] usserInfoWithId:userDict[@"appUserId"]];
    if (appUser && appUser.nickname) {
        
        return appUser.nickname;
    }
    
    //取消在
    [[MOBIMUserManager sharedManager] fetchUserInfo:userDict[@"appUserId"] needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
        
    }];
    
    return userDict[@"appUserId"];
}

- (NSString *)nickNameWithUser:(MIMUser*)user
{
    if (user.nickname)
    {
        return user.nickname;
    }
    
    MOBIMUser *appUser = [[MOBIMUserManager sharedManager] usserInfoWithId:user.appUserId];
    if (appUser && appUser.nickname) {
        
        return appUser.nickname;
    }
    
    //取消在
    [[MOBIMUserManager sharedManager] fetchUserInfo:user.appUserId needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
        
    }];
    
    return user.appUserId;
}

@end
