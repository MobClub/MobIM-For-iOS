//
//  MOBIMBaseMessageCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MOBIMBaseMessageCellLineStyle) {
    MOBIMBaseMessageCellLineStyleDefault,
    MOBIMBaseMessageCellLineStyleFill,
    MOBIMBaseMessageCellLineStyleNone
};


@interface MOBIMBaseMessageCell : UITableViewCell

/** 边界线 */
@property (nonatomic, assign) MOBIMBaseMessageCellLineStyle bottomLineStyle;
@property (nonatomic, assign) MOBIMBaseMessageCellLineStyle topLineStyle;

@property (nonatomic, assign) CGFloat leftFreeSpace; // 低线的左边距

@property (nonatomic, assign) CGFloat rightFreeSpace;

@property (nonatomic, weak) UIView *bottomLine;

@end
