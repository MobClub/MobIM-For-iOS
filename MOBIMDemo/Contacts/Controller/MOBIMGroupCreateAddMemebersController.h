//
//  MOBIMGroupCreateAddMemebersController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/29.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseTableViewController.h"

@interface MOBIMGroupCreateAddMemebersController : MOBIMBaseTableViewController

@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *introduction;

//好友聊天时，创建群，好友信息
@property (nonatomic, strong) MOBIMUser *otherUser;


@end
