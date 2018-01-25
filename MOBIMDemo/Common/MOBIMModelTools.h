//
//  MOBIMModelTools.h
//  MOBIMDemo
//
//  Created by hower on 15/11/2017.
//  Copyright © 2017 hower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOBIMUser.h"

@interface MOBIMModelTools : NSObject

//NSDictionary 获取用户 MOBIMUser
+ (MOBIMUser *)userWithDict:(NSDictionary*)userDict;

//NSDictionary 获取当前用户 MOBIMUser
+ (MOBIMUser *)curUserWithDict:(NSDictionary*)userDict;

@end
