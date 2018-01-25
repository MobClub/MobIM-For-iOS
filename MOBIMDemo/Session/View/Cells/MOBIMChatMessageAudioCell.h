//
//  MOBIMChatMessageAudioCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseChatMessageCell.h"
#import "MOBIMChatMessageFrame.h"

typedef void(^MOBIMAudioClickCompletion)(MOBIMChatMessageFrame *modelFrame,UIImageView *audioIcon,UIView *redView);


@interface MOBIMChatMessageAudioCell : MOBIMBaseChatMessageCell

@property (nonatomic, copy) MOBIMAudioClickCompletion audioClickCompletion;
@end

