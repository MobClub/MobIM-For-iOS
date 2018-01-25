//
//  MOBIMChatGroupRoomInfoViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOBIMBaseViewController.h"

@interface MOBIMChatGroupRoomInfoViewController : MOBIMBaseViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MIMGroup *groupInfo;

//会话id
@property (nonatomic, strong) NSString *conversationId;



@end
