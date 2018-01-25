//
//  MOBIMChatInputBoxMoreViewItem.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOBIMGConst.h"



@interface MOBIMChatInputBoxMoreViewItem : UIView
{

}
@property (nonatomic, assign, readonly) MOBIMChatInputBoxMoreViewItemType moreViewItemType;
@property (nonatomic, strong, readonly) UIButton *button;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

- (void)setTitle:(NSString*)title imageName:(NSString*)imageName moreViewItemType:(MOBIMChatInputBoxMoreViewItemType)moreViewItemType;

@end
