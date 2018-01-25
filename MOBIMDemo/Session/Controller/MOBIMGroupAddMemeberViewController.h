//
//  MOBIMGroupAddMemeberViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewController.h"

@interface MOBIMGroupAddMemeberViewController : MOBIMBaseViewController
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MIMGroup *groupInfo;

@end
