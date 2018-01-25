//
//  MOBIMChatInputBoxMoreView.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOBIMGConst.h"




@class MOBIMChatInputBoxMoreView;
@protocol MOBIMChatInputBoxMoreViewDelegate <NSObject>
/**
 *  点击更多的类型
 *
 *  @param chatInputBoxMoreView MOBIMChatInputBoxViewController
 *  @param itemType        类型
 */
- (void)chatBoxMoreView:(MOBIMChatInputBoxMoreView *)chatInputBoxMoreView didSelectItem:(MOBIMChatInputBoxMoreViewItemType)itemType;

@end


@interface MOBIMChatInputBoxMoreView : UIView

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak) id<MOBIMChatInputBoxMoreViewDelegate>delegate;

@end
