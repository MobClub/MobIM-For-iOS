//
//  MIMVCard.h
//  MobIM
//
//  Created by Sands_Lee on 2017/11/20.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MIMVCard : NSManagedObject

/**
 用户id
 */
@property (nonatomic, copy, readonly) NSString *appUserId;

/**
 群组id
 */
@property (nonatomic, copy, readonly) NSString *groupId;

/**
 用户在该群中的昵称
 */
@property (nonatomic, copy, readonly) NSString *groupNickname;

/**
 是否免打扰
 */
@property (nonatomic, readonly) BOOL isDisturb;

@end
