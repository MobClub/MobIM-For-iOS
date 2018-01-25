//
//  MOBIMBadgeView.h
//  MOBIMDemo
//
//  Created by hower on 2017/10/12.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, MOBIMBadgeAlignment)
{
    MOBIMBadgeAlignmentCenter =   (1 << 0),
    MOBIMBadgeAlignmentTop    =   (1 << 1),
    MOBIMBadgeAlignmentBottom =   (1 << 2),
    MOBIMBadgeAlignmentLeft   =   (1 << 3),
    MOBIMBadgeAlignmentRight  =   (1 << 4)
};

typedef NS_ENUM(NSUInteger, MOBIMBadgeType)
{
    MOBIMBadgeTypeNumber,
    MOBIMBadgeTypePoint
};


@interface MOBIMBadgeView : UIView

@property (nonatomic, copy) NSString *badgeText;
@property (nonatomic, assign) MOBIMBadgeType badgeType;
@property (nonatomic, assign) MOBIMBadgeAlignment badgeAlignment;
@property (nonatomic, strong) UIColor *badgeTextColor;
@property (nonatomic, strong) UIFont *badgeTextFont;
@property (nonatomic, strong) UIColor *badgeBackgroundColor;
@property (nonatomic, assign) CGFloat badgeCornerRadius;
@property (nonatomic, assign) CGFloat badgeMinWidth;
@property (nonatomic, assign) CGFloat badgeMaxWidth;

@property (nonatomic, strong) NSString *specificText; //可显示的非数值类型的字符
@property (nonatomic, assign, readonly) CGRect rectDrawArea;

@end

