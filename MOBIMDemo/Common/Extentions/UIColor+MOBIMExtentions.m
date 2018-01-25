//
//  MOBIMUIColor+Extentions.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "UIColor+MOBIMExtentions.h"

@implementation UIColor(MOBIMUIColor_Extentions)

+ (UIColor *)colorWithHex:(long)colorHex
{
    return  [UIColor colorWithRed:((float)((colorHex & 0xFF0000) >> 16)) / 255.0 green:((float)((colorHex & 0xFF00) >> 8)) / 255.0 blue:((float)(colorHex & 0xFF)) / 255.0 alpha:1.0];
}

@end
