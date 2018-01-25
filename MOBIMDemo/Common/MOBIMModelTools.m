//
//  MOBIMModelTools.m
//  MOBIMDemo
//
//  Created by hower on 15/11/2017.
//  Copyright © 2017 hower. All rights reserved.
//

#import "MOBIMModelTools.h"

@implementation MOBIMModelTools


+ (MOBIMUser *)curUserWithDict:(NSDictionary*)userDict
{
    if (!userDict) {
        return nil;
    }
    NSInteger userId = [userDict[@"id"] integerValue];
    NSString *userIdStr = @"";
    if (userId > 0) {
        userIdStr = [NSString stringWithFormat:@"%ld",userId];
    }
    
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND appUserId = %@",[MOBIMUserManager sharedManager].currentUser.appUserId,userIdStr];
    MOBIMUser *user  = [MOBIMUser MR_findFirstWithPredicate:userPredicate sortedBy:nil ascending:YES];
    if (!user) {
        user = [MOBIMUser MR_createEntity];
        user.userType = MIMUserTypeNormal;
    }
    
    user.appUserId = userIdStr;
    user.currentUserId = userIdStr;

    NSString *nickname = userDict[@"nickname"];
    if (nickname && nickname.length > 0) {
        user.nickname = nickname;
    }
    NSString *avatar = userDict[@"avatar"];
    if (avatar && avatar.length > 0) {
        user.avatar = avatar;
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    
    return user;
}

+ (MOBIMUser *)userWithDict:(NSDictionary*)userDict
{
    if (!userDict) {
        return nil;
    }
    NSInteger userId = [userDict[@"id"] integerValue];
    NSString *userIdStr = @"";
    if (userId > 0) {
        userIdStr = [NSString stringWithFormat:@"%ld",userId];
    }
    
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND appUserId = %@",[MOBIMUserManager sharedManager].currentUser.appUserId,userIdStr];
    MOBIMUser *user  = [MOBIMUser MR_findFirstWithPredicate:userPredicate sortedBy:nil ascending:YES];
    if (!user) {
        user = [MOBIMUser MR_createEntity];
        user.userType = MIMUserTypeNormal;
    }
    
    user.appUserId = userIdStr;
    user.currentUserId = [MOBIMUserManager sharedManager].currentUser.appUserId;

    NSString *nickname = userDict[@"nickname"];
    if (nickname && nickname.length > 0) {
        user.nickname = nickname;
    }
    NSString *avatar = userDict[@"avatar"];
    if (avatar && avatar.length > 0) {
        user.avatar = avatar;
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

    
    return user;
}

@end
