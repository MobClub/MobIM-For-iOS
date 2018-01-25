//
//  MOBIMVCard.h
//  MOBIMDemo
//
//  Created by hower on 07/12/2017.
//  Copyright © 2017 hower. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOBIMVCard : NSManagedObject

@property (nullable, nonatomic, copy) NSString *avatar;
@property (nonatomic) BOOL black;
@property (nonatomic) int16_t chatRoomType;
@property (nullable, nonatomic, copy) NSString *currentUserId;
@property (nullable, nonatomic, copy) NSString *displayName;
@property (nullable, nonatomic, copy) NSString *nickname;
@property (nonatomic) BOOL noDistribMessage;
@property (nullable, nonatomic, copy) NSString *roomId;
@property (nullable, nonatomic, copy) NSString *uId;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nonatomic) int16_t vcardType;

@end

NS_ASSUME_NONNULL_END
