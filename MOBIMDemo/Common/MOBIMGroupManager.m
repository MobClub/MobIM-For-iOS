//
//  MOBIMGroupManager.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/20.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMGroupManager.h"

@implementation MOBIMGroupManager


+ (instancetype)sharedManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)modifyGroupName:(NSString*)groupName groupId:(NSString*)groupId completion:(MOBIMModifyGroupNameCompletionBlock)completion
{
    if (completion) {
        completion(groupId,groupName,nil);
    }
}


- (void)modifyGroupIntroduction:(NSString*)introduction groupId:(NSString*)groupId completion:(MOBIMModifyGroupIntroductionCompletionBlock)completion
{
    if (completion) {
        completion(groupId,introduction,nil);
    }
}


- (void)modifyGroupNotice:(NSString*)notice groupId:(NSString*)groupId completion:(MOBIMModifyGroupNoticeCompletionBlock)completion
{
    if (completion) {
        completion(groupId,notice,nil);
    }
}

- (void)userModifyNicknameInGroup:(NSString*)nickName groupId:(NSString*)groupId completion:(MOBIMUserModifyNicknameInGroupNoticeCompletionBlock)completion
{
    if (completion) {
        completion(groupId,nickName,nil);
    }
}

- (void)modifyGroupDisturb:(BOOL)disturb groupId:(NSString*)groupId completion:(MOBIMModifyGroupDisturbCompletionBlock)completion
{
    if (completion) {
        completion(groupId,disturb,nil);
    }
}

- (void)disbandGroup:(NSString*)groupId completion:(MOBIMDisbandGroupCompletionBlock)completion
{
    if (completion) {
        completion(groupId,nil);
    }
}

- (void)quitGroup:(NSString*)groupId completion:(MOBIMQuitGroupCompletionBlock)completion
{
    if (completion) {
        completion(groupId,nil);
    }
}

- (void)transferGroup:(NSString*)groupId toUser:(NSString*)userId completion:(MOBIMTranferGroupCompletionBlock)completion
{
    if (completion) {
        completion(groupId,userId,nil);
    }
}



@end
