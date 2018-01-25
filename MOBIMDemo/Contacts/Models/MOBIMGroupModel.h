//
//  MOBIMGroupModel.h
//  MOBIMDemo
//
//  Created by hower on 2017/10/18.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOBIMUserModel;
@interface MOBIMGroupModel : NSObject
@property (nullable, nonatomic, copy) NSString *avatarPath;
@property (nullable, nonatomic, copy) NSString *currentUserId;
@property (nullable, nonatomic, copy) NSString *groupId;
@property (nullable, nonatomic, copy) NSString *introduction;
@property (nonatomic) int16_t introductionUpdateDate;
@property (nonatomic) int16_t memberCount;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *notice;
@property (nonatomic) int16_t noticeUpdateDate;
@property (nullable, nonatomic, copy) NSString *owerId;
@property (nullable, nonatomic, copy) NSString *role;
@property (nullable, nonatomic, copy) NSString *uId;
@property (nonatomic) BOOL isMyGroup;
@property (nullable, nonatomic, retain) NSSet<MOBIMUserModel *> *users;
@end
