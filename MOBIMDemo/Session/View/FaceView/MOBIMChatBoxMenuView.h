//
//  MOBIMChatBoxMenuView.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    MOBIMEmotionMenuButtonTypeEmoji = 100,
    MOBIMEmotionMenuButtonTypeCuston,
    MOBIMEmotionMenuButtonTypeGif
    
} MOBIMEmotionMenuButtonType;

@class MOBIMChatBoxMenuView;

@protocol MOBIMChatBoxMenuDelegate <NSObject>

@optional
- (void)emotionMenu:(MOBIMChatBoxMenuView *)menu
    didSelectButton:(MOBIMEmotionMenuButtonType)buttonType;
- (void)sendButtonClicked:(MOBIMChatBoxMenuView *)menu;

@end

@interface MOBIMChatBoxMenuView : UIView

@property (nonatomic, weak) id <MOBIMChatBoxMenuDelegate>delegate;


@end
