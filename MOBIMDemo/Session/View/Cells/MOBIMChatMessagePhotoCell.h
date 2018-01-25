//
//  MOBIMChatMessagePhotoCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseChatMessageCell.h"


typedef void(^MOBIMPhotoClickCompletion)(MOBIMChatMessageFrame *modelFrame,UIButton *presentImageView, CGRect smallImageRect,CGRect bigImageRect);


@interface MOBIMChatMessagePhotoCell : MOBIMBaseChatMessageCell

@property (nonatomic, copy) MOBIMPhotoClickCompletion photoClickCompletion;


@end
