//
//  MOBIMUser.h
//  MOBIMDemo
//
//  Created by hower on 07/12/2017.
//  Copyright © 2017 hower. All rights reserved.
//

#import <CoreData/CoreData.h>
NS_ASSUME_NONNULL_BEGIN

@interface MOBIMUser : NSManagedObject

@property (nullable, nonatomic, copy) NSString *appUserId;
@property (nullable, nonatomic, copy) NSString *avatar;
@property (nullable, nonatomic, copy) NSString *currentUserId;
@property (nullable, nonatomic, copy) NSString *displayName;
@property (nonatomic) BOOL isConact;
@property (nullable, nonatomic, copy) NSString *nickname;
@property (nonatomic) int16_t userType;


@end
NS_ASSUME_NONNULL_END
