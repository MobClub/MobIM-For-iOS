//
//  MOBIMUserChatRoomController.h
//  MOBIMDemo
//
//  Created by hower on 2017/10/18.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatRoomViewController.h"

@interface MOBIMUserChatRoomController : MOBIMChatRoomViewController

//@property (nonatomic, strong) MIMUser *contact;

@property (nonatomic, strong) MOBIMUserModel *contact;
@property (nonatomic, strong) NSString *otherUserId;

@end
