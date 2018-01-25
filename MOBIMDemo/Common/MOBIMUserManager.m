//
//  MOBIMUserManager.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/11.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMUserManager.h"
#import "MOBIMVCard.h"
#import "MOBIMModelTools.h"

@implementation MOBIMUserManager

+ (instancetype)sharedManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (MOBIMUser *)currentUser
{
    if (!_currentUser) {
        NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@" currentUserId!=null and appUserId!=null and  currentUserId=appUserId "];
        MOBIMUser *user  = [MOBIMUser MR_findFirstWithPredicate:userPredicate sortedBy:nil ascending:YES];
        _currentUser = user;
    }
    
    return _currentUser;
}

+ (NSString *)currentUserId
{
    return [MOBIMUserManager sharedManager].currentUser.appUserId;
}

+ (MOBIMUserModel*)userToUserModel:(MOBIMUser*)user
{
    if (user) {
        MOBIMUserModel *contact = [MOBIMUserModel new];
        contact.nickname = user.nickname;
        contact.avatar = user.avatar;
        contact.appUserId = user.appUserId;
        contact.isConact = user.isConact;
        contact.currentUserId = user.currentUserId;
        contact.userType = user.userType;

        return contact;
    }
    
    return nil;
}

+ (MOBIMUser *)userModelToUser:(MOBIMUserModel *)user
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND appUserId = %@",[MOBIMUserManager currentUserId],user.appUserId];
    MOBIMUser *resultUser  = [MOBIMUser MR_findFirstWithPredicate:predicate sortedBy:nil ascending:YES];
    if (!resultUser) {
        resultUser = [MOBIMUser MR_createEntity];
        resultUser.userType = MIMUserTypeNormal;
    }
    
    resultUser.nickname = user.nickname;
    resultUser.avatar = user.avatar;
    resultUser.appUserId = user.appUserId;
    resultUser.currentUserId = [MOBIMUserManager currentUserId];
    resultUser.userType = user.userType;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    return resultUser;
}


+ (MOBIMUserModel*)userSdkToUserModel:(MIMUser*)user
{
    if (user) {
        MOBIMUserModel *contact = [MOBIMUserModel new];
        contact.nickname = user.nickname;
        contact.avatar = user.avatar;
        contact.appUserId = user.appUserId;
        contact.currentUserId = [MOBIMUserManager currentUserId];
        contact.userType = user.userType;

        return contact;
    }
    
    return nil;
}


+ (MOBIMUser *)userToAppUser:(MIMUser*)user
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND appUserId = %@",[MOBIMUserManager currentUserId],user.appUserId];
    MOBIMUser *resultUser  = [MOBIMUser MR_findFirstWithPredicate:predicate sortedBy:nil ascending:YES];
    if (!resultUser) {
        resultUser = [MOBIMUser MR_createEntity];
        resultUser.userType = MIMUserTypeNormal;
    }
    
    resultUser.nickname = user.nickname;
    resultUser.avatar = user.avatar;
    resultUser.appUserId = user.appUserId;
    resultUser.currentUserId = [MOBIMUserManager currentUserId];
    resultUser.userType = user.userType;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

    return resultUser;
}


+ (MOBIMUser *)saveUserToAppTipUser:(MIMUser*)user
{
    
    if (!user)
    {
        return nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND appUserId = %@ AND userType=%d ",[MOBIMUserManager currentUserId],user.appUserId,MIMUserTypeNoticer];
    MOBIMUser *resultUser  = [MOBIMUser MR_findFirstWithPredicate:predicate sortedBy:nil ascending:YES];
    if (!resultUser) {
        resultUser = [MOBIMUser MR_createEntity];
    }
    
    resultUser.nickname = user.nickname;
    resultUser.avatar = user.avatar;
    resultUser.appUserId = user.appUserId;
    resultUser.currentUserId = [MOBIMUserManager currentUserId];
    resultUser.userType = MIMUserTypeNoticer;
    [[NSManagedObjectContext MR_context] MR_saveToPersistentStoreAndWait];
    
    return resultUser;
}

+ (void)userModelToUser:(MOBIMUserModel*)userModel user:(MOBIMUser*)user
{
    if (userModel && user) {
        user.nickname = userModel.nickname;
        user.avatar = userModel.avatar;
        user.appUserId = userModel.appUserId;
        user.currentUserId = userModel.currentUserId;
        user.isConact = userModel.isConact;
        
    }
    
}




- (MOBIMUser *)usserInfoWithId:(NSString*)userId
{
    if (!userId)
    {
        MOBIMLog(@"%@ 参数错误",NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSPredicate *groupUserPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND appUserId = %@",[MOBIMUserManager sharedManager].currentUser.appUserId,userId];
    MOBIMUser *user  = [MOBIMUser MR_findFirstWithPredicate:groupUserPredicate sortedBy:nil ascending:YES];
    if (user) {
        return user;
    }
    
    return nil;
}

- (MOBIMVCard *)fetchOrCreateUserVcardWithUserId:(NSString*)userId
{
    if (!userId)
    {
        MOBIMLog(@"%@ 参数错误",NSStringFromSelector(_cmd));
        return nil;
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND userId = %@",[MOBIMUserManager sharedManager].currentUser.appUserId,userId];
    MOBIMVCard *vcard  = [MOBIMVCard MR_findFirstWithPredicate:predicate sortedBy:nil ascending:YES];
    if (vcard == nil) {
        vcard = [MOBIMVCard MR_createEntity];
        vcard.currentUserId = [MOBIMUserManager sharedManager].currentUser.appUserId;
        vcard.userId = userId;
        vcard.uId = vcard.currentUserId;
    }
    
    return vcard;
}

- (MOBIMVCard *)updateBalackStatus:(NSString*)userId black:(BOOL)isBlack
{
    
    if (!userId)
    {
        MOBIMLog(@"%@ 参数错误",NSStringFromSelector(_cmd));
        return nil;
    }
    
    
    MOBIMVCard *vcard = [self fetchOrCreateUserVcardWithUserId:userId];
    vcard.black = isBlack;
    [[NSManagedObjectContext MR_context] MR_saveToPersistentStoreAndWait];

    return vcard;
}


- (void)fetchUserInfo:(NSString*)userId completion:(MOBIMUserGetCompletionBlock)completion
{
    if (!userId)
    {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"参数错误!";
        dict[NSLocalizedFailureReasonErrorKey] = @"参数错误!";
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        completion(nil,error);
        
        
        return;
    }
    
    
    [MOBFHttpService sendHttpRequestByURLString:MOBIMNetworkUrl(@"/find")
                                         method:@"GET"
                                     parameters:@{@"appkey": @"moba6b6c6d6",@"id":userId}
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           NSInteger status = [responseDict[@"status"] integerValue];
                                           if (status == 200)
                                           {
                                               NSDictionary *resDict = responseDict[@"res"];
                                               if (resDict && resDict.allKeys.count > 0)
                                               {
                                                   //网络获取成功后直接更新
                                                   if (completion) {
                                                       completion([MOBIMModelTools userWithDict:resDict],nil);
                                                   }
                                               }
                                           }
                                           else
                                           {
                                               if (responseDict[@"res"]) {
                                                   
                                                   NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                                   dict[NSLocalizedDescriptionKey] = responseDict[@"res"];
                                                   dict[NSLocalizedFailureReasonErrorKey] = responseDict[@"res"];
                                                   NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
                                                   
                                                   completion(nil,error);
                                                   
                                               }
                                           }
                                           
                                       }
                                        onFault:^(NSError *error) {
                                            MOBIMLog(@"%@", error);
                                            completion(nil,error);
                                            
                                        }
                               onUploadProgress:nil];
}

- (void)fetchUserInfo:(NSString*)userId needNetworkFetch:(BOOL)needNetworkFetch completion:(MOBIMUserGetCompletionBlock)completion
{
    if (!userId) {
        MOBIMLog(@"---%@-不能为空-",userId);
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"参数错误!";
        dict[NSLocalizedFailureReasonErrorKey] = @"参数错误!";
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        completion(nil,error);
        
        return;
    }
    
    
    NSPredicate *groupUserPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND appUserId = %@",[MOBIMUserManager sharedManager].currentUser.appUserId,userId];
    MOBIMUser *user  = [MOBIMUser MR_findFirstWithPredicate:groupUserPredicate sortedBy:nil ascending:YES];
    if (user && completion) {
        completion(user,nil);
        return;
    }
    
    
    //本地没有缓存，网络获取
    if (needNetworkFetch == YES) {
        
        [MOBFHttpService sendHttpRequestByURLString:MOBIMNetworkUrl(@"/find")
                                             method:@"GET"
                                         parameters:@{@"appkey": @"moba6b6c6d6",@"id":userId}
                                            headers:nil
                                           onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                               NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                               NSInteger status = [responseDict[@"status"] integerValue];
                                               if (status == 200)
                                               {
                                                   NSDictionary *resDict = responseDict[@"res"];
                                                   if (resDict && resDict.allKeys.count > 0)
                                                   {
                                                       //网络获取成功后直接更新
                                                       if (completion) {
                                                           completion([MOBIMModelTools userWithDict:resDict],nil);
                                                       }
                                                   }
                                               }
                                               else
                                               {
                                                   if (responseDict[@"res"]) {
                                                       
                                                       NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                                       dict[NSLocalizedDescriptionKey] = responseDict[@"res"];
                                                       dict[NSLocalizedFailureReasonErrorKey] = responseDict[@"res"];
                                                       NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
                                                       
                                                       completion(nil,error);

                                                   }
                                               }
                                               
                                           }
                                            onFault:^(NSError *error) {
                                                MOBIMLog(@"%@", error);
                                                completion(nil,error);

                                            }
                                   onUploadProgress:nil];
        
    }else{
        
    }
    
    
}


- (void)fethNetUserInfo:(NSString*)userId completion:(MOBIMUserGetCompletionBlock)completion
{
    if (!userId) {
        //MOBIMLog(@"---%@-不能为空-",userId);
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"参数错误!";
        dict[NSLocalizedFailureReasonErrorKey] = @"参数错误!";
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        completion(nil,error);
        
        
        return;
    }
    
    [MOBFHttpService sendHttpRequestByURLString:MOBIMNetworkUrl(@"/find")
                                         method:@"GET"
                                     parameters:@{@"appkey": @"moba6b6c6d6",@"id":userId}
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           NSInteger status = [responseDict[@"status"] integerValue];
                                           if (status == 200)
                                           {
                                               NSDictionary *resDict = responseDict[@"res"];
                                               if (resDict && resDict.allKeys.count > 0)
                                               {
                                                   //网络获取成功后直接更新
                                                   if (completion) {
                                                       completion([MOBIMModelTools userWithDict:resDict],nil);
                                                   }
                                               }
                                           }
                                           else
                                           {
                                               if (responseDict[@"res"]) {
                                                   
                                                   NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                                   dict[NSLocalizedDescriptionKey] = responseDict[@"res"];
                                                   dict[NSLocalizedFailureReasonErrorKey] = responseDict[@"res"];
                                                   NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
                                                   
                                                   completion(nil,error);
                                                   
                                               }
                                           }
                                           
                                       }
                                        onFault:^(NSError *error) {
                                            MOBIMLog(@"%@", error);
                                            completion(nil,error);
                                            
                                        }
                               onUploadProgress:nil];
}


- (void)fetchContacts:(MOBIMContactsGetCompletionBlock)completion;
{
    NSMutableArray *contacts = [NSMutableArray new];
    NSPredicate *contactsPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND isConact == 1 ",[MOBIMUserManager sharedManager].currentUser.appUserId];
    NSArray *users = [MOBIMUser MR_findAllWithPredicate:contactsPredicate];
    if (users) {
        [contacts addObjectsFromArray:users];
    }
    
    if (completion) {
        completion(contacts,nil);
    }
}

- (void)fetchTipUsers:(MOBIMTipUsersGetCompletionBlock)completion
{
    NSMutableArray *users = [NSMutableArray new];
    NSPredicate *usersPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND userType = %d ",[MOBIMUserManager currentUserId],MIMUserTypeNoticer];
    NSArray *findUsers = [MOBIMUser MR_findAllWithPredicate:usersPredicate];
    if (findUsers) {
        [users addObjectsFromArray:findUsers];
    }
    
    if (completion) {
        completion(users,nil);
    }
}


- (MOBIMUser *)userFindFirstOrCreateWithUserModel:(MOBIMUserModel*)userModel
{
    if (userModel) {
        NSPredicate *groupUserPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND appUserId = %@",[MOBIMUserManager sharedManager].currentUser.appUserId,userModel.appUserId];
        MOBIMUser *user  = [MOBIMUser MR_findFirstWithPredicate:groupUserPredicate sortedBy:nil ascending:YES];
        if (!user) {
            user = [MOBIMUser MR_createEntity];
            user.userType = MIMUserTypeNormal;
        }
        //[MOBIMUserManager userModelToUser:userModel user:user];
        if (userModel && user) {
            user.nickname = userModel.nickname;
            user.avatar = userModel.avatar;
            user.appUserId = userModel.appUserId;
            user.currentUserId = userModel.currentUserId;
            user.isConact = userModel.isConact;
            user.userType = userModel.userType;

        }
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

        return user;

    }

    return nil;
}

- (void)modifyCurrentUserAvatarPath:(NSString*)avatarPath completion:(MOBIMModifyCurrentUserAvatarCompletionBlock)completion
{

    if (!avatarPath || ![MOBIMUserManager currentUserId])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"参数错误!";
        dict[NSLocalizedFailureReasonErrorKey] = @"参数错误!";
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        completion(nil,error);
        
        return;
    }
    [MOBFHttpService sendHttpRequestByURLString:MOBIMNetworkUrl(@"/update/user")
                                         method:@"GET"
                                     parameters:@{@"appkey": @"moba6b6c6d6",@"id":[MOBIMUserManager currentUserId],
                                                  @"avatar": avatarPath
                                                  }
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           NSInteger status = [responseDict[@"status"] integerValue];
                                           if (status == 200)
                                           {
                                               //对接MOBIMSDK 用户体系
                                               
                                               [MobSDK setUserWithUid:[MOBIMUserManager currentUserId]
                                                             nickName:[MOBIMUserManager sharedManager].currentUser.nickname
                                                               avatar:avatarPath
                                                             userData:nil];
                                               
                                               //网络获取成功后直接更新
                                               if (completion) {
                                                   completion(avatarPath,nil);
                                               }
                                           }
                                           else
                                           {
                                               if (responseDict[@"res"]) {
                                                   
                                                   NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                                   dict[NSLocalizedDescriptionKey] = responseDict[@"res"];
                                                   dict[NSLocalizedFailureReasonErrorKey] = responseDict[@"res"];
                                                   NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
                                                   
                                                   completion(nil,error);
                                                   
                                               }
                                           }
                                           
                                       }
                                        onFault:^(NSError *error) {
                                            MOBIMLog(@"%@", error);
                                            completion(nil,error);
                                            
                                        }
                               onUploadProgress:nil];

}

- (void)modifyCurrentUserNickname:(NSString*)nickName completion:(MOBIMModifyCurrentUserNicknameCompletionBlock)completion
{
    if (!nickName || ![MOBIMUserManager currentUserId])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"参数错误!";
        dict[NSLocalizedFailureReasonErrorKey] = @"参数错误!";
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        completion(nil,error);
        
        return;
    }
    
    [MOBFHttpService sendHttpRequestByURLString:MOBIMNetworkUrl(@"/update/user")
                                         method:@"GET"
                                     parameters:@{@"appkey": @"moba6b6c6d6",@"id":[MOBIMUserManager currentUserId],
                                                  @"nickname": nickName
                                                  }
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           NSInteger status = [responseDict[@"status"] integerValue];
                                           if (status == 200)
                                           {
                                               
                                               //对接MOBIMSDK 用户体系
                                               [MobSDK setUserWithUid:[MOBIMUserManager currentUserId]
                                                             nickName:nickName
                                                               avatar:[MOBIMUserManager sharedManager].currentUser.avatar
                                                             userData:nil];
                                               
                                               //网络获取成功后直接更新
                                               if (completion) {
                                                   completion(nickName,nil);
                                               }
                                           }
                                           else
                                           {
                                               if (responseDict[@"res"]) {
                                                   
                                                   NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                                   dict[NSLocalizedDescriptionKey] = responseDict[@"res"];
                                                   dict[NSLocalizedFailureReasonErrorKey] = responseDict[@"res"];
                                                   NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
                                                   
                                                   completion(nil,error);
                                                   
                                               }
                                           }
                                           
                                       }
                                        onFault:^(NSError *error) {
                                            MOBIMLog(@"%@", error);
                                            completion(nil,error);
                                            
                                        }
                               onUploadProgress:nil];

}



- (void)removeBlackUser:(NSString*)userId completion:(MOBIMRemoveBlackUserCompletionBlock)completion
{
    
    [[MobIM getUserManager] deleteBlackListWithUserId:userId resultHandler:^(MIMUser *user, MIMError *error) {
    

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND userId = %@ ",[MOBIMUserManager sharedManager].currentUser.appUserId,userId];
        MOBIMVCard *vcard  = [MOBIMVCard MR_findFirstWithPredicate:predicate sortedBy:nil ascending:YES];
        
        
        
        if (vcard == nil) {
            vcard = [MOBIMVCard MR_createEntity];
            vcard.currentUserId = [MOBIMUserManager sharedManager].currentUser.appUserId;
            vcard.userId = user.appUserId;
            
            vcard.nickname = user.nickname;
            vcard.avatar = user.avatar;
        }
        
        if (!user) {
            vcard.userId = userId;
            
        }
        
        if (vcard && !error) {
            
            vcard.black = NO;
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

        
        if (completion) {
            completion(vcard,error);
        }
        
    }];
    
}

- (void)addBlackUser:(NSString*)userId completion:(MOBIMAddBlackUserCompletionBlock)completion
{
    //网络修改成功后
    
    [[MobIM getUserManager] addToBlackListWithUserId:userId resultHandler:^(MIMUser *user, MIMError *error) {
        
        
        NSPredicate *groupUserPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND userId = %@",[MOBIMUserManager sharedManager].currentUser.appUserId,userId];
        MOBIMVCard *vcard  = [MOBIMVCard MR_findFirstWithPredicate:groupUserPredicate sortedBy:nil ascending:YES];
        
        if (vcard == nil) {
            vcard = [MOBIMVCard MR_createEntity];
            vcard.currentUserId = [MOBIMUserManager sharedManager].currentUser.appUserId;
            vcard.userId = user.appUserId;
            
            vcard.nickname = user.nickname;
            vcard.avatar = user.avatar;
        }
        
        if (!user) {
            vcard.userId = userId;
            
        }
        
        if (vcard && !error) {
            
            vcard.black = YES;
            
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];



        if (completion) {
            completion(vcard,error);
        }
        
    }];
    
    

}


- (void)fetchBlackList:(MOBIMBlackListCompletionBlock)completion
{
    [[MobIM getUserManager] getBlackListWithResultHandler:^(NSArray<MIMUser *> *blackList, MIMError *error) {
        

        if (!error)
        {
            //存储
            for (MIMUser *user in blackList)
            {
                
                NSPredicate *groupUserPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND userId = %@",[MOBIMUserManager sharedManager].currentUser.appUserId,user.appUserId];
                MOBIMVCard *vcard  = [MOBIMVCard MR_findFirstWithPredicate:groupUserPredicate sortedBy:nil ascending:YES];
                
                if (vcard == nil) {
                    vcard = [MOBIMVCard MR_createEntity];
                    vcard.currentUserId = [MOBIMUserManager sharedManager].currentUser.appUserId;
                    vcard.userId = user.appUserId;
                    
                    vcard.nickname = user.nickname;
                    vcard.avatar = user.avatar;
                }
                
                vcard.black = YES;
            }
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
        }

        if (completion) {
            completion(blackList,error);
        }
        
    }];
}

- (void)addUserDisturb:(NSString*)userId completion:(MOBIMAddUserDisturbCompletionBlock)completion
{
    NSPredicate *groupUserPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND userId = %@",[MOBIMUserManager sharedManager].currentUser.appUserId,userId];
    MOBIMVCard *vcard  = [MOBIMVCard MR_findFirstWithPredicate:groupUserPredicate sortedBy:nil ascending:YES];
    if (vcard == nil) {
        vcard = [MOBIMVCard MR_createEntity];
        vcard.currentUserId = [MOBIMUserManager sharedManager].currentUser.appUserId;
        vcard.userId = userId;
        vcard.uId = vcard.currentUserId;
        
    }
    vcard.noDistribMessage = YES;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    
    //更新sdk 相关状态
    [[MobIM getUserManager] setUserToDisturbWithUserId:vcard.userId isDisturb:vcard.noDistribMessage];
    
    if (completion) {
        completion(vcard,nil);
    }
}

- (void)removeUserDisturb:(NSString*)userId completion:(MOBIMRemoveUserDisturbCompletionBlock)completion
{
    NSPredicate *groupUserPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND userId = %@",[MOBIMUserManager sharedManager].currentUser.appUserId,userId];
    MOBIMVCard *vcard  = [MOBIMVCard MR_findFirstWithPredicate:groupUserPredicate sortedBy:nil ascending:YES];
    if (vcard == nil) {
        vcard = [MOBIMVCard MR_createEntity];
        vcard.currentUserId = [MOBIMUserManager sharedManager].currentUser.appUserId;
        vcard.userId = userId;
        vcard.uId = vcard.currentUserId;

    }
    vcard.noDistribMessage = NO;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    //更新sdk 相关状态
    [[MobIM getUserManager] setUserToDisturbWithUserId:vcard.userId isDisturb:vcard.noDistribMessage];

    
    if (completion) {
        completion(vcard,nil);
    }
}

@end

