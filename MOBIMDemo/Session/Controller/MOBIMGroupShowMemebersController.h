//
//  MOBIMGroupShowMemebersController.h
//  MOBIMDemo
//
//  Created by hower on 2017/10/19.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewController.h"


@interface MOBIMGroupShowMemebersController : MOBIMBaseViewController
@property (nonatomic, strong) MIMGroup *groupInfo;
@property (nonatomic, assign, readonly)BOOL isGroupRoomOwer;

//会话id
@property (nonatomic, strong) NSString *conversationId;

@end
