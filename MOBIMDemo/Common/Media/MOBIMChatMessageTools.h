//
//  MOBIMChatMessageTools.h
//  MOBIMDemo
//
//  Created by hower on 2017/10/1.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOBIMChatMessageTools : NSObject


+ (NSString *)timeDurationFormatter:(NSUInteger)duration;

+ (NSDictionary *)fileTypeDictionary;
+ (NSNumber *)fileType:(NSString *)type;

+ (NSString *)timeFormatWithDate:(NSInteger)time;

+ (NSString *)timeFormatWithDate2:(NSInteger)time;


@end
