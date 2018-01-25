//
//  MOBIMGroupDeleteMemeberViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewController.h"

@interface MOBIMGroupDeleteMemeberViewController : MOBIMBaseViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MIMGroup *groupInfo;

//是否群组
@property (nonatomic, assign) BOOL isGroupRoomOwer;

//会话id
@property (nonatomic, strong) NSString *conversationId;
@end
