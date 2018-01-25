//
//  NSString+MOBIMExtension.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MOBIMExtension)


- (NSString *)emoji;

- (CGSize)sizeWithMaxWidth:(CGFloat)width andFont:(UIFont *)font;

- (NSString *)originName;

+ (NSString *)currentName;

- (NSString *)firstStringSeparatedByString:(NSString *)separeted;

/// 当前时间
+ (NSInteger)currentMessageTime;

- (NSString *)getFirstLetter;


+ (NSString *)md5:(NSString *)key;

//本机全局唯一key
+ (NSString*)globalUniKey;

/**
 *param dateInt 时间13 位  (1508828449315)
 *param isList  是否列表显示
 **/
+ (NSString *)dateIntToDateString:(double)dateDouble isList:(BOOL)isList;
+ (int)dayFromDateInt:(double)dateDouble;

//NSDate to String 2013-05-07 09:46:14
+ (NSString *)dateToStringStyle1:(NSDate*)date;

@end
