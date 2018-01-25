//
//  MOBIMChatMessageVideoCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseChatMessageCell.h"


typedef void(^MOBIMVideoClickCompletion)(MOBIMChatMessageFrame *modelFrame, NSString *path, UIImage *thumbnailImage, BOOL localUrl);
@interface MOBIMChatMessageVideoCell : MOBIMBaseChatMessageCell

@property (nonatomic, copy) MOBIMVideoClickCompletion videoClickCompletion;

- (void)stopVideo;


@end
