//
//  MIMGroup.h
//  MobIM
//
//  Created by Sands_Lee on 2017/11/13.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MIMDefine.h"

@class MIMUser;

@interface MIMGroup : NSManagedObject

/**
 群组创建时间
 */
@property (nonatomic, readonly) int64_t createAt;

/**
 群组状态
 */
@property (nonatomic, assign, readonly) MIMGroupStatus groupStatus;

/**
 群组ID
 */
@property (nullable, nonatomic, copy, readonly) NSString *groupId;

/**
 群名称
 */
@property (nullable, nonatomic, copy, readonly) NSString *groupName;

/**
 群简介
 */
@property (nullable, nonatomic, copy, readonly) NSString *groupDesc;

/**
 群公告
 */
@property (nullable, nonatomic, copy, readonly) NSString *groupNotice;

/**
 群主
 */
@property (nullable, nonatomic, strong, readonly) MIMUser *owner;

/**
 群人数(包含群主)
 */
@property (nonatomic, readonly) int32_t membersCount;

/**
 群成员
 */
@property (nullable, nonatomic, strong, readonly) NSSet<MIMUser *> *membersList;


@end
