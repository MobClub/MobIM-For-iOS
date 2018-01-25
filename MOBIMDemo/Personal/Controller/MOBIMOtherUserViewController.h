//
//  MOBIMOtherUserViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewController.h"
#import "MOBIMUser.h"



@interface MOBIMOtherUserViewController : MOBIMBaseViewController
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MOBIMUserModel *otherUser;
@property (nonatomic, strong) NSString *userId;


@property (nonatomic, assign) BOOL hiddenSendMessageButton;


@end

