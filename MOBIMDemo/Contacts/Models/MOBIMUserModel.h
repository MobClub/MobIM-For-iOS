//
//  MOBIMUserModel.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOBIMUserModel : NSObject

@property (nonatomic) int16_t userType;

@property (nullable, nonatomic, copy) NSString *avatar;
@property (nullable, nonatomic, copy) NSString *currentUserId;
@property (nullable, nonatomic, copy) NSString *displayName;
@property (nonatomic) BOOL isConact;
@property (nullable, nonatomic, copy) NSString *nickname;
@property (nullable, nonatomic, copy) NSString *appUserId;

@property (nullable, nonatomic, copy) NSDictionary *extDict;

@end
