//
//  MOBIMFaceManager.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MOBIMEmotion;

@interface MOBIMFaceManager : NSObject


+ (NSArray *)customEmotion;

+ (NSArray *)gifEmotion;

+ (NSArray *)emojiGroups;


+ (YYTextLayout*)textLayout:(NSString*)content
                  maxWidth:(float)maxWidth
                      font:(UIFont *)font
                    insets:(UIEdgeInsets)insets
                 textColor:(UIColor*)textColor;



+ (NSRange)endCustomEmotionRange:(NSString*)content;

@end
