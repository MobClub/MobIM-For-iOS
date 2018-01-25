//
//  MOBIMEmotion.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMEmotion.h"

@implementation MOBIMEmotion


- (BOOL)isEqual:(MOBIMEmotion *)emotion
{
    return [self.face_name isEqualToString:emotion.face_name] || [self.code isEqualToString:emotion.code];
}
@end
