//
//  MIMUser.h
//  MobIM
//
//  Created by Sands_Lee on 2017/11/13.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MIMDefine.h"

@class MOBFUser;

@interface MIMUser : NSManagedObject

@property (nonatomic, copy) NSString *appUserId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *muid;
@property (nonatomic, strong) NSDictionary *appUserData;
/**
 用户类型
 */
@property (nonatomic, assign, readonly) MIMUserType userType;

+ (instancetype)userWithMobUser:(MOBFUser *)mobUser;

+ (instancetype)userWithDict:(NSDictionary *)dict;

+ (instancetype)userWithAppUid:(NSString *)appUid
                        avatar:(NSString *)avatar
                      nickname:(NSString *)nickname
                          muid:(NSString *)muid
                   appUserData:(NSDictionary *)appUserData
                      userType:(MIMUserType)type;

@end
