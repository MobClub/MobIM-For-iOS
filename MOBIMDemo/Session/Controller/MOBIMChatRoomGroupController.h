//
//  MOBIMChatRoomGroupController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatRoomViewController.h"
#import "MOBIMGConst.h"

@class MIMGroup;
@interface MOBIMChatRoomGroupController : MOBIMChatRoomViewController

@property (nonatomic, strong) MIMGroup  *groupInfo;

@property (nonatomic, strong) NSString *groupId;


@end
