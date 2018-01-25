//
//  MOBIMChatMessageFileCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseChatMessageCell.h"


typedef void(^MOBIMFileClickCompletion)(MOBIMChatMessageFrame *modelFrame,NSString *filePath,UIButton *fileBtn);

@interface MOBIMChatMessageFileCell : MOBIMBaseChatMessageCell

@property (nonatomic, copy) MOBIMFileClickCompletion fileClickCompletion;
@end
